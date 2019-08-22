///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_agent
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 2019-07-02 04:44:53
//     REVISION: ---
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef  PIN_AGENT_SV
`define  PIN_AGENT_SV

class pin_agent extends uvm_agent;

  pin_agent_config      m_cfg;
  pin_virtual_sequencer m_vseqr;

  pin_driver            m_drv[string];
  pin_sequencer         m_seqr[string];

  pin_monitor           m_mon[string];

  protected pin_driver    m_prot_drv[int unsigned];  //internal drv array. not accessable
  protected pin_sequencer m_prot_seqr[int unsigned];
  protected pin_monitor   m_prot_mon[int unsigned];  //internal mon array. not accessable

  virtual pin_intf        vif;

  `uvm_component_utils_begin(pin_agent)
    `uvm_field_object(m_cfg,   UVM_ALL_ON)
    `uvm_field_aa_object_string(m_drv,   UVM_ALL_ON)
    `uvm_field_aa_object_string(m_seqr,  UVM_ALL_ON)
    `uvm_field_object(m_vseqr,  UVM_ALL_ON)
  `uvm_component_utils_end


  // ******************************************************************************
  // Constructor
  // ******************************************************************************
  function new (string name = "pin_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  // *******************************************************************************
  // build_phase
  // *******************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(pin_agent_config)::get(this, "", "config", this.m_cfg)) begin
      this.m_cfg = pin_agent_config::type_id::create("m_cfg");
      `uvm_info(this.get_type_name(), $psprintf("Create pin_agent_config local with type %s", this.get_type_name()), UVM_LOW)
    end

    if(!uvm_config_db #(virtual pin_intf)::get(this, "", "vif", this.vif)) begin
      `uvm_fatal(this.get_type_name(), $psprintf("Fail to get virtual pin_intf vif from config_db"))
    end

    void'( this.m_cfg.print() );

    this.m_vseqr = pin_virtual_sequencer::type_id::create("m_vseqr", this);

    if(this.m_cfg.pin_cfg.size() > `PIN_MAX) begin
      `uvm_warning(this.get_type_name(), $psprintf("env config pin_cfg num %0d exceed max pin size %0d!", this.m_cfg.pin_cfg.size(),`PIN_MAX))
    end

    foreach(m_cfg.pin_cfg[idx]) begin
      if(this.m_cfg.pin_cfg.size() <= `PIN_MAX) begin
        if(this.m_cfg.pin_cfg[idx] != null) begin
          void'( uvm_config_db #(pin_config)::set(this, {this.m_cfg.pin_cfg[idx].pinName, "_drv"}, "config", this.m_cfg.pin_cfg[idx]) );
          void'( uvm_config_db #(virtual pin_intf)::set(this, {this.m_cfg.pin_cfg[idx].pinName, "_drv"},  "vif",    this.vif) );

          if(this.m_cfg.pin_cfg[idx].pinType == PIN_TYPE_Driver) begin
            this.m_prot_drv[idx] = pin_driver::type_id::create({this.m_cfg.pin_cfg[idx].pinName, "_drv"}, this);
            this.m_prot_drv[idx].set_index(idx);
            this.m_drv[this.m_cfg.pin_cfg[idx].pinName] = this.m_prot_drv[idx];

            this.m_prot_seqr[idx] = pin_sequencer::type_id::create({this.m_cfg.pin_cfg[idx].pinName, "_seqr"}, this);
            this.m_seqr[this.m_cfg.pin_cfg[idx].pinName] = this.m_prot_seqr[idx];
            this.m_vseqr.clk_rst_seqr[this.m_cfg.pin_cfg[idx].pinName] = this.m_prot_seqr[idx];
          end
          else begin
            this.m_prot_mon[idx] = pin_monitor::type_id::create({this.m_cfg.pin_cfg[idx].pinName, "_drv"}, this);
            this.m_prot_mon[idx].set_index(idx);
            this.m_mon[this.m_cfg.pin_cfg[idx].pinName] = this.m_prot_mon[idx];
          end
        end
        else begin
          `uvm_error(this.get_type_name(), $psprintf("m_cfg.pin_cfg[%d] is a null object!",idx))
        end
      end
    end

  endfunction : build_phase


  // *******************************************************************************
  // connect_phase
  // *******************************************************************************
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    foreach(this.m_prot_drv[idx]) begin
      this.m_prot_drv[idx].seq_item_port.connect(this.m_prot_seqr[idx].seq_item_export);
      this.m_prot_drv[idx].rsp_port.connect(this.m_prot_seqr[idx].rsp_export);
    end
  endfunction : connect_phase

endclass : pin_agent

`endif //PIN_AGENT_SV
