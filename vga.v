/*
generate test pattern at 640 x 480 @ 60Hz

total pixels is 800 x 525 @ 60Hz = 25.2Mhz = 39.6ns

Timings from :

* http://hamsterworks.co.nz/mediawiki/index.php/VGA_timings
* http://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml

code adapted from VHDL :

* http://hamsterworks.co.nz/mediawiki/index.php/FPGA_VGA
* http://hamsterworks.co.nz/mediawiki/index.php/Dvid_test#vga.vhd

Horizontal Timing
640     h visible
16      front
96      sync
48      back
800     whole
-       hsync

Vertical Timing

480     v visible
10      front
2       sync
33      back
525     whole
-       vsync

45 blank lines at the bottom, 800 pix wide = 36k clocks for other things

*/
`default_nettype none
module vga (
	input wire clk,
    input wire reset,
    input wire [2:0] px_red,
    input wire [2:0] px_grn,
    input wire [2:0] px_blu,
    output reg [2:0] red,
    output reg [2:0] green,
    output reg [2:0] blue,
    output reg [10:0] hcounter,
    output reg [9:0] vcounter,
    output reg hsync,
    output reg vsync,
    output reg blank,
    output reg lower_blank
    );

    localparam border_w = 10;

	always@(hcounter or vcounter) begin // results in a note about combinatorial logic
        // black everywhere
        red   <= 3'b000;
        green <= 3'b000;
        blue  <= 3'b000;

        // sync
        hsync <= 1'b1;
        vsync <= 1'b1;
        blank <= 1'b0;
        lower_blank <= 1'b0;

        // sync pulses
        if(hcounter > 655 && hcounter < 751)
           hsync <= 1'b0;
        if(vcounter > 489 && vcounter < 491)
           vsync <= 1'b0;
        // blank is whenever outside of viewable area
        if(hcounter > 639 || vcounter > 479)
           blank <= 1'b1;
        if(vcounter > 479 )
           lower_blank <= 1'b1;

        if(vcounter < 480 && hcounter < 640) begin
            red <= px_red;
            green <= px_grn;
            blue <= px_blu;
        end else begin
            red <= 3'b0;
            green <= 3'b0;
            blue <= 3'b0;
        end 

    end

    // increment counters and wrap them
    always@(posedge clk) begin
        if(reset == 1) begin
            hcounter <= 0;
            vcounter <= 0;
        end else if(hcounter == 799) begin
            hcounter <= 0;
            if(vcounter == 524) begin
                vcounter <= 0;
            end else
                vcounter <= vcounter + 1;
            end
        else
            hcounter <= hcounter + 1;
    end
endmodule
