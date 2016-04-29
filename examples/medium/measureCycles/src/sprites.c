//-----------------------------LICENSE NOTICE------------------------------------
//  This file is part of CPCtelera: An Amstrad CPC Game Engine 
//  Copyright (C) 2015 Dardalorth / Fremos / Carlio
//  Copyright (C) 2015 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//------------------------------------------------------------------------------

#include "sprites.h"

// Mode 1 palette (firmware colours) for 4-arms monster
const u8 G_palette[4] = { 0x0D, 0x00, 0x06, 0x18 };

// Death with an oil lamp in Mode 1 Graphics, designed by Dardalorth
const u8 G_death[9*44] = {
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
   0x00,0x00,0x00,0x80,0x00,0x00,0x00,0x00,0x00,
   0x00,0x00,0x00,0xC0,0x00,0x00,0x00,0x00,0x00,
   0x00,0x20,0x10,0xE0,0x00,0x00,0x00,0x00,0x00,
   0x00,0x10,0xF0,0xF0,0x00,0x00,0x00,0x00,0x00,
   0x00,0x10,0xF0,0xF0,0x80,0x00,0x00,0x00,0x00,
   0x00,0x10,0xF0,0xF0,0xC0,0x00,0x00,0x00,0x00,
   0x00,0x10,0xF0,0xF0,0x00,0x00,0x00,0x00,0x00,
   0x00,0x30,0xF0,0xE0,0x00,0x00,0x00,0x00,0x00,
   0x00,0xF0,0xF0,0xE0,0x00,0x00,0x00,0x00,0x00,
   0x00,0xF0,0xF0,0xE0,0x00,0x00,0x00,0x00,0x00,
   0x00,0x70,0xF0,0xE0,0x00,0x00,0x00,0x00,0x00,
   0x00,0x30,0xF0,0xF0,0x90,0xC0,0x00,0x00,0x00,
   0x00,0x10,0xF0,0xF0,0xF0,0xE0,0x00,0x00,0x00,
   0x00,0x00,0xD0,0xF0,0xF0,0x5A,0x00,0x00,0x00,
   0x00,0x00,0x50,0xF0,0xF0,0xF0,0x00,0x00,0x00,
   0x00,0x00,0x30,0xF0,0xF0,0xE0,0x00,0x00,0x00,
   0x00,0x00,0x30,0xF0,0xF0,0xC0,0x00,0x00,0x00,
   0x00,0x00,0x30,0xF0,0xF0,0xD0,0x00,0x00,0x00,
   0x00,0x00,0x70,0xF0,0xF0,0xF0,0x80,0x00,0x00,
   0x00,0x00,0x70,0xF0,0xF0,0xF0,0x80,0x00,0x00,
   0x00,0x00,0x70,0xF0,0xF0,0xF0,0x80,0x00,0x00,
   0x00,0x00,0xF0,0xF0,0xF0,0xF0,0xC0,0x00,0x00,
   0x00,0x00,0xF0,0xF0,0xF0,0xA0,0x60,0x00,0x00,
   0x00,0x00,0xF0,0xF0,0xF0,0xC0,0x30,0x00,0x00,
   0x00,0x10,0xF0,0xF0,0xF0,0xC0,0x10,0x80,0x00,
   0x00,0x10,0xF0,0x87,0x78,0xC0,0x00,0xC0,0x00,
   0x00,0x10,0xF0,0xC0,0xF0,0xC0,0x00,0x60,0x00,
   0x00,0x10,0xF0,0x00,0x30,0xC0,0x00,0x30,0x00,
   0x00,0x10,0xF0,0xBB,0x74,0xC0,0x00,0x10,0x00,
   0x00,0x00,0xF0,0x00,0x30,0xC0,0x00,0x00,0x00,
   0x00,0x00,0xF0,0xBB,0x74,0xC0,0x00,0x00,0x00,
   0x00,0x00,0xE0,0x00,0x10,0x80,0x00,0x00,0x00,
   0x00,0x00,0x60,0x00,0x10,0x80,0x00,0x00,0x00,
   0x00,0x00,0x70,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x70,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x70,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x70,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x30,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x30,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x30,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x30,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x30,0xF0,0xF0,0x80,0x00,0x00,0x00,
   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
};