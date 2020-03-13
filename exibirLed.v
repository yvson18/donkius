module exibirLed(led, enable, clk, flag);
	input enable, clk;
	output reg led;
	output reg flag = 0;
	
	integer contador;
	
	always@(clk)begin
		if(enable)
			contador <= contador + 1;
	end
	
	always@(enable)begin
		if(contador == 0)begin
			led <= 1;
		end
	end
	
	always@(*)begin
		if(contador == 5000)begin
			led <= 0;
			contador <= 0;
			flag <= 1;
		end
	end
		
		always@(*)begin
			if(!enable)begin
				flag <= 0;
			end
		end	
	
endmodule
