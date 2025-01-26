`timescale 1ns/1ps
module smart_parking(
    input clk,
    input rst,
    input sensor_entry,
    input sensor_exit,
    input [3:0] password,
    output reg GREEN_LED,
    output reg RED_LED,
    output reg BLUE_LED,
    output reg YELLOW_LED
);

parameter IDLE = 3'b000, WAIT_PASSWORD = 3'b001, WRONG_PASSWORD = 3'b010,
          RIGHT_PASSWORD = 3'b011, SYS_STOP = 3'b100;

reg [2:0] current_state, next_state;
reg [31:0] counter_wait;

// State Register
always @(posedge clk or negedge rst) begin
  if (!rst)
    current_state <= IDLE;
  else
    current_state <= next_state;
end

// Counter for WAIT_PASSWORD state
always @(posedge clk or negedge rst) begin
  if (!rst)
    counter_wait <= 32'd0;
  else if (current_state == WAIT_PASSWORD)
    counter_wait <= counter_wait + 1;
  else
    counter_wait <= 32'd0;
end

// Next-State Logic (Combinational)
always @(*) begin
  case (current_state)
    IDLE: begin
      if (sensor_entry)
        next_state = WAIT_PASSWORD;
      else
        next_state = IDLE;
    end

    WAIT_PASSWORD: begin
      if (counter_wait <= 3)
        next_state = WAIT_PASSWORD;
      else begin
        if (password == 4'b1101)
          next_state = RIGHT_PASSWORD;
        else
          next_state = WRONG_PASSWORD;
      end
    end

    WRONG_PASSWORD: begin
      if (password == 4'b1101)
        next_state = RIGHT_PASSWORD;
      else
        next_state = WRONG_PASSWORD;
    end

    RIGHT_PASSWORD: begin
      if (sensor_entry && sensor_exit)
        next_state = SYS_STOP;
      else if (sensor_exit)
        next_state = IDLE;
      else
        next_state = RIGHT_PASSWORD;
    end

    SYS_STOP: begin
      if (password == 4'b1101)
        next_state = RIGHT_PASSWORD;
      else
        next_state = SYS_STOP;
    end

    default: next_state = IDLE;
  endcase
end

// Output Logic (Combinational)
always @(*) begin
  // Default values to prevent latches
  GREEN_LED  = 1'b0;
  RED_LED    = 1'b0;
  YELLOW_LED = 1'b0;
  BLUE_LED   = 1'b0;

  case (current_state)
    IDLE: begin
      BLUE_LED = 1'b1;
    end

    WAIT_PASSWORD: begin
      YELLOW_LED = 1'b1;
      BLUE_LED   = 1'b1;
    end

    WRONG_PASSWORD: begin
       RED_LED =1'b1;
    end

    RIGHT_PASSWORD: begin
      GREEN_LED = 1'b1;
    end

    SYS_STOP: begin
      RED_LED    = 1'b1;
      YELLOW_LED = 1'b1;
    end

    default: begin
      BLUE_LED = 1'b1;
    end
  endcase
end


endmodule
