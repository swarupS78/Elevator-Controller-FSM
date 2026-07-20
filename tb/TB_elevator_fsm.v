`timescale 1ns/1ps

module TB_elevator_fsm;

reg clk;
reg reset;
reg req_valid;
reg [2:0] req_floor;

wire [2:0] current_floor;
wire door_open;
wire moving_up;
wire moving_down;

elevator_fsm DUT(

    .clk(clk),
    .reset(reset),
    .req_valid(req_valid),
    .req_floor(req_floor),
    .current_floor(current_floor),
    .door_open(door_open),
    .moving_up(moving_up),
    .moving_down(moving_down)

);

always #5 clk = ~clk;

initial
begin

    clk = 0;
    reset = 1;
    req_valid = 0;
    req_floor = 0;

    #20;
    reset = 0;

    #10;
    req_floor = 3;
    req_valid = 1;

    #10;
    req_valid = 0;

    #20;
    req_floor = 6;
    req_valid = 1;

    #10;
    req_valid = 0;

    #20;
    req_floor = 1;
    req_valid = 1;

    #10;
    req_valid = 0;

    #250;

    $finish;

end

initial
begin

    $monitor(
    "t=%0t Floor=%0d Door=%b Up=%b Down=%b Requests=%b",
    $time,
    current_floor,
    door_open,
    moving_up,
    moving_down,
    DUT.requests
    );

end

endmodule
