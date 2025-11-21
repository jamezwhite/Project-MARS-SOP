% Wrapper class for the standard report class.
% Usage: \documentclass{latex classes/report}
% Defaults: No options are set by default; any options passed are forwarded to the base class.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{latex classes/report}[2025/05/15 Baseline wrapper around report]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass{report}
