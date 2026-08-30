# Application Product Surface Portfolio

This page explains how the shared Framework product surface affects every
current Umicom application. It separates what is reusable today from the thin
product work that still remains, so a new developer does not mistake a recipe
for a finished graphical application.

## What is complete across the portfolio

Framework owns learning, standard and focus recipes for 26 application
families. The shared product surface can validate, project, start, snapshot and
stop every one of those recipes through the same headless lifecycle. The
portfolio test checks all catalogue entries, not a hand-written shortlist.

This means the reusable pieces are ready for Accountant, Author, Bank, CAD,
Creator, Database Studio, Desktop, Education, Exchange, Games, IDE, Integration
Studio, Kitchen Designer, LLM, Marketplace, Media Studio, Mobile Studio, Music
Studio, Operations, OS, RAG, Security Centre, Studio, TMS, Trader and Web
Studio.

It does **not** mean every product is finished. A recipe describes which
Framework pieces belong on the workbench. A complete product still needs its
domain services, product controllers, frontend binding, acceptance tests and
release evidence.

## First product adopters

| Product | Thin product surface | Audience layouts | Product behavior |
|---|---|---|---|
| Studio IDE | Delegates existing API to Framework | Learning, standard, focus | IDE guidance and command routing |
| Trader | Delegates existing API to Framework | Learning, standard, focus | Simulation wording and trading safety |
| Bank | New thin product API | Learning, standard, focus | Honest empty states and authorization staging |
| TMS | New thin product API | Learning, standard, focus | Treasury guidance and approval staging |
| Music Studio | New thin product API | Learning, standard, focus | Creative guidance without fake engine results |

## How the remaining products should adopt it

Each remaining product can migrate without deleting its current runtime:

1. Add an opaque product-surface type in the application repository.
2. Put `UmiApplicationPresentationProductSurface` inside it.
3. Keep existing public product functions and delegate them to Framework.
4. Register one controller for every panel selected by the chosen recipe.
5. Describe empty, disconnected, loading and permission states honestly.
6. Exercise learning, standard and focus through headless tests.
7. Bind GTK, Qt or web controls only after the product-neutral behavior works.

The generic surface and portfolio test already prove that the Framework part
can start each recipe. Migration therefore stays small and reviewable: each
application adds product meaning rather than another copy of the lifecycle.

## Recommended next order

Continue the agreed product priority:

1. Finish Framework contracts, hosts, customization and accessibility.
2. Complete Studio IDE services and graphical adoption.
3. Complete Trader simulation, broker boundaries and safety evidence.
4. Deepen Bank, TMS and Music product services on their new surfaces.
5. Move the remaining thin applications to the same wrapper one at a time.

Shared improvements must continue to enter Framework first whenever another
current or future application could use them.
