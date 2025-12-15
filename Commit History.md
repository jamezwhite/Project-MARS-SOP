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

## 2025-11-15 – Merge overleaf-2025-11-16-0310 into main

Commit: `6ef9706`

- Overhauled section and heading formatting: replaced the prior paragraph-formatting block with a new, clearer section-formatting policy that changes numbering/display for chapters, sections, subsections, subsubsections, paragraphs, and subparagraphs, and adjusts spacing/indents for each heading level.
- Changed numbering depth and counter resets: number through paragraph level (secnumdepth=4), set table-of-contents depth to 2, restart subsubsection numbering per subsection and paragraph numbering per subsubsection; subsubsections now use alphabetic labels and paragraphs use parenthetical numerals, while subparagraphs remain unnumbered.
- Added the ulem package (with normalem) to preserve italic emphasis styling while allowing underlining where used.
- Promoted many inline paragraph entries to actual subsubsection headings (notably in the References appendix and the General chapter) to improve document hierarchy; also fixed a typo in the "Precedence" heading and standardized a few section titles.
- Minor layout and markup cleanups across chapters: moved a chapter label onto its own line in Pilot Certification, normalized indentation/whitespace of subsection lines in several chapter files.

---

## 2025-11-17 – Add daily summary email workflow

Commit: `7aadb85`

