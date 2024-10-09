.PHONY: clean
.PHONY: build
.PHONY: run
.PHONY: copy

SDK = $(PLAYDATE_SDK_PATH)
SDKBIN=$(SDK)/bin
GAME=$(notdir $(CURDIR))
CONFIG=$(SDK)/Disk/Data/org.tomshiro.mandala
SIM=PlaydateSimulator
SRCDIR=Source
GAMESRC=$(SRCDIR)/main.lua $(SRCDIR)/editConfiguration.lua $(SRCDIR)/makeGFXTable.lua  $(SRCDIR)/utility.lua makefile

build: compile run

run: open

clean:
	rm -rf '$(GAME).pdx'
	rm -rf $(CONFIG)

compile: $(GAME).pdx

dist:
	zip -r ${GAME}.zip ${GAME}.pdx/*

$(GAME).pdx : $(GAMESRC)
	echo Compiling $(GAMESRC)
	"$(SDKBIN)/pdc" '-k' 'Source' '$(GAME).pdx'

open:
	$(SDKBIN)/PlaydateSimulator $(GAME).pdx
