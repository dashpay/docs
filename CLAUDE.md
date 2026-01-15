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

The documentation supports both reStructuredText (`.rst`) and Markdown (`.md`) via MyST parser with `colon_fence` extension enabled.

## Key Configuration

* **conf.py** - Sphinx configuration including:
  * Theme: `pydata_sphinx_theme`
  * Extensions: `myst_parser`, `sphinx_design`, `hoverxref`, `sphinx_copybutton`, `sphinx-sitemap`
  * Intersphinx linking to Platform docs at `https://docs.dash.org/projects/platform/en/stable/`
  * Auto-clones DIPs repository during build (processed by `scripts/dip-format.sh`)

## Translations

Translations are managed via Transifex. Scripts in `transifex/` handle push/pull operations. Locale files are in `locale/`.

## Helper Scripts

* `scripts/dip-format.sh` - Formats DIPs from the dashpay/dips repository for inclusion in docs
* `scripts/core-download-link-update.sh` - Updates Dash Core download links
* `scripts/evo-tool-download-link-update.sh` - Updates Dash Evo Tool download links
* `scripts/dashmate-update.sh` - Updates dashmate download links content
