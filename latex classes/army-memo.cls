\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{army-memo}[2025/11/21 Army memorandum format]

\makeatletter

% Base document class
\LoadClass{article}

% Packages
\RequirePackage[letterpaper,margin=1in]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{calc}
\RequirePackage{setspace}
\RequirePackage{datetime}
\RequirePackage{enumitem}
\RequirePackage{graphicx}
\RequirePackage{hyperref}
\RequirePackage{ifthen}
\RequirePackage{xcolor}
\RequirePackage{xparse}

% Default font and spacing
\renewcommand{\familydefault}{\sfdefault}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.75\baselineskip}
\onehalfspacing

% Header/footer setup
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[C]{\thepage}

% Memo metadata storage
\newcommand{\memoTo}{\@empty}
\newcommand{\memoFrom}{\@empty}
\newcommand{\memoSubject}{\@empty}
\newcommand{\memoSuspense}{\@empty}
\newcommand{\memoDate}{\today}
\newcommand{\memoOfficeSymbol}{\@empty}
\newcommand{\memoReplyTo}{\@empty}

\DeclareDocumentCommand{\memotitle}{m}{\renewcommand{\memoSubject}{#1}}
\DeclareDocumentCommand{\memoto}{m}{\renewcommand{\memoTo}{#1}}
\DeclareDocumentCommand{\memofrom}{m}{\renewcommand{\memoFrom}{#1}}
\DeclareDocumentCommand{\memosuspense}{m}{\renewcommand{\memoSuspense}{#1}}
\DeclareDocumentCommand{\memodate}{m}{\renewcommand{\memoDate}{#1}}
\DeclareDocumentCommand{\memoofficesymbol}{m}{\renewcommand{\memoOfficeSymbol}{#1}}
\DeclareDocumentCommand{\memoreplyto}{m}{\renewcommand{\memoReplyTo}{#1}}

% Heading block
% DoD seal for header
\newcommand{\dodseal}{%
  \IfFileExists{../assets/dod-seal.png}{%
    \includegraphics[width=1.25in]{../assets/dod-seal.png}%
  }{%
    \IfFileExists{assets/dod-seal.png}{%
      \includegraphics[width=1.25in]{assets/dod-seal.png}%
    }{%
      \fbox{\scriptsize DoD seal missing}%
    }%
  }%
}


\newcommand{\memorandumheading}{%
  \begin{tabular*}{\textwidth}{@{}l@{\extracolsep{\fill}}r@{}}
    \begin{minipage}[t]{0.18\textwidth}\centering\dodseal\end{minipage} & \begin{minipage}[t]{0.75\textwidth}
      \raggedleft DEPARTMENT OF THE ARMY\\[-0.25\baselineskip]
      MEMORANDUM FOR RECORD\\
      \memoOfficeSymbol\hfill \memoDate
    \end{minipage}\\
  \end{tabular*}
  \vspace{1.25\baselineskip}
  \begin{tabular}{@{}ll}
    MEMORANDUM FOR & \memoTo\\
    FROM & \memoFrom\\
    SUBJECT & \memoSubject\\
    SUSPENSE & \memoSuspense\\
  \end{tabular}
  \vspace{1.5\baselineskip}
}

% Reply-to line placed above footer
\AtBeginDocument{%
  \ifthenelse{\equal{\memoReplyTo}{\@empty}}{}{%
    \fancyfoot[L]{\small Reply to attention of: \memoReplyTo}%
  }
}

% Title command override
\renewcommand{\maketitle}{%
  \thispagestyle{fancy}%
  \memorandumheading
}

% Section formatting suitable for short memos
\setcounter{secnumdepth}{0}
\setcounter{tocdepth}{0}
\renewcommand\section{\@startsection{section}{1}{0pt}{1.1\baselineskip}{0.5\baselineskip}{\bfseries}}

% Signature block helper
\NewDocumentCommand{\memorandumsignature}{m m}{%
  \vspace{1.5\baselineskip}
  \begin{tabular}{@{}l}
    #1\\\cline{1-1}\\[-0.5ex]
    #2
  \end{tabular}
}

% Distribution block helper
\newenvironment{memorandumdistribution}{%
  \vspace{\baselineskip}
  \textbf{DISTRIBUTION:}\begin{itemize}[leftmargin=1.25em]
}{\end{itemize}}

% Points of contact helper
\newenvironment{memorandumpoc}{%
  \vspace{\baselineskip}
  \textbf{POINT OF CONTACT:}\begin{itemize}[leftmargin=1.25em]
}{\end{itemize}}

% Compatibility with older template name
\providecommand{\armymemosection}{\section}
\providecommand{\armymemosubsection}{\subsection}

% End of class
\makeatother
\endinput
