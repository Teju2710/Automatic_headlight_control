# Automatic_headlight_control
## Intoduction
The Automatic Headlight Control System is a Verilog-based design that automates the vehicle's headlight functionality for enhanced safety and convenience. This system dynamically adjusts the vehicle's headlights based on external lighting conditions, weather, and vehicle speed. It ensures optimal headlight usage, reducing driver intervention and improving safety, especially in low-light or adverse weather conditions.

### Key features include:

#### Automatic On/Off Control:
The headlights turn on automatically when the surrounding environment is dark (nighttime) or during rainy conditions, and remain off during bright daylight and dry weather.
#### Speed-Based Brightness Adjustment: 
The brightness of the headlights is adjusted depending on the vehicle's speed, ensuring full brightness at higher speeds and dimmed lights in rain or lower speeds.
#### Weather and Ignition Sensor Integration:
The system integrates a rain sensor and vehicle ignition status to provide intelligent control, ensuring headlights are only active when needed, and turn off when the vehicle is not running.

The system helps improve driving safety by ensuring that headlights are always appropriately managed, regardless of environmental factors, thereby reducing the likelihood of accidents due to poor visibility. Designed for simplicity and efficiency, the project is implemented virtually using Verilog and can be easily simulated and tested within environments like Xilinx Vivado.

## Code
     `timescale 1ns / 1ps
     module automatic_headlight_control(
    input wire light_sensor,       // Input from the light sensor (0 = dark, 1 = bright)
    input wire rain_sensor,        // Input from the rain sensor (0 = no rain, 1 = rain)
    input wire [7:0] speed_sensor, // Input from the speed sensor (speed of the vehicle in km/h)
    input wire ignition,           // Input from the car's ignition (1 = car is on)
    output reg headlights,         // Output to control the headlights (0 = off, 1 = on)
    output reg [7:0] dim_level     // Output for headlight brightness control (0 = off, 255 = full brightness)
    );

    // Parameters for speed thresholds
    parameter LOW_SPEED_THRESHOLD = 40;  // Speed below which headlights are mandatory in rain
    parameter HIGH_SPEED_THRESHOLD = 100; // Speed above which full brightness is required at night
    
    // Parameters for brightness levels
    parameter BRIGHTNESS_LOW = 128;      // Dimming for low speed or rain
    parameter BRIGHTNESS_HIGH = 255;     // Full brightness for high speeds
    
    always @ (light_sensor or rain_sensor or speed_sensor or ignition) begin
        if (ignition == 1) begin   // Check if the car's ignition is on
            // Automatic control based on light sensor, rain sensor, and speed
            if (light_sensor == 0 || rain_sensor == 1) begin
                // Headlights ON if it's night or raining
                headlights = 1;

                // Adjust headlight brightness based on speed and rain
                if (rain_sensor == 1 && speed_sensor < LOW_SPEED_THRESHOLD) begin
                    dim_level = BRIGHTNESS_LOW; // Dim lights for low speed and rain
                end else if (speed_sensor > HIGH_SPEED_THRESHOLD) begin
                    dim_level = BRIGHTNESS_HIGH; // Full brightness for high speed
                end else if (light_sensor == 0) begin
                    dim_level = BRIGHTNESS_HIGH; // Full brightness at night
                end else begin
                    dim_level = BRIGHTNESS_LOW;  // Dim lights in rain or low light
                end
            end else if (light_sensor == 1 && rain_sensor == 0) begin
            // During the day with no rain, headlights are off regardless of speed
                 headlights = 0;
                 dim_level = 0;
            end else if (speed_sensor > HIGH_SPEED_THRESHOLD) begin
                // If speed is greater than the threshold, turn on full brightness even during the day
                headlights = 1;
                dim_level = BRIGHTNESS_HIGH;
            end else begin
                headlights = 0;    // Turn headlights OFF when bright outside and no rain
                dim_level = 0;      // No brightness if headlights are off
            end
        end else begin
            headlights = 0;        // Turn headlights OFF if the ignition is off
            dim_level = 0;          // No brightness if car is off
        end
    end
    endmodule

## Testbench Code
    `timescale 1ns / 1ps
    module tb_automatic_headlight_control();
    reg light_sensor;
    reg rain_sensor;
    reg [7:0] speed_sensor;
    reg ignition;
    wire headlights;
    wire [7:0] dim_level;

    // Instantiate the automatic_headlight_control module
    automatic_headlight_control UUT (
        .light_sensor(light_sensor),
        .rain_sensor(rain_sensor),
        .speed_sensor(speed_sensor),
        .ignition(ignition),
        .headlights(headlights),
        .dim_level(dim_level)
    );

    initial begin
        // Initialize signals
        ignition = 0;
        light_sensor = 1;   // Daylight
        rain_sensor = 0;    // No rain
        speed_sensor = 0;   // Stationary
        #10;

        // Case 1: Car off, no headlights
        $display("Case 1: Car off - headlights = %b, dim_level = %d", headlights, dim_level);
        ignition = 0; light_sensor = 0; rain_sensor = 0; speed_sensor = 0;
        #10;
        // Case 2: Car on, daytime, no rain, low speed
        $display("Case 2: Car on, daytime, no rain, low speed - headlights = %b, dim_level = %d", headlights, dim_level);
        ignition = 1; light_sensor = 1; rain_sensor = 0; speed_sensor = 30;
        #10;
        // Case 3: Car on, nighttime, no rain, low speed
        $display("Case 3: Car on, nighttime, no rain, low speed - headlights = %b, dim_level = %d", headlights, dim_level);
        ignition = 1; light_sensor = 0; rain_sensor = 0; speed_sensor = 30;
        #10;
        // Case 4: Car on, nighttime, no rain, high speed
        $display("Case 4: Car on, nighttime, no rain, high speed - headlights = %b, dim_level = %d", headlights, dim_level);
        ignition = 1; light_sensor = 0; rain_sensor = 0; speed_sensor = 120;
        #10;
        // Case 5: Car on, daytime, raining, low speed
        $display("Case 5: Car on, daytime, raining, low speed - headlights = %b, dim_level = %d", headlights, dim_level);
        ignition = 1; light_sensor = 1; rain_sensor = 1; speed_sensor = 30;
        #10;
        // Case 6: Car on, daytime, raining, high speed
        $display("Case 6: Car on, daytime, raining, high speed - headlights = %b, dim_level = %d", headlights, dim_level);
        ignition = 1; light_sensor = 1; rain_sensor = 1; speed_sensor = 120;
        #10;
        // Case 7: Car on, daytime, no rain, high speed
        $display("Case 7: Car on, daytime, no rain, high speed - headlights = %b, dim_level = %d", headlights, dim_level);
        ignition = 1; light_sensor = 1; rain_sensor = 0; speed_sensor = 120;
        #10;
        // End simulation
        $finish;
    end
    endmodule

## Result
The Automatic Headlight Control System was successfully implemented and simulated using Verilog in a virtual environment. The system demonstrated efficient and accurate control of the vehicle's headlights based on external light conditions, rain detection, and vehicle speed. During simulation, the headlights automatically turned on when it was dark or rainy, and remained off during the day when no rain was detected, even at varying speeds. The system also adjusted the headlight brightness based on the speed of the vehicle, providing dimmed lights at lower speeds and full brightness at higher speeds, ensuring enhanced visibility in adverse conditions. The simulation confirmed that the system behaves as expected, providing a reliable solution for automatic headlight control that enhances driver safety and convenience.
