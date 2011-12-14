/*
 * Simple Brainfuck CPU in Verilog.
 * Copyright (C) 2011  Sergey Gridasov <grindars@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
 
`define OP_INCPTR		0	// >
`define OP_DECPTR		1	// <
`define OP_INC			2	// +
`define OP_DEC			3	// -
`define OP_COUT		4	// .
`define OP_CIN			5	// ,
`define OP_LOOPBEGIN	6	// [
`define OP_LOOPEND	7	// ]
`define OP_ILLEGAL	8	// others

`define STATE_IFETCH	   4'b0000
`define STATE_DECODE    4'b0001
`define STATE_DFETCH	   4'b0010
`define STATE_DUPDATE   4'b0011
`define STATE_WRITEBACK 4'b0100
`define STATE_DFETCH2	4'b0101
`define STATE_IFETCH2	4'b0110
`define STATE_LOOPBEGIN	4'b0111
`define STATE_LOOPEND	4'b1000
`define STATE_LOOPEND2	4'b1001
`define STATE_LOOPEND3	4'b1010
`define STATE_LOOPSEEK	4'b1011
`define STATE_COUT		4'b1100
`define STATE_CIN			4'b1101
