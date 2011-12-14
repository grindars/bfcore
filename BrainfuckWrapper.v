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
module BrainfuckWrapper(
	 CLK, RESET,
	 CIN, COUT, CRDA, CACK, CWR, CRDY
    );
	 
	parameter FAST_LOOPEND    = 1;
	parameter IA_WIDTH	     = 11;
	parameter DA_WIDTH        = 11;
	parameter DD_WIDTH        = 8;
	parameter STACK_DEPTH_POW = 7;
	
	input CLK;
	input RESET;	 

	input [7:0] CIN;
	output [7:0] COUT;
	input CRDA;
	output CACK;
	output CWR;
	input CRDY;
	 
	wire [IA_WIDTH - 1:0] IA;
	wire [7:0] IDIN;
	wire IEN;

	// Data bus
	wire [DA_WIDTH - 1:0] DA;
	wire [DD_WIDTH - 1:0] DDIN;
	wire [DD_WIDTH - 1:0] DDOUT;
	wire DEN;
	wire DWE;
	 
	BrainfuckCPU #(
		.FAST_LOOPEND(FAST_LOOPEND),
		.IA_WIDTH(IA_WIDTH),
		.DA_WIDTH(DA_WIDTH),
		.DD_WIDTH(DD_WIDTH),
		.STACK_DEPTH_POW(STACK_DEPTH_POW)
	) cpu (
		.CLK(CLK), 
		.RESET(RESET), 
		.IA(IA), 
		.IDIN(IDIN), 
		.IEN(IEN), 
		.DA(DA), 
		.DDIN(DDIN), 
		.DDOUT(DDOUT), 
		.DEN(DEN), 
		.DWE(DWE), 
		.CIN(CIN), 
		.COUT(COUT), 
		.CRDA(CRDA), 
		.CACK(CACK), 
		.CWR(CWR), 
		.CRDY(CRDY)
	);
	
	IRAM #(
		.IA_WIDTH(IA_WIDTH)
	) iram (
		.CLK(CLK),
		.A(IA),
		.DOUT(IDIN),
		.EN(IEN)
	);
	
	DRAM #(
		.DA_WIDTH(DA_WIDTH),
		.DD_WIDTH(DD_WIDTH)
	) dram (
		.CLK(CLK),
		.A(DA),
		.DIN(DDOUT),
		.DOUT(DDIN),
		.EN(DEN),
		.WE(DWE)
	);


endmodule
