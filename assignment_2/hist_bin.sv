module s_m_hist (
    input aclk,
    input aresetn,

    // AXI-Stream Slave
    input [31:0]s_axis_tdata,
    input s_axis_tvalid,
    output reg s_axis_tready,

    // AXI-Stream Master 
    output reg [31:0]m_axis_tdata,
    output reg m_axis_tvalid,
    input m_axis_tready
);

    // State machine states
    localparam IDLE = 2'b00;
    localparam PROCESS = 2'b01;
    localparam WRITE_COUNT = 2'b10;
    localparam WRITE_DATA = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] bin_counts [0:7];    // Count for each bin
    reg [7:0] current_bin;         // Current bin being processed
    reg [7:0] data_index;          // Index within bin's data section
    reg [7:0] input_value;         // Store the input value

    // Calculate bin number based on input value
    function [2:0] get_bin;
        input [7:0] value;
        begin
            if (value <= 32)  get_bin = 0;
            else if (value <= 64)  get_bin = 1;
            else if (value <= 96)  get_bin = 2;
            else if (value <= 128) get_bin = 3;
            else if (value <= 160) get_bin = 4;
            else if (value <= 192) get_bin = 5;
            else if (value <= 224) get_bin = 6;
            else get_bin = 7;
        end
    endfunction

    // Calculate RAM address for bin data
    function [7:0] get_data_addr;
        input [2:0] bin;
        input [7:0] index;
        begin
            get_data_addr = 8'h20 + (bin * 8'h20) + index;
        end
    endfunction

    // State machine
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            s_axis_tready <= 1'b0;
            m_axis_tvalid <= 1'b0;
            m_axis_tdata <= 32'b0;
            current_bin <= 8'b0;
            data_index <= 8'b0;
            
            // Reset bin counts
            for (integer i = 0; i < 8; i = i + 1) begin
                bin_counts[i] <= 8'b0;
            end
        end else begin
            case (state)
                IDLE: begin
                    s_axis_tready <= 1'b1;
                    if (s_axis_tvalid && s_axis_tready) begin
                        input_value <= s_axis_tdata[7:0];  // Take lower 8 bits
                        state <= PROCESS;
                        s_axis_tready <= 1'b0;
                    end
                end

                PROCESS: begin
                    // Update bin count and prepare to write
                    current_bin <= get_bin(input_value);
                    bin_counts[get_bin(input_value)] <= bin_counts[get_bin(input_value)] + 1;
                    state <= WRITE_COUNT;
                    m_axis_tvalid <= 1'b1;
                end

                WRITE_COUNT: begin
                    if (m_axis_tready) begin
                        // Send bin count and its address
                        m_axis_tdata <= {16'b0, bin_counts[current_bin], 8'h00 + (current_bin * 4)};
                        state <= WRITE_DATA;
                    end
                end

                WRITE_DATA: begin
                    if (m_axis_tready) begin
                        // Send input value and its storage address
                        m_axis_tdata <= {16'b0, input_value, get_data_addr(current_bin, data_index)};
                        data_index <= data_index + 1;
                        state <= IDLE;
                        m_axis_tvalid <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule
