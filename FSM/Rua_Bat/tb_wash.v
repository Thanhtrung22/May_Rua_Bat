
module new_test();
	reg clk, reset, door_close, start, filled, soap_added, wash_timeout, drained, drying_timeout;
	wire door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash; 
	
automatic_washing_machine machine1(clk, reset, door_close, start, filled, soap_added, wash_timeout, drained, drying_timeout, door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash);

	initial
		
	begin
	clk = 0;
		reset = 1;
		start = 0;
		door_close = 0;
		filled = 0;
		drained = 0;
		soap_added = 0;
		wash_timeout = 0;
		drying_timeout = 0;
		
		#5 reset=0;
		#5 start=1;door_close=1;
		#10 filled=1;
		#10 soap_added=1;
		#10 wash_timeout=1;
		#10 drained=1;wash_timeout=0;
		#10 drained=0;
		#10 wash_timeout=1;
		#10 drained=1;
		#10 drying_timeout=1;
		
	end
	
	always
	begin
		#5 clk = ~clk;
	end
	
	initial
	begin
		$monitor("Time=%d, Clock=%b, Reset=%b, start=%b, door_close=%b, filled=%b, soap_added=%b, wash_timeout=%b, drained=%b, drying_timeout=%b, door_lock=%b, motor_on=%b, fill_valve_on=%b, drain_valve_on=%b, soap_wash=%b, water_wash=%b, done=%b",$time, clk, reset, start, door_close, filled, soap_added, wash_timeout, drained, drying_timeout, door_lock, motor_on, fill_valve_on, drain_valve_on, soap_wash, water_wash, done);
	end
endmodule