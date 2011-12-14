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

module BrainfuckCPU(
	 CLK, RESET,
	 IA, IDIN, IEN,
	 DA, DDIN, DDOUT, DEN, DWE,
	 CIN, COUT, CRDA, CACK, CWR, CRDY
    );

	parameter FAST_LOOPEND    = 1;
	parameter IA_WIDTH	     = 11;
	parameter DA_WIDTH        = 11;
	parameter DD_WIDTH        = 8;
	parameter STACK_DEPTH_POW = 7;
	
	input CLK;
	input RESET;

	// Instruction bus
	output reg [IA_WIDTH - 1:0] IA;
	input [7:0] IDIN;
	output reg IEN;

	// Data bus
	output [DA_WIDTH - 1:0] DA;
	input [DD_WIDTH - 1:0] DDIN;
	output [DD_WIDTH - 1:0] DDOUT;
	output reg DEN;
	output reg DWE;

	// Console interface
	input [7:0] CIN;
	output reg [7:0] COUT;
	input CRDA;
	output reg CACK;
	output reg CWR;
	input CRDY;

	reg [3:0] STATE;
	wire [IA_WIDTH - 1:0] PC;
	reg [DA_WIDTH - 1:0] DC;
	wire [IA_WIDTH - 1:0] STACK_PC, LOOP_PC;
	wire [8:0] DECODED;
	wire ZERO;
	reg STACK_PUSH, STACK_POP, LOOPSEEK;
	reg [STACK_DEPTH_POW - 1:0] LOOP_DEPTH;
	wire CONLOAD, PCLOAD;
		
	InstructionDecoder decoder(
		.OPCODE(IDIN),
		.DECODED(DECODED)
	);
	
	GenericCounter #(
		.WIDTH(DD_WIDTH)
	) dcnt (
		.CLK(CLK),
		.RESET(RESET),
		.D(CONLOAD ? CIN : DDIN),
		.Q(DDOUT),
		.EN((STATE == `STATE_DFETCH2) || (STATE == `STATE_DUPDATE) || CONLOAD),
		.LOAD(STATE == `STATE_DFETCH2 || CONLOAD),
		.DOWN(DECODED[`OP_DEC])
	);
	
	GenericCounter #(
		.WIDTH(IA_WIDTH)
	) pcnt (
		.CLK(CLK),
		.RESET(RESET),
		.D(LOOP_PC),
		.Q(PC),
		.EN((STATE == `STATE_IFETCH) || PCLOAD),
		.LOAD(PCLOAD),
		.DOWN(1'b0)
	);
		
	Stack #(
		.WIDTH(IA_WIDTH),
		.DEPTH_POW(STACK_DEPTH_POW)
	) stack (
		.CLK(CLK),
		.RESET(RESET),
		.PUSH(STACK_PUSH),
		.POP(STACK_POP),
		.D(PC),
		.Q(STACK_PC)
	);
	
	always @ (posedge CLK)
		if(RESET)
		begin
			STATE <= `STATE_IFETCH;
			IA <= 0;
			DC <= 0;
			IEN <= 1'b0;
			DEN <= 1'b0;
			DWE <= 1'b0;
			STACK_PUSH <= 1'b0;
			STACK_POP <= 1'b0;
			LOOPSEEK <= 1'b0;
			LOOP_DEPTH <= 0;
			COUT <= 8'b0;
			CWR <= 1'b0;
			CACK <= 1'b0;
		end
		else
			case(STATE)
			`STATE_IFETCH:
			begin	
				DEN <= 1'b0;
				DWE <= 1'b0;
				STACK_PUSH <= 1'b0;
				CWR <= 1'b0;
			
				IA <= PC;
				IEN <= 1'b1;
				
				STATE <= `STATE_IFETCH2;
			end
			`STATE_IFETCH2:
			begin
				IEN <= 1'b0;
				if(LOOPSEEK)
					STATE <= `STATE_LOOPSEEK;
				else
					STATE <= `STATE_DECODE;
			end
				
			`STATE_DECODE:
			begin
				
				if(DECODED[`OP_ILLEGAL])
					STATE <= `STATE_IFETCH;
				else if(DECODED[`OP_INC] || DECODED[`OP_DEC] || DECODED[`OP_LOOPBEGIN] ||
				        (DECODED[`OP_LOOPEND] && FAST_LOOPEND) || DECODED[`OP_COUT])
				begin
					DEN <= 1'b1;
					
					STATE <= `STATE_DFETCH;
				end
				else if(!FAST_LOOPEND && DECODED[`OP_LOOPEND])
					STATE <= `STATE_LOOPEND;
				else if(DECODED[`OP_INCPTR])
				begin
					DC <= DC + 1;
					
					STATE <= `STATE_IFETCH;
				end
				else if(DECODED[`OP_DECPTR])
				begin
					DC <= DC - 1;
					
					STATE <= `STATE_IFETCH;
				end
				else if(DECODED[`OP_CIN])
					STATE <= `STATE_CIN;
				else
					STATE <= `STATE_DECODE;
			end
			`STATE_DFETCH:
			begin
				DEN <= 1'b0;
				STATE <= `STATE_DFETCH2;
			end
			
			`STATE_DFETCH2:
			begin
				if(DECODED[`OP_LOOPBEGIN])
					STATE <= `STATE_LOOPBEGIN;
				else if(DECODED[`OP_LOOPEND])
					STATE <= `STATE_LOOPEND;
				else if(DECODED[`OP_COUT])
					STATE <= `STATE_COUT;
				else
					STATE <= `STATE_DUPDATE;
			end
			
			`STATE_DUPDATE:
			begin					
				STATE <= `STATE_WRITEBACK;
			end
			
			`STATE_WRITEBACK:
			begin
				CACK <= 1'b0;
				DEN <= 1'b1;
				DWE <= 1'b1;
				
				STATE <= `STATE_IFETCH;
			end
			
			`STATE_LOOPBEGIN:
			begin					
				if(ZERO)
				begin
					LOOPSEEK <= 1'b1;
					LOOP_DEPTH <= 1;
				end
				else
					STACK_PUSH <= 1'b1;
					
				STATE <= `STATE_IFETCH;				
			end
			
			`STATE_LOOPEND:
			begin
				STACK_POP <= 1'b1;
				STATE <= `STATE_LOOPEND2;
			end
			
			`STATE_LOOPEND2:
			begin
				STACK_POP <= 1'b0;
				
				STATE <= `STATE_LOOPEND3;
			end
			
			`STATE_LOOPEND3:
			begin					
				STATE <= `STATE_IFETCH;
			end
			
			`STATE_LOOPSEEK:
			begin
				if(DECODED[`OP_LOOPBEGIN])
					LOOP_DEPTH <= LOOP_DEPTH + 1;
				else if(DECODED[`OP_LOOPEND])
				begin
					if(LOOP_DEPTH == 1)
						LOOPSEEK <= 1'b0;
					
					LOOP_DEPTH <= LOOP_DEPTH - 1;
				end
				
				STATE <= `STATE_IFETCH;
			end
			
			`STATE_COUT:
				begin
					if(CRDY)
					begin
						COUT <= DDOUT;
						CWR <= 1'b1;
						STATE <= `STATE_IFETCH;
					end
					else
						STATE <= `STATE_COUT;
				end
				
			`STATE_CIN:
				if(CRDA)
				begin
					CACK <= 1'b1;
					STATE <= `STATE_WRITEBACK;
				end
				else
					STATE <= `STATE_CIN;
			endcase

	assign DA = DC;
	assign CONLOAD = (STATE == `STATE_CIN) && CRDA;
	assign PCLOAD = (!ZERO || !FAST_LOOPEND) && STATE == `STATE_LOOPEND3;
	assign LOOP_PC = STACK_PC - 1;
	assign ZERO = DDOUT == 0;
	
endmodule


