`timescale 1ns / 1ps

module s_axil_tb;

    // Parameters
    localparam C_AXIL_ADDR_WIDTH = 4;
    localparam C_AXIL_DATA_WIDTH = 32;

    // Signals
    logic aclk;
    logic aresetn;

    logic [C_AXIL_ADDR_WIDTH-1:0] s_axi_awaddr;
    logic s_axi_awvalid;
    logic s_axi_awready;

    logic [C_AXIL_DATA_WIDTH-1:0] s_axi_wdata;
    logic s_axi_wvalid;
    logic s_axi_wready;

    logic [1:0] s_axi_bresp;
    logic s_axi_bvalid;
    logic s_axi_bready;

    logic [C_AXIL_ADDR_WIDTH-1:0] s_axi_araddr;
    logic s_axi_arvalid;
    logic s_axi_arready;

    logic [C_AXIL_DATA_WIDTH-1:0] s_axi_rdata;
    logic [1:0] s_axi_rresp;
    logic s_axi_rvalid;
    logic s_axi_rready;

    logic [C_AXIL_DATA_WIDTH-1:0] m_axis_tdata;
    logic m_axis_tvalid;
    logic m_axis_tready;

    // Instantiate DUT
    s_axil #(
        .C_AXIL_ADDR_WIDTH(C_AXIL_ADDR_WIDTH),
        .C_AXIL_DATA_WIDTH(C_AXIL_DATA_WIDTH)
    ) dut (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready)
    );

    // Clock Generation
    always #5 aclk = ~aclk;  // 10ns clock period

    // Test Sequence
    initial begin
        // Initialize signals
        aclk = 0;
        aresetn = 0;
        s_axi_awaddr = 4'h0;
        s_axi_awvalid = 0;
        s_axi_wdata = 32'h0000;
        s_axi_wvalid = 0;
        s_axi_bready = 1;
        s_axi_araddr = 4'h0;
        s_axi_arvalid = 0;
        s_axi_rready = 1;
        m_axis_tready = 1;

        // Dump VCD for EPWave
        $dumpfile("dump.vcd");  
        $dumpvars(0, s_axil_tb);  

        // Reset sequence
        #20 aresetn = 1;

        // Example write operation
        #10 s_axi_awaddr = 4'h0;  // Write to ADDR_START
        s_axi_awvalid = 1;
        s_axi_wdata = 32'h1;
        s_axi_wvalid = 1;
        #10 s_axi_awvalid = 0;
        s_axi_wvalid = 0;

        // Example read operation
        #10 s_axi_araddr = 4'h0;  // Read from ADDR_START
        s_axi_arvalid = 1;
        #10 s_axi_arvalid = 0;

        // Stop simulation
        #100 $finish;
    end

endmodule
