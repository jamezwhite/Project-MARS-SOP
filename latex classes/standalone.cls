% Wrapper class for the standalone class.
% Usage: \documentclass{latex classes/standalone}
% Defaults: No options are set by default; any options passed are forwarded to the base class.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{latex classes/standalone}[2025/05/15 Baseline wrapper around standalone]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{standalone}}
\ProcessOptions\relax
\LoadClass{standalone}
