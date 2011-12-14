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
 
module Nexys2Top(
    input CLK_IN,
    input RESET_IN,
    input UART_RX,
    output UART_TX
    );

	wire CLK_MAIN, RESET;
	wire [7:0] CIN, COUT;
	wire CRDA, CACK, CWR, CRDY;
	
	ClockManager #(
		.DELAY(16)
	) clock (
		.CLK_IN(CLK_IN),
		.RESET_IN(RESET_IN),
	
		.CLK_MAIN(CLK_MAIN),
		.RESET(RESET)
	);

	BrainfuckWrapper #(
		.IA_WIDTH(12)
	) wrap (
		.CLK(CLK_MAIN),
		.RESET(RESET),
		
		.CIN(CIN),
		.COUT(COUT),
		.CRDA(CRDA),
		.CACK(CACK),
		.CWR(CWR),
		.CRDY(CRDY)
	);
	
	UART uart (
		.CLK(CLK_MAIN),
		.RESET(RESET),
		
		.TX(UART_TX),
		.RX(UART_RX),
		
		.IN(COUT),
		.OUT(CIN),
		.RDA(CRDA),
		.ACK(CACK),
		.RDY(CRDY),
		.WR(CWR)
	);

endmodule
