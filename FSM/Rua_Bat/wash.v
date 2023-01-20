`timescale 10ns / 1ps

module automatic_washing_machine(clk, reset, door_close, start, filled, soap_added, wash_timeout, drained, drying_timeout, door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash);

	input clk, reset, door_close, start, filled, soap_added, wash_timeout, drained, drying_timeout;
	output reg door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash; 
	
	//defining the states
	parameter check_door = 3'b000;
	parameter fill_water = 3'b001;
	parameter add_soap = 3'b010;
	parameter wash = 3'b011;
	parameter drain_water = 3'b100;
	parameter drying = 3'b101;
	
	reg[2:0] current_state, next_state;
	
	always@(current_state or start or door_close or filled or soap_added or drained or wash_timeout or drying_timeout)
	begin
	case(current_state)
		check_door:
			if(start==1 && door_close==1)
			begin
				next_state = fill_water;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 0;
				water_wash = 0;
				done = 0;
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 0;
				soap_wash = 0;
				water_wash = 0;
				done = 0;
			end
			
			fill_water:
			if (filled==1)
			begin
				if(soap_wash == 0)
				begin
					next_state = add_soap;
					motor_on = 0;
					fill_valve_on = 0;
					drain_valve_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 0;
					done = 0;
				end
				else
				begin
					next_state = wash;
					motor_on = 0;
					fill_valve_on = 0;
					drain_valve_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 1;
					done = 0;
				end
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 1;
				drain_valve_on = 0;
				door_lock = 1;
				done = 0;
			end
			add_soap:
			if(soap_added==1)
			begin
				next_state = wash;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 1;
				done = 0;
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 1;
				water_wash = 0;
				done = 0;
			end
			wash:
			if(wash_timeout == 1)
			begin
				next_state = drain_water;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				done = 0;
			end
			else
			begin
				next_state = current_state;
				motor_on = 1;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				done = 0;
			end
			drain_water:
			 if(drained==1)
			 begin
				if(water_wash==0)
				begin
					next_state = fill_water;
					motor_on = 0;
					fill_valve_on = 0;
					drain_valve_on = 0;
					door_lock = 1;
					soap_wash = 1;
					done = 0;
				end
				else
				begin
				next_state = drying;
					motor_on = 0;
					fill_valve_on = 0;
					drain_valve_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 1;
					done = 0;
				end
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 1;
				door_lock = 1;
				soap_wash = 1;
				done = 0;
			end
			drying:
			if(drying_timeout==1)
			begin
				next_state = door_close;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 1;
				water_wash = 1;
				done = 1;
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 1;
				water_wash = 1;
				done = 0;
			end
			default:
				next_state = check_door;
				
			endcase
	end
	
	always@(posedge clk or negedge reset)
	begin
		if(reset)
		begin
			current_state<=3'b000;
		end
		else
		begin
			current_state<=next_state;
		end
	end
	
endmodule


