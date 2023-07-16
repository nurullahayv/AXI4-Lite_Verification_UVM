class axi_monitor extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(axi_monitor);

// Virtual Interface
virtual monitor_bfm m_bfm;

//------------------------------------------
// Data Members
//------------------------------------------

//apb_agent_config m_cfg;
  
//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(axi_lite_sequence_item) ax;

//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:

extern function new(string name = "axi_lite_monitor", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void report_phase(uvm_phase phase);

// Proxy Methods:
  
extern function void notify_transaction(axi_lite_sequence_item item);
  
// Helper Methods:

extern function void set_axi_index(int index = 0);
  
endclass: axi_monitor



function axi_monitor::new(string name = "axi_monitor", uvm_component parent = null);
  super.new(name, parent);
  ax = new("ax", this);
endfunction

function void axi_monitor::build_phase(uvm_phase phase);
  `get_config(axi_agent_config, m_cfg, "axi_agent_config")
  m_bfm = m_cfg.mon_bfm;
  m_bfm.proxy = this;
  set_axi_index(m_cfg.axi_index);
  
  // ax = new("ax", this);
endfunction: build_phase

task axi_monitor::run_phase(uvm_phase phase);
  m_bfm.run();
endtask: run_phase

function void axi_monitor::report_phase(uvm_phase phase);
// Might be a good place to do some reporting on no of analysis transactions sent etc
  uvm_report_server server;
  int err_num;
  super.report_phase(phase);

  server = get_report_server();
  err_num = server.get_severity_count(UVM_ERROR);

  if (err_num != 0) begin
    $display("TEST CASE FAILED");
  end
  else begin
    $display("TEST CASE PASSED");
  end

endfunction: report_phase

function void axi_monitor::notify_transaction(axi_lite_sequence_item item);
  ax.write(item);
endfunction : notify_transaction

function void axi_monitor::set_axi_index(int index = 0);
  //m_bfm.axi_index = index;
endfunction : set_axi_index
