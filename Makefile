all: game.gb

%.obj: %.asm header.inc
	rgbasm -o$@ $<

game.gb: main.obj
	rgblink -mgame.map -ngame.sym -ogame.gb main.obj
	rgbfix -p0 -v game.gb

clean:
	rm -f *.obj *.map *.sym *.gb
