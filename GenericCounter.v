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
module GenericCounter (
	CLK,
	RESET,
	D,
	Q,
	EN,
	LOAD,
	DOWN
);

	parameter WIDTH = 8;

	input CLK;
	input RESET;
	input [WIDTH - 1:0] D;	
	output reg [WIDTH - 1:0] Q;
	input EN;
	input LOAD;
	input DOWN;
	
	always @ (posedge CLK)
		if(RESET)
			Q <= 0;
		else if(EN)
		begin
			if(LOAD)
				Q <= D;
			else if(DOWN)
				Q <= Q - 1;
			else
				Q <= Q + 1;
		end
	
endmodule

