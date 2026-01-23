RAM_ATTR EQU $5800 ; address of attribute RAM
RAM_ATTR_L EQU $02E0 ; length of attribute RAM - 2 lines
RAM_ATTR_END EQU (RAM_ATTR + RAM_ATTR_L)

;----------
; scroll_attr_down
;----------
            ld hl, RAM_ATTR_END - $21
            ld de, RAM_ATTR_END - $01
            ld bc, RAM_ATTR_L - $20
            lddr
            ret