# Smart Parking System

This project implements a smart parking system using a Finite State Machine (FSM) in Verilog. The system manages entry and exit of vehicles based on sensor inputs and a password verification mechanism. The state of the system is indicated using LEDs.

## Table of Contents
1. Overview
2. State Descriptions
3. Inputs and Outputs
4. Usage
5. Simulation and Testing
6. File List
7. License

## Overview

The smart parking system operates with five primary states:
1. IDLE
2. WAIT_PASSWORD
3. WRONG_PASSWORD
4. RIGHT_PASSWORD
5. SYS_STOP

The system starts in the `IDLE` state. When a vehicle is detected by the entry sensor, the system transitions to `WAIT_PASSWORD` and expects a password input. Depending on the correctness of the password, the system moves to either the `WRONG_PASSWORD` or `RIGHT_PASSWORD` state. The `SYS_STOP` state indicates a system halt condition when both entry and exit sensors are triggered simultaneously.

## State Descriptions

- **IDLE (3'b000)**: Default state when no vehicle is detected at the entry sensor. BLUE_LED is on.
- **WAIT_PASSWORD (3'b001)**: State entered when a vehicle is detected. The system waits for a password input. YELLOW_LED and BLUE_LED are on.
- **WRONG_PASSWORD (3'b010)**: State indicating an incorrect password entry. RED_LED blinks.
- **RIGHT_PASSWORD (3'b011)**: State indicating a correct password entry. GREEN_LED is on.
- **SYS_STOP (3'b100)**: State indicating a system halt condition. RED_LED and YELLOW_LED are on.

## Inputs and Outputs

### Inputs
- **clk**: System clock.
- **rst**: System reset (active low).
- **sensor_entry**: Entry sensor signal.
- **sensor_exit**: Exit sensor signal.
- **password [3:0]**: 4-bit password input.

### Outputs
- **GREEN_LED**: Indicates successful password entry.
- **RED_LED**: Indicates incorrect password entry or system halt.
- **BLUE_LED**: Indicates idle state.
- **YELLOW_LED**: Indicates waiting for password.

## Usage

1. **Initialization**: Ensure the `rst` signal is asserted at the beginning to reset the system to the `IDLE` state.
2. **Entry Detection**: When `sensor_entry` is activated, the system transitions to `WAIT_PASSWORD` state.
3. **Password Entry**: Provide a 4-bit password input.
   - Correct Password: The system transitions to `RIGHT_PASSWORD` state.
   - Incorrect Password: The system transitions to `WRONG_PASSWORD` state.
4. **Exit Detection**: The system transitions back to `IDLE` state upon `sensor_exit` activation.
5. **System Halt**: When both `sensor_entry` and `sensor_exit` are activated, the system transitions to `SYS_STOP`.

## Simulation and Testing

To test the system:
1. Set up a testbench to provide clock (`clk`), reset (`rst`), sensor signals (`sensor_entry`, `sensor_exit`), and password input (`password`).
2. Observe the state transitions by monitoring the `current_state` and `next_state` signals.
3. Check the LED outputs (`GREEN_LED`, `RED_LED`, `BLUE_LED`, `YELLOW_LED`) to verify correct state indications.
4. RTL schemetic can be produced by using xilinx vivado


