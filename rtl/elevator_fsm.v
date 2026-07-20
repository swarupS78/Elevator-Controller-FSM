`timescale 1ns/1ps

module elevator_fsm(
    input clk,
    input reset,
    input req_valid,
    input [2:0] req_floor,

    output reg [2:0] current_floor,
    output reg door_open,
    output reg moving_up,
    output reg moving_down
);

reg [7:0] requests;

parameter IDLE      = 2'd0;
parameter MOVE_UP   = 2'd1;
parameter MOVE_DOWN = 2'd2;
parameter DOOR_OPEN = 2'd3;

reg [1:0] state;
reg [1:0] next_state;

integer i;
reg above;
reg below;

always @(*) begin

    above = 0;
    below = 0;

    for(i=0;i<8;i=i+1) begin
        if(requests[i]) begin
            if(i>current_floor)
                above=1;
            if(i<current_floor)
                below=1;
        end
    end
end

always @(*) begin

    next_state = state;

    case(state)

    IDLE:
    begin
        if(requests[current_floor])
            next_state = DOOR_OPEN;
        else if(above)
            next_state = MOVE_UP;
        else if(below)
            next_state = MOVE_DOWN;
    end

    MOVE_UP:
    begin
        if(requests[current_floor+1])
            next_state = DOOR_OPEN;
        else
            next_state = MOVE_UP;
    end

    MOVE_DOWN:
    begin
        if(requests[current_floor-1])
            next_state = DOOR_OPEN;
        else
            next_state = MOVE_DOWN;
    end

    DOOR_OPEN:
    begin
        if(above)
            next_state = MOVE_UP;
        else if(below)
            next_state = MOVE_DOWN;
        else
            next_state = IDLE;
    end

    endcase

end

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        state <= IDLE;
        current_floor <= 0;
        requests <= 0;
    end
    else
    begin

        state <= next_state;

        if(req_valid)
            requests[req_floor] <= 1;

        case(state)

        IDLE:
        begin
        end

        MOVE_UP:
        begin
            current_floor <= current_floor + 1;
        end

        MOVE_DOWN:
        begin
            current_floor <= current_floor - 1;
        end

        DOOR_OPEN:
        begin
            requests[current_floor] <= 0;
        end

        endcase

    end

end

always @(*) begin

    door_open = 0;
    moving_up = 0;
    moving_down = 0;

    case(state)

    IDLE:
    begin
    end

    MOVE_UP:
        moving_up = 1;

    MOVE_DOWN:
        moving_down = 1;

    DOOR_OPEN:
        door_open = 1;

    endcase

end

endmodule
