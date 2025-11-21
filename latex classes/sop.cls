\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sop}[2025/01/01 Project MARS SOP class]

% Base class
\LoadClass{report}

% ------------------------------ Packages ------------------------------
\RequirePackage{titling}
\RequirePackage{newtxtext}
\RequirePackage{xspace}
\RequirePackage{fancyhdr}
\RequirePackage{acro}
\RequirePackage[section=section]{glossaries}
\RequirePackage{blindtext}
\RequirePackage{titlesec}
\RequirePackage[normalem]{ulem}
\RequirePackage{graphicx}
\RequirePackage[titletoc]{appendix}
\RequirePackage[
  letterpaper,
  margin=1in,
  includeheadfoot,
  headheight=14pt,
  headsep=10pt,
  footskip=24pt
]{geometry}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{cleveref}
\RequirePackage{pdfcomment}
\RequirePackage{enumitem}

% ------------------------------ Fonts and project helper ------------------------------
\renewcommand{\familydefault}{\sfdefault}
\DeclareRobustCommand{\projectmars}{Project \ac{mars}\xspace}

% ------------------------------ Header/Footer Formatting ------------------------------
\pagestyle{fancy}
\fancyhf{}

% Expose the date set for the title page so we can reuse it in the footer
\makeatletter
\newcommand{\frontpagedate}{\@date}
\makeatother

% Put ONLY the chapter title (not "Chapter 1") in the running header mark
\renewcommand{\chaptermark}[1]{\markboth{#1}{}}

% --- Header: top-left shows chapter title on non-opening pages
\fancyhead[L]{\nouppercase{\leftmark}}

% --- Footer: left = fixed text + front-page date, right = page number
\fancyfoot[L]{Project MARS SOP, \thedate}
\fancyfoot[R]{\thepage}

% Optional rules (lines). Header rule on; footer rule off.
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}

% Make chapter opening pages use a blank header but keep the same footer
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[L]{Project MARS SOP, \thedate}%
  \fancyfoot[R]{\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
}

% Prevent the classic "Package Fancyhdr Warning: \headheight is too small"
\setlength{\headheight}{14pt}

% ------------------------------ Acronym Setup and Tooltips ------------------------------
% Redefine commands after everything is loaded to turn on tooltips
\AtBeginDocument{%
    \let\oldac\ac
    \renewcommand{\ac}[1]{%
        \pdftooltip{\oldac{#1}}{\acl{#1}}%
    }%
}

% ------------------------------ Term Setup and Tooltips ------------------------------
\AtBeginDocument{%
  % Show tooltip with the entry's description when hovering the term
  \NewDocumentCommand{\term}{m}{\pdftooltip{\gls{#1}}{\glsentrydesc{#1}}}
  \NewDocumentCommand{\Term}{m}{\pdftooltip{\Gls{#1}}{\glsentrydesc{#1}}}
  \NewDocumentCommand{\terms}{m}{\pdftooltip{\glspl{#1}}{\glsentrydesc{#1}}}
  \NewDocumentCommand{\Terms}{m}{\pdftooltip{\Glspl{#1}}{\glsentrydesc{#1}}}
}

\newglossarystyle{termabove}{%
  \setglossarystyle{list}% start from the basic list style
  \renewenvironment{theglossary}%
    {\begin{description}[leftmargin=0pt,labelsep=0pt,itemsep=.6\baselineskip]}%
    {\end{description}}%
  \renewcommand*{\glossentry}[2]{%
    \item[]%
      \glstarget{##1}{\textbf{\glsentryname{##1}}}\par
      \glossentrydesc{##1}\glspostdescription\space ##2%
  }%
  \renewcommand*{\glsgroupskip}{}% suppress A/B/C group headings
}

% ------------------------------ Reference Formatting ------------------------------
\crefformat{chapter}{Chapter~#2#1 (\descriptionlabel{#1})#3}
\Crefformat{chapter}{Chapter~#2#1 (\descriptionlabel{#1})#3}

% ------------------------------ Section Formatting ------------------------------
% Numbering policy: number through \paragraph; leave \subparagraph unnumbered
\setcounter{secnumdepth}{5}
% Optional: how deep to list in the ToC (tweak as you like)
\setcounter{tocdepth}{2}

% --------Chapter--------
\renewcommand{\thechapter}{\arabic{chapter}}
\titleformat{\chapter}[display]
  {\normalfont\Huge\bfseries}%
  {Chapter \thechapter}{0.5ex}{\LARGE}
\titlespacing*{\chapter}{0pt}{*3}{*2}

% --------Section--------
\renewcommand{\thesection}{\thechapter-\arabic{section}}
\titleformat{\section}
  {\normalfont\Large\bfseries}%
  {\thesection}{0.6em}{}
\titlespacing*{\section}{0pt}{*2}{0.5\baselineskip}

% --------Subsection--------
\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
\titleformat{\subsection}
  {\normalfont\large\bfseries}%
  {\thesubsection}{0.6em}{}
\titlespacing*{\subsection}{0.10in}{*1.5}{0.4\baselineskip}

% --------Subsubsection--------
\makeatletter
\@addtoreset{subsubsection}{subsection} % restart a., b., c. each subsection
\makeatother
\renewcommand{\thesubsubsection}{\alph{subsubsection}}
\titleformat{\subsubsection}[runin]
  {\normalfont\normalsize\bfseries}%
  {\textit{\thesubsubsection.}}{0.75em}{}
  [\normalfont]
\titlespacing*{\subsubsection}{0.25in}{0.5\baselineskip}{0.75em}

% --------Paragraph--------
\makeatletter
\@addtoreset{paragraph}{subsubsection} % restart (1), (2) under each letter
\makeatother
\renewcommand{\theparagraph}{(\arabic{paragraph})}
\titleformat{\paragraph}[runin]
  {\normalfont\normalsize}%
  {\theparagraph}{0.75em}{\underline}
  [\normalfont]
\titlespacing*{\paragraph}{0.5in}{0.25\baselineskip}{0.75em}

% --------Subparagraph--------
\makeatletter
\@addtoreset{subparagraph}{paragraph} % restart i, ii, iii under each number
\makeatother
\renewcommand{\thesubparagraph}{(\roman{subparagraph})}
\titleformat{\subparagraph}[runin]
  {\normalfont\normalsize}%
  {\thesubparagraph}{.75em}{\bfseries}
  [\normalfont]
\titlespacing*{\subparagraph}{.5in}{0.25\baselineskip}{0.75em}

\endinput
