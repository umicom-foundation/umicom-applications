<!-- --------------------------------------------------------------------------
Umicom Applications
File: docs/architecture/AI_ASSISTANT_VIBE_CODING_AND_LOCAL_SECRETS.md

PURPOSE:
Explain how Studio composes the Framework AI coding runtime, local RAG, model
providers, review gates and machine-local secret storage without leaking keys.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
---------------------------------------------------------------------------- -->

# AI Assistant, Vibe Coding and Local Secrets

The idea is a strong fit for Umicom Studio. Most of the difficult reusable
foundation already exists in Umicom Framework: provider-neutral AI requests,
local and remote runtime catalogues, repository indexing, RAG context,
workbench commands, patch previews, approval, application, validation, repair,
rollback and audit history.

Studio should remain the product shell. It asks what the user wants, displays
progress and review information, and delegates the real work to Framework.

## Intended experience

1. The user writes a goal such as “add a searchable lesson list”.
2. Studio creates a Vibe Coding session and identifies the active workspace.
3. Framework selects bounded repository and document context.
4. RAG adds relevant material with source provenance.
5. The selected local or remote model streams explanation and progress events.
6. Tools may inspect source, search symbols and prepare a patch under policy.
7. Studio shows every proposed file change before mutation.
8. The user approves, rejects or asks for a revision.
9. Framework applies the approved patch transactionally.
10. Focused build and test validation runs through the developer executor.
11. Failure output becomes the next bounded repair context.
12. Studio records the result and leaves Git commit and push under user control.

“Real time” means the workbench receives events while work is happening. It does
not mean that model text is written straight into project files. A response and
a reviewed patch are separate objects.

## Provider choices

The same contracts can support:

- in-process or supervised local models;
- Ollama chat and embedding endpoints;
- LM Studio's local REST or compatible endpoints;
- llama.cpp server adapters;
- AuthorEngine;
- approved online providers through HTTPS.

Ollama documents a local embedding endpoint suitable for RAG, while LM Studio
documents local REST, stateful chat, model management and compatible endpoints.
These are adapters, not new Studio-specific AI engines:

- [Ollama embedding API](https://docs.ollama.com/api/embed)
- [LM Studio REST API](https://lmstudio.ai/docs/developer/rest)

Remote providers remain disabled by default. A configured endpoint is not
reported healthy until its adapter completes a real health probe.

## API key rule

The embedded Studio database stores only ordinary metadata:

- provider identifier;
- model identifier;
- endpoint;
- an opaque reference such as `windows-vault://ai/openai`;
- creation and rotation information;
- whether the provider is enabled.

It must never store the raw API key, a reversible key beside encrypted data, or
the key in a log, crash report, session archive, prompt, Git file or test
fixture.

The secret value belongs in an operating-system credential provider:

- Windows: a user-scoped DPAPI or Credential Manager adapter;
- Linux: a Secret Service/libsecret adapter;
- macOS: a Keychain Services adapter.

Microsoft explains that default DPAPI protection is tied to the same user on
the same machine. GNOME's Secret Service stores secrets in the login session's
secret service, while lookup attributes are not themselves secret. Apple
recommends Keychain Services for small secrets and warns against implementing
ad-hoc encryption:

- [Microsoft DPAPI example and scope](https://learn.microsoft.com/en-us/windows/win32/seccrypto/example-c-program-using-cryptprotectdata)
- [GNOME libsecret simple API](https://gnome.pages.gitlab.gnome.org/libsecret/libsecret-simple-api.html)
- [Apple Keychain Services](https://developer.apple.com/documentation/security/keychain-services/)

The Framework secret provider now has optional store and remove operations,
understands `provider://name` references, and offers an explicit memory-clearing
helper. Environment variables remain a read-only development provider. Native
vault adapters should implement the same contract; Studio should never call an
operating-system vault directly.

## Settings added to Studio

The typed schema now includes:

- preferred coding runtime;
- optional remote provider, endpoint and model;
- opaque remote secret reference;
- RAG enabled;
- streamed response events enabled;
- existing patch approval and file-change limits.

Empty remote endpoint and secret-reference defaults keep a new installation
local. Enabling remote access still requires a complete provider profile and a
`provider://name` secret reference.

## Approval boundaries

- Reading explicitly selected, non-sensitive workspace context may proceed.
- Sensitive context needs policy permission.
- Network use needs remote-provider permission.
- Tool use follows the declared tool policy.
- Creating or deleting files follows the patch policy.
- A patch requires human approval by default.
- Source-control push is not an automatic Vibe Coding action.
- A failed validation may roll back an applied patch under the configured
  policy.

## Delivery sequence

1. Land the provider/runtime settings and secret-reference rules.
2. Implement DPAPI/Credential Manager, libsecret and Keychain adapters.
3. Connect the Studio AI pane to the Framework operational agent event queue.
4. Add Ollama, LM Studio and llama.cpp health and streaming adapters.
5. Add local repository and documentation indexing controls.
6. Render plan, tool, patch, approval and validation events in one timeline.
7. Add consent prompts for sensitive context and online transmission.
8. Add secure rotation, forget-provider and export-without-secrets workflows.
9. Add end-to-end tests with fake providers and disposable workspaces.
10. Complete an external security review before calling online-key storage
    production ready.


