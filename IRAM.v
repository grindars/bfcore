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
 
module IRAM (
	CLK,
	A,
	DOUT,
	EN
);

	parameter IA_WIDTH = 11;
	parameter IA_DEPTH = (1 << IA_WIDTH);
	
	input CLK;
	input [IA_WIDTH - 1:0] A;
	output reg [7:0] DOUT;
	input EN;
	
	
	reg [7:0] MEM [0:IA_DEPTH - 1];

	always @ (posedge CLK)
		if(EN)
			DOUT <= MEM[A];

	integer i;
	initial
	begin
		for(i = 0; i < IA_DEPTH; i = i + 1)
			MEM[i] = 8'b0;
			
		$readmemh("iram.txt", MEM);
	end

endmodule
