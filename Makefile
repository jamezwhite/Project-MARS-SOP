# Project MARS SOP - Makefile
# Provides standardized build commands for the LaTeX document

# Configuration
MAIN_TEX = Main.tex
OUTPUT_DIR = build
PDF_NAME = Project-MARS-SOP.pdf
LATEX_CMD = pdflatex
LATEX_FLAGS = -interaction=nonstopmode -halt-on-error -output-directory=$(OUTPUT_DIR)

# Phony targets (not actual files)
.PHONY: all clean build quick watch help install-deps

# Default target
all: build

# Full build with glossaries and cross-references
build:
	@echo "Building Project MARS SOP (full build)..."
	@mkdir -p $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/chapters
	@mkdir -p $(OUTPUT_DIR)/appendices
	@mkdir -p $(OUTPUT_DIR)/glossaries
	@mkdir -p $(OUTPUT_DIR)/frontmatter
	$(LATEX_CMD) $(LATEX_FLAGS) $(MAIN_TEX)
	@if [ -f $(OUTPUT_DIR)/Main.aux ]; then \
		makeglossaries -d $(OUTPUT_DIR) Main; \
	fi
	$(LATEX_CMD) $(LATEX_FLAGS) $(MAIN_TEX)
	$(LATEX_CMD) $(LATEX_FLAGS) $(MAIN_TEX)
	@mv $(OUTPUT_DIR)/Main.pdf ./$(PDF_NAME)
	@echo "Build complete: $(PDF_NAME)"

# Quick build (single pass, no glossaries)
quick:
	@echo "Quick build (single pass)..."
	@mkdir -p $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/chapters
	@mkdir -p $(OUTPUT_DIR)/appendices
	@mkdir -p $(OUTPUT_DIR)/glossaries
	@mkdir -p $(OUTPUT_DIR)/frontmatter
	$(LATEX_CMD) $(LATEX_FLAGS) $(MAIN_TEX)
	@mv $(OUTPUT_DIR)/Main.pdf ./$(PDF_NAME)
	@echo "Quick build complete: $(PDF_NAME)"

# Continuous build with latexmk
watch:
	@echo "Starting continuous build (watch mode)..."
	@echo "Press Ctrl+C to stop"
	@mkdir -p $(OUTPUT_DIR)
	@mkdir -p $(OUTPUT_DIR)/chapters
	@mkdir -p $(OUTPUT_DIR)/appendices
	@mkdir -p $(OUTPUT_DIR)/glossaries
	@mkdir -p $(OUTPUT_DIR)/frontmatter
	latexmk -pdf -pvc -outdir=$(OUTPUT_DIR) $(MAIN_TEX)

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(OUTPUT_DIR)
	@rm -f $(PDF_NAME)
	@rm -f *.aux *.log *.out *.toc *.lof *.lot *.bbl *.blg
	@rm -f *.acn *.acr *.alg *.glg *.glo *.gls *.ist
	@rm -f *.fdb_latexmk *.fls *.synctex.gz
	@echo "Clean complete"

# Install required LaTeX packages (for Ubuntu/Debian)
install-deps:
	@echo "Installing LaTeX dependencies..."
	@echo "This requires sudo privileges"
	sudo apt-get update
	sudo apt-get install -y texlive-latex-extra texlive-fonts-extra
	sudo apt-get install -y texlive-science texlive-pictures
	sudo apt-get install -y latexmk
	@echo "Dependencies installed"

# Help target
help:
	@echo "Project MARS SOP - Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  make build       - Full build with glossaries (default)"
	@echo "  make quick       - Quick single-pass build"
	@echo "  make watch       - Continuous build on file changes"
	@echo "  make clean       - Remove all build artifacts"
	@echo "  make install-deps - Install LaTeX dependencies (Ubuntu/Debian)"
	@echo "  make help        - Show this help message"
	@echo ""
	@echo "Output: $(PDF_NAME)"
