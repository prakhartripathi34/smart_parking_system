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

always @(posedge clk or negedge rst) begin
  if (~rst)
    current_state <= IDLE;
  else
    current_state <= next_state;
end

always @(posedge clk or negedge rst) begin
  if (~rst)
    counter_wait <= 0;
  else if (current_state == WAIT_PASSWORD)
    counter_wait <= counter_wait + 1;
  else
    counter_wait <= 0;
end

always @(*) begin
  case (current_state)
    IDLE: begin
      if (sensor_entry == 1)
      begin
        next_state <= WAIT_PASSWORD;
      end
      else
      begin
        next_state <= IDLE;
      end
    end

    WAIT_PASSWORD: begin
      if (counter_wait <= 3)
      begin
        next_state <= WAIT_PASSWORD;
      end
      else begin
        if (password == 4'b1101)
        begin
          next_state <= RIGHT_PASSWORD;
        end
        else
        begin
          next_state <= WRONG_PASSWORD;
        end
      end
    end

    WRONG_PASSWORD: begin
      if (password == 4'b1101)
      begin
        next_state <= RIGHT_PASSWORD;
      end
      else
      begin
        next_state <= WRONG_PASSWORD;
      end
    end

    RIGHT_PASSWORD: begin
      if (sensor_entry == 1 && sensor_exit == 1)
      begin
        next_state <= SYS_STOP;
      end
      else if (sensor_exit == 1)
      begin
        next_state <= IDLE;
      end
      else
      begin
        next_state <= RIGHT_PASSWORD;
      end
    end

    SYS_STOP: begin
      if (password == 4'b1101)
      begin
        next_state <= RIGHT_PASSWORD;
      end
      else
      begin
        next_state <= SYS_STOP;
      end
    end

    default: next_state <= IDLE;
  endcase
end

always @(current_state) begin
  case (current_state)
    IDLE: begin
      GREEN_LED <= 1'b0;
      RED_LED <= 1'b0;
      YELLOW_LED <= 1'b0;
      BLUE_LED <= 1'b1;
    end

    WAIT_PASSWORD: begin
      GREEN_LED <= 1'b0;
      RED_LED <= 1'b0;
      YELLOW_LED <= 1'b1;
      BLUE_LED <= 1'b1;
    end

    WRONG_PASSWORD: begin
      GREEN_LED <= 1'b0;
      RED_LED <= ~RED_LED;
      YELLOW_LED <= 1'b0;
      BLUE_LED <= 1'b0;
    end

    RIGHT_PASSWORD: begin
      GREEN_LED <= 1'b1;
      RED_LED <= 1'b0;
      BLUE_LED <= 1'b0;
      YELLOW_LED <= 1'b0;
    end

    SYS_STOP: begin
      GREEN_LED <= 1'b0;
      RED_LED <= 1'b1;
      YELLOW_LED <= 1'b1;
      BLUE_LED <= 1'b0;
    end


  endcase
end

endmodule
