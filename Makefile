INCLUDES=header.inc defines.inc

all: game.gb

%.obj: %.asm $(INCLUDES)
	rgbasm -o$@ $<

game.gb: main.obj
	rgblink -mgame.map -ngame.sym -ogame.gb main.obj
	rgbfix -p0 -v game.gb

clean:
	rm -f *.obj *.map *.sym game.gb
