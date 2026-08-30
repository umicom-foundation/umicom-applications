<!--
Umicom Applications
File: docs/architecture/ADR-0010-runtime-behavior-policies.md

PURPOSE:
Record ownership of reusable panel behavior and workspace runtime policy.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
-->

# ADR-0010: Framework Owns Runtime Behavior Policies

Status: Accepted

## Context

The application surface runtime can place and host reusable panels, but a
layout alone does not explain refresh timing, command safety, shared context,
background activity or checkpoint timing. Implementing those choices separately
inside every product would create drift and make future applications harder to
assemble from shared parts.

## Decision

Umicom Framework owns one portable surface behavior for every reusable panel
and one portable workspace runtime policy for every recipe.

Product repositories such as Studio and Trader may provide thin façades and
product controllers. They must not copy the catalogue, scheduler or generic
policy enforcement. Frontends translate toolkit events into elapsed time,
background state and context updates.

Guarded commands require a registered product controller. This rule adds a
presentation-level gate and does not replace domain permissions or safety
services.

## Consequences

- New applications inherit predictable panel behavior from Framework.
- Studio can reduce background work while Trader keeps market panels current.
- Focus and learning recipes behave consistently across the product family.
- One command-line tool can explain any component or recipe policy.
- Catalogue validation fails when a component or recipe lacks policy coverage.

This decision extends ADR-0009. It does not change ownership of trading,
security, persistence or frontend-toolkit implementations.
