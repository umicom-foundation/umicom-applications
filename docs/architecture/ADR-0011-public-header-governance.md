<!--
Umicom Applications
File: docs/architecture/ADR-0011-public-header-governance.md

PURPOSE:
Record the public SDK header convention and include-guard ownership decision.

AUTHOR AND ORGANISATION:
Sammy Hegab
Umicom Foundation

LICENCE:
MIT
-->

# ADR-0011: Public Headers Are Governed SDK Contracts

Status: Accepted

## Context

Framework, Studio and Trader expose thousands of C headers. Two different
experience catalogue headers used the same guard, making declarations depend on
include order and breaking Studio workspace layout compilation.

Large public APIs also become difficult for new developers when file ownership
and purpose comments vary from one header to another.

## Decision

Every public SDK header must have:

- one guard derived from its complete logical include path;
- a matching `#ifndef` and `#define`;
- a guard not shared by another header in the same SDK;
- a human-readable file, purpose, author, organisation and licence comment.

Framework owns the reusable audit implementation. Framework, Studio and Trader
register it for their respective public include trees.

Similar but distinct APIs must use unambiguous guards. A combined umbrella
header may be added when applications commonly require both APIs.

## Consequences

- Public declarations no longer depend on accidental include order.
- SDK contract failures are reported directly during testing.
- Junior developers receive consistent context in every public header.
- Header comment changes do not alter ABI or runtime behavior.
- Superseded duplicate aggregate headers may be removed after confirming they
  contain no unique declaration and have no references.
