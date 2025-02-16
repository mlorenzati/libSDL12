# Makefile for gcc version of SDL
#
# changes:
#  18-Apr: _ApolloKeyRGB565toRGB565: disabled AMMX version of ColorKeying (for now, storem is not working in Gold2)
#  17-Nov: - fixed Shadow Surfaces (hopefully), they were effectively impossible
#            in the code base I got
#          - fixed ARGB32 (CGX code was assuming RGBA all the time)
#  12-Feb: - deleted redundant includes, now only SDL/ directory remains (as it should)
BASE:= /Users/marcelo.lorenzati/.vscode/extensions/job.amiga-debug-job-1.7.7
PREFX := $(BASE)/bin/darwin/opt
SDK := $(BASE)/bin/darwin/opt/m68k-amiga-elf/sys-include
STD := $(BASE)/template_libs/libs/library/include
CC := $(PREFX)/bin/m68k-amiga-elf-gcc
AS := $(PREFX)/bin/m68k-amiga-elf-as
AR := $(BASE)/bin/darwin/opt/m68k-amiga-elf/bin/ar
LD := $(PREFX)/bin/m68k-amiga-elf-ld
RL := $(PREFX)/bin/m68k-amiga-elf-ranlib
VASM := $(BASE)/bin/darwin/vasmm68k_mot

CPU := 68030

DEFINES= DEFINE=ENABLE_CYBERGRAPHICS DEFINE=inline=__inline  DEFINE=NO_SIGNAL_H DEFINE=HAVE_STDIO_H DEFINE=ENABLE_AHI
# DEFINE=HAVE_OPENGL
INCLUDES = IDIR=./include/SDL

GCCFLAGS = -I$(SDK) -I$(STD) -I$(PREFX)/include -I./include/ -I./include/SDL \
		-Ofast -fomit-frame-pointer -m68030 -mhard-float -ffast-math \
		-flto -fno-builtin -fomit-frame-pointer -MMD -MP\
		-DNOIXEMUL -D_HAVE_STDINT_H
GLFLAGS = -DSHARED_LIB -lamiga
GCCFLAGS += -DNO_AMIGADEBUG
GLFLAGS  += -DNO_AMIGADEBUG

GCCDEFINES = -DENABLE_CYBERGRAPHICS -DNO_SIGNAL_H -D__MEM_AMIGA -DENABLE_AHI 
#-DNO_INLINE_STDARG

GOBJS = audio/SDL_audio.o audio/SDL_audiocvt.o audio/SDL_mixer.o audio/SDL_mixer_m68k.o audio/SDL_wave.o audio/amigaos/SDL_ahiaudio.o \
	SDL_error.o SDL_fatal.o video/SDL_RLEaccel.o video/SDL_blit.o video/SDL_blit_0.o \
	video/SDL_blit_1.o video/SDL_blit_A.o video/SDL_blit_N.o \
	video/SDL_bmp.o video/SDL_cursor.o video/SDL_pixels.o video/SDL_surface.o video/SDL_stretch.o \
	video/SDL_yuv.o video/SDL_yuv_sw.o video/SDL_video.o \
	timer/amigaos/SDL_systimer.o timer/SDL_timer.o joystick/SDL_joystick.o \
	joystick/SDL_sysjoystick.o SDL_cdrom.o SDL_syscdrom.o events/SDL_quit.o events/SDL_active.o \
	events/SDL_keyboard.o events/SDL_mouse.o events/SDL_resize.o file/SDL_rwops.o SDL.o \
	events/SDL_events.o thread/amigaos/SDL_sysmutex.o thread/amigaos/SDL_syssem.o thread/amigaos/SDL_systhread.o thread/amigaos/SDL_thread.o \
	thread/amigaos/SDL_syscond.o video/amigaos/SDL_cgxvideo.o video/amigaos/SDL_cgxmodes.o video/amigaos/SDL_cgximage.o video/amigaos/SDL_amigaevents.o \
	video/amigaos/SDL_amigamouse.o video/amigaos/SDL_cgxgl.o video/amigaos/SDL_cgxwm.o \
	video/amigaos/SDL_cgxyuv.o video/amigaos/SDL_cgxaccel.o video/amigaos/SDL_cgxgl_wrapper.o \
	video/SDL_gamma.o SDL_lutstub.ll stdlib/SDL_stdlib.o stdlib/SDL_string.o stdlib/SDL_malloc.o stdlib/SDL_getenv.o

#
# BEGIN APOLLO ASM SUPPORT
# ( build vasm: make CPU=m68k SYNTAX=mot )
#
VFLAGS = -devpac -I$(SDK) -I$(PREFX)/m68k-amigaos/ndk-include -Fhunk
GCCFLAGS += -DAPOLLO_BLIT -I./video/apollo
#GCCFLAGS += -DAPOLLO_BLITDBG
GOBJS += video/apollo/blitapollo.ao video/apollo/apolloammxenable.ao video/apollo/colorkeyapollo.ao

%.ao: %.asm
	$(VASM) $(VFLAGS) -o $@ $*.asm
#
# END APOLLO ASM SUPPORT
#

%.o: %.c
	$(CC) $(GCCFLAGS) $(GCCDEFINES) -o $@ -c $*.c

%.ll: %.s
	$(AS) -m$(CPU) -o $@ $*.s

all: libSDL.a


libSDL.a: $(GOBJS)
	-rm -f libSDL.a
	$(AR) cru libSDL.a $(GOBJS)

#$(RL) libSDL.a

clean:
	-rm -f $(GOBJS)
