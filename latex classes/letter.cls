% Wrapper class for the standard letter class.
% Usage: \documentclass{latex classes/letter}
% Defaults: No options are set by default; any options passed are forwarded to the base class.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{latex classes/letter}[2025/05/15 Baseline wrapper around letter]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{letter}}
\ProcessOptions\relax
\LoadClass{letter}
