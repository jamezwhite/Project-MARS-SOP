# Contributing to Project MARS SOP

Thank you for contributing to the Project MARS Standard Operating Procedure documentation. This guide will help you maintain consistency and quality across the document.

## Table of Contents

- [Getting Started](#getting-started)
- [Document Structure](#document-structure)
- [LaTeX Style Guide](#latex-style-guide)
- [Commit Guidelines](#commit-guidelines)
- [Review Process](#review-process)
- [Testing](#testing)

## Getting Started

### Prerequisites

1. **LaTeX Distribution**: Install a complete LaTeX distribution
   ```bash
   # Ubuntu/Debian
   make install-deps

   # Or manually
   sudo apt-get install texlive-latex-extra texlive-fonts-extra latexmk
   ```

2. **Git**: Ensure Git is configured
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@mail.mil"
   ```

3. **Text Editor**: Use a LaTeX-aware editor
   - **Recommended**: VS Code + LaTeX Workshop extension
   - **Alternatives**: TeXstudio, Overleaf, Texmaker

### Branching Strategy

- `main`: Production-ready document (protected)
- `feature/*`: New features or major additions
- `fix/*`: Bug fixes or corrections
- `update/*`: Content updates or revisions

**Workflow:**
```bash
# Create a feature branch
git checkout -b feature/add-emergency-procedures

# Make changes and test
make build

# Commit with clear message
git commit -m "Add emergency landing procedures to Chapter 7"

# Push and create PR
git push origin feature/add-emergency-procedures
```

## Document Structure

### File Organization

#### Chapters (`chapters/`)
- **Purpose**: Main procedural content
- **Naming**: Use descriptive names with spaces (e.g., `Flight Operations.tex`)
- **Structure**: Chapter → Section → Subsection → Paragraph → Subparagraph
- **Length**: Keep chapters focused (< 500 lines preferred)

#### Appendices (`appendices/`)
- **Purpose**: Supporting reference material
- **Naming**: Descriptive names (e.g., `Checklists.tex`)
- **Content**: Forms, tables, detailed references

#### Glossaries (`glossaries/`)
- **ABCA.tex**: Acronyms only
- **Terms.tex**: Technical terms with definitions
- **Format**: See examples below

### Adding New Content

#### New Chapter
```latex
% chapters/New Chapter.tex
\chapter{New Chapter Title}
\label{chap:new-chapter}

\section{First Section}
\label{sec:first-section}

Content goes here...
```

Add to `Main.tex`:
```latex
\include{chapters/New Chapter}
```

#### New Acronym
Add to `glossaries/ABCA.tex`:
```latex
\acro{NEWACRO}{New Acronym Full Form}
```

Usage in text:
```latex
\ac{NEWACRO}  % First use: "New Acronym Full Form (NEWACRO)"
              % Subsequent: "NEWACRO"
```

#### New Glossary Term
Add to `glossaries/Terms.tex`:
```latex
\newglossaryentry{newterm}{
    name={New Term},
    description={Definition of the new term with relevant context}
}
```

Usage in text:
```latex
\gls{newterm}
```

## LaTeX Style Guide

### General Formatting

**Indentation:**
```latex
% Good
\section{Section Title}
  \subsection{Subsection Title}
    Content with proper indentation.

% Bad
\section{Section Title}
\subsection{Subsection Title}
Content without indentation.
```

**Line Length:**
- Aim for 80-100 characters per line
- Break at logical points (after sentences, commas)

**Spacing:**
```latex
% Good
\section{First Section}

This is the first paragraph.

This is the second paragraph.

\section{Second Section}

% Bad
\section{First Section}
This is the first paragraph.
This is the second paragraph.
\section{Second Section}
```

### Cross-References

**Use `\cref{}` from cleveref package:**
```latex
% Good
See \cref{sec:safety-procedures} for details.
% Output: "See Section 7.2 for details."

% Avoid
See Section~\ref{sec:safety-procedures} for details.
```

**Label Naming Convention:**
```latex
\chapter{...}      \label{chap:short-name}
\section{...}      \label{sec:short-name}
\subsection{...}   \label{subsec:short-name}
\figure{...}       \label{fig:short-name}
\table{...}        \label{tab:short-name}
```

### Lists

**Use `enumerate` for numbered lists:**
```latex
\begin{enumerate}
  \item First item
  \item Second item
  \item Third item
\end{enumerate}
```

**Use `itemize` for bullet points:**
```latex
\begin{itemize}
  \item First bullet
  \item Second bullet
  \item Third bullet
\end{itemize}
```

### Tables

**Standard table format:**
```latex
\begin{table}[htbp]
  \centering
  \caption{Table Title}
  \label{tab:example}
  \begin{tabular}{lcc}
    \hline
    \textbf{Column 1} & \textbf{Column 2} & \textbf{Column 3} \\
    \hline
    Row 1 Data & Value & Value \\
    Row 2 Data & Value & Value \\
    \hline
  \end{tabular}
\end{table}
```

### Figures

**Standard figure format:**
```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{assets/image-name.png}
  \caption{Figure caption explaining the image}
  \label{fig:image-name}
\end{figure}
```

### Comments

**Use comments for:**
- Explaining complex LaTeX code
- Marking TODOs or pending revisions
- Documenting sources or references

```latex
% TODO: Update this section with new FAA regulations
% Source: AR 95-1, Chapter 3, Section 2

\section{Regulatory Compliance}
```

## Commit Guidelines

### Commit Message Format

```
<type>: <short summary>

<optional detailed description>

<optional footer>
```

**Types:**
- `content`: Document content changes (procedures, policies)
- `fix`: Corrections or error fixes
- `format`: Formatting or style changes
- `glossary`: Acronym or term additions/updates
- `assets`: Image or media updates
- `build`: Build system or tooling changes
- `docs`: README or contributing guide updates

**Examples:**
```bash
# Good
git commit -m "content: Add pre-flight inspection checklist to Chapter 5"

git commit -m "fix: Correct acronym definition for BVLOS"

git commit -m "format: Improve table alignment in Appendix B"

# Bad
git commit -m "updates"
git commit -m "fixed stuff"
git commit -m "WIP"
```

### Commit Size

- **Preferred**: Small, focused commits (one logical change)
- **Avoid**: Large commits mixing multiple unrelated changes

### AI Changelog

Commits to `main` automatically receive AI-generated summaries:
- Powered by OpenAI GPT-5-mini
- Appended to commit message body
- Focuses on content changes (not LaTeX markup)

## Review Process

### Before Submitting

1. **Build Locally:**
   ```bash
   make clean
   make build
   ```

2. **Check for Errors:**
   - No LaTeX compilation errors
   - No undefined references
   - No missing acronyms

3. **Review PDF:**
   - Check formatting and layout
   - Verify cross-references work
   - Test acronym/glossary tooltips

4. **Run Spellcheck:**
   - Use editor's built-in spellchecker
   - Pay attention to military terminology

### Pull Request Checklist

- [ ] Branch is up-to-date with `main`
- [ ] Document builds without errors
- [ ] All cross-references are valid
- [ ] New acronyms added to `ABCA.tex`
- [ ] New terms added to `Terms.tex`
- [ ] Commit messages follow guidelines
- [ ] Changes align with military documentation standards

### Review Criteria

Reviewers will check:
- **Accuracy**: Technical and procedural correctness
- **Compliance**: Adherence to regulations (FAA, DoD, Army)
- **Consistency**: Matches existing style and terminology
- **Clarity**: Clear and unambiguous language
- **Completeness**: All necessary information included

## Testing

### Local Build Testing

```bash
# Full build with all passes
make build

# Quick build for rapid iteration
make quick

# Watch mode for continuous testing
make watch
```

### Validation Checklist

- [ ] PDF generates without errors
- [ ] Table of Contents is correct
- [ ] List of Figures is correct (if applicable)
- [ ] List of Tables is correct (if applicable)
- [ ] All acronyms render with tooltips
- [ ] All glossary terms render with tooltips
- [ ] Cross-references link correctly
- [ ] Headers and footers display properly
- [ ] Page numbering is sequential

## Questions or Issues?

- **LaTeX Errors**: Check LaTeX log file in `build/Main.log`
- **Build Issues**: Review Makefile or try manual build
- **Content Questions**: Contact SFC Jamez White, Project NCOIC
- **Technical Issues**: Open a GitHub issue

## Additional Resources

- [LaTeX Documentation](https://www.latex-project.org/help/documentation/)
- [Overleaf Tutorials](https://www.overleaf.com/learn)
- [Army Publishing Directorate](https://armypubs.army.mil/)
- [FAA UAS Regulations](https://www.faa.gov/uas)

---

Thank you for helping maintain high-quality documentation for Project MARS!
