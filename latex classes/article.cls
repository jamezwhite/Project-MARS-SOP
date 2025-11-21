% Wrapper class for the standard article class.
% Usage: \documentclass{latex classes/article}
% Defaults: No options are set by default; any options passed are forwarded to the base class.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{latex classes/article}[2025/05/15 Baseline wrapper around article]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}
