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
GAMESRC=makefile $(SRCDIR)/main.lua $(SRCDIR)/editConfiguration.lua $(SRCDIR)/makeGFXTable.lua \
$(SRCDIR)/utility.lua $(SRCDIR)/changeMandalaCenter.lua $(SRCDIR)/changeCrankRate.lua \
$(SRCDIR)/changeRearScale.lua

GAMERESOURCES=$(SRCDIR)/Images/card.png $(SRCDIR)/pdxinfo
build: compile run

run: open

clean:
	rm -rf '$(GAME).pdx'
	rm -rf $(CONFIG)

compile: $(GAME).pdx

dist:   $(GAME).pdx $(GAMERESOURCES)
	rm ${GAME}.zip
	zip -r ${GAME}.zip ${GAME}.pdx/*

$(GAME).pdx : $(GAMESRC) 
	echo Compiling $(GAMESRC)
	"$(SDKBIN)/pdc" '-k' 'Source' '$(GAME).pdx'

open:
	$(SDKBIN)/PlaydateSimulator $(GAME).pdx
