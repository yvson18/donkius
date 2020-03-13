module LFSR(random_0, random_1, clk);
	
	output reg[3:0]random_0;
	output reg[3:0]random_1; 
	input clk;

	reg[3:0]rnd = 4'b1110;
	reg[3:0]aux;
	
	integer contador = 0, identity_0 = 0, identity_1 = 0, identity_2 = 0, identity_3 = 0;
	
	always@(posedge clk)begin
		rnd[0] <= rnd[2] ^ rnd[3];
		rnd[1] <= rnd[0];
		rnd[2] <= rnd[1];
		rnd[3] <= rnd[2];
	end//always
	
	always@(rnd)begin
		if(rnd % 4 == 0)begin
			aux[0] = 1'b1;
		end else aux[0] = 1'b0;
		if(rnd % 4 == 1)begin
			aux[1] = 1'b1;
		end else aux[1] = 1'b0;
		if(rnd % 4 == 2)begin
			aux[2] = 1'b1;
		end else aux[2] = 1'b0;
		if(rnd % 4 == 3)begin
			aux[3] = 1'b1;
		end 
		else aux[3] = 1'b0;
	end//always
	
	always@(*)begin
	
	if(aux[0] || aux[1] || aux[2] || aux[3]) //TERMINAR ESSE IF-ZÃO
	begin
		if(contador < 4)
			contador <= contador + 1;
	end//if
	end //always
	
	always@(aux[0])
	begin
		identity_0 <= aux[0];
	end
	
	always@(aux[1])
	begin
		identity_1 <= aux[1];
	end
	
	always@(aux[2])
	begin
		identity_2 <= aux[2];
	end
	
	always@(aux[3])
	begin
		identity_3 <= aux[3];
	end
	
	always@(contador)
	begin
		if(contador < 4)
		begin
			random_0[contador] = (identity_0 || identity_2)? 0 : 1;
		end
	end
	
endmodule
