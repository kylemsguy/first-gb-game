INCLUDES=header.inc defines.inc music_routines.inc sprites.inc

all: game.gb

%.obj: %.asm $(INCLUDES)
	rgbasm -o$@ $<

game.gb: main.obj sprites.obj
	rgblink -mgame.map -ngame.sym -ogame.gb main.obj sprites.obj
	rgbfix -p0 -v game.gb

clean:
	rm -f *.obj *.map *.sym game.gb
