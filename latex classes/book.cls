% Wrapper class for the standard book class.
% Usage: \documentclass{latex classes/book}
% Defaults: No options are set by default; any options passed are forwarded to the base class.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{latex classes/book}[2025/05/15 Baseline wrapper around book]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions\relax
\LoadClass{book}
