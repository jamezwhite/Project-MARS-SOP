# Project MARS — Claude Code Guidelines

## Change Tracking (mandatory)

Track **substantive prose additions** in chapter/appendix files using the commands below. The goal is to mark new content for review, not to track formatting or structure.

| Command | Use |
|---|---|
| `\claudeadd{...}` | New prose text you insert |
| `\claudedel{...}` | Prose text you remove |
| `\claudereplace{new}{old}` | Prose text you modify |
| `\claudecomment{...}` | Notes, questions, or flags for the author |

### What to Track

- Sentences and paragraphs of prose content
- List item text (wrap the text inside `\item`, not the `\item` command itself)
- Table cell content (wrap the cell text, not the table structure)

### What NOT to Track

**Never use change-tracking commands in these files** (they are processed in the preamble):
- `glossaries/ABCA.tex` — add/edit acronyms directly; append `(added by Claude)` to the `long` field
- `glossaries/Terms.tex` — add/edit terms directly; append `(added by Claude)` to the `description` field

**Never wrap these structural elements** (causes compilation errors):
- Sectioning: `\chapter`, `\section`, `\subsection`, `\subsubsection`, `\paragraph`
- Environments: `\begin{...}`, `\end{...}`
- Labels/refs: `\label`, `\ref`, `\cref`, `\nameref`
- Declarations: `\DeclareAcronym`, `\newglossaryentry`
- Table/list structure: `\hline`, `\\`, `&`, `\item`

### Examples

```latex
% CORRECT - wrap prose content only
\claudeadd{The crew will verify all equipment before launch.}

\begin{itemize}
    \item \claudeadd{Check battery levels}
    \item \claudeadd{Verify GPS lock}
\end{itemize}

% CORRECT - acronym addition (no tracking command, marker in long form)
\DeclareAcronym{xyz}{
    short = {XYZ},
    long  = {Example Acronym (added by Claude)}
}

% WRONG - do not wrap structural commands
\claudeadd{\subsection{New Section}}
\claudeadd{\begin{itemize}...\end{itemize}}
```

When finished, summarize what was changed and in which files.

## No Compilation

Never compile or build the document. The user will run `pdflatex` / `latexmk` manually.

## Acronyms & Abbreviations (ABCA)

- All acronyms in `.tex` content must be cited with `\ac{key}` (or `\acs{}`, `\acl{}`, `\acf{}`, `\acp{}` as appropriate). Never write a bare acronym in prose.
- Acronym declarations live in `glossaries/ABCA.tex` using `\DeclareAcronym{key}{ short = {...}, long = {...} }`. Keep entries in alphabetical order by key.
- The `acro` package handles first-use expansion automatically — do not manually spell out an acronym on first use.

## Glossary Terms

- Defined terms live in `glossaries/Terms.tex` using `\newglossaryentry{key}{...}`. Each entry must include a `description` with a trailing `\glspar\hfill\textit{Source: ...}` attribution.
- Reference terms in prose with `\term{key}` (lowercase) or `\Term{key}` (sentence-case). Plural forms: `\terms{key}` / `\Terms{key}`.

## Document Structure

- The document class is `sop` (defined in `sop.cls`), based on `report`.
- Sectioning hierarchy: `\chapter` → `\section` → `\subsection` → `\subsubsection` → `\paragraph` → `\subparagraph`. Numbering goes through `\paragraph`; `\subparagraph` is unnumbered.
- Numbering format: chapters are arabic (`1`), sections are `1-1`, subsections `1-1.1`, subsubsections are lettered (`a.`), paragraphs are `(1)`, subparagraphs are `(i)`.
- Cross-references use `cleveref`: prefer `\cref{}` and `\Cref{}` over manual "Chapter 1" text.
- Use `\projectmars{}` for the project name — it expands to "Project MARS" with proper acronym handling.

## File Organization

| Path | Content |
|---|---|
| `Main.tex` | Preamble and document skeleton — avoid editing unless adding packages or preamble commands |
| `sop.cls` | Document class — do not modify without explicit permission |
| `chapters/` | Main body chapters |
| `appendices/` | Appendix chapters |
| `glossaries/ABCA.tex` | Acronym declarations |
| `glossaries/Terms.tex` | Glossary term definitions |
| `assets/` | Images, PDFs, and other supporting documents |

## Style Notes

- This is a US Army Standard Operating Procedure. Maintain formal, directive tone.
- Prefer active voice and imperative mood for procedures (e.g., "The RPIC will verify..." or "Verify...").
- Do not introduce casual language, contractions, or emojis.
