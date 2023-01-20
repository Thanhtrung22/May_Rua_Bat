module new_test();
	reg clk, reset, start, timeout, detect_bowl, detect_chopstick, detect_plate;
	wire motor_1, motor_2, motor_3; 	
	
classify_machine machine1(clk, reset, start, timeout, detect_bowl, detect_chopstick, detect_plate, motor_1, motor_2, motor_3);

	
	initial
		
	begin
	clk = 0;
		reset = 1;
		start = 0;
		timeout = 0;
                detect_bowl = 0;
                detect_chopstick = 0;
                detect_plate = 0;
		
		#5 reset=0;
		#5 start=1;
		#10 detect_bowl=1;detect_plate=0;detect_chopstick=0;
		#10 timeout=1;detect_bowl=0;
		#10 timeout=0;		
		#10 detect_bowl=0;detect_plate=0;detect_chopstick=1;
		#10 timeout=1;detect_chopstick=0;
		#10 timeout=0;	
		#10 detect_bowl=0;detect_plate=1;detect_chopstick=0;
		#10 timeout=1;detect_plate=0;
		#10 timeout=0;
		
	end
	
	always
	begin
		#5 clk = ~clk;
	end
	
	initial
	begin
		$monitor("Time=%d, Clock=%b, Reset=%b, start=%b, timeout=%b, detect_bowl=%b, detect_chopstick=%b, detect_plate=%b, motor_1=%b, motor_2=%b, motor_3=%b",$time, clk, reset, start, timeout, detect_bowl, detect_chopstick, detect_plate, motor_1, motor_2, motor_3);
	end
endmodule
