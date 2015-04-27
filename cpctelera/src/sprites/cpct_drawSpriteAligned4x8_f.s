;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
;;  Copyright (C) 2014-2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.
;;
;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------
.module cpct_sprites

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Function: cpct_drawSpriteAligned4x8_f
;;
;;    Copies a 4x8-byte sprite to video memory (or screen buffer), assuming that
;; location to be copied is Pixel Line 0 of a character line. This function is
;; ~32% faster than <cpct_drawSpriteAligned4x8>
;;
;; C Definition:
;;    void *cpct_drawSpriteAligned4x8_f* (void* *sprite*, void* *memory*)
;;
;; Input Parameters (4 bytes):
;;  (2B HL) sprite - Source Sprite Pointer (32-byte array with 8-bit pixel data)
;;  (2B DE) memory - Pointer (aligned) to the first byte in video memory where the sprite will be copied.
;;
;; Parameter Restrictions:
;;    * *sprite* must be a pointer to an array array containing sprite's pixels
;; data in screen pixel format. Sprite must be rectangular and all bytes in the 
;; array must be consecutive pixels, starting from top-left corner and going 
;; left-to-right, top-to-bottom down to the bottom-right corner. Total amount of
;; bytes in pixel array should be *32*. You may check screen pixel format for
;; mode 0 (<cpct_px2byteM0>) and mode 1 (<cpct_px2byteM1>) as for mode 2 is 
;; linear (1 bit = 1 pixel).
;;    * *memory* must be a pointer to the first byte in video memory (or screen
;; buffer) where the sprite will be drawn. This location *must be aligned*, 
;; meaning that it must be a Pixel Line 0 of a screen character line. To Know
;; more about pixel lines and character lines on screen, take a look at
;; <cpct_drawSprite>. If *memory* points to a not aligned byte (one pertaining
;; to a Non-0 Pixel Line of a character line), this function will overwrite 
;; random parts of the memory, with unexpected results (typically, bad drawing 
;; results, erratic program behaviour, hangs and crashes).
;;
;; Known limitations:
;;     * This function does not do any kind of boundary check or clipping. If you 
;; try to draw sprites on the frontier of your video memory or screen buffer 
;; if might potentially overwrite memory locations beyond boundaries. This 
;; could cause your program to behave erratically, hang or crash. Always 
;; take the necessary steps to guarantee that you are drawing inside screen
;; or buffer boundaries.
;;     * As this function receives a byte-pointer to memory, it can only 
;; draw byte-sized and byte-aligned sprites. This means that the sprite cannot
;; start on non-byte aligned pixels (like odd-pixels, for instance) and 
;; their sizes must be a multiple of a byte (2 in mode 0, 4 in mode 1 and
;; 8 in mode 2).
;;
;; Details:
;;    This function does the same operation than <cpct_drawSpriteAligned4x8>
;; but using and unrolled loop. This makes this function ~32% faster, at the
;; cost of requiring ~243% more memory for the code.
;; 
;;    Copies a 4x8-byte sprite from an array with 32 screen pixel format 
;; bytes to video memory or a screen buffer. This function is tagged 
;; *aligned*, meaning that the destination byte must be *character aligned*. 
;; Being character aligned means that the 8 lines of the sprite will 
;; coincide with the 8 lines of a character line in video memory (or 
;; in the screen buffer). For more details about video memory character
;; and pixel lines check table 1 at <cpct_drawSprite>.
;;
;;    As the 8 lines of the sprite must go to a character line on video 
;; memory (or screen buffer), *memory* destination pointer must point to
;; a the first line (Pixel Line 0) of a character line. If hardware 
;; scrolling has not been used, all pixel lines 0 are contained inside
;; one of these 4 ranges:
;;
;;    [ 0xC000 -- 0xC7FF ] - RAM Bank 3 (Default Video Memory Bank)
;;    [ 0x8000 -- 0x87FF ] - RAM Bank 2
;;    [ 0x4000 -- 0x47FF ] - RAM Bank 1
;;    [ 0x0000 -- 0x07FF ] - RAM Bank 0
;;
;;    All of them have 3 bits in common: bits 5, 4 and 3 are always 0 
;; (xx000xxx). Any address not having all these 3 bits set to 0 does not
;; refer to a Pixel Line 0 and is not considered to be aligned.
;;
;;    This function will just copy bytes, not taking care of colours or 
;; transparencies. If you wanted to copy a sprite without erasing the background
;; just check for masked sprites and <cpct_drawMaskedSprite>.
;;
;; Destroyed Register values: 
;;    AF, BC, DE, HL
;;
;; Required memory:
;;    103 bytes
;;
;; Time Measures:
;; (start code)
;; Case  | Cycles | microSecs (us)
;; ---------------------------------
;; Any   |   705  |  176.25
;; ---------------------------------
;; (end code)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_cpct_drawSpriteAligned4x8_f::
   ;; GET Parameters from the stack (Push+Pop is faster than referencing with IX)
   pop  af                 ;; [10] AF = Return Address
   pop  hl                 ;; [10] HL = Source address
   pop  de                 ;; [10] DE = Destination address
   push de                 ;; [11] Leave the stack as it was
   push hl                 ;; [11] 
   push af                 ;; [11] 

   ;; Copy 8 lines of 4 bytes each (4x8 = 32 bytes)
   ;;  (Unrolled version of the loop)
   ld    a, d              ;; [ 4] First, save DE into A and B, 
   ld    b, e              ;; [ 4]   to ease the 800h increment step
   ld    c, #33            ;; [ 7] Ensure that 32 LDIs do not change value of B (as they will decrement BC)

   ;; Sprite Line 1
   ldi                     ;; [16] <|Copy 4 bytes with (DE) <- (HL) and decrement BC 
   ldi                     ;; [16]  |
   ldi                     ;; [16]  |
   ldi                     ;; [16] <|
   add  #8                 ;; [ 7] DE += 800h (Using previous A, B copy)
   ld    d, a              ;; [ 4]
   ld    e, b              ;; [ 4]

   ;; Sprite Line 2
   ldi                     ;; [16] <|Copy 4 bytes with (DE) <- (HL) and decrement BC 
   ldi                     ;; [16]  |
   ldi                     ;; [16]  |
   ldi                     ;; [16] <|
   add  #8                 ;; [ 7] DE += 800h (Using previous A, B copy)
   ld    d, a              ;; [ 4]
   ld    e, b              ;; [ 4]

   ;; Sprite Line 3
   ldi                     ;; [16] <|Copy 4 bytes with (DE) <- (HL) and decrement BC 
   ldi                     ;; [16]  |
   ldi                     ;; [16]  |
   ldi                     ;; [16] <|
   add  #8                 ;; [ 7] DE += 800h (Using previous A, B copy)
   ld    d, a              ;; [ 4]
   ld    e, b              ;; [ 4]

   ;; Sprite Line 4
   ldi                     ;; [16] <|Copy 4 bytes with (DE) <- (HL) and decrement BC 
   ldi                     ;; [16]  |
   ldi                     ;; [16]  |
   ldi                     ;; [16] <|
   add  #8                 ;; [ 7] DE += 800h (Using previous A, B copy)
   ld    d, a              ;; [ 4]
   ld    e, b              ;; [ 4]

   ;; Sprite Line 5
   ldi                     ;; [16] <|Copy 4 bytes with (DE) <- (HL) and decrement BC 
   ldi                     ;; [16]  |
   ldi                     ;; [16]  |
   ldi                     ;; [16] <|
   add  #8                 ;; [ 7] DE += 800h (Using previous A, B copy)
   ld    d, a              ;; [ 4]
   ld    e, b              ;; [ 4]

   ;; Sprite Line 6
   ldi                     ;; [16] <|Copy 4 bytes with (DE) <- (HL) and decrement BC 
   ldi                     ;; [16]  |
   ldi                     ;; [16]  |
   ldi                     ;; [16] <|
   add  #8                 ;; [ 7] DE += 800h (Using previous A, B copy)
   ld    d, a              ;; [ 4]
   ld    e, b              ;; [ 4]

   ;; Sprite Line 7
   ldi                     ;; [16] <|Copy 4 bytes with (DE) <- (HL) and decrement BC 
   ldi                     ;; [16]  |
   ldi                     ;; [16]  |
   ldi                     ;; [16] <|
   add  #8                 ;; [ 7] DE += 800h (Using previous A, B copy)
   ld    d, a              ;; [ 4]
   ld    e, b              ;; [ 4]

   ;; Sprite Line 8
   ldi                     ;; [16] <|Copy 4 bytes with (DE) <- (HL) and decrement BC 
   ldi                     ;; [16]  |
   ldi                     ;; [16]  |
   ldi                     ;; [16] <|

   ret                     ;; [10]
