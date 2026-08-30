# Shared Product Surface for Every Application

## Decision

Umicom Framework owns the common application-surface lifecycle. Product
repositories select an application ID and recipe audience, contribute small
controllers, and expose thin product-named functions to their frontends.

Framework validates the application and recipe relationship, creates the
runtime, binds the host, registers controllers, starts visible panels, forwards
events and cleans up. Applications must not copy this lifecycle.

## Why this is needed

Studio and Trader had almost identical code for allocation, headless-host
binding, controller registration and startup. Bank, TMS and Music had recipes
but no equivalent live surface. Copying the Studio code into every repository
would make later fixes slow and inconsistent.

A single Framework surface means one lifecycle repair benefits the whole
portfolio. Learning, standard and focus layouts are selected from the same
catalogue, so applications no longer assume that every layout contains the
standard panel list.

## Product responsibilities

An application still owns:

- its public product-facing API;
- product wording and honest empty states;
- calls into its real domain services;
- authorization and safety rules that are specific to the product;
- frontend entry points and product branding.

Framework owns reusable components, recipes, panel/window definitions, runtime
policies, state transitions, host contracts and the product-surface lifecycle.

## Safety

The product surface refuses a recipe that belongs to another application.
Bank and TMS controllers stage financial commands and show that authorization
is required; they do not claim that a transaction, trade or settlement ran.
Trader continues to label its commands as simulation preparation. Music Studio
does not claim that an AI or audio engine ran when no engine is connected.

## Compatibility

Existing Studio and Trader application-surface functions remain available.
Their implementations delegate to Framework. New audience-selection and
runtime-event functions are additive.
