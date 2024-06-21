`timescale 1ns/1ps

module tb_smart_parking();

reg clk;
reg rst;
reg sensor_entry;
reg sensor_exit;
reg [3:0] password;
wire GREEN_LED;
wire RED_LED;
wire BLUE_LED;
wire YELLOW_LED;

// Instantiate the smart_parking module
smart_parking uut (
    .clk(clk),
    .rst(rst),
    .sensor_entry(sensor_entry),
    .sensor_exit(sensor_exit),
    .password(password),
    .GREEN_LED(GREEN_LED),
    .RED_LED(RED_LED),
    .BLUE_LED(BLUE_LED),
    .YELLOW_LED(YELLOW_LED)
);

// Clock generation
always #5 clk = ~clk;

// Initial block for stimulus
initial begin
    // Initialize signals
    clk = 0;
    rst = 0;
    sensor_entry = 0;
    sensor_exit = 0;
    password = 4'b0000;

    // Open VCD file for GTKWave
    $dumpfile("smart_parking_tb.vcd");
    $dumpvars(0, tb_smart_parking);

    // Reset the system
    #10;
    rst = 1;
    #10;
    rst = 0;
    #10;
    rst = 1;
    
    // Scenario 1: Correct password entry
    sensor_entry = 1;
    #10;
    sensor_entry = 0;
    #40; // Wait for 40 time units to simulate waiting for password input
    
    password = 4'b1101;
    #20; // Wait for the system to check the password
    
    // Scenario 2: Sensor exit without sensor entry
    sensor_exit = 1;
    #10;
    sensor_exit = 0;
    
    // Scenario 3: Wrong password entry
    sensor_entry = 1;
    #10;
    sensor_entry = 0;
    #40; // Wait for 40 time units to simulate waiting for password input
    
    password = 4'b0001;
    #20; // Wait for the system to check the password
    
    // Scenario 4: Correct password after wrong password
    password = 4'b1101;
    #20; // Wait for the system to check the password

    // Scenario 5: Simultaneous entry and exit sensors triggered
    sensor_entry = 1;
    sensor_exit = 1;
    #10;
    sensor_entry = 0;
    sensor_exit = 0;

    // End of simulation
    #50;
    $finish;
end

endmodule
