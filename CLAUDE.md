# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Project Overview

This is the official Dash user documentation repository, built with Sphinx and hosted on Read the Docs at https://docs.dash.org. The documentation covers wallets, masternodes, governance, mining, and developer guides for the Dash cryptocurrency ecosystem.

## Build Commands

```bash
# Set up Python virtual environment (Python 3.13 recommended)
python3.13 -m venv venv/
source ./venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Build documentation
make html

# Clean rebuild (required when modifying pages)
rm -r _build/ || true && make html
```

The built documentation will be in `_build/html/`. Note: search functionality is not available in local builds.

## Package Management

Uses pip-tools for package management:
```bash
pip install pip-tools

# Add new package: add to requirements.in, then:
pip-compile
pip install -r requirements.txt

# Update all packages:
pip-compile --upgrade
```

## Documentation Structure

* **docs/user/** - User documentation (`.rst` files): wallets, masternodes, governance, mining, developers
* **docs/core/** - Core developer documentation (`.md` files using MyST parser): RPC API reference, protocol guides, P2P network, transaction tutorials, DIPs
* **index.rst** - Main entry point with three-section layout (User Docs, Core Docs, Platform Docs)
* **_extra/llms.txt** - Hand-maintained index of top-level pages served at the site root. Update it when top-level pages are added, moved, or renamed.
* **docs/core/api/ai-prompt.md** - Prompts for checking RPC reference tables against `help <rpc>` output (excluded from the build)

The documentation supports both reStructuredText (`.rst`) and Markdown (`.md`) via MyST parser with `colon_fence` extension enabled. `myst_heading_anchors = 5` auto-generates anchors for Markdown headings (levels 1-5), so `#heading-slug` links work without explicit labels.

## Key Configuration

* **conf.py** - Sphinx configuration including:
  * Theme: `pydata_sphinx_theme`
  * Extensions: `myst_parser`, `sphinx_design`, `hoverxref`, `sphinx_copybutton`, `sphinx_sitemap`, `sphinx.ext.intersphinx`, `sphinx.ext.autodoc`, `sphinxcontrib.googleanalytics`
  * Intersphinx linking to Platform docs at `https://docs.dash.org/projects/platform/en/stable/`. `intersphinx_disabled_reftypes = ["*"]` is set, so Platform links must be explicitly prefixed (e.g., ``:ref:`FAQ <platform:resources-faq>` ``). Unprefixed refs never fall back to Platform.
  * `html_context.github_version` must match the current default branch (used by the "Edit this page" button). Update it when the version branch rolls over.
  * `exclude_patterns` - Any non-doc Markdown/RST file (READMEs, notes, prompts, working directories) must be added here or Sphinx will try to build it.

### DIPs

DIPs are cloned from `dashpay/dips` and processed by `scripts/dip-format.sh`, but **only when `_external_repo/` does not exist** ([conf.py](conf.py) uses it as a sentinel). In a local checkout with `_external_repo/` present, the clone is skipped and `docs/core/dips/` contains only the placeholder `README.md`. When the clone does run, it copies DIP files into `docs/core/dips/` and they are not gitignored, so do not commit them.

## Translations

Translations are managed via Transifex. Scripts in `transifex/` handle push/pull operations. Locale files are in `locale/`. Only `docs/user/` is translated; `docs/core/` is excluded. Changing source strings in user docs invalidates existing translations, so avoid gratuitous rewording.

## Helper Scripts

* `scripts/dip-format.sh` - Formats DIPs from the dashpay/dips repository for inclusion in docs
* `scripts/core-download-link-update.sh` - Updates Dash Core download links
* `scripts/evo-tool-download-link-update.sh` - Updates Dash Evo Tool download links
* `scripts/dashmate-update.sh` - Updates dashmate download links content
* `scripts/check-rpc-links.py` - Verifies that `` [`<rpc>` RPC](...#anchor) `` links point at the RPC they name. Run after editing RPC docs: `scripts/check-rpc-links.py [paths...]` (default: `docs/`)
* `scripts/core-help-parsing.sh` - Converts `dashd`/`dash-qt`/`dash-cli --help` output into the format used by the `docs/core/dashcore/wallet-arguments-and-commands-*` pages (supports `--update <file>`)
* `scripts/core-rpc-tools/` - Dumps RPC help from a running node and generates version-to-version change summaries. Primary workflow for Dash Core release updates; see its README.

## Automation

* `core-download-update.yml`, `dashmate-update.yml`, and `evo-tool-download-update.yml` run twice daily (Core also runs on release dispatch) and open PRs that rewrite download links using the scripts above. Do not hand-edit the generated download-link content; change the scripts instead, or the next run will overwrite it.
* `preview-url.yml` appends a Read the Docs preview build URL to new PRs (`https://dash-docs--<PR>.org.readthedocs.build/en/<PR>/`). Use it to check rendering and search, which local builds lack.

## Contributing Conventions

* Branches are named after Dash Core versions. PRs target the upstream (`dashpay/docs`) default branch, currently `23.0.0`. Older version branches (e.g., `0.17.0`) are stale; do not use them as a PR base even if a fork's `HEAD` points there.
* Commit messages use conventional commits with scopes, e.g. `docs(rpc): ...`, `docs(governance): ...`, `chore: ...`.
* Before finishing a change, do a clean rebuild and confirm no new Sphinx warnings. After RPC doc edits, also run `scripts/check-rpc-links.py`.
