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
 
module DRAM (
	CLK,
	A,
	DIN,
	DOUT,
	EN,
	WE
);

	parameter DA_WIDTH = 11;
	parameter DD_WIDTH = 8;

	parameter DA_DEPTH = (1 << DA_WIDTH);

	input	CLK;
	input [DA_WIDTH - 1:0] A;
	input [DD_WIDTH - 1:0] DIN;
	output reg [DD_WIDTH - 1:0] DOUT;
	input EN;
	input WE;
	
	reg [7:0] MEM [0:DA_DEPTH - 1];

	always @ (posedge CLK)
		if(EN)
		begin				
			if(WE)
				MEM[A] <= DIN;		
				
			DOUT <= MEM[A];				
		end

	integer i;
	initial
		for(i = 0; i < DA_DEPTH; i = i + 1)
			MEM[i] = 8'b0;
endmodule
