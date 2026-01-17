# latexmk configuration for Project MARS SOP
# Enables automated builds with proper glossary/acronym handling

# Use pdflatex for PDF generation
$pdf_mode = 1;
$dvi_mode = 0;
$postscript_mode = 0;

# Output directory
$out_dir = 'build';

# Clean up extended file types
$clean_ext = 'acn acr alg glg glo gls ist synctex.gz';

# Custom dependency for glossaries
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

sub run_makeglossaries {
    my ($base_name, $path) = fileparse($_[0]);
    pushd $path;
    my $return = system "makeglossaries", $base_name;
    popd;
    return $return;
}

# Continuous preview mode settings
$preview_continuous_mode = 1;
$pdf_previewer = 'start %O %S';  # Windows
# $pdf_previewer = 'open %O %S';  # macOS
# $pdf_previewer = 'evince %O %S';  # Linux

# Maximum number of LaTeX runs
$max_repeat = 5;

# Interaction mode
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';

# Silence some warnings
$silent = 0;
