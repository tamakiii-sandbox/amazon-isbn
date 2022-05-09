.PHONY: help dependencies clean FORCE
.PHONY: @isbn/% @tsv

include include/curl/headers.mk

help:
	cat $(lastword $(MAKEFILE_LIST))

dependencies:
	which curl
	which xmllint
	which jq

@isbn/%:
	$(MAKE) dist/html/$(notdir $(basename $@)).html
	$(MAKE) dist/json/$(notdir $(basename $@)).json
	$(MAKE) dist/tsv/$(notdir $(basename $@)).tsv

dist/all.tsv: FORCE | dist
	jq --null-input -r '["isbn", "title", "href"] | @tsv' > $@
	for file in $(shell find dist/json/*.json); do \
		echo '[]' | jq ".+ [$$(cat $$file)]" | jq -r '.[] | [.isbn, .title, .href] | @tsv' >> $@; \
	done

dist/html/%: | dist/html
	curl "https://www.amazon.co.jp/s?i=stripbooks&rh=p_66%3A$(notdir $(basename $@))" \
		$(foreach h,$(CURL_HEADERS),-H $h) \
		--silent \
		--compressed \
		> $@

dist/json/%: | dist/json
	echo '{}' \
		| jq '.+ {"isbn": "$(notdir $(basename $@))"}' \
		| jq '.+ {"title": "$(shell shell/amazon.co.jp/title.sh dist/html/$(notdir $(basename $@)).html)"}' \
		| jq '.+ {"href": "https://www.amazon.co.jp/$(shell shell/amazon.co.jp/url.sh dist/html/$(notdir $(basename $@)).html)"}' \
		> $@

dist/tsv/%: | dist/tsv
	echo '[]' | jq ".+ [$$(cat dist/json/$(notdir $(basename $@)).json)]" | jq -r '.[] | [.isbn, .title, .href] | @tsv' >> $@;

dist:
	mkdir -p $@

dist/json: | dist
	mkdir -p $@

dist/html: | dist
	mkdir -p $@

dist/tsv: | dist
	mkdir -p $@

clean:
	rm -rf dist
