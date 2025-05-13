`timescale 1ns / 1ps
​
module s_axil #(
    parameter C_AXIL_ADDR_WIDTH = 4,
    parameter C_AXIL_DATA_WIDTH = 32
)(
    input logic aclk,
    input logic aresetn,
​
    // AXI-Lite Slave Interface
    input logic [C_AXIL_ADDR_WIDTH-1:0] s_axi_awaddr,  // 4-bit address
    input logic s_axi_awvalid,  // Is address valid?
    output logic s_axi_awready,  // Slave ready to take address
​
    input logic [C_AXIL_DATA_WIDTH-1:0] s_axi_wdata,
    input logic s_axi_wvalid,
    output logic s_axi_wready,
​
    output logic [1:0] s_axi_bresp,
    output logic s_axi_bvalid,
    input logic s_axi_bready,
​
    input logic [C_AXIL_ADDR_WIDTH-1:0] s_axi_araddr,
    input logic s_axi_arvalid,
    output logic s_axi_arready,
​
    output logic [C_AXIL_DATA_WIDTH-1:0] s_axi_rdata,
    output logic [1:0] s_axi_rresp,
    output logic s_axi_rvalid,
    input logic s_axi_rready,
​
    // AXI - Stream Master Interface
    output logic [C_AXIL_DATA_WIDTH-1:0] m_axis_tdata,
    output logic m_axis_tvalid,
    input logic m_axis_tready
);
​
    // Address map for registers
    localparam ADDR_START = 4'h0;
    localparam ADDR_STOP  = 4'h4;
    localparam ADDR_SEED  = 4'h8;
    localparam ADDR_TAPS  = 4'hC;
​
    // Internal registers
    logic start_reg;
    logic stop_reg;
    logic [7:0] seed_reg;
    logic [7:0] taps_reg;
    logic [7:0] lfsr_reg;
​
    // AXI Write Logic
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            start_reg <= 0;
            stop_reg  <= 0;
            seed_reg  <= 8'h01;
            taps_reg  <= 8'h87;
            s_axi_awready <= 0;
            s_axi_wready  <= 0;
        end else begin
            if (s_axi_awvalid && s_axi_wvalid && !s_axi_awready && !s_axi_wready) begin
                s_axi_awready <= 1;
                s_axi_wready  <= 1;
                case (s_axi_awaddr[3:0])
                    ADDR_START: start_reg <= s_axi_wdata[0];
                    ADDR_STOP:  stop_reg  <= s_axi_wdata[0];
                    ADDR_SEED:  seed_reg  <= s_axi_wdata[7:0];
                    ADDR_TAPS:  taps_reg  <= s_axi_wdata[7:0];
                endcase
            end else begin
                s_axi_awready <= 0;
                s_axi_wready  <= 0;
            end
        end
    end
​
    // Write response logic
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            s_axi_bvalid <= 0;
            s_axi_bresp  <= 2'b00;
        end else if (s_axi_awvalid && s_axi_wvalid && !s_axi_bvalid) begin
            if (s_axi_awaddr[3:0] == ADDR_START || 
                s_axi_awaddr[3:0] == ADDR_STOP  || 
                s_axi_awaddr[3:0] == ADDR_SEED  || 
                s_axi_awaddr[3:0] == ADDR_TAPS) begin
                s_axi_bresp <= 2'b00; // OKAY response
            end else begin
                s_axi_bresp <= 2'b11; // DECERR response
            end
            s_axi_bvalid <= 1;
        end else if (s_axi_bready) begin
            s_axi_bvalid <= 0;
        end
    end
​
    // AXI Read Logic with Proper s_axi_arready Handling
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            s_axi_rvalid  <= 0;
            s_axi_rresp   <= 2'b00;
            s_axi_arready <= 0;
        end else begin
            if (s_axi_arvalid && !s_axi_rvalid && !s_axi_arready) begin
                s_axi_arready <= 1; // Accept read address
                case (s_axi_araddr[3:0])
                    ADDR_START: s_axi_rdata <= {31'b0, start_reg};
                    ADDR_STOP:  s_axi_rdata <= {31'b0, stop_reg};
                    ADDR_SEED:  s_axi_rdata <= {24'b0, seed_reg};
                    ADDR_TAPS:  s_axi_rdata <= {24'b0, taps_reg};
                    default:    s_axi_rdata <= 32'b0;
                endcase
​
                s_axi_rresp <= (s_axi_araddr[3:0] == ADDR_START || 
                                s_axi_araddr[3:0] == ADDR_STOP  || 
                                s_axi_araddr[3:0] == ADDR_SEED  || 
                                s_axi_araddr[3:0] == ADDR_TAPS) ? 2'b00 : 2'b11;
​
                s_axi_rvalid <= 1;
            end else begin
                s_axi_arready <= 0; // Deassert when not accepting address
            end
​
            if (s_axi_rready) begin
                s_axi_rvalid <= 0; // Clear read valid when data is accepted
            end
        end
    end
​
​
    // LFSR Logic with AXI-Stream Handshake
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            lfsr_reg <= seed_reg;
            m_axis_tvalid <= 0;
        end else if (start_reg && !stop_reg && m_axis_tready) begin
            lfsr_reg <= {^(lfsr_reg & taps_reg), lfsr_reg[7:1]};
            m_axis_tvalid <= 1;
        end else if (!m_axis_tready) begin
            m_axis_tvalid <= m_axis_tvalid; // Hold value until ready
        end else begin
            m_axis_tvalid <= 0;
        end
    end
​
    // AXI-Stream Output
    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn)
            m_axis_tdata <= 0;
        else if (m_axis_tvalid && m_axis_tready)  // Only update data when ready
            m_axis_tdata <= {24'b0, lfsr_reg};
    end
​
endmodule
​
​
