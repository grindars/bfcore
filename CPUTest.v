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
 
module TestConsole (
	input CLK,
	input RESET,
	input [7:0] IN,
	output [7:0] OUT,
	output RDA,
	input ACK,
	input WR,
	output RDY
);
	reg [3:0] SELREG;

	assign OUT = 8'h41 + SELREG;
	assign RDA = 1'b1;
	assign RDY = 1'b1;
	
	always @ (posedge CLK)
	begin
		if(RESET)
			SELREG <= 8'h00;
		else
		begin
			if(WR)
				$write("%c", IN);
				
			if(ACK)
				SELREG <= SELREG + 1;
		end
	end
	
endmodule

module CPUTest;

	// Inputs
	reg CLK;
	reg RESET;
	wire [7:0] CIN;
	wire CRDA;
	wire CRDY;

	// Outputs
	wire [7:0] COUT;
	wire CACK;
	wire CWR;

	TestConsole console (
		.CLK(CLK),
		.RESET(RESET),
		.IN(COUT),
		.OUT(CIN),
		.RDA(CRDA),
		.ACK(CACK),
		.WR(CWR),
		.RDY(CRDY)
	);
		
	// Instantiate the Unit Under Test (UUT)
	BrainfuckWrapper #(
		.IA_WIDTH(12)
	) uut (
		.CLK(CLK), 
		.RESET(RESET), 
		.CIN(CIN), 
		.COUT(COUT), 
		.CRDA(CRDA), 
		.CACK(CACK), 
		.CWR(CWR), 
		.CRDY(CRDY)
	);

	initial begin
		// Initialize Inputs
		CLK = 1'b1;
		RESET = 1'b1;

		// Wait 100 ns for global reset to finish
		#100;
        
		RESET = 1'b0;
		#100;

	end
	
	always
		#20 CLK <= ~CLK;
		
      
endmodule

