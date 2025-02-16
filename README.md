Disclaimer
==========

The Simple DirectMedia Layer (SDL for short) is a cross-platfrom library
designed to make it easy to write multi-media software, such as games and
emulators.

The Simple DirectMedia Layer library source code is available from:
http://www.libsdl.org/

This library is distributed under the terms of the GNU LGPL license:
http://www.gnu.org/copyleft/lesser.html

Introduction
------------
Update: this is a fork from original  AmigaPorts/libSDL12 but to compile with
modern GCC and tools provided by https://github.com/jyoberle/vscode-amiga-debug
which is a fork of https://github.com/BartmanAbyss/vscode-amiga-debug but with
AmigaOS Libraries compiled with elf support.
My attempt is to use this library in an app being built in https://github.com/mlorenzati/amidev

This is one of the ports of SDL to the AmigaOS3/68k platform. I cannot
comment much on the origins of the code contributions to this port. I've
kept the files I got into my hands, along with the various existing Makefiles.

The main purpose of this branch (based on SDL 1.2.14, AFAIK) was to provide 
some bugfixes and performance improvements. Towards the latter point, most of
the blitting functions have been rewritten in 68k ASM. Also, some of the routines
can switch to AMMX usage (where applicable). 

This SDL version should work on all Amigas with RTG (Picasso96 or CyberGraphX).


Building
--------
Update: Just install in vscode the vscode-amiga-debug extension from jyoberle (JOB) and use the build task

Several Makefiles for different targets are present in this codebase. The one
I was using for the AMMX enabled builds is "Makefile". The compilers I've 
successfully used were gcc2.95 and gcc6.3.1b (20171120).

The static libSDL.a can be built by

    make CPU=68040 PREFX=/path/to/amiga-gcc/root

If no PREFX is defined during make, the default will be /opt/m68k-amigaos. Change the prefix path
as necessary. Compiler, Assembler and Linker binary names might need adjusting, too.
Please also have a look at VFLAGS. The old cross-compile toolchain I had was putting
the AmigaOS includes into "os-include". The recently released GCC6 toolchain by Bebbo
refers to "sys-include" instead.

My regular AMMX build is for libnix. If ixemul or clib2 is desired, then please refer to 
the other Makefiles to mix up an appropriate environment.


Usage
-----

When compiling SDL programs, I usually set the following flags to gcc: 

    -noixemul -O3 -fomit-frame-pointer -m68020-60 -mhard-float 

-mhard-float should only be used for binaries compiled for systems that has an FPU installed. For FPU-less setups use -msoft-float

The Linker commands should include -noixemul and -lSDL
