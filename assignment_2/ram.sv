module axi_ram (
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

    reg [7:0] mem [0:288];  // RAM storage
    
    // State machine states
    localparam IDLE = 1'b0;
    localparam WRITE = 1'b1;
    
    reg state;
    
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            s_axis_tready <= 1'b0;
            m_axis_tvalid <= 1'b0;
            m_axis_tdata <= 32'b0;
            
            // Initialize memory
            for (integer i = 0; i < 289; i = i + 1) begin
                mem[i] <= 8'b0;
            end
        end else begin
            case (state)
                IDLE: begin
                    s_axis_tready <= 1'b1;
                    if (s_axis_tvalid && s_axis_tready) begin
                        // Write data to memory
                        mem[s_axis_tdata[7:0]] <= s_axis_tdata[15:8];  // Address in lower byte, data in next byte
                        state <= WRITE;
                        s_axis_tready <= 1'b0;
                    end
                end

                WRITE: begin
                    if (m_axis_tready) begin
                        m_axis_tvalid <= 1'b1;
                        m_axis_tdata <= {24'b0, mem[s_axis_tdata[7:0]]};  // Output the written data
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
