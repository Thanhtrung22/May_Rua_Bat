`timescale 1ns / 1ps

module classify_machine(clk, reset, start, timeout, detect_bowl, detect_chopstick, detect_plate, motor_1, motor_2, motor_3);
	input clk, reset, start, timeout, detect_bowl, detect_chopstick, detect_plate;
	output reg motor_1, motor_2, motor_3; 
	
	//defining the states
	parameter IDLE = 2'b00;
	parameter BOWL = 2'b01;
	parameter PLATE = 2'b10;
	parameter CHOPSTICK = 2'b11;
	
	reg[1:0] current_state, next_state;
	
	always@(current_state or start or timeout or detect_bowl or detect_chopstick or detect_plate)
	begin
	case(current_state)
		IDLE:
			if(detect_bowl==1)
				next_state = BOWL;
			else if(detect_chopstick==1)
				next_state = CHOPSTICK;
			else if(detect_plate==1)
				next_state = PLATE;
			else
			begin
				next_state = current_state;
				motor_1 = 0;
				motor_2 = 0;
				motor_3 = 0;
			end
		BOWL:
			if(timeout == 1)
			begin
				next_state = IDLE;
				motor_1 = 0;
			end
			else
			begin
				next_state = current_state;
				motor_1 = 1;
			end
		PLATE:
			if(timeout == 1)
			begin
				next_state = IDLE;
				motor_2 = 0;
			end
			else
			begin
				next_state = current_state;
				motor_2 = 1;
			end
		CHOPSTICK:
			if(timeout == 1)
			begin
				next_state = IDLE;
				motor_3 = 0;
			end
			else
			begin
				next_state = current_state;
				motor_3 = 1;
			end
		default:
				next_state = IDLE;
				
		endcase
	end
	
	always@(posedge clk or negedge reset)
	begin
		if(reset)
		begin
			current_state<=2'b00;
		end
		else
		begin
			current_state<=next_state;
		end
	end
	
endmodule


