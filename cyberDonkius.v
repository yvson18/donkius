module cyberDonkius(clock, liga, enable, n_reset, key);
	parameter S0 = 0;
	parameter S1 = 1;
	parameter S2 = 2;
	parameter S3 = 3;
	
	input clock, liga, n_reset;
	input [3:0]key;
	wire [3:0]key_0;
	output reg [3:0]enable = 4'b0;
	integer estado = 0, flag = 0, turno = 0;
	
	wire exibiu = 1'b0, perdeu = 1'b0, venceu = 1'b0;
	wire led_1, led_2, led_3, led_0, we0, we1, we2, we3;
	wire [3:0]w1;
	wire [3:0]w0;
	wire [15:0]saida;
	
	DeBounce D0(clock, n_reset, key[0], key_0[0]);
	DeBounce D1(clock, n_reset, key[1], key_0[1]);
	DeBounce D2(clock, n_reset, key[2], key_0[2]);
	DeBounce D3(clock, n_reset, key[3], key_0[3]);
	
	LFSR L1(
	w0, 
	w1, 
	clock
	);
	
	exibirLed e0(led_0, enable[0], clock, we0);
	exibirLed e1(led_1, enable[1], clock, we1);
	exibirLed e2(led_2, enable[2], clock, we2);
	exibirLed e3(led_3, enable[3], clock, we3);
	
	verificarSequencia V00(w0[0], 0, saida[0], w1[0], 0);
	verificarSequencia V10(w0[0], 1, saida[1], w1[0], 0);
	verificarSequencia V20(w0[0], 0, saida[2], w1[0], 1);
	verificarSequencia V30(w0[0], 1, saida[3], w1[0], 1);
	
	verificarSequencia V01(w0[1], 0, saida[4], w1[1], 0);
	verificarSequencia V11(w0[1], 1, saida[5], w1[1], 0);
	verificarSequencia V21(w0[1], 0, saida[6], w1[1], 1);
	verificarSequencia V31(w0[1], 1, saida[7], w1[1], 1);
	
	verificarSequencia V02(w0[2], 0, saida[8], w1[2], 0);
	verificarSequencia V12(w0[2], 1, saida[9], w1[2], 0);
	verificarSequencia V22(w0[2], 0, saida[10], w1[2], 1);
	verificarSequencia V32(w0[2], 1, saida[11], w1[2], 1);
	
	verificarSequencia V03(w0[3], 0, saida[12], w1[3], 0);
	verificarSequencia V13(w0[3], 1, saida[13], w1[3], 0);
	verificarSequencia V23(w0[3], 0, saida[14], w1[3], 1);
	verificarSequencia V33(w0[3], 1, saida[15], w1[3], 1);
	
	always@(*)begin
		if(perdeu)begin
			enable <= 4'b1111;
			if(we0 && we1 && we2 && we3)begin
				enable<=4'b0;
				perdeu<=1'b0;
			end
		end
	end
	
	always@(clock)//mudança de estados
	begin
		case(estado)
		S0:
		begin
			if(liga && (!perdeu) && (!venceu))
				estado <= S1;
		end//case S0
		S1:
		begin
			if(exibiu)
			begin
				estado <= S2;
				exibiu <= 1'b0;
			end//if(exibiu)
		end//case S1
		S2:
		begin
			case(flag)
				0:
				begin
					estado <= S1;
				end//case 0
				1:
				begin
					estado <= S3;
				end//case 1
				2:
				begin
					estado <= S0;
				end//case 2
				endcase
			end//S2
		endcase
	end//mudança de estados
	
	always@(clock)
	begin
		case(estado)
			S1:
			begin
				case(w1[turno])
					1:
					begin
						case(w0[turno])
							1:
							begin
								enable <= 4'b1000; 
							end
							0:
							begin
								enable <= 4'b0100;
							end
						endcase
					end
					0:
					begin
						case(w0[turno])
							1:
							begin
								enable <= 4'b0010; 
							end
							0:
							begin
								enable <= 4'b0001;
							end
						endcase
					end
				endcase
				if(we0 || we1 || we2 || we3)begin
					enable <= 4'b0;
					exibiu <= 1'b1;
				end
			end//S1
			S2:
			begin
				if(key_0[0] && turno < 4)begin
					turno <= (saida[4 * turno])? turno + 1 : 0;
					perdeu <= (saida[4 * turno])? 0 : 1;
					enable <= 4'b0001;
				end
				else
				if(key_0[1] && turno < 4)begin
					turno <= (saida[(4 * turno) + 1])? turno + 1 : 0;
					perdeu <= (saida[(4 * turno) + 1])? 0 : 1;
					enable <= 4'b0010;
				end
				else
				if(key_0[2] && turno < 4)begin
					turno <= (saida[(4 * turno) + 2])? turno + 1 : 0;
					perdeu <= (saida[(4 * turno) + 2])? 0 : 1;
					enable <= 4'b0100;
				end
				else
				if(key_0[3] && turno < 4)begin
					turno <= (saida[(4 * turno) + 3])? turno + 1 : 0;
					perdeu <= (saida[(4 * turno) + 3])? 0 : 1;
					enable <= 4'b1000;
				end
				if(we0 || we1 || we2 || we3)begin
				enable <= 4'b0;
					flag <= (turno >= 4)? 1 : (!perdeu)? 0 : 2;
				end
				end//S2
			S3:
			begin
				venceu <= 1'b1;
			end//S1
		endcase
	end//função de saida

endmodule
