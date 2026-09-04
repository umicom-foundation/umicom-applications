# Umicom Application Header and Launcher Manifest

**Remote suite baseline:** `65d3d165ec081af6e6fc4f50ae191d8493541c81`
**Remote Framework baseline:** `36ffc5c1bc18f31510b38c460f5353d06121f356`
**Remote Studio baseline:** `a0dab0172047a4d2d92f72186b6e8d12dd54406b`
**Scope:** Complete semantically changed files only.
**Self-hash rule:** This manifest does not hash itself; the archive summary records the final archive checksum.

## Semantic change summary

| Repository | Project path | New | Added | Deleted | Non-whitespace added | Non-whitespace deleted |
|---|---|---:|---:|---:|---:|---:|
| framework | `framework/adapters/gtk4/workstation/shell_header_gtk4.c` | No | 735 | 8 | 688 | 8 |
| framework | `framework/include/umicom/ui/gtk4/workstation/shell_header.h` | No | 48 | 2 | 44 | 2 |
| framework | `framework/src/ui/workspace_geometry.c` | No | 15 | 15 | 15 | 15 |
| framework | `framework/tests/application_experience/test_portfolio_alignment.c` | No | 30 | 0 | 27 | 0 |
| framework | `framework/tests/test_workspace_layout.c` | No | 42 | 0 | 37 | 0 |
| parent | `docs/governance/APPLICATION_FEATURE_COVERAGE.md` | No | 36 | 0 | 28 | 0 |
| parent | `docs/governance/PRODUCT_DECISION_REGISTER.md` | No | 93 | 0 | 69 | 0 |
| parent | `docs/architecture/UNIVERSAL_APPLICATION_WORKBENCH.md` | No | 9 | 1 | 5 | 1 |
| parent | `docs/architecture/WORKBENCH_FEATURE_ROADMAP.md` | No | 24 | 6 | 18 | 6 |
| parent | `docs/architecture/APPLICATION_HEADER_AND_LAUNCHER.md` | Yes | 115 | 0 | 80 | 0 |
| parent | `docs/validation/APPLICATION_HEADER_AND_LAUNCHER_VALIDATION.md` | Yes | 125 | 0 | 94 | 0 |

## Per-file evidence

### `framework/adapters/gtk4/workstation/shell_header_gtk4.c`

- Repository: `framework`
- Baseline Git blob: `96a7d7a05884908874fc57533ae59ec399788214`
- Updated Git blob: `903d3ef22273392e839815341534d1abbd3e5f7a`
- Baseline SHA-256: `b43d6dec046ed0c20f2dffad1de61a1ab2d35b2abf8d611bd43a9ea0dc9d88dd`
- Updated SHA-256: `a2402ed57aa86401c0976a549b2efd532012ed28f201979598422e23f811990f`
- Non-whitespace additions: `688` lines
- Non-whitespace deletions: `8` lines
- Changed areas: Application catalogue, executable resolver, host callback routing, active application tab, new-window and close controls; managed-header lifecycle enhanced.

### `framework/include/umicom/ui/gtk4/workstation/shell_header.h`

- Repository: `framework`
- Baseline Git blob: `6b8c03496d87b6de707da088fd699ad7e2cd4275`
- Updated Git blob: `6f5b3073702592598fe27815a191d1ecc07662a0`
- Baseline SHA-256: `631920c680542afe826cdc7275bf85028a5252abdc8e325fe2823e209c88a52d`
- Updated SHA-256: `f5187a19d339f10be875e4fb90f69d208ca9a4c7da1bdd3fac98ae265513892d`
- Non-whitespace additions: `44` lines
- Non-whitespace deletions: `2` lines
- Changed areas: Additive application-open mode, host callback and application-control APIs; missing-icon contract clarified.

### `framework/src/ui/workspace_geometry.c`

- Repository: `framework`
- Baseline Git blob: `55541e75ae632ee8db7f915b0008c5ccb50d7cbd`
- Updated Git blob: `5a32fabe5e9be2cacd8ab33ca8257d355202923d`
- Baseline SHA-256: `37e084ebc625dc31ec03e7d8f5fd3799c594bd4dd4555c5144feb3919a7db428`
- Updated SHA-256: `5efcd449c3eb94832ba8d1e67f62356debddfefef88880325b5b408f0df8c397`
- Non-whitespace additions: `15` lines
- Non-whitespace deletions: `15` lines
- Changed areas: umi_ui_workspace_region_rect: centre-dominant semantic region proportions.

### `framework/tests/application_experience/test_portfolio_alignment.c`

- Repository: `framework`
- Baseline Git blob: `944fc49a2de00fe518f4ab256699c44efc6c0ebd`
- Updated Git blob: `5510f1a3897d0871bc2a8d8b252b0a7e028cd9b7`
- Baseline SHA-256: `d414fbb2af2d6924d31f810e62c338b592e704a051ee4b62ce14712ee1423af3`
- Updated SHA-256: `394526ac3b378aeebf836fc755464138a99fa1f94a2e658ad5c6068ca22fc420`
- Non-whitespace additions: `27` lines
- Non-whitespace deletions: `0` lines
- Changed areas: assert_application_launcher_contract; existing portfolio-alignment test enhanced.

### `framework/tests/test_workspace_layout.c`

