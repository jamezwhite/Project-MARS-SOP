# Project MARS - Standard Operating Procedure

[![Build Status](https://img.shields.io/badge/LaTeX-Document-blue.svg)](https://www.latex-project.org/)
[![License](https://img.shields.io/badge/license-Government-green.svg)]()

This repository contains the **Standard Operating Procedure (SOP)** for Project MARS (Medical Autonomous Resupply System) at Keller Army Community Hospital. The document defines operational procedures, personnel requirements, and safety guidelines for Unmanned Aircraft Systems (UAS/drone) operations supporting medical logistics.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Building the Document](#building-the-document)
- [Repository Structure](#repository-structure)
- [Development Workflow](#development-workflow)
- [Contributing](#contributing)
- [Automation](#automation)
- [License](#license)

## Overview

**Project MARS SOP** is a comprehensive operational manual covering:

- **General Procedures**: Purpose, applicability, and authority
- **Roles & Responsibilities**: Personnel requirements and duties
- **Airframe & Systems**: Technical specifications
- **Operator Certification**: Training and qualification requirements
- **Flight Operations**: Mission planning and execution
- **Maintenance**: Preventive and corrective maintenance procedures
- **Safety**: Risk management and emergency procedures

**Key Features:**
- Multi-rotor Small UAS (sUAS) operations
- Beyond Visual Line-of-Sight (BVLOS) capability
- Autonomous medical logistics delivery
- Compliance with FAA, DoD, Army regulations, and KACH policies

**Author:** SFC Jamez White, Project NCOIC
**Last Updated:** 01 Dec 2025

## Prerequisites

### Required Software

- **LaTeX Distribution:**
  - Linux: `texlive-full` (recommended) or `texlive-latex-extra`
  - macOS: MacTeX
  - Windows: MiKTeX or TeX Live

- **Build Tools:**
  - `make` (for using Makefile)
  - `latexmk` (for continuous builds)
  - `makeglossaries` (for acronym/glossary generation)

### Installation (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install -y texlive-latex-extra texlive-fonts-extra
sudo apt-get install -y texlive-science latexmk
```

Or use the provided Makefile:

```bash
make install-deps
```

## Building the Document

### Quick Start

```bash
# Full build (recommended)
make build

# Quick single-pass build
make quick

# Continuous build (auto-rebuild on changes)
make watch

# Clean build artifacts
make clean
```

### Manual Build

```bash
# Create output directory
mkdir -p build

# Full build with glossaries
pdflatex -output-directory=build Main.tex
makeglossaries -d build Main
pdflatex -output-directory=build Main.tex
pdflatex -output-directory=build Main.tex

# Move PDF to root
mv build/Main.pdf Project-MARS-SOP.pdf
```

### Using latexmk

```bash
# Single build
latexmk -pdf -outdir=build Main.tex

# Continuous preview mode
latexmk -pdf -pvc -outdir=build Main.tex
```

## Repository Structure

```
Project-MARS-SOP/
├── Main.tex                    # Root document
├── sop.cls                     # Custom LaTeX class
├── Makefile                    # Build automation
├── .latexmkrc                  # latexmk configuration
│
├── chapters/                   # Main content (7 chapters)
│   ├── General.tex
│   ├── Roles and Responsibilities.tex
│   ├── Airframe and Supporting Systems.tex
│   ├── Operator Certification.tex
│   ├── Flight Operations.tex
│   ├── Maintenance.tex
│   └── Safety.tex
│
├── appendices/                 # Supporting material (5 appendices)
│   ├── References.tex
│   ├── Checklists.tex
│   ├── Forms.tex
│   ├── uas characteristics.tex
│   └── Route Development.tex
│
├── glossaries/                 # Acronyms and terms
│   ├── ABCA.tex               # 50+ military/aviation acronyms
│   ├── Terms.tex              # Technical glossary
│   └── Glossary.tex           # Glossary formatting
│
├── frontmatter/               # Document preliminaries
│   └── frontpage.tex
│
├── assets/                    # Images and media
│   ├── Project Mars Patch.png
│   └── dod-logo.png
│
├── scripts/                   # Automation utilities
│   ├── ai-changelog.sh        # AI-powered changelog generator
│   └── ai-changelog-local.sh  # Local version
│
└── .github/workflows/         # GitHub Actions
    ├── ai-changelog.yml       # Auto-generate commit summaries
    └── daily-summary-email.yml # Daily digest emails
```

## Development Workflow

### Local Editing

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd Project-MARS-SOP
   ```

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Edit LaTeX files** in your preferred editor:
   - VS Code with LaTeX Workshop extension
   - TeXstudio
   - Overleaf (see below)

4. **Build and preview:**
   ```bash
   make watch  # Auto-rebuild on changes
   ```

5. **Commit changes:**
   ```bash
   git add .
   git commit -m "Description of changes"
   git push origin feature/your-feature-name
   ```

### Overleaf Integration

This repository syncs with Overleaf for collaborative editing:

1. Link Overleaf project to GitHub repository
2. Edit in Overleaf web interface
3. Sync changes back to GitHub
4. Overleaf commits appear as "Updates from Overleaf"

### LaTeX Style Guidelines

- **Indentation**: Use 2 spaces (not tabs)
- **Line length**: Aim for 80-100 characters
- **Section breaks**: Add blank lines between major sections
- **Comments**: Use `%` for explanatory comments
- **Acronyms**: Define all acronyms in `glossaries/ABCA.tex`
- **Cross-references**: Use `\cref{}` instead of `\ref{}`
- **Consistency**: Follow existing patterns in chapter files

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

**Quick Guidelines:**
- Follow existing document structure and formatting
- Test builds locally before committing
- Write clear commit messages
- Update glossaries/acronyms as needed
- Ensure compliance with military documentation standards

## Automation

### AI-Powered Changelog

Commits to the `main` branch automatically generate AI summaries:

```bash
# Workflow: .github/workflows/ai-changelog.yml
# Script: scripts/ai-changelog.sh
# Uses: OpenAI GPT-5-mini for plain-English summaries
```

Commit messages are automatically amended with a section like:

```
AI changelog:
- Updated safety procedures for BVLOS operations
- Added new checklist for pre-flight inspections
- Clarified operator certification requirements
```

### Daily Summary Emails

Stakeholders receive daily email digests at 08:30 UTC:

```bash
# Workflow: .github/workflows/daily-summary-email.yml
# Recipients: Configured via GitHub Secrets
# Format: Plain-English summary for non-technical audiences
```

## Document Features

### Interactive PDF Elements

- **Acronym Tooltips**: Hover over acronyms to see full definitions
- **Glossary Tooltips**: Hover over technical terms for descriptions
- **Hyperlinked References**: Click cross-references to navigate
- **Table of Contents**: Clickable chapter/section navigation

### Custom Formatting

The `sop.cls` class provides:
- Hierarchical section indentation
- Running headers with chapter titles
- Consistent footer branding
- Automated list margin management
- Military-style section numbering (1-2.3 format)

## License

This document is property of the U.S. Government and Keller Army Community Hospital. Distribution and use are subject to applicable government regulations.

## Contact

**Project NCOIC:** SFC Jamez White
**Organization:** Keller Army Community Hospital
**Purpose:** UAS Operations for Medical Logistics

---

**Version Control:** All changes tracked via Git
**Changelog:** See [Commit History.md](Commit%20History.md) for detailed change log
