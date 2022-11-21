$(eval SHELL:=/bin/bash)

OUT = output
INNEROUT = output
PAGES = pages
NOTES = reference_notes
CODE = code
IMAGES = images
BIB = documentRef.bib
TEX = document.tex
MINUTES = minutes.tex
THESIS = thesis.tex
CHEATSHEET = cheatsheet.tex
REFS = references.tex
EXAMPLES = example_pages.tex
WEEKLY = weekly_log
PROJ = document
TEMPLATE = template
DECK = presentations

TIMEZ = Pacific/Auckland

BLANK :=
SLASH = \$(BLANK)

CLEAN_DIRS  = $(OUT) $(PAGES) .

.PHONY : clean
clean : 
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.swp         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.aux         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.bbl         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.blg         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.fdb_latexmk )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.fls         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.log         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.out         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.gz          )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.toc         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.glo         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.glsdefs     )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.glsist      )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.ist         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.odt         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.4ct         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.4tc         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.bcf         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.dvi         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.idv         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.lg          )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.tmp         )
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.xref        )
	@ -rm -r $(OUT) || true 
	@ -rm -r $(OUT)-* || true 
	@ -mkdir $(OUT)

.PHONY : superclean
superclean:
	make clean
	@ -$(foreach dir, $(CLEAN_DIRS) , rm -f $(dir)/*.pdf         )

# example usage: 
# for a custom name:
# 	make NAME=custom rename
# for the default name:
# 	make rename
.PHONY : rename
rename:
	-mv $(PROJ).docx $(NAME).docx
	-mv $(PROJ).pdf $(NAME).pdf

.PHONY : source
source:
	rsync -a --exclude="*RData*" ${CODE} ${OUT}

# example usage:
# 	make PAGE=2020-12-07 convertMD
# without PAGE=prefix, it will prompt for a filename
#@for PAGE in $(shell ls ${PAGES}/*.md); 
.PHONY : convertMD
convertMD:
	mkdir -p ${OUT}
	mkdir -p ${OUT}/${INNEROUT}
	make source
	cp *tex ${OUT}
	cp ${BIB} ${OUT}/${INNEROUT}
	cp ${BIB} ${OUT}
	rsync -a ${DECK} ${OUT}
	rsync -a $(PAGES) $(OUT)
	rsync -a $(IMAGES) $(OUT)
	rsync -a --exclude="word" ${TEMPLATE} $(OUT)

	@for PAGE in $(shell find pages -name '*.md'); \
		do \
			BASE="`echo $${PAGE} | sed 's/\.md$$//g'`"; \
			FROM=$${BASE}.md; \
			TO=${OUT}/$${BASE}.tex; \
			cat template/page-header-footer/head.tex > $${TO}; \
			pandoc -f markdown -t latex $${FROM} >> $${TO}; \
			cat template/page-header-footer/tail.tex >> $${TO}; \
		done

.PHONY : pdf
pdf:
	make OUT=${OUT} convertMD
	cd $(OUT) && pdflatex --shell-escape -output-directory $(INNEROUT) $(TEX)
	cd $(OUT)/$(INNEROUT) && biber $(PROJ) && cd - && \
	cd ${OUT}/${INNEROUT} && for f in *.sagetex.sage ; \
		do \
			sage $${f} ; \
			rsync -a sage-plots* .. || true ; \
		done
	cd $(OUT) && pdflatex --shell-escape -output-directory $(INNEROUT) $(TEX) 
	cp $(OUT)/$(INNEROUT)/*pdf .

.PHONY : minutes
#	$(MAKE) TEX=${MINUTES} PROJ=$(shell basename ${MINUTES} .tex) pdf
minutes:
	mkdir -p output-$(shell basename ${MINUTES} .tex)/output-$(shell basename ${MINUTES} .tex)
	$(MAKE) TEX=${MINUTES} PROJ=$(shell basename ${MINUTES} .tex) OUT="output-$(shell basename ${MINUTES} .tex)" pdf

.PHONY : thesis
thesis:
	$(MAKE) TEX=${THESIS} PROJ=$(shell basename ${THESIS} .tex) OUT="output-$(shell basename ${THESIS} .tex)" pdf


.PHONY : examples
examples:
	$(MAKE) TEX=${EXAMPLES} PROJ=$(shell basename ${EXAMPLES} .tex) OUT="output-$(shell basename ${EXAMPLES} .tex)" pdf


.PHONY : cheatsheet
cheatsheet:
	$(MAKE) TEX=${CHEATSHEET} PROJ=$(shell basename ${CHEATSHEET} .tex) OUT="output-$(shell basename ${CHEATSHEET} .tex)" pdf


.PHONY : ref
ref:
	$(MAKE) TEX=${REFS} PROJ=$(shell basename ${REFS} .tex) OUT="output-$(shell basename ${REFS} .tex)" pdf


.PHONY : weekly
weekly:
	$(MAKE) TEX=${WEEKLY}.tex PROJ=${WEEKLY} OUT="output-${WEEKLY}" pdf


# -------

.PHONY : week
week:
	$(MAKE) TEX=${WEEKLY}.tex OUT="output-${WEEKLY}" page

.PHONY : week-word
week-word:
	$(MAKE) TEX=${WEEKLY} OUT="output-${WEEKLY}" page-word

# compile single page from weekly_log
#
# example usage:
# 	make PAGE=2020-12-07 page
# without PAGE=prefix, it will prompt for a filename
# more verbose alternative 
#	$(eval CHAP := $(shell cat ${TEX} | grep ^\\\\subfile{.*tex} | nl | grep ${PAGE} | cut -f 1 | grep -oP [0-9]+))
#
# left as an exercise: add citetitle support
# (hint: check page-word target for inspiration)
#	$(eval FPATH := $(shell cat ${TEX} | grep subfile{.*tex} | grep -v % | grep ${PAGE} | sed 's/\\subfile{//g' | sed 's/{PAGE}.*}//g') )
#
.PHONY : page
page:
	make convertMD
	$(eval TMPFILE := TEMP_${PAGE})
	echo ${TMPFILE}
	echo ${TEX}

	$(eval CHAP := $(shell cat ${TEX} | grep subfile{.*tex} | grep -v % | nl | grep ${PAGE} | cut -f 1 | grep -oP [0-9]+))
	$(eval CHAP := $(shell expr ${CHAP} - 1))
	$(eval CHAP := $(if $(CHAP),$(CHAP),0))
	$(eval FPATH := $(shell cat ${TEX} | grep subfile{.*tex} | grep -v % | grep ${PAGE} | sed 's/\\subfile{//g' | sed 's/${PAGE}.*}//g'))
	mkdir -p ${OUT}/${FPATH}
	cd ${OUT} && echo "\AtBeginDocument{\setcounter{chapter}{${CHAP}}}" > ${FPATH}/${TMPFILE}.tex
	cd ${OUT} && cat ${FPATH}/${PAGE}.tex >> ${FPATH}/${TMPFILE}.tex
	cd ${OUT} && cat ${FPATH}/${TMPFILE}.tex > ${FPATH}/${PAGE}.tex
	

	cd ${OUT} && pdflatex --shell-escape -output-directory $(INNEROUT) ${FPATH}/${PAGE}.tex 
	cd ${OUT}/${INNEROUT} && biber ${PAGE} 
	-cd ${OUT}/${INNEROUT} && sage ${PAGE}.sagetex.sage
	-mv ${OUT}/${INNEROUT}/sage-plots* ${OUT}/
	cd ${OUT} && pdflatex --shell-escape -output-directory $(INNEROUT) ${FPATH}/${PAGE}.tex 
	cp ${OUT}/${INNEROUT}/${PAGE}.pdf .


# compile a slide deck
# MUST use `make PAGE=mypage deck`
# there is no master target
.PHONY : deck
deck:
	$(eval DECKOUT := "output-${DECK}")
	$(MAKE) TEX=${DECK}/${PAGE}.tex PROJ=$(DECKOUT) OUT=${DECKOUT} convertMD
	# for when I have a master tex
	#cd  ${DECKOUT} && pdflatex --shell-escape -output-directory $(OUT) ${DECK}/${PAGE}.tex 
	#-cd  ${DECKOUT}/${DECKOUT} && biber ${DECK}/${PAGE} 
	#-cd ${DECKOUT}/${DECKOUT}/${DECK} && sage ${PAGE}.sagetex.sage
	cd  ${DECKOUT} && pdflatex --shell-escape -output-directory $(OUT) ${PAGE}.tex 
	-cd  ${DECKOUT}/${DECKOUT} && biber ${PAGE} 
	-cd ${DECKOUT}/${DECKOUT} && sage ${PAGE}.sagetex.sage
	-mv ${DECKOUT}/${DECKOUT}/sage-plots* ${DECKOUT}/
	cd  ${DECKOUT} && pdflatex --shell-escape -output-directory $(OUT) ${DECK}/${PAGE}.tex 
	cp  ${DECKOUT}/${OUT}/${PAGE}.pdf ./${PAGE}-${DECK}.pdf


# generate report from one meeting, in pdf format
# example usage:
# 	make PAGE=2020-12-07 minute
# without PAGE=prefix, it will prompt for a filename
#make convertMD
.PHONY : minute
minute:
	$(eval MINOUT := "output-$(shell basename ${MINUTES} .tex)")
	$(eval SUFFIX := "$(shell basename ${MINUTES} .tex)")
	$(MAKE) TEX=${MINUTES} PROJ=$(MINOUT) OUT=${MINOUT} convertMD
	$(eval TMPFILE := TEMP_${PAGE})
	echo ${TMPFILE}

	$(eval CHAP := $(shell cat ${MINUTES} | grep subfile{.*tex} | grep -v % | nl | grep ${PAGE} | cut -f 1 | grep -oP [0-9]+))
	$(eval CHAP := $(shell expr ${CHAP} - 1))
	$(eval CHAP := $(if $(CHAP),$(CHAP),0))
	$(eval FPATH := $(shell cat ${MINUTES} | grep subfile{.*tex} | grep -v % | grep ${PAGE} | sed 's/\\subfile{//g' | sed 's/${PAGE}.*}//g'))
	mkdir -p ${MINOUT}/${FPATH}
	cd ${MINOUT} && echo "\AtBeginDocument{\setcounter{chapter}{${CHAP}}}" > ${FPATH}/${TMPFILE}.tex
	cd ${MINOUT} && cat ${FPATH}/${PAGE}.tex >> ${FPATH}/${TMPFILE}.tex
	cd ${MINOUT} && cat ${FPATH}/${TMPFILE}.tex > ${FPATH}/${PAGE}.tex
	

	cd  ${MINOUT} && pdflatex --shell-escape -output-directory $(INNEROUT) ${FPATH}/${PAGE}.tex 
	cd  ${MINOUT}/${INNEROUT} && biber ${PAGE} 
	-cd ${MINOUT}/${INNEROUT}/${FPATH} && sage ${PAGE}.sagetex.sage
	-mv ${MINOUT}/${INNEROUT}/sage-plots* ${MINOUT}/
	cd  ${MINOUT} && pdflatex --shell-escape -output-directory $(INNEROUT) ${FPATH}/${PAGE}.tex 
	cp  ${MINOUT}/${INNEROUT}/${PAGE}.pdf ./${PAGE}-${SUFFIX}.pdf


# generate entire document in docx format
# \citetitle isn't supported in Pandoc, so use Python to do some magic
.PHONY : word
word:
	make convertMD
	rsync -a ${TEMPLATE} $(OUT)
	cp ${BIB} ${OUT}
	#cd ${OUT} && find pages -type f -name "*.tex" -print0 | xargs -0 sed -i 's/{timebox}/{verbatim}/g' ; # display raw code
	#cd ${OUT} && find pages -type f -name "*.tex" -print0 | xargs -0 sed -i 's/{sagesilent}/{verbatim}/g' ; # display raw code
	cd ${OUT} && find pages -type f -name "*.tex" -print0 | xargs -0 sed -i 's/{timebox}/{comment}/g' ; # suppress raw code
	cd ${OUT} && find pages -type f -name "*.tex" -print0 | xargs -0 sed -i 's/{sagesilent}/{comment}/g' ; # suppress raw code
	cd ${OUT} && find pages -type f -name "*.tex" -print0 | xargs -0 sed -i 's/\\sage{/\\snippet{/g' ; 
	cd ${OUT} && find pages -type f -name "*.tex" -print0 | xargs -0 sed -i 's/\\sageplot{/\\snippet{/g' ; 
#	for f1 in $(shell ls ${PAGES} | grep -E ^[0-9]{4}-[0-9]{2}-[0-9]{2}.tex | cut -d . -f 1); do python ${TEMPLATE}/citeTitle.py ${PAGES}/$${f1}; done
	cd ${OUT} && pandoc \
		--toc \
		-N \
		-V documentclass=memoir \
		-f latex \
		-t docx \
		--lua-filter ${TEMPLATE}/word/my-pagebreak.lua \
		$(TEX) \
		-o ${OUT}/${PROJ}.docx \
		--metadata link-citations=true \
		--metadata backtick_code_blocks=true \
		--metadata reference-section-title=Bibliography \
		--biblio=$(BIB) \
		--citeproc 
#		--reference-doc=template/word/UoAThesisTemplate-UnNumbered.dotm
	cp $(OUT)/$(OUT)/$(PROJ).docx .



# generate one subfile, in docx format
# section numbering not supported (must create filter to number top level sections properly)
#
# example usage:
# 	make PAGE=2020-12-07 page-word
page-word:
	make convertMD
	$(eval TMPFILE := TEMP_${PAGE})
	$(eval TEX := ${WEEKLY}.tex)
	echo ${TMPFILE}
	echo ${TEX}

	$(eval CHAP := $(shell cat ${TEX} | grep subfile{.*tex} | grep -v % | nl | grep ${PAGE} | cut -f 1 | grep -oP [0-9]+))
	$(eval CHAP := $(shell expr ${CHAP} - 1))
	$(eval CHAP := $(if $(CHAP),$(CHAP),0))
	$(eval FPATH := $(shell cat ${TEX} | grep subfile{.*tex} | grep -v % | grep ${PAGE} | sed 's/\\subfile{//g' | sed 's/${PAGE}.*}//g'))
	mkdir -p ${OUT}/${FPATH}
	cd ${OUT} && echo "\AtBeginDocument{\setcounter{chapter}{${CHAP}}}" > ${FPATH}/${TMPFILE}.tex
	cd ${OUT} && cat ${FPATH}/${PAGE}.tex >> ${FPATH}/${TMPFILE}.tex
	cd ${OUT} && cat ${FPATH}/${TMPFILE}.tex > ${INNEROUT}/${PAGE}.tex

#	cd ${OUT} && python ${TEMPLATE}/citeTitle.py ${PAGE}
	cd ${OUT} && pandoc \
		${INNEROUT}/${PAGE}.tex \
		-o ${INNEROUT}/${PAGE}.docx \
		--metadata link-citations=true \
		--metadata backtick_code_blocks=true \
		--metadata reference-section-title=Bibliography \
		--biblio=$(BIB) \
		--citeproc 
#		--reference-doc=template/word/UoAThesisTemplate-UnNumbered.dotm
	cp $(OUT)/$(INNEROUT)/${PAGE}.docx .

# Create a new .tex file in the pages directory, 
# intended to be imported as a subfile for the main tex document.
# example usage to generate hello.tex:
# 	make PAGE=hello newpage
# without PAGE=name, it will use today's date in YYYY-MM-DD formatnew
# example usage generating today's date:
# 	make page
#
# read more here:
# https://newbedev.com/how-to-conditionally-set-makefile-variable-to-something-if-it-is-empty
.PHONY : newpage
newpage:
	$(eval TODAY := $(if $(PAGE),$(PAGE),$(shell TZ=$(TIMEZ) date +%Y-%m-%d)))

	touch $(PAGES)/$(TODAY).tex
	cat template/page-header-footer/head.tex > $(PAGES)/$(TODAY).tex;
	cat template/page-header-footer/pagestart.tex >> $(PAGES)/$(TODAY).tex;
	echo {$(TODAY)} >> $(PAGES)/$(TODAY).tex;
	cat template/page-header-footer/tail.tex >> $(PAGES)/$(TODAY).tex;

# example usage:
# 	make PAGE=ArbGil2020 note
.PHONY : note
note:
	$(eval TODAY := $(if $(PAGE),$(PAGE),$(shell TZ=$(TIMEZ) date +%Y-%m-%d)))

	touch $(PAGES)/$(NOTES)/$(TODAY).tex
	cat template/page-header-footer/head.tex > $(PAGES)/$(NOTES)/$(TODAY).tex;
	cat template/page-header-footer/pagestart.tex >> $(PAGES)/$(NOTES)/$(TODAY).tex;
	echo {$(TODAY)} >> $(PAGES)/$(NOTES)/$(TODAY).tex;
	cat template/page-header-footer/note-body.tex >> $(PAGES)/$(NOTES)/$(TODAY).tex;
	cat template/page-header-footer/tail.tex >> $(PAGES)/$(NOTES)/$(TODAY).tex;


.PHONY : timetracking
timetracking:
	$(eval TODAY := $(if $(PAGE),$(PAGE),$(shell TZ=$(TIMEZ) date +%Y-%m-%d)))

	touch $(PAGES)/$(WEEKLY)/$(TODAY).tex
	cat template/page-header-footer/head.tex > $(PAGES)/$(WEEKLY)/$(TODAY).tex;
	cat template/page-header-footer/pagestart.tex >> $(PAGES)/$(WEEKLY)/$(TODAY).tex;
	echo {Week of $(TODAY)} >> $(PAGES)/$(WEEKLY)/$(TODAY).tex;
	cat template/page-header-footer/timetracking.tex >> $(PAGES)/$(WEEKLY)/$(TODAY).tex;
	cat template/page-header-footer/tail.tex >> $(PAGES)/$(WEEKLY)/$(TODAY).tex;
	cat $(PAGES)/$(WEEKLY)/$(TODAY).tex | sed \
		-e 's/1 January/'"$$(TZ=$(TIMEZ) date +'%d %B')/g" \
		-e 's/Jan 1/'"$$(TZ=$(TIMEZ) date +'%b %d')/g" \
		-e 's/Jan 2/'"$$(TZ=$(TIMEZ) date +'%b %d' -d '+1 days')/g" \
		-e 's/Jan 3/'"$$(TZ=$(TIMEZ) date +'%b %d' -d '+2 days')/g" \
		-e 's/Jan 4/'"$$(TZ=$(TIMEZ) date +'%b %d' -d '+3 days')/g" \
		-e 's/Jan 5/'"$$(TZ=$(TIMEZ) date +'%b %d' -d '+4 days')/g" \
		> $(PAGES)/$(WEEKLY)/$(TODAY).tex;


.PHONY : meeting 
meeting:
	make convertMD
	$(eval TODAY := $(if $(PAGE),$(PAGE),$(shell TZ=$(TIMEZ) date +%Y-%m-%d)))
	$(eval DIR := $(shell basename ${MINUTES} .tex))
	cat pages/00_meeting_template.tex > $(PAGES)/$(DIR)/$(TODAY).tex;
	echo -n $(PAGES)/$(DIR)/$(TODAY).tex | xargs -0 sed -i 's/1970-01-01/'"$$(TZ=$(TIMEZ) date +'%Y-%m-%d')/g" 




# requires installation of bibutils
# http://bibutils.refbase.org
.PHONY : endnote
endnote:
	bib2xml $(BIB) | xml2end > ${OUT}/citations.enw


.PHONY : ool
ool:
	make convertMD
	cd $(OUT) && pandoc $(TEX) --biblio=$(OUT)/$(BIB) -o $(OUT)/$(PROJ).odt --citeproc
	cp $(OUT)/$(OUT)/${PROJ}.odt .


#.PHONY : beamerppt
#beamerppt:
# see: https://pandoc.org/MANUAL.html#option--reference-doc
#	# seems to create corrupted files
#	pandoc output-presentations/2022-05-26.tex -w beamer -V theme:Warsaw -o demo.pptx
#	# works, but no theme
#	#pandoc output-presentations/2022-05-26.tex -o demo.pptx