- Added a new GitHub Actions workflow that sends a "Daily layman summary" email: scheduled to run at 08:30 and 09:30 UTC (with an internal check so it only proceeds when it's 04:30 Eastern) and also triggerable manually for testing.
- The workflow checks out the repo, collects git commits from the last 24 hours (using a full fetch) and skips the rest of the pipeline if there are no recent commits.
- When changes exist, it builds a plain‑language system+user prompt and calls the OpenAI gpt-5-mini model to produce a 3–5 bullet summary aimed at non‑technical stakeholders, focusing on high‑level document changes and their significance.
- The generated summary is captured and used as the plain‑text body of an email that the workflow sends via an SMTP action; recipients, sender, and SMTP connection are supplied through repository secrets.
- Secrets and failure handling: the workflow reads OPENAI_API_KEY and mail credentials from secrets, prints diagnostic output, and fails with an error if summary generation does not return valid content.

---

## 2025-11-17 – Improve daily summary email workflow

Commit: `2cb884a`

- Condensed the schedule-related commentary: the previous multi-line note explaining Eastern vs UTC timing was shortened to a single-line summary while the cron schedule (08:30 and 09:30 UTC) is unchanged.
- Converted the AI system and user prompts from multi-line heredocs to single-line shell strings with embedded newline escapes; prompt content is preserved with a small wording tweak to request the summary "in a bulleted list."
- Removed a few commented examples/explanatory lines (notably the SMTP connection example and a comment about the plain-text body) to simplify the workflow file.
- Minor cleanup of comments and spacing around the email/send steps; no functional change to the conditional gating, summary generation, or the email body which still uses the AI-generated summary.

---


## 2025-11-18 – Overleaf sync: restructure headings and outlines

Commit: `f890b72`

- Adjusted heading layout across the document: increased left indentation/spacing for subsections, subsubsections, paragraphs, and subparagraphs (switched to inch-based offsets) and cleaned a minor package/whitespace line for list spacing.
- Added a set of placeholder subsections and high-level sections to the Flight Operations chapter: Routine Scheduled Delivery, On‑Demand / Emergency Response Delivery, DTE Flights, Training Flights, plus empty sections for Air Corridor and Route Management, Mission Planning and Approval Cycle, Flight Procedures, and Data Management (skeleton structure for detailed content).
- Expanded the Maintenance chapter with section headings for Maintenance Schedule, Battery Management Protocol, Software and Firmware Update Procedures, Supply and Spare Parts Management, and Maintenance Documentation (skeleton additions to outline maintenance procedures).
- Reflowed and clarified the Pilot Certification chapter: tidied paragraph breaks and indentation, preserved the Operator Qualification Framework and AO qualification text, and added/explicitly created headings for QP Qualification, EO Qualification, Instructor Pilot / Pilot Evaluator Training, and Currency and Recurrency Requirements.
- Clarified Roles and Responsibilities wording: renamed/standardized references to the Technical Lead, added an explicit responsibility to certify individual airframes for flight, and specified that the Technical Lead trains and approves maintenance technicians; small wording fixes to the Maintenance Technician description.
- Removed the opening lines of the "Lost Communication (Lost Link)" emergency-procedures subsection (the "Situation" heading and its opening sentence), indicating the start of a restructure of the Lost Link content.

---
## 2025-11-18 – Fix placement of Overleaf sync changelog

Commit: `1d250ef`

- Restructured heading layout and list spacing across the document: increased left indentation/spacing for subsections, subsubsections, paragraphs and subparagraphs (moved to inch-based offsets) and cleaned a minor package/whitespace line affecting list spacing.
- Added a set of placeholder subsections to the Flight Operations chapter to create a high-level outline: Routine Scheduled Delivery, On‑Demand / Emergency Response Delivery, DTE Flights, Training Flights, plus skeleton headings for Air Corridor and Route Management, Mission Planning and Approval Cycle, Flight Procedures, and Data Management.
- Expanded the Maintenance chapter with skeleton section headings for key procedures: Maintenance Schedule, Battery Management Protocol, Software and Firmware Update Procedures, Supply and Spare Parts Management, and Maintenance Documentation.
- Reflowed and clarified the Pilot Certification chapter: tidied paragraph breaks and indentation, kept the Operator Qualification Framework and AO qualification text, and added explicit headings for QP Qualification, EO Qualification, Instructor Pilot / Pilot Evaluator Training, and Currency and Recurrency Requirements.
- Clarified Roles and Responsibilities wording: standardized references to the Technical Lead, added an explicit responsibility to certify individual airframes for flight and to train/approve maintenance technicians, applied minor wording fixes to the Maintenance Technician description, and removed the opening "Situation" lines from the Lost Communication (Lost Link) emergency subsection as part of its restructuring.

---

## 2025-11-19 – Modify daily summary email schedule and remove time check

Commit: `4edcc1f`

- Schedule simplified: the workflow now runs once daily at 08:30 UTC instead of at both 08:30 and 09:30 UTC.
- Removed the shell step that checked Eastern time (04:30) and set the RUN_TASK environment flag, eliminating the internal time-gating logic.
- The checkout step (and any subsequent steps) still retain the conditional on env.RUN_TASK == 'true', but the workflow no longer sets that variable within the job.

---

## 2025-11-19 – Refactor daily summary email workflow conditions

Commit: `98591e6`

- Simplified the scheduled run: clarified the workflow now runs daily at 08:30 UTC (keeps the existing cron schedule) and removed the previous comment about running twice and gating on Eastern time.  
- Introduced a job-level HAS_CHANGES flag (default "false") and updated the commit-collection step to set HAS_CHANGES=true/false; added a short log line when commits are found to make output clearer.  
- Removed the previous RUN_TASK gating: repository checkout and commit collection always execute, and the AI-summary and email-send steps are now conditioned solely on HAS_CHANGES being true (no longer require RUN_TASK).  
- Kept the existing AI summary generation and email-send actions, but simplified their if-conditions so they run whenever recent commits are detected.

---

## 2025-11-19 – Add SMTP server configuration for email action

Commit: `427a4c4`

- Replace the single connection_url secret with explicit SMTP fields: the workflow now specifies server address, port and secure flag instead of relying on a single connection URL.
- Add explicit authentication fields (username and password) and note they should be stored in GitHub secrets; the previous single SECRET-based connection is removed.
- Clarify email metadata and routing: subject, to, and from remain, and the message body is now explicitly set to the AI-generated summary output from the workflow step.
- Add inline comments to document where to place SMTP details and that credentials should be kept in secrets for security.

---

## 2025-11-19 – Merge overleaf-2025-11-19-1504 into main

Commit: `13e209c`

- Fixed paragraph-level heading spacing in the document preamble: the left spacing argument for paragraph titles was changed (previously "1in", now "in"), adjusting the indentation applied to paragraph headings.
- Minor layout tweak only — this affects the horizontal spacing/indentation of all paragraph headings throughout the document.

---

## 2025-11-19 – Updates from Overleaf

Commit: `e2fad6a`

- Added a reusable project-name macro for "Project MARS" and included support for correct trailing space handling when the macro is used, to standardize in-document references to the project name.
- Extended numbering depth to include subparagraphs and enabled subparagraph numbering (roman numerals reset under each paragraph); updated run-in subparagraph formatting and adjusted paragraph/subparagraph spacing to increase left margin and vertical separation for those levels.
- Reorganized and labeled major operational chapters: the Flight Operations chapter was split into explicit, labeled sections (Ground Operations, Flight Scheduling, Briefings and Risk Management, Weather Considerations, Crew Coordination) and the "Types of Operations" section was reintroduced with labels; similarly, the Airframes & Supporting Systems chapter had section and subsection labels added for easier cross-referencing.
- Added section labels to each checklist in the appendices (pre-flight, post-flight, emergency) to allow referencing those checklists from elsewhere in the document.
- Introduced a new appendix "Air Corridor and Route Development" — a full skeleton chapter covering purpose/definitions, roles and responsibilities, design criteria, development process, protection/monitoring, documentation/change management, and templates/examples to guide corridor and route development.

---

## 2025-11-20 – Update daily-summary-email.yml

Commit: `0fe37b5`

- Updated the daily project summary GitHub Actions workflow to send the email to an additional recipient: the government address (adds MAIL_TO_GOVTEMAIL alongside the existing personal email).
- Email metadata otherwise unchanged (subject, from, and AI-generated body remain the same).

---

## 2025-11-21 – Uploading Overlay Photos for CoA

Commit: `fa01f90`

- Added two new aerial illustrations for the Proposed Airspace material: a satellite-overlay view and a VFR sectional view (JPEG assets).
- These images are stored with the Certificate of Authorization materials and provide alternate visualizations of the proposed airspace boundaries and landmarks.
- The new figures improve situational clarity for reviewers by offering both orthophoto/contextual imagery and a conventional VFR sectional depiction for navigation/airspace reference.

---

## 2025-11-21 – Merge overleaf-2025-11-21-1539 into main

Commit: `70b7c46`

- Added an internal label placeholder to the "Accident/Incident Reporting" section to allow future cross-referencing; no other content in that section was changed.
- Minor file-ending change: the trailing newline was removed (no substantive text edits or restructuring).

---

## 2025-11-21 – Add baseline LaTeX class wrappers

Commit: `26846f2`

- Added six minimal wrapper class files under latex classes for the common LaTeX base classes: article, book, report, letter, memoir and standalone. These provide project-local class names that map to the corresponding standard classes.
- Each wrapper is intentionally minimal and documented with a short usage comment; they do not impose any default options and instead forward any options the user supplies to the underlying base class.
- Standardized class metadata (ProvidesClass with a 2025/05/15 identifier) is included in each file, making the wrappers discoverable and consistent across the project.

---

## 2025-11-21 – Create SOP class and simplify main document

Commit: `b372a10`

- Introduced a custom document class (latex classes/sop.cls) and switched the main file to use it. The new class centralizes the entire preamble: package loading, fonts, helper macros, page headers/footers, geometry, hyperref/cleveref, and other layout settings that were previously in the main file.
- Moved all glossary/acronym and tooltip setup into the class (acro/glossaries loading, tooltip-wrapping of \ac and term commands, and the custom "termabove" glossary style), and kept the project glossary inputs in the main document so term data remain unchanged.
- Sectioning, numbering and reference formatting (chapter/section/subsection/subsubsection/paragraph/subparagraph styles and cleveref chapter formatting) were migrated into the class so document-wide typography and numbering are applied automatically.
- Main.tex was drastically slimmed down to the document metadata and content includes (title/author/date, glossary inputs, appendices, etc.); there are no substantive content or wording changes to the body text — this is a structural refactor to centralize style/configuration.

---

## 2025-11-21 – Updates from Overleaf

Commit: `9ce55cb`

- Added a new placeholder file under Certificate of Authorization/VLOS for an airspace request (COL Hipp) — file created for future content.
- Removed the standalone "Aircraft/Medical Emergency Response" section from the Safety chapter, simplifying the section structure.
- Consolidated "Accident/Incident Reporting": gave the section a proper label for cross-referencing and inserted an empty subsection as a placeholder for expanded content.

---

## 2025-11-21 – Remove DoD seal binary asset

Commit: `907d0a4`

- Added a new custom LaTeX class "army-memo" to provide a ready-made memorandum layout: sans-serif font, 1 in margins and 1.5 spacing, unnumbered sections, header/footer setup, commands to set memo metadata (to/from/subject/date/office symbol/suspense/reply-to), automatic heading with a DoD-seal image (with fallback search paths), and helpers for signature blocks, point-of-contact lists, and distribution lists — enabling concise army-style memos from a simple document-level API.

- Added a collection of blank/template documents under "Blank Documents": examples for an army memorandum (showing purpose/background/request, signature block, POC and distribution), and minimal skeletons for article, book, letter, memoir, report, SOP, and standalone documents. Each template contains basic structure and placeholder text to jump-start writing those document types.

- Relocated the "Project Mars Patch.png" asset into the top-level assets directory and updated the frontpage file to use the new relative path (adjusted image include), ensuring the frontpage logo reference resolves after the asset move.

---

## 2025-11-21 – Add files via upload

Commit: `37d0316`

- Added a new image asset: assets/dod-logo.png (Department of Defense logo) to the project's assets folder.
- No textual or structural document changes; the logo is now available for inclusion on the title page, headers, or figures where needed.

---

## 2025-11-21 – Merge overleaf-2025-11-21-1859 into main

Commit: `c7917be`

- Added a new placeholder LaTeX source for the "Airspace Request - COL Hipp" under Certificate of Authorization/VLOS, establishing a file for the upcoming airspace request document.
- The file is currently an empty standalone document (no sections, text, figures, or citations yet) and references the project's standalone document class—serves as a template stub for future content.

---

## 2025-11-25 – Updates from Overleaf

Commit: `5e64152`

- Updated the LaTeX class reference in the army memo template to point to the shared "latex classes" directory (adjusts the documentclass path so the memo uses the centralized class file).
- Replaced the old Pilot Certification chapter file with a relocated/renamed chapter: the include in Main.tex now references the new Operator Certification file and the original Pilot Certification.tex was removed (chapter remains part of the main build under the new path).
- Added/kept a comprehensive "Pilot Certification, Training & Currency" chapter (now stored as Operator Certification) that defines the operator qualification framework and tiers (AO, QP, EO), spells out eligibility and baseline requirements for all operators, and details role descriptions and re‑certification requirements for each tier.
- Expanded and clarified currency and recurrency policy: frequency and tracking rules for AO/QP/EO currency, procedures for lapse and re‑establishment of currency, waiver authority, and cross‑platform currency applicability.

---

## 2025-11-25 – Align list indentation with section levels

Commit: `7dea015`

- Centralized heading/list indentation: introduced a set of shared length registers and helper commands to represent chapter/section/subsection/subsubsection/paragraph/subparagraph indents and a computed list-offset, replacing hard-coded numeric spacing values used for title spacing.
- Made title spacing configurable: chapter/section/subsection/subsubsection/paragraph/subparagraph spacing now references the new shared indentation lengths so heading indents can be adjusted from a single place.
- Sync lists with surrounding headings: added hooks that update a computed left margin when entering a heading and apply that margin to itemize/enumerate, so lists align consistently with the containing heading level plus a fixed offset.
- Infrastructure additions: loaded the etoolbox package and used its hook commands to attach the indent-updating behavior; no document text/content was changed—this is purely a layout/class refactor for consistent indentation.

---

## 2025-11-25 – Updates from Overleaf

Commit: `55f0398`

- Clarified the EO (equipment operator) Role: merged and tightened the description so EOs are explicitly the subject-matter experts for sUAS operations and also serve as flight instructors and operator evaluators; reiterates that the Lead Operator must be EO qualified.  
- Expanded the Lead Operator "Primary Role" to enumerate duties: defined the Lead Operator as the project's SME for flight operations, required EO qualification, responsibility to help the Project OIC develop/implement/manage the aircrew training program (ATP), conduct initial qualification training (IQT) and AO qualification, and either conduct or assist with QP training depending on Master Trainer status.  
- Added an explicit Lead Operator responsibility that they maintain flight qualification training records for project personnel (keeps the Appointment clause unchanged).

---

## 2025-11-25 – Wrap sop class internals in makeatletter

Commit: `402cee3`

- Wrapped the class's internal indentation and list-setting definitions with LaTeX's makeatletter/makeatother so the '@' character is treated as a letter for those internal macro names.  
- This scopes internal length registers and list margin settings correctly, preventing related compilation warnings/errors while leaving visible document formatting unchanged.

---

## 2025-11-25 – Updates from Overleaf

Commit: `0a80f94`

- Cleaned up heading structure and minor formatting in "Roles and Responsibilities": removed an empty subheading, corrected the "Permanent / Appointed Positions" title, and adjusted the heading level for "Additional Responsibilities" under Hospital Commander for consistent hierarchy and presentation.

- Renamed and tightened risk subsections in Safety: "Training Flight Risk" → "Risk of Training Flights" and the catch-all subsection → "Risk of All Other Flights"; clarified that non‑training flights require a hazard analysis and a risk determination and that briefings and prescribed mitigation measures are to be implemented (briefings to be conducted by the RPIC).

- Reworked "Specific Emergency Procedures" layout and references: consolidated the introductory text, switched to capitalized cross‑reference formatting, and reorganized the Lost Communication (Lost Link) guidance into clearer detection/verification checks and bulleted steps for immediate action.

- Expanded and clarified Lost Link procedures and responsibilities: defined RPIC priorities, specified immediate actions (attempt manual link recovery within 30 seconds; monitor telemetry; expect programmed behaviors such as RTH, loiter‑and‑land, or navigation along a contingency route), added notification rules (notify a QP if the RPIC is not QP‑qualified and notify the lead operator), and required logging of time/location/telemetry and reporting to the project NCOIC (with follow‑up actions if a reportable mishap occurs).

- Replaced the previous BVLOS/VLOS subsections with mode‑based guidance: added "Autonomous Flight Mode Specific Considerations" and "Controlled Flight Mode Specific Considerations" to distinguish risks and recommended responses depending on whether the aircraft was on an autonomous route or under person‑control; also standardized the "GPS / Navigation Failure" heading spacing.

---

## 2025-11-26 – Update ai-changelog.sh

Commit: `079b47d`

- Add a new guidance line to the changelog generator instructions requiring that any script or workflow changes be summarized in a single bullet, updating the Output format requirements in scripts/ai-changelog.sh.

---

## 2025-12-15 – Updates from Overleaf

Commit: `532e385`

- Removed a set of blank starter templates used across the project: army memorandum, article, book, letter, memoir, report, SOP, and standalone document templates. These basic example files and their placeholder content (titles, author/date, minimal sections) were deleted, so the repository no longer contains those ready-to-use LaTeX skeletons.

- Deleted Certificate of Authorization visual and placeholder assets: two proposed airspace images (satellite overlay and VFR sectional) and a minimal VLOS airspace-request TeX file. The visual materials and the small COA TeX wrapper are no longer present.

- Removed several KACH SOP helper files (binary helpers and spreadsheets: "3) SOP Generic Operation rev 3.docx", "ABCA Terms LaTeX generator.xlsx", "DRAFT Generic Configuration matrix rev1.docx") and, importantly, deleted the entire Safety and Emergency Procedures chapter. The removed Safety chapter contained the risk-management framework, delegated risk-acceptance authorities, distinctions between training and other flights, general emergency priorities (preservation of life/materiel/mission), pilot priorities (aviate/navigate/communicate), and the beginning of specific emergency procedures including a lost-link subsection.

---

