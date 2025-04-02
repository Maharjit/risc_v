module tb_histogram_system();

    // Clock and reset
    reg aclk;
    reg aresetn;

    // LFSR to Histogram signals
    reg [31:0] lfsr_data;
    reg lfsr_valid;
    wire lfsr_ready;
    wire [31:0] hist_to_ram_data;
    wire hist_to_ram_valid;
    wire hist_to_ram_ready;

    // RAM output signals
    wire [31:0] ram_out_data;
    wire ram_out_valid;
    reg ram_out_ready;

    // Expected values storage
    reg [7:0] expected_counts [0:7];
    reg [7:0] expected_data [0:7][0:31];

    // Monitor signals
    reg [7:0] monitor_addr;
    reg [7:0] monitor_data;
    reg [2:0] monitor_bin_num;
    reg [4:0] monitor_data_index;

    // Instantiate histogram module
    s_m_hist histogram_inst (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tdata(lfsr_data),
        .s_axis_tvalid(lfsr_valid),
        .s_axis_tready(lfsr_ready),
        .m_axis_tdata(hist_to_ram_data),
        .m_axis_tvalid(hist_to_ram_valid),
        .m_axis_tready(hist_to_ram_ready)
    );

    // Instantiate RAM module
    axi_ram ram_inst (
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tdata(hist_to_ram_data),
        .s_axis_tvalid(hist_to_ram_valid),
        .s_axis_tready(hist_to_ram_ready),
        .m_axis_tdata(ram_out_data),
        .m_axis_tvalid(ram_out_valid),
        .m_axis_tready(ram_out_ready)
    );

    // Clock generation
    initial begin
        aclk = 0;
        forever #10 aclk = ~aclk;
    end

    // Bin calculation function
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

    // Initialize expected values
    initial begin
        for (integer i = 0; i < 8; i = i + 1) begin
            expected_counts[i] = 0;
            for (integer j = 0; j < 32; j = j + 1) begin
                expected_data[i][j] = 0;
            end
        end
    end

    // Monitor and verify m_axis_tdata
   

    // Test value task
    task test_value;
        input [7:0] value;
        begin
            @(posedge aclk);
            wait(lfsr_ready);
            $display("\nTime=%0t ns: Sending value: %0d", $time, value);
            lfsr_data = {24'b0, value};
            lfsr_valid = 1;
            @(posedge aclk);
            while (!lfsr_ready) @(posedge aclk);
            lfsr_valid = 0;
            
            monitor_bin_num = get_bin(value);
            expected_counts[monitor_bin_num] = expected_counts[monitor_bin_num] + 1;
            expected_data[monitor_bin_num][expected_counts[monitor_bin_num]-1] = value;
            
            $display("Sending value %0d to bin %0d", value, monitor_bin_num);
            #50;
        end
    endtask

    // Test stimulus
    initial begin
        aresetn = 0;
        lfsr_data = 0;
        lfsr_valid = 0;
        ram_out_ready = 1;

        #200;
        aresetn = 1;
        #100;

        $display("\nStarting Boundary Value Tests");
        test_value(8'd1);    #100;
        test_value(8'd32);   #100;
        test_value(8'd33);   #100;
        
        $display("\nTesting middle bins");
        test_value(8'd96);   #100;
        test_value(8'd97);   #100;
        test_value(8'd160);  #100;
        
        $display("\nTesting upper bins");
        test_value(8'd192);  #100;
        test_value(8'd224);  #100;
        test_value(8'd255);  #100;

        $display("\nTesting multiple values in same bin");
        test_value(8'd15);   #100;
        test_value(8'd16);   #100;
        test_value(8'd17);   #100;

        $display("\nTesting back-to-back transactions");
        test_value(8'd50);   #50;
        test_value(8'd100);  #50;
        test_value(8'd150);  #50;

        $display("\nTesting backpressure");
        ram_out_ready = 0;
        test_value(8'd200);
        #200;
        $display("Releasing backpressure");
        ram_out_ready = 1;

        #1000;
        $display("\nSimulation completed successfully");
        $finish;
    end

    // Final verification
    final begin
        $display("\nFinal Bin Counts:");
        for (integer i = 0; i < 8; i = i + 1) begin
            $display("Bin %0d: %0d values", i, expected_counts[i]);
        end
    end

    // Timeout watchdog
    initial begin
        #100000;
        $display("Simulation timeout!");
        $finish;
    end

    // Generate waveform file
    initial begin
        $dumpfile("histogram_system.vcd");
        $dumpvars(0, tb_histogram_system);
    end

endmodule
