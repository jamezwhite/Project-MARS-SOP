$pdf_mode = 1;            # use pdflatex
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Ensure enough runs for TOC, glossaries, and cross-references
$max_repeat = 5;
