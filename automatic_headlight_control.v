`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 15:59:32
// Design Name: 
// Module Name: automatic_headlight_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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



