interface axi4_lite_bfm (  axi_bit,
  
  input         PCLK,
  input         PRESETn,
  input         read_or_write;

  input logic [axi_bit-1:0] ARADDR;
  input logic [3:0] ARCACHE;
  input logic [2:0] ARPROT;
  input logic ARVALID;
  output logic ARREADY;

  output logic [axi_bit-1:0] RDATA;
  output logic RRESP; // response sig 
  output logic RVALID;
  input logic RREADY;

  input logic [axi_bit-1:0] AWADDR;
  input logic [3:0] AWCACHE;
  input logic [2:0] AWPROT;
  input logic AWVALID;
  output logic AWREADY;

  input logic [axi_bit-1:0] WDATA;
  input logic [((axi_bit/8)-1):0] WSTRB;
  output logic WALID;
  output logic WREADY;

  output logic BRESP;
  output logic BVALID;
  input logic BREADY;
 
  );


    function void clear_signs();

        ARADDR <= 0;
        ARCACHE <= 0;
        ARPROT <= 0;
        ARVALID <= 0;
        ARREADY <= 0;
        RDATA <= 0;
        RRESP <= 0;
        RVALID <= 0;
        RREADY <= 0;
        AWADDR <= 0;
        AWCACHE <= 0;
        AWPROT <= 0;
        AWVALID <= 0;
        AWREADY <= 0;
        WDATA <= 0;
        WSTRB <= 0;
        WALID <= 0;
        WREADY <= 0;
        BRESP <= 0;
        BVALID <= 0;
        BREADY <= 0;

    endfunction : clear_sigs



    task drive (axi_lite_sequence_item req);

        if ( read_or_write == 0 ) begin
        
            @(posedge M_AXI_ACLK) begin
            ARADDR <= req.ARADDR;
            ARVALID <= req.ARVALID;
            RREADY <= req.RREADY;
            end

            while (!ARREADY)
                @(posedge PCLK);
            ARADDR <= 32'b0000000;
            ARVALID <= 1'b0;
            req.RDATA <= RDATA;

            while (!RVALID)
                @(posedge PCLK);
            RREADY = 1'b0;

            while (!RRESP)
                @(posedge PCLK);
            AWADDR <= 4'b0000;
            AWVALID <= 1'b1;
            WDATA <= 4'b0000;
            WVALID <= 1'b1;
            BREADY <= 1'b1 ;
            ARADDR <= 4'b0000;
            ARVALID <= 1'b1;
            RREADY <= 1'b1;            
        end

        else ( read_or_write == "0" ) begin
            
            @(posedge M_AXI_ACLK) begin 
            fork 
                begin 
                        begin
                            AWADDR <= req.AWADDR;
                            AWVALID <= req.AWVALID;
                        end

                        while (!AWREADY)
                            @(posedge PCLK);
                            AWVALID = 1'b0;
                            AWADDR = 32'h00000000;                        
                end

                begin 
                        begin
                            WDATA <= req.AWADDR;
                            WVALID <= req.AWVALID;
                        end
                        
                        while (!WREADY)
                            @(posedge PCLK);
                            WVALID = 1'b0;
                            WDATA = 32'h00000000;

                end     

            join
          
            while (!BVALID)
                @(posedge PCLK);
                BREADY = 1'b0 ;

            while (!BRESP)
                @(posedge PCLK);
                AWADDR = 4'b0000;
                AWVALID = 1'b1;
                WDATA = 4'b0000;
                WVALID = 1'b1;
                BREADY = 1'b1 ;
                ARADDR = 4'b0000;
                ARVALID = 1'b1;
                RREADY = 1'b1;       
   
            end
        end
    
    endtask : drive

endinterface: axi4_lite_bfm