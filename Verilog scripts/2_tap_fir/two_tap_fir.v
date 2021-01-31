module two_tap_fir(
	input clock,
	input startTransistion,
	output reg [31:0] dataOut
);

// Continuous input signal x for now is just a pre-set array.
// Coefficient values are pre-set to. This script just test the concept of the
// FIR filter
reg [7:0] input_x [0:2];
reg [7:0] input_coef [0:1];
reg [7:0] buffer [0:1];
reg [2:0] counter;


reg [1:0] state;
reg [1:0] IDLE = 3'd0;
reg [1:0] START = 3'd1;
reg [1:0] STOP = 3'd2;



initial begin
	dataOut = 0;

	input_x[0] = 8'd200;
	input_x[1] = 8'd15;
	input_x[2] = 8'd169;

	input_coef[0] = 8'd5;
	input_coef[1] = 8'd153;

	buffer[0] = 0;
	buffer[1] = 0;


	counter = 0;

	state = 0;
end

always @(posedge clock) begin
	case(state)
		IDLE: begin
			if(startTransistion == 1) begin
				state = START;
			end
		end
		START: begin
			if(counter == 0) begin
				buffer[0] = input_x[0];
				buffer[1] = 0;
			end
			else if (counter == 3) begin
				buffer[0] = 0;
				buffer[1] = input_x[2];
				state = STOP;
			end
			else begin
				buffer[0] = input_x[counter];
				buffer[1] = input_x[counter - 1];
			end

			dataOut = (input_coef[0] * buffer[0]) + (input_coef[1] * buffer[1]);
			counter = counter + 3'd1;
		end
		STOP: begin
			dataOut = 0;
			buffer[0] = 0;
			buffer[1] = 0;
			counter = 0;
		end
	endcase
end

endmodule
