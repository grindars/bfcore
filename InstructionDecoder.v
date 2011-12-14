`timescale 1ns / 1ps
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
`include "pack.v"

module InstructionDecoder (
    input [7:0] OPCODE,
    output reg [8:0] DECODED
    );

	always @(OPCODE)
		case(OPCODE)
		8'h3E:   DECODED <= 9'b0_0000_0001;
		8'h3C:   DECODED <= 9'b0_0000_0010;
		8'h2B:   DECODED <= 9'b0_0000_0100;
		8'h2D:   DECODED <= 9'b0_0000_1000;
		8'h2E:   DECODED <= 9'b0_0001_0000;
		8'h2C:   DECODED <= 9'b0_0010_0000;
		8'h5B:   DECODED <= 9'b0_0100_0000;
		8'h5D:   DECODED <= 9'b0_1000_0000;
		default: DECODED <= 9'b1_0000_0000;
		endcase

endmodule
