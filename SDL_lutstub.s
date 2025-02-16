#NO_APP
gcc2_compiled.:
___gnu_compiled_c:
.text
	.even
.globl _WLUT

_WLUT:
	movem.l #0x3f36, sp-1
	move.l sp+48,a5
	move.l sp+52,a3
	move.l sp+56,d2
	move.l sp+64,a2
	move.l sp+68,d3
	move.l sp+72,d4
	move.l sp+76,d5
	move.l sp+80,d6
	move.l sp+84,d7
	move.l _CyberGfxBase,a6
	move.l sp+44,a0
	move.w a5,d0
	move.w a3,d1
	move.l sp+60,a1
#APP
	jsr %a6@(-0xc6:W)
#NO_APP
	movem.l sp+1,#0x6cfc
	rts
