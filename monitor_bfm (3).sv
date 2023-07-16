
interface axi4lite_monitor_bfm (
  input         PCLK,
  input         PRESETn,
  input         read_or_write;

  input logic [axi_bit-1:0] ARADDR;
  input logic [3:0] ARCACHE;
  input logic [2:0] ARPROT;
  input logic ARVALID;
  input logic ARREADY;

  input logic [axi_bit-1:0] RDATA;
  input logic RRESP; // response sig 
  input logic RVALID;
  input logic RREADY;

  input logic [axi_bit-1:0] AWADDR;
  input logic [3:0] AWCACHE;
  input logic [2:0] AWPROT;
  input logic AWVALID;
  input logic AWREADY;

  input logic [axi_bit-1:0] WDATA;
  input logic [((axi_bit/8)-1):0] WSTRB;
  input logic WALID;
  input logic WREADY;

  input logic BRESP;
  input logic BVALID;
  input logic BREADY;
);


//------------------------------------------
// Data Members
//------------------------------------------

apb_monitor proxy;
  
//------------------------------------------
// Component Members
//------------------------------------------

//------------------------------------------
// Methods
//------------------------------------------

// BFM Methods:
  
task run();
  axi_lite_sequence_item item;
  axi_lite_sequence_item cloned_item;
  
  item = axi_lite_sequence_item::type_id::create("item");

  forever begin

    @(posedge PCLK);
    if(read_or_write == 0)
        if(RVALID)
          begin
            item.ADDR = ARADDR
            item.DATA = RDATA
          end
        if(RVALID)
          begin
            item.RESPONSE = RRESP
          end
    else(read_or_write == 1)
        fork
            begin
              if(AWREADY)
                item.ADDR = AWADDR
            end
            begin
              if(WREADY)
                item.DATA = WDATA
            end
        join

        if(BVALID)
          begin
          item.RESPONSE = BRESP
          end
        $cast(cloned_item, item.clone());
        proxy.notify_transaction(cloned_item);
      end
endtask: run

endinterface: axi4lite_monitor_bfm