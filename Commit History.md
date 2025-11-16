## 2025-11-08 – Initial commit

AI changelog:
- Add top-level README.md containing a single-line project title "Project-MARS".
- Establish a minimal documentation placeholder at the repository root for future project description and usage details.
- README currently only includes the title line and has no trailing newline at end of file.


---

## 2025-11-10 – add initial LaTeX files for project documentation

AI changelog:
- Add top-level LaTeX book skeleton (Main.tex) to serve as the SOP root document; contains basic document structure and an empty include placeholder for assembling chapters.
- Add new chapter file "Roles and Responsibilities.tex" defining a "Roles and Responsibilities" chapter with discrete sections for Hospital Commander, Project MARS OIC, Project MARS NCOIC, Cadet Engineering Team Liaison, Remote Pilot in Command (RPIC), Visual Observer (VO), and Maintenance Officer / Technician.
- Establish initial SOP structure: chapter and section headings created as placeholders (no substantive prose for the roles yet), making the document ready for content population and further chapter includes.


---

## 2025-11-10 – Initial commit of KACH Standard Operating Procedures (SOP) document.

AI changelog:
- Add chapter "Airframe & Supporting Systems" with a full outline: Approved Airframes; Configuration Management and Documentation; System Specifications (with subsections for Airframe Performance, Command and Control (C2) Systems, and Beyond Visual Line of Sight (BVLOS) Systems); Cargo Approved for Flight; and Ground Control Station (GCS) and Software.
- Add chapter "Flight Operations" and flesh out its structure: Types of Operations (subsections for Routine Scheduled Delivery, On‑Demand/Emergency Response, Developmental Test & Evaluation (DT&E), and Training), plus sections for Air Corridor and Route Management, Mission Planning and Approval Cycle, Flight Procedures, and Data Management.
- Add Appendix C "Checklists" containing placeholders for Pre‑Flight Checklist, Post‑Flight Checklist, and Emergency Procedures Checklist.
- Add Appendix D "Required Forms" listing Pre‑Flight Inspection Form, Flight Log Form, Maintenance Log Form, and Incident Report Form.
- Add/expand the "General" chapter skeleton with sections for Purpose, Description of Operation, Applicability, and Proponent and Authority, including paragraph-level items for Proponent, Exception/Waiver Authority, Limits to Proponent Authority, Recommended Changes, and Precedence.


---

## 2025-11-10 – Updated Readme.md to include information about LaTeX documentation.

AI changelog:
- README expanded from a bare title to a short project description that states the repository holds all relevant documentation for Project MARS.
- Clarifies that all documentation is written in LaTeX and notes this choice as intended to ease future updates.
- Minor readability/structure: title now separated from the descriptive text with paragraph breaks to make the README easier to scan.


---

## 2025-11-15 – Updates from Overleaf

AI changelog:
- Added a new, comprehensive acronym glossary file containing definitions for a wide set of terms used throughout the SOP (examples: UAS/UAV, GCS, C2, BVLOS, FAA, DoD, KACH, MARS, ATC, NOTAM, VLOS, RPI C, etc.), centralizing acronym definitions for consistent usage.
- Renamed the "Airframe & Supporting Systems" chapter to "Airframes & Supporting Systems" and added a chapter label to enable stable internal references.
- Reworked the chapter subsectioning: the former "Approved Airframes" heading was replaced by a "UAS Operational Approval" section, and subsystem headings now use standard acronyms for clarity (e.g., C2 Systems, BVLOS Systems, Ground Control Station and Software) instead of parenthetical spell-outs.
- Added a chapter label to the Checklists chapter to support cross-references; no changes to checklist content or section structure were made.


---

## 2025-11-15 – Add AI changelog workflow configuration

AI changelog:
- Add a new GitHub Actions workflow "AI Changelog" that runs on pushes to the main branch to produce an automated changelog for recent changes.
- Job "summarize-and-amend" runs on ubuntu-latest and checks out the repository with fetch-depth: 2 so the workflow can compute the parent commit diff for summarization.
- Workflow configures a dedicated git identity (ai-changelog-bot) and exposes GITHUB_SHA and OPENAI_API_KEY to a script that generates the changelog (scripts/ai-changelog.sh).
- Grant write permission to repository contents so the job can amend the commit (push/force-push), enabling the generated AI changelog to be committed back to the branch.


---

## 2025-11-15 – Implement AI changelog generator script

Add AI-powered changelog generator for LaTeX repos

AI changelog:
- Add a new ai-changelog.sh automation that generates concise, LaTeX-aware changelog summaries for the latest commit by calling an OpenAI chat model; documents runner requirements (curl, jq) and expects OPENAI_API_KEY (GITHUB_SHA optional).
- Collect and trim the commit diff (handles the initial-commit case by using git show, otherwise uses git diff HEAD^ HEAD) and limits diff size to 12k characters; exits early if no diff is found.
- Construct a focused AI prompt tailored to LaTeX/document projects (detailed system message and user instructions) so the model produces 3–10 bullet changelogs that describe document-level edits rather than raw LaTeX commands.
- Call the OpenAI chat completions API (model gpt-5-mini) with a controlled temperature, extract and normalize the returned summary, and check for empty or error responses; includes safety/error checks (missing API key, empty response) and robust shell settings (set -euo pipefail).
- Integrate the generated text into the repository by skipping if the commit already contains an "AI changelog:" section, appending the AI summary to the commit message, amending the commit, and pushing the updated commit back with --force-with-lease; emits progress and error logs.


---

## 2025-11-15 – Make ai-changelog script executable

AI changelog:
- Set scripts/ai-changelog.sh as executable (file mode changed from 100644 to 100755).
- No changes to the script's contents or text; only the file permission was modified.
- Allows the changelog-generation script to be run directly without an extra chmod, simplifying local developer workflow and automation.
- No change to LaTeX sources or document content—this is purely a tooling/permission update.


---

## 2025-11-15 – test: trigger AI changelog

Add a test note regarding AI changelog.

AI changelog:
- Inserted a source-only developer/test note as a LaTeX comment after \end{document}; the comment is an AI-changelog test message that references the Montreal Canadiens/Boston Bruins rivalry ("Go B's!"). This is present only in the .tex source and does not affect the compiled PDF.
- Added two trailing blank lines at the end of the file (whitespace-only change, no effect on output).
- No changes to document structure or visible content: appendices, glossary inclusion, and the document termination remain unchanged.


---

## 2025-11-15 – Lower temperature for AI model in changelog script

Reduced temperature setting for AI model to improve response consistency.

AI changelog:
- Removed the explicit "temperature": 0.15 field from the JSON payload used when calling the GPT model, so the request will now rely on the API's default temperature (potentially changing the randomness of generated summaries).
- Inserted a blank line before the log message that announces the LaTeX-aware summary request (purely formatting/whitespace; no change to logic).
- No other changes to the request construction or the log text — the script still builds the JSON payload and sends it to the model as before.


---

## 2025-11-15 – Add AI changelog script for local commits

AI changelog:
- Add a new local helper script that automatically generates a concise, LaTeX-focused changelog for the current commit and appends it to the commit message.
- Designed for interactive use (e.g., during an interactive rebase) and intentionally local-only: it amends the current commit but does not push anything.
- Determines an appropriate diff for the current commit (handles root commit vs normal commits), truncates the diff to ~12k characters, and skips when there is no diff to summarize.
- Skips generation if the commit already contains an "AI changelog:" section or if the OPENAI_API_KEY environment variable is not set; emits clear error/status messages in these cases.
- Sends the diff plus explicit system/user prompts to OpenAI (chat completions using model gpt-5-mini) asking for a 3–6 bullet, LaTeX-document-focused changelog, validates the response, and reports API errors.
- Formats the returned bullets under an "AI changelog:" heading, trims extra blank lines, and amends the commit message; includes console logging to show the AI summary and progress.


---

## 2025-11-15 – Doing a Rebase; have to upload a script

AI changelog:
- Make scripts/ai-changelog-local.sh executable (file mode changed from 100644 to 100755), so the helper script can be run directly from the checkout.
- Simplifies local changelog workflow by allowing ./scripts/ai-changelog-local.sh invocation instead of invoking an interpreter explicitly.
- No changes to the script's contents or documentation text — this is a permission-only update.


---
## 2025-11-16 – Fixed issue with printf formatting in ai-changelog script

Commit: `90211a5`

- Simplified and clarified scripts/ai-changelog.sh file writing: creation of the commit-history header now uses a single grouped write (one redirect) instead of multiple separate echo calls, reducing redundant redirections.
- Replaced the multi-printf append block with a heredoc that appends a consistently formatted entry (date and subject line, "Commit: `hash`", the summary text, and a '---' separator). The produced content and git add behavior remain the same, but the script is easier to read and maintain.

---

## 2025-11-15 – Merge pull request #1 from jamezwhite/codex/review-sop-structure

Commit: `36631cd`

- Reorganized the document source into a clearer directory structure: chapter files moved into chapters/, appendices into appendices/, glossary files into glossaries/, front page into frontmatter/, and images into assets/.  
- Updated the main document to point to the new locations for the front matter, all chapter includes, and appendices so the table of contents, lists and appendices are built from the relocated files.  
- Moved glossary/abbreviation and term inputs to the new glossaries/ folder and updated the main file to load them from that path.  
- Adjusted the front page to use the relocated Project Mars Patch image under assets/ and updated the image reference accordingly.  
- No substantive content changes to chapters, appendices, glossary entries, or checklists — files were renamed/moved (content preserved).

---

## 2025-11-15 – Merge overleaf-2025-11-16-0128 into main

Commit: `9b1c0be`

- Removed executable bit from scripts/ai-changelog-local.sh and scripts/ai-changelog.sh (file mode changed from 100755 to 100644), so the helper scripts are no longer marked as executable.
- No edits to document content, structure, or LaTeX sources — this is purely a tooling/permission change.

---

