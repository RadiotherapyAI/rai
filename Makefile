SHELL := /bin/bash -o pipefail -e
.SUFFIXES:
.SECONDARY:
.DELETE_ON_ERROR:

release := ./docs
src := ./src

CONFIG := $(src)/config.yml
DATA_FILES := $(wildcard $(src)/data/*.yml)

SRC_MD := $(shell find $(src)/documents/ -type f -name '*.md')
SRC_PNG := $(shell find $(src)/documents/ -type f -name '*.png')
SRC_JPG := $(shell find $(src)/documents/ -type f -name '*.jpg')
SRC_CSV := $(shell find $(src)/documents/ -type f -name '*.csv')
SRC_XLSX := $(shell find $(src)/documents/ -type f -name '*.xlsx')

RELEASE_MD := $(patsubst $(src)/documents/%.md,$(release)/%.md,$(SRC_MD))
RELEASE_PNG := $(patsubst $(src)/documents/%.png,$(release)/%.png,$(SRC_PNG))
RELEASE_JPG := $(patsubst $(src)/documents/%.jpg,$(release)/%.jpg,$(SRC_JPG))
RELEASE_CSV := $(patsubst $(src)/documents/%.csv,$(release)/%.csv,$(SRC_CSV))
RELEASE_XLSX := $(patsubst $(src)/documents/%.xlsx,$(release)/%.xlsx,$(SRC_XLSX))
RELEASE_JB = $(release)/_config.yml $(release)/_toc.yml \
	$(release)/references.bib \
	$(release)/_static/handsontable.full.min.css \
	$(release)/_static/handsontable.full.min.js \
	$(release)/_static/pyexcel.css \

RELEASE_ALL := $(RELEASE_PNG) $(RELEASE_JPG) $(RELEASE_MD) $(RELEASE_CSV) $(RELEASE_JB) $(RELEASE_XLSX)

all: $(RELEASE_ALL)

$(release)/%.md: $(src)/documents/%.md $(CONFIG) $(DATA_FILES)
	@mkdir -p $(@D)
	poetry run rdm render $< $(CONFIG) $(DATA_FILES) > $@

$(release)/%.png: $(src)/documents/%.png
	@mkdir -p $(@D)
	cp $< $@

$(release)/%.jpg: $(src)/documents/%.jpg
	@mkdir -p $(@D)
	cp $< $@

$(release)/%.csv: $(src)/documents/%.csv
	@mkdir -p $(@D)
	cp $< $@

$(release)/%.xlsx: $(src)/documents/%.xlsx
	@mkdir -p $(@D)
	cp $< $@

$(release)/%.yml: $(src)/jupyter-book/%.yml
	cp $< $@

$(release)/%.bib: $(src)/jupyter-book/%.bib
	cp $< $@

$(release)/%.css: $(src)/jupyter-book/%.css
	@mkdir -p $(@D)
	cp $< $@

$(release)/%.js: $(src)/jupyter-book/%.js
	@mkdir -p $(@D)
	cp $< $@

$(release)/%.html: $(src)/jupyter-book/%.html
	@mkdir -p $(@D)
	cp $< $@


# Manually call recipe to pull down your development history
$(src)/data/history.yml:
	poetry run rdm pull $< > $@

.PHONY:
clean:
	rm -rf $(release)
