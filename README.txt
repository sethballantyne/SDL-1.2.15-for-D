SDL 1.2.15 for D
Created by: Seth Ballantyne  <seth.ballantyne@gmail.com>

This is D binding to SDL that I've created for my own use. I've made in publically available
on the off-chance someone else might find it useful. Currently everything
in the SDL documenation has been included, and ONLY that so if it's
not in the docs, it aint here.. yet. I'll add to it over time. This has
only been tested on windows and >>> ASSUMES LITTLE ENDIANNESS. <<<
You'll need SDL.lib in OMF format, grab it at /lib/x86/SDL.lib. 32-bit only at 
this time. If you want to convert your own for any reason, see below.

to use the SDL binding in your project:
dmd <your source files> SDL.d -c
link <your object files> SDL.obj SDL.lib

to avoid the command prompt window appearing when the resulting binary is 
executed, add /subsystem:windows to the link command line:

link <your object files> SDL.obj SDL.lib /subsystem:windows

the 32-bit VC++ .lib file was converted to OMF format using comf2omf
that comes with the free version of the Borland compiler. You can find it on 
the Embarcadero website or easier yet, search archive.org; you'll want 
version 5.5. Digital Mars has their own but I've never used it. 

coff2omf SDL.lib SDL_converted.lib

it'll spit out a converted library as SDL_converted.lib.

you can find a converted version of the 32-bit lib for your use at 
/lib/x86/SDL.lib.

The code is released under the MIT license; have fun.
