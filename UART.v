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
 
module UART(
    input CLK,
    input RESET,
    output TX,
    input RX,
    input [7:0] IN,
    output [7:0] OUT,
    output reg RDA,
    input ACK,
    output RDY,
    input WR
    );

	parameter SYS_CLOCK = 50000000;
	parameter BAUD = 9600;

	wire RECEIVED, TRANSMITTING;

	osdvu #(
		.CLOCK_DIVIDE(SYS_CLOCK / (BAUD * 4))
	) uart (
		.clk(CLK),
		.rst(RESET),
		.rx(RX),
		.tx(TX),
		.transmit(WR),
		.tx_byte(IN),
		.received(RECEIVED),
		.rx_byte(OUT),
		.is_receiving(),
		.is_transmitting(TRANSMITTING),
		.recv_error()
	);

	always @ (posedge CLK)
		if(RESET || ACK)
			RDA <= 1'b0;
		else if(RECEIVED)
			RDA <= 1'b1;
			
	assign RDY = !RESET && !TRANSMITTING;
					
endmodule