- Repository: `framework`
- Baseline Git blob: `7894955dd8ede5143a06e5a9261a316569fa0a73`
- Updated Git blob: `ef1ae1f67d53e990b8151555ad669c48b54cfb91`
- Baseline SHA-256: `c839f0f58dc90fedc9ebff7b3bd47073ef09164c1c35c05f17038d68f70e9908`
- Updated SHA-256: `75d7d89ef08ab8bf1774c7ceda7184ace7fd6b42ef8cfc16ecfc81ba2dbe7a95`
- Non-whitespace additions: `37` lines
- Non-whitespace deletions: `0` lines
- Changed areas: geometry_equal and assert_default_workspace_geometry; existing layout test enhanced.

### `docs/governance/APPLICATION_FEATURE_COVERAGE.md`

- Repository: `parent`
- Baseline Git blob: `d992842b7972312ce0aa7f3aafcb3b2a576b8635`
- Updated Git blob: `1bd8ac4afba391db6727a78c7dd9203d138b83c3`
- Baseline SHA-256: `b8507bcc183d15a2f529304dcf1605cab44b40f317a40a0dd642c648689ccb47`
- Updated SHA-256: `c26694c67b0f97ae6b4b9309f38cb36d8ca9b9bb519cc1d559956338ab31d282`
- Non-whitespace additions: `28` lines
- Non-whitespace deletions: `0` lines
- Changed areas: Application-family adoption and current launcher limitation recorded.

### `docs/governance/PRODUCT_DECISION_REGISTER.md`

- Repository: `parent`
- Baseline Git blob: `c653ce7bd41caad315b890e5c9ae1bc5369c8d33`
- Updated Git blob: `f9c3ed981c67d3097d61a05f8b66d031ead9d3ac`
- Baseline SHA-256: `37875c1a8565fdc2874c653b16d1db64457cd1bc23f5d872ce536349f08450e5`
- Updated SHA-256: `db6c9be3f479792514f29a97284f99cba1a48d81169f96bab83936d61f89ba34`
- Non-whitespace additions: `69` lines
- Non-whitespace deletions: `0` lines
- Changed areas: UX-017, UX-018 and HOST-001 added.

### `docs/architecture/UNIVERSAL_APPLICATION_WORKBENCH.md`

- Repository: `parent`
- Baseline Git blob: `ec471773496869db056ce76e06bbb8cc6f1795b3`
- Updated Git blob: `8ef6fa2488789c352180e9e51349153235057856`
- Baseline SHA-256: `c98595185fb5b83d7d81e38ddba3983a6daad6674c045d4894c4ddab3a0f116b`
- Updated SHA-256: `8883e06c16970b03808bd782dc8d3ee262d72b5ba5d34a08f997fc5f69f620f8`
- Non-whitespace additions: `5` lines
- Non-whitespace deletions: `1` lines
- Changed areas: Executable catalogue, host callback and shared default geometry recorded.

### `docs/architecture/WORKBENCH_FEATURE_ROADMAP.md`

- Repository: `parent`
- Baseline Git blob: `219a5a3c6e39c858a261511e1f374de89de998a0`
- Updated Git blob: `ecd5ec1a4ccb003466b363c83ab5d08a7f3829bf`
- Baseline SHA-256: `30ea97361ac4977c6637d0f0b11b4c1dd531f84bf56c10d02f80009cb583d55a`
- Updated SHA-256: `276a37092d970b37154c6bcd8b5a9dd36210f9144535372fa6163166b6af04d2`
- Non-whitespace additions: `18` lines
- Non-whitespace deletions: `6` lines
- Changed areas: Implemented header foundation separated from remaining host work.

### `docs/architecture/APPLICATION_HEADER_AND_LAUNCHER.md`

- Repository: `parent`
- Baseline Git blob: `not present`
- Updated Git blob: `6dc32823fc550c6eed4da105b532693b05519c38`
- Baseline SHA-256: `not present`
- Updated SHA-256: `067bc23d58481b52ee0f2ed478ec9825a4e62529cc0a7463677d785c4521d40f`
- Non-whitespace additions: `80` lines
- Non-whitespace deletions: `0` lines
- Changed areas: New canonical feature architecture and acceptance specification.

### `docs/validation/APPLICATION_HEADER_AND_LAUNCHER_VALIDATION.md`

- Repository: `parent`
- Baseline Git blob: `not present`
- Updated Git blob: `0aca087cdfc4c20210665cb2ce798838c990c33f`
- Baseline SHA-256: `not present`
- Updated SHA-256: `3dd1d2093c2e08115f2f3cf361831ac169e818aa0b330027f530fe02ca81d32c`
- Non-whitespace additions: `94` lines
- Non-whitespace deletions: `0` lines
- Changed areas: New honest source-validation and Windows acceptance record.

## Validation evidence

- baseline Git-object verification: PASS;
- whitespace-only tracked-file rejection: PASS;
- GCC C23 strict compilation of changed Framework sources: PASS;
- Clang C23 strict compilation of changed Framework sources: PASS;
- isolated public-header compilation in C and C++: PASS;
- shell-header lifecycle smoke: PASS;
- application host-callback routing smoke: PASS;
- default process-launch fallback smoke: PASS;
- case-insensitive application search smoke: PASS;
- centre-dominant geometry behaviour smoke: PASS;
- conflict-marker and introduced-whitespace checks: PASS;
- complete Windows UCRT64 build and graphical acceptance: REQUIRED AFTER MERGE.
