% Wrapper class for the memoir class.
% Usage: \documentclass{latex classes/memoir}
% Defaults: No options are set by default; any options passed are forwarded to the base class.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{latex classes/memoir}[2025/05/15 Baseline wrapper around memoir]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax
\LoadClass{memoir}
