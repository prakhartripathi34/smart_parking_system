`timescale 1ns/1ps
module tb_smart_parking();

    // Signal Definitions
    reg clk;
    reg rst; // Active-low reset
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

    // Clock generation: 100MHz clock (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Task Definitions for Reusability and Readability

    // Task to apply reset (active-low)
    task apply_reset;
        begin
            $display("[%0t] Asserting Reset (rst = 0)", $time);
            rst = 0;          // Assert reset
            #20;
            $display("[%0t] Deasserting Reset (rst = 1)", $time);
            rst = 1;          // Deassert reset
            #20;
        end
    endtask

    // Task to activate entry sensor
    task activate_entry_sensor;
        begin
            $display("[%0t] Activating Entry Sensor", $time);
            sensor_entry = 1;
            #10;
            sensor_entry = 0;
            $display("[%0t] Deactivating Entry Sensor", $time);
        end
    endtask

    // Task to activate exit sensor
    task activate_exit_sensor;
        begin
            $display("[%0t] Activating Exit Sensor", $time);
            sensor_exit = 1;
            #10;
            sensor_exit = 0;
            $display("[%0t] Deactivating Exit Sensor", $time);
        end
    endtask

    // Task to provide password
    task provide_password(input [3:0] pwd);
        begin
            $display("[%0t] Providing Password: %b", $time, pwd);
            password = pwd;
            #20;
            password = 4'b0000; // Clear password after entry
            $display("[%0t] Password Cleared", $time);
        end
    endtask

    // Task to trigger simultaneous sensors
    task activate_both_sensors;
        begin
            $display("[%0t] Activating Both Entry and Exit Sensors", $time);
            sensor_entry = 1;
            sensor_exit = 1;
            #10;
            sensor_entry = 0;
            sensor_exit = 0;
            $display("[%0t] Deactivating Both Sensors", $time);
        end
    endtask

    // Initial block for stimulus
    initial begin
        // Initialize signals
        rst = 1;                // Ensure reset is deasserted initially
        sensor_entry = 0;
        sensor_exit = 0;
        password = 4'b0000;

        // Open VCD file for waveform analysis
        $dumpfile("smart_parking_tb.vcd");
        $dumpvars(0, tb_smart_parking);

        // Apply Reset
        apply_reset();

        // Scenario 1: Correct password entry
        $display("=== Scenario 1: Correct Password Entry ===");
        activate_entry_sensor();
        #40; // Wait for password input time
        provide_password(4'b1101); // Correct password

        // Wait for system to process
        #40;

        // Scenario 2: Sensor exit without sensor entry
        $display("=== Scenario 2: Exit Without Entry ===");
        activate_exit_sensor();

        // Wait for system to process
        #20;

        // Scenario 3: Wrong password entry
        $display("=== Scenario 3: Wrong Password Entry ===");
        activate_entry_sensor();
        #40; // Wait for password input time
        provide_password(4'b0001); // Incorrect password

        // Wait for system to process
        #40;

        // Scenario 4: Correct password after wrong password
        $display("=== Scenario 4: Correct Password After Wrong ===");
        provide_password(4'b1101); // Correct password

        // Wait for system to process
        #40;

        // Scenario 5: Simultaneous entry and exit sensors triggered
        $display("=== Scenario 5: Simultaneous Sensors Triggered ===");
        activate_both_sensors();

        // Wait for system to process
        #50;

        // End of simulation
        $display("=== End of Simulation ===");
        $finish;
    end

    // Monitor Outputs
    always @(posedge clk) begin
        $display("[%0t] State: %b | GREEN_LED: %b | RED_LED: %b | BLUE_LED: %b | YELLOW_LED: %b",
                 $time, uut.current_state, GREEN_LED, RED_LED, BLUE_LED, YELLOW_LED);
    end

endmodule
