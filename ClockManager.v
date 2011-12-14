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
 
module ClockManager(
	 (* buffer_type = "ibufg" *) input CLK_IN,
	 input RESET_IN,
	 output CLK_MAIN,
	 output reg RESET
	);

	parameter DELAY = 4;
	
	reg [DELAY - 1:0] CNT_SLOW;
	reg CLK_SLOW;
	
	always @ (posedge CLK_IN)
		if(RESET_IN)
			CNT_SLOW <= 0;
		else
			CNT_SLOW <= CNT_SLOW + 1;
			
	always @ (posedge CLK_IN)
		if(RESET_IN)
		begin
			RESET <= 1'b1;
			CLK_SLOW <= 1'b0;
		end
		else if(CNT_SLOW == (1 << DELAY) - 1)
		begin
			RESET <= 1'b0;
			CLK_SLOW <= ~CLK_SLOW;
		end

	assign CLK_MAIN = CLK_IN;
	
endmodule
