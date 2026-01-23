;----------
; crash_sfx - could do with being more crash-y but shows multiple m/c routines work
;----------
beepborder:
        ld bc, 10000 ; duration (tweak this)
.loop:
        ld a, c ; use C as a fast-changing value
        and 7 ; border 0..7
        ; add a toggling bit for sound (bit 4)
        ld d, a ; keep border bits
        ld a, b
        and 1
        rlca
        rlca
        rlca
        rlca ; move bit0 -> bit4
        or d
        out (#fe), a ; border + speaker toggle
        ; small delay to shape pitch (tweak these NOPs)
        nop
        nop
        nop
        nop
        dec bc
        ld a, b
        or c
        jr nz, .loop
        ld a, 2 ; end on red border
        out (#fe), a
        ret