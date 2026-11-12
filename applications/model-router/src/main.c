/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: applications/model-router/src/main.c
 *
 * PURPOSE:
 *   Expose Framework worker services to existing UI bindings through a small C23 executable.
 *
 * EDUCATIONAL OVERVIEW:
 *   This thin host owns stdin/stdout only. Framework owns HTTP and AI policy;
 *   native model processes remain separately supervised local or tunnelled services.
 *
 * AUTHOR AND ORGANISATION:
 *   Sammy Hegab
 *   Umicom Foundation
 *
 * LICENCE:
 *   MIT
 *---------------------------------------------------------------------------*/

#include "umicom/ai_workspace/worker_transport.h"
#include <json-c/json.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif
#ifdef UMICOM_WORKER_HAS_TEXT
#include "umicom/ai_workspace/providers.h"
#endif

/* Binary mode is required for UTF-8 JSON and media bytes on Windows pipes. */
static bool BridgeWrite(void *context, const void *data, size_t length)
{
    FILE *out = context;
    return fwrite(data, 1U, length, out) == length;
}

/* Read an exact typed string; fixed Framework structures must never truncate it. */
static const char *BridgeString(json_object *root, const char *key, size_t capacity)
{
    json_object *value = NULL;
    if (!json_object_object_get_ex(root, key, &value) || !json_object_is_type(value, json_type_string)) return NULL;
    const char *text = json_object_get_string(value);
    int n = json_object_get_string_len(value);
    if (text == NULL || n < 1 || (size_t)n >= capacity || strlen(text) != (size_t)n) return NULL;
    return text;
}

/* Reject Boolean and floating-point ports rather than coercing them into integers. */
static bool BridgeInteger(json_object *root, const char *key, int64_t low, int64_t high, int64_t *out)
{
    json_object *value = NULL;
    if (!json_object_object_get_ex(root, key, &value) || !json_object_is_type(value, json_type_int)) return false;
    int64_t n = json_object_get_int64(value);
    if (n < low || n > high) return false;
    *out = n; return true;
}

#ifdef UMICOM_WORKER_HAS_TEXT
/* Translate UI JSON into the canonical Framework provider contract, then call it. */
static UmiStatus BridgeText(json_object *root, const UmiAiWorkerEndpoint *endpoint)
{
    UmiAiRequest *request = calloc(1U,sizeof(*request));
    UmiAiResponse response = {0};
    UmiAiProvider provider = {0};
    UmiStatus status = UMI_STATUS_INVALID_ARGUMENT;
    if(request==NULL) return UMI_STATUS_OUT_OF_MEMORY;
    const char *model=BridgeString(root,"model",sizeof(request->model_id));
    const char *id=BridgeString(root,"request_id",sizeof(request->request_id));
    json_object *messages=NULL, *temperature=NULL;
    int64_t maximum;
    if(model==NULL || id==NULL || !BridgeInteger(root,"max_tokens",1,4096,&maximum) ||
       !json_object_object_get_ex(root,"temperature",&temperature) ||
       !(json_object_is_type(temperature,json_type_double)||json_object_is_type(temperature,json_type_int)) ||
       !json_object_object_get_ex(root,"messages",&messages) || !json_object_is_type(messages,json_type_array)) goto done;
    request->temperature=json_object_get_double(temperature);
    if(!isfinite(request->temperature)||request->temperature<0.0||request->temperature>2.0) goto done;
    request->message_count=json_object_array_length(messages);
    if(request->message_count<1U||request->message_count>UMI_AI_MAX_MESSAGES) goto done;
    memcpy(request->model_id,model,strlen(model)+1U);
    memcpy(request->request_id,id,strlen(id)+1U);
    request->max_output_tokens=(uint32_t)maximum;
    request->allow_tools=0;
    for(size_t i=0U;i<request->message_count;++i) {
        json_object *entry=json_object_array_get_idx(messages,i);
        if(!json_object_is_type(entry,json_type_object)) goto done;
        const char *role=BridgeString(entry,"role",20U);
        const char *text=BridgeString(entry,"content",sizeof(request->messages[i].text));
        if(role==NULL||text==NULL) goto done;
        if(strcmp(role,"system")==0) request->messages[i].role=UMI_AI_ROLE_SYSTEM;
        else if(strcmp(role,"user")==0) request->messages[i].role=UMI_AI_ROLE_USER;
        else if(strcmp(role,"assistant")==0) request->messages[i].role=UMI_AI_ROLE_ASSISTANT;
        else {status=UMI_STATUS_PERMISSION_DENIED;goto done;}
        memcpy(request->messages[i].text,text,strlen(text)+1U);
    }
    /* Existing transport owns model identity checks, tool rejection and response decoding. */
    status=UmiAiWorkspaceLocalProviderCreate(endpoint->port,endpoint->timeoutMillis,NULL,&provider);
    if(status!=UMI_STATUS_OK) goto done;
    status=provider.generate(provider.instance,request,&response);
    provider.destroy(provider.instance);
    if(status==UMI_STATUS_OK) {
        json_object *output=json_object_new_object();
        if(output==NULL) {status=UMI_STATUS_OUT_OF_MEMORY;goto done;}
        json_object_object_add(output,"text",json_object_new_string(response.text));
        json_object_object_add(output,"model",json_object_new_string(response.model_id));
        json_object_object_add(output,"finish_reason",json_object_new_string(
            response.finish_reason==UMI_AI_FINISH_LENGTH?"length":"stop"));
        const char *encoded=json_object_to_json_string_ext(output,JSON_C_TO_STRING_PLAIN);
        if(encoded==NULL || !BridgeWrite(stdout,encoded,strlen(encoded))) status=UMI_STATUS_IO_ERROR;
        json_object_put(output);
    }
 done:
    free(request);return status;
}
#endif

