# Public documentation and product websites

A usable Umicom feature needs an explanation as well as an implementation.
The product website introduces the project. The user guide teaches a complete
task. The developer Wiki explains the source and its public contracts. These
views should be published from the same reviewed repository content.

## Relationship to product implementation

The [Workbench Feature Roadmap](WORKBENCH_FEATURE_ROADMAP.md) remains the product
priority order. Native Studio usability is the first functional milestone.
Documentation work accompanies each milestone; a website does not substitute
for working editing, build, run, install or recovery behaviour.

For each delivered feature, include:

- a test of the intended operation and its important failure cases;
- a Wiki entry with repository, header, implementation and test locations;
- an example that uses the real exported Framework interface;
- a user-guide task for each adopting application;
- an accurate feature description and relevant download requirements.

## Ownership and publication

Framework owns reusable documentation templates, examples and code-reference
configuration. Application repositories own their product explanations.
The site builder under `framework/docs/site` assembles those sources and uses the
existing Doxygen configuration for the optional function and type index.
Generated HTML and archives belong in the build directory.

The canonical Wiki is ordinary version-controlled content. GitHub Wikis may
link to it or receive a generated mirror. They must not hold a separately edited
copy of method signatures, feature status or installation instructions.
Existing learning content and stable lesson identifiers are preserved.

A product website needs an overview, features with meaningful availability
states, getting started, user guide, developer Wiki, source repository, issues,
releases and download requirements. Release metadata should eventually name
platform, architecture, source and Framework revisions, checksums, signatures,
prerequisites and known limitations. Links must refer to real published assets.
Source archives, developer packages and stable installers are different choices.

## Documentation coverage

Begin with Framework, Studio, Trader, Desk and Bank. Extend the same structure
to every registered application as its first usable journey is completed.
The current public-header map is an inventory, not a claim that every function
already has a worked tutorial. A directory is not necessarily a runtime module.

The Wiki should cover module purpose, capabilities, dependencies, CMake target,
public functions, structures, enums, events, commands, callbacks, components,
source files, examples and tests. Each function explanation must describe inputs,
outputs, ownership, lifetime, thread rules, failure conditions and limits. A
visual component also needs its adapter requirements, behaviour and a runnable
window example. Private interfaces must be visibly distinguished from supported
public APIs.

Worked topics progress from documents, diagnostics and windows to commands,
events, layouts, processes, persistence, testing, debugging, Git, providers,
security, market data, orders, accounts, payments and operational recovery.
Cross-link instead of copying the same Framework explanation into every product.

## Publishing stages

1. Build the local website and check source links, examples and navigation.
2. Generate the API index where Doxygen is available; review its warnings and
   missing explanatory coverage before publication.
3. Choose a public hosting location and release workflow. Do not overwrite the
   Foundation's existing website, change DNS or expose internal files implicitly.
4. Connect installed Help and the Learning module through Framework resource
   services using version-matched offline pages.
5. Add reproducible release downloads and documentation archives when their
   actual installation and application checks have passed.

Keep implementation evidence and private review reports separate from public
teaching pages. Use natural professional English, define unfamiliar terms, and
teach useful applications such as Notes or a training account. Preserve names
and comments unless correcting a concrete issue. Do not rename example install
directories merely because another development update was prepared.
