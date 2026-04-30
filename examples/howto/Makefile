# ***********************************************************************
#
# Name:          Makefile
# Project:       clio-example-howto
# Purpose:       build a deployable executable + asset bundle
# Author:        mikel evins
# Copyright:     2026 by mikel evins
#
# ***********************************************************************
#
# Targets:
#
#   build                  -- default. Builds the executable, then
#                             assembles deploy/ with the executable
#                             and a populated public/ tree.
#   refresh-clio-assets    -- re-copies $(CLIO_DIR)/public/ contents
#                             into this example's public/clio/. Run
#                             after Clio's bundled assets change.
#   clean                  -- removes the build product and deploy/.
#
# Variables:
#
#   CLIO_DIR -- path to the Clio repository checkout. Default: ../..
#               (correct when this example is built from inside the
#               Clio repo). Override on the command line, e.g.:
#                   make CLIO_DIR=/path/to/clio
#   LISP     -- name of the Lisp implementation. Default: sbcl.

CLIO_DIR ?= ../..
LISP     ?= sbcl

.PHONY: build clean refresh-clio-assets

build:
	@echo "Building executable..."
	$(LISP) --non-interactive \
	    --eval '(asdf:load-system :clio)' \
	    --eval '(setf clio:*deployment-mode* :deployed)' \
	    --eval '(asdf:load-system :clio-example-howto)' \
	    --eval '(asdf:make :clio-example-howto)'
	@echo "Assembling deploy bundle..."
	rm -rf deploy
	mkdir -p deploy/public/clio
	mv howto deploy/
	cp -R public/css deploy/public/
	cp -R $(CLIO_DIR)/public/. deploy/public/clio/
	@echo "Done."
	@echo "Deploy bundle: deploy/"
	@echo "Run with:      cd deploy && ./howto"

refresh-clio-assets:
	@echo "Refreshing public/clio/ from $(CLIO_DIR)/public/..."
	rm -rf public/clio
	mkdir -p public/clio
	cp -R $(CLIO_DIR)/public/. public/clio/
	@echo "Done."

clean:
	rm -f howto
	rm -rf deploy
