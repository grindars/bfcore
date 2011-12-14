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
module Stack (
	CLK,
	RESET,
	PUSH,
	POP,
	D,
	Q
);

	parameter WIDTH = 11;
	parameter DEPTH_POW = 7;
	parameter DEPTH = 1 << DEPTH_POW;

	input CLK;
	input RESET;
	input PUSH;
	input POP;
	input [WIDTH - 1:0] D;
	output reg [WIDTH - 1:0] Q;
	reg [DEPTH_POW - 1:0] PTR;
	reg [WIDTH - 1:0] STACK [0:DEPTH - 1];

	always @ (posedge CLK)
		if(RESET)
			PTR <= 0;
		else if(PUSH)
			PTR <= PTR + 1;
		else if(POP)
			PTR <= PTR - 1;

	always @ (posedge CLK)
		if(PUSH || POP)
		begin
			if(PUSH)
			begin
				STACK[PTR] <= D;
			end			
			
			Q <= STACK[PTR - 1];
		end

endmodule