/* Emit machine-readable build capabilities without probing a service or loading weights. */
static int BridgeCapabilities(void)
{
#ifdef UMICOM_WORKER_HAS_TEXT
    bool text=UmiAiWorkspaceLocalProviderAvailable();
    printf("{\"abi\":1,\"media\":true,\"text\":%s,\"message_bytes\":%u,\"response_bytes\":%u,\"messages\":%u}",
           text?"true":"false",(unsigned)UMI_AI_TEXT_CAPACITY-1U,
           (unsigned)(UMI_AI_TEXT_CAPACITY*2U)-1U,(unsigned)UMI_AI_MAX_MESSAGES);
#else
    printf("{\"abi\":1,\"media\":true,\"text\":false}");
#endif
    return ferror(stdout)?1:0;
}

/* A one-shot child has no listening port, secret store or background process lifetime. */
int main(int argc, char **argv)
{
#ifdef _WIN32
    if(_setmode(_fileno(stdin),_O_BINARY)==-1 || _setmode(_fileno(stdout),_O_BINARY)==-1) return 1;
#endif
    if(argc==2 && strcmp(argv[1],"--capabilities")==0) return BridgeCapabilities();
    if(argc!=1) {fputs("Usage: umicom-ai-bridge [--capabilities]; request JSON on stdin\n",stderr);return 2;}
    char *input=malloc(UMI_AI_WORKER_JSON_LIMIT);
    if(input==NULL) return 1;
    size_t length=fread(input,1U,UMI_AI_WORKER_JSON_LIMIT,stdin);
    json_object *root=NULL;
    UmiStatus status=UMI_STATUS_CAPACITY_EXCEEDED;
    char error[256]="Invalid bounded worker request.";
    if(length<UMI_AI_WORKER_JSON_LIMIT && !ferror(stdin)) status=UmiAiWorkerParseJson(input,length,&root);
    if(status==UMI_STATUS_OK) {
        int64_t port, timeout;
        const char *action=BridgeString(root,"action",64U);
        if(action==NULL || !BridgeInteger(root,"port",1024,65535,&port) ||
            !BridgeInteger(root,"timeout_ms",100,60000,&timeout)) status=UMI_STATUS_INVALID_ARGUMENT;
        else {
            UmiAiWorkerEndpoint endpoint={.port=(uint16_t)port,.timeoutMillis=(uint32_t)timeout};
            if(strcmp(action,"text")==0) {
#ifdef UMICOM_WORKER_HAS_TEXT
                status=BridgeText(root,&endpoint);
                (void)snprintf(error,sizeof(error),"Text provider failed. Check model alias, message capacity, tunnel and worker; no automatic retry.");
#else
                status=UMI_STATUS_UNAVAILABLE;
                (void)snprintf(error,sizeof(error),"This build does not include the canonical Framework text provider.");
#endif
            } else status=UmiAiWorkerExecute(&endpoint,input,length,BridgeWrite,stdout,error,sizeof(error));
        }
    }
    if(root!=NULL) json_object_put(root);
    free(input);
    if(status!=UMI_STATUS_OK) {
        /* Diagnostic messages are fixed strings: request content stays out of logs. */
        fprintf(stderr,"Worker status %d: %s\n",(int)status,error);
        return (int)status;
    }
    return fflush(stdout)==0?0:1;
}
