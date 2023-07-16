class axi_lite_sequence_item#(parameter int axi_bit = 32) extends uvm_sequence_item;

    `uvm_object_utils(axi_lite_sequence_item)
    
    function new (string name = "");
        
        super.new(name);

    endfunction
    
    //payload;
    //configurations;
    rand bit [axi_bit-1:0] addr_interval_top; // constraint condition: ???
    rand bit [axi_bit-1:0] addr_interval_base;// constraint condition: ???

    //interface signals 
    //global signals
    //rand int aclk;
    //rand int aresetn;

    //read Address  channel
    rand bit [axi_bit-1:0] ARADDR;
    rand bit [3:0] ARCACHE;
    rand bit [2:0] ARPROT;
    rand bit ARVALID;
    bit ARREADY;

    //read data channel
    bit [axi_bit-1:0] RDATA;
    bit RRESP; // response sig 
    bit RVALID;
    rand bit RREADY;


    //Write Address Channel
    rand bit [axi_bit-1:0] AWADDR;
    rand bit [3:0] AWCACHE;
    rand bit [2:0] AWPROT;
    rand bit AWVALID;
    bit AWREADY;

    //Write Data Channel
    rand bit [axi_bit-1:0] WDATA;
    rand bit [((axi_bit/8)-1):0] WSTRB;
    bit WALID;
    bit WREADY;


    //Write Response Channel
    bit BRESP;
    bit BVALID;
    rand bit BREADY;

    // axi 32 or 64

    constraint addresses_c {
        AWADDR >= addr_interval_base && addr <= (addr_interval_top - 4) && (addr % 4) == 0;
        ARADDR >= addr_interval_base && addr <= (addr_interval_top - 4) && (addr % 4) == 0;
    }
    
    extern function string convert2string();
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function void do_copy(uvm_object rhs);

endclass

// ------------------------------------------------------------------------------
function string axi_lite_sequence_item::convert2string();
    
    return $sformatf("addr_interval_top = %0H, addr_interval_base= %0hgh, ARADDR= %0h,
    ARCACHE= %0h, ARPROT= %0h, ARVALID= %0h, ARREADY= %0h, RDATA,RRESP= %0h, RVALID= %0h,
    RREADY= %0h, AWADDR= %0h, AWCACHE= %0h, AWPROT= %0h, AWVALID= %0h, AWREADY= %0h, WDATA= %0h,
    WSTRB= %0h, WALID= %0h, WREADY= %0h, BRESP= %0h, BVALID= %0h, BREADY= %0h",
    addr_interval_top,addr_interval_base,,ARADDR,ARCACHE,ARPROT,ARVALID,ARREADY,RDATA,RRESP,
    RVALID,RREADY,AWADDR,AWCACHE,AWPROT,AWVALID,AWREADY,WDATA,WSTRB,WALID,WREADY,BRESP,BVALID,
    BREADY);

endfunction

function void axi_lite_sequence_item::do_copy(uvm_object rhs);
    
    axi_lite_sequence_item RHS;
    super.do_copy(rhs);
    $cast(RHS, rhs);
    
    addr_interval_top = RHS.addr_interval_top;
    addr_interval_base = RHS.addr_interval_base;
    ARADDR = RHS.ARADDR;
    ARCACHE = RHS.ARCACHE;
    ARPROT = RHS.ARPROT;
    ARVALID = RHS.ARVALID;
    ARREADY = RHS.ARREADY;
    RDATA = RHS.RDATA;
    RRESP = RHS.RRESP;
    RVALID = RHS.RVALID;
    RREADY = RHS.RREADY;
    AWADDR = RHS.AWADDR;
    AWCACHE = RHS.AWCACHE;
    AWPROT = RHS.AWPROT;
    AWVALID = RHS.AWVALID;
    AWREADY = RHS.AWREADY;
    WDATA = RHS.WDATA;
    WSTRB = RHS.WSTRB;
    WALID = RHS.WALID;
    WREADY = RHS.WREADY;
    BRESP = RHS.BRESP;
    BVALID = RHS.BVALID;
    BREADY = RHS.BREADY;

endfunction


function bit axi_lite_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);

    axi_lite_sequence_item RHS;
    bit same;
    same = super.do_compare(rhs, comparer);
    $cast(RHS, rhs);
    same = && (BREADY = RHS.BREADY) 
    && (BVALID = RHS.BVALID) 
    && (BRESP = RHS.BRESP) 
    && (WREADY = RHS.WREADY) 
    && (WALID = RHS.WALID) 
    && (WSTRB = RHS.WSTRB) 
    && (WDATA = RHS.WDATA) 
    && (AWREADY = RHS.AWREADY) 
    && (AWVALID = RHS.AWVALID) 
    && (AWPROT = RHS.AWPROT) 
    && (AWCACHE = RHS.AWCACHE) 
    && (AWADDR = RHS.AWADDR) 
    && (RREADY = RHS.RREADY) 
    && (RVALID = RHS.RVALID) 
    && (RRESP = RHS.RRESP) 
    && (RDATA = RHS.RDATA) 
    && (ARREADY = RHS.ARREADY) 
    && (ARVALID = RHS.ARVALID) 
    && (ARPROT = RHS.ARPROT) 
    && (ARCACHE = RHS.ARCACHE) 
    && (ARADDR = RHS.ARADDR)     
    && (addr_interval_top == RHS.addr_interval_top) 
    && (addr_interval_base == RHS.addr_interval_base) 
    && same;

    return same;
    
endfunction