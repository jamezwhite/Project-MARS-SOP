Conduct a full ABCA (Acronyms, Brevity Codes, and Abbreviations) check across all `.tex` files in this repository.

## Steps

1. **Scan every `.tex` file** for uncited ABCAs — uppercase abbreviations (2+ capital letters) that appear as plain text rather than inside an `\ac{}`, `\acs{}`, `\acl{}`, `\acf{}`, or `\acp{}` command. Ignore ABCAs inside `\DeclareAcronym` blocks, `\label`/`\ref` commands, LaTeX comments (`%`), and `glossaries/ABCA.tex` itself.

2. **For each uncited ABCA found:**
   a. Check whether a matching `\DeclareAcronym` entry already exists in `glossaries/ABCA.tex`.
   b. If it does **not** exist, add a new entry in alphabetical order. Use your best judgment for the long-form expansion based on context; if uncertain, flag it with `\claudecomment{}`.
   c. Replace the plain-text occurrence with `\claudereplace{\ac{key}}{ORIGINAL}`.

3. **Summary:** After all edits, list:
   - Each ABCA that was cited (file, line, original text → replacement)
   - Any new entries added to `glossaries/ABCA.tex`
   - Any ABCAs flagged as uncertain
