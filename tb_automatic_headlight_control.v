`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 18:48:57
// Design Name: 
// Module Name: tb_automatic_headlight_control
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

