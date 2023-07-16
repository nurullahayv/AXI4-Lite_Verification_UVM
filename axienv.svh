//
class axi_env extends uvm_env;

  // UVM Factory Registration Macro
  //
  `uvm_component_utils(axi_env)
  //------------------------------------------
  // Data Members
  //------------------------------------------
  axiagent m_axiagent;
  spi_agent m_spi_agent;
  axi_env_config m_cfg;  // !!!
  spi_scoreboard m_scoreboard;

  // Register layer adapter
  reg2apb_adapter m_reg2apb;
  // Register predictor
  uvm_reg_predictor#(apb_seq_item) m_apb2reg_predictor;

  //------------------------------------------
  // Constraints
  //------------------------------------------

  //------------------------------------------
  // Methods
  //------------------------------------------

  // Standard UVM Methods:
  extern function new(string name = "axi_env", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass:axi_env

function axi_env::new(string name = "axi_env", uvm_component parent = null);
  super.new(name, parent);
endfunction

function void axi_env::build_phase(uvm_phase phase);
  if (!uvm_config_db #(axi_env_config)::get(this, "", "axi_env_config", m_cfg))
    `uvm_fatal("CONFIG_LOAD", "Cannot get() configuration axi_env_config from uvm_config_db. Have you set() it?")

  uvm_config_db #(axiagent_config)::set(this, "m_axiagent*",
                                         "axiagent_config",
                                         m_cfg.m_axiagent_cfg);
  m_axiagent = axiagent::type_id::create("m_axiagent", this);

  // Build the register model predictor !!
  // !!!
  // m_apb2reg_predictor = uvm_reg_predictor#(apb_seq_item)::type_id::create("m_apb2reg_predictor", this);
  m_reg2apb = reg2apb_adapter::type_id::create("m_reg2apb");
  // !!
  uvm_config_db #(spi_agent_config)::set(this, "m_spi_agent*",
                                         "spi_agent_config",
                                         m_cfg.m_spi_agent_cfg);
  m_spi_agent = spi_agent::type_id::create("m_spi_agent", this);

  if(m_cfg.has_spi_scoreboard) begin
    m_scoreboard = spi_scoreboard::type_id::create("m_scoreboard", this);
  end
endfunction:build_phase

function void axi_env::connect_phase(uvm_phase phase);

  // Only set up register sequencer layering if the spi_rb is the top block
  // If it isn't, then the top level environment will set up the correct sequencer
  // and predictor
  if(m_cfg.spi_rb.get_parent() == null) begin
    if(m_cfg.m_axiagent_cfg.active == UVM_ACTIVE) begin
      m_cfg.spi_rb.spi_reg_block_map.set_sequencer(m_axiagent.m_sequencer, m_reg2apb);
    end

    //
    // Register prediction part:
    //
    // Replacing implicit register model prediction with explicit prediction
    // based on APB bus activity observed by the APB agent monitor
    // Set the predictor map:
    m_apb2reg_predictor.map = m_cfg.spi_rb.spi_reg_block_map;
    // Set the predictor adapter:
    m_apb2reg_predictor.adapter = m_reg2apb;
    // Disable the register models auto-prediction
    m_cfg.spi_rb.spi_reg_block_map.set_auto_predict(0);
    // Connect the predictor to the bus agent monitor analysis port
    m_axiagent.ax.connect(m_apb2reg_predictor.bus_in);
  end

  if(m_cfg.has_spi_scoreboard) begin
    m_spi_agent.ap.connect(m_scoreboard.spi.analysis_export);
    m_scoreboard.spi_rb = m_cfg.spi_rb;
  end

endfunction: connect_phase