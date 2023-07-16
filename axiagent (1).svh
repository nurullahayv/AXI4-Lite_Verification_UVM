

class axi_agent extends uvm_component;

// UVM Factory Registration Macro
//
`uvm_component_utils(axi_agent)

//------------------------------------------
// Data Members
//------------------------------------------
axi_agent_config m_cfg;
  
//------------------------------------------
// Component Members
//------------------------------------------
uvm_analysis_port #(axi_lite_sequence_item) ap;
aximonitor   m_monitor;
axi_sequencer m_sequencer; // !!!
axidriver    m_driver;
//------------------------------------------
// Methods
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "axi_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: axi_agent


function axi_agent::new(string name = "axi_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void axi_agent::build_phase(uvm_phase phase);
  `get_config(axi_agent_config, m_cfg, "axi_agent_config")
  // Monitor is always present
  m_monitor = aximonitor::type_id::create("m_monitor", this);
  m_monitor.m_cfg = m_cfg;
  // Only build the driver and sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver = axidriver::type_id::create("m_driver", this);
    m_driver.m_cfg = m_cfg;
    m_sequencer = axisequencer::type_id::create("m_sequencer", this); // axi sequencer !!! 404
  end
endfunction: build_phase

function void axi_agent::connect_phase(uvm_phase phase);
  ax = m_monitor.ax;
  // Only connect the driver and the sequencer if active
  if(m_cfg.active == UVM_ACTIVE) begin
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  end
endfunction: connect_phase