//
// Converts single-precision floating point numbers to an integer
//

module fp_convert
	#(parameter EXPONENT_WIDTH = 8, 
	parameter SIGNIFICAND_WIDTH = 23,
	parameter TOTAL_WIDTH = 1 + EXPONENT_WIDTH + SIGNIFICAND_WIDTH,
	parameter SIGNIFICAND_PRODUCT_WIDTH = (SIGNIFICAND_WIDTH + 1) * 2)

	(input 										sign_i,
	input[EXPONENT_WIDTH - 1:0] 				exponent_i,
	input[SIGNIFICAND_PRODUCT_WIDTH + 1:0] 		significand_i,
	output reg [TOTAL_WIDTH - 1:0] 				result_o = 0);

	reg[TOTAL_WIDTH - 1:0]						unnormalized_result = 0;

	wire[5:0] shift_amount = (SIGNIFICAND_PRODUCT_WIDTH - (exponent_i - 127) - 2);
	wire[TOTAL_WIDTH - 1:0]	shifted_result = { {SIGNIFICAND_PRODUCT_WIDTH + 1{1'b0}},  
		significand_i } >> shift_amount;

	always @*
	begin
		if (exponent_i >= 127)	// Exponent is not negative
			unnormalized_result = shifted_result;
		else
			unnormalized_result = 0;
	end

	always @*
	begin
		if (exponent_i == 0 && sign_i == 0 && significand_i == 0)
			result_o = 0;
		else if (sign_i)
			result_o = ~unnormalized_result + 1;
		else
			result_o = unnormalized_result;
	end
endmodule
