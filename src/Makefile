.PHONY: download install cleanup full-cleanup measure help

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  install        Installs luas"
	@echo "  download       Cleans up previous files, downloads new ones, and performs a light cleanup"
	@echo "  full-cleanup   Removes all generated or temporary files for a fresh start"
	@echo "  measure        Runs measurement or benchmarking script"
	@echo "  help           Shows this help message"

install:
	./scripts/install.sh

download: full-cleanup
	./scripts/download.sh
	./scripts/cleanup.sh

full-cleanup:
	./scripts/full-cleanup.sh

measure: 
	./scripts/measure.sh

measure_c:
	./scripts/measure_c.sh