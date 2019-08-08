//
//----------------------------------------------------------------------
//   Copyright 2019 Veri5.org
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`ifndef UVME_AGENT_SVH
`define UVME_AGENT_SVH

//------------------------------------------------------------------------------
//
// CLASS: uvme_agent_config
//
// The uvme_agent_config class is the configuration class for uvme_agent.
// Used to control active/passive mode and whether enable function coverage.
// User should extend from this class.
//------------------------------------------------------------------------------

class uvme_agent_config extends uvm_object;

  uvm_active_passive_enum active = UVM_ACTIVE;

  bit enable_func_cov = 0;

  `uvm_object_utils_begin(uvme_agent_config)
    `uvm_field_enum(uvm_active_passive_enum, active, UVM_ALL_ON)
    `uvm_field_int(enable_func_cov, UVM_ALL_ON)
  `uvm_object_utils_end


  //Function: new
  //
  // Constructor

  function new (string name = "uvme_agent_config");
    super.new(name);
  endfunction : new

endclass : uvme_agent_config



//------------------------------------------------------------------------------
//
// CLASS: uvme_coverage
//
// The uvme_coverage class is the class where user should implement function
// function coverage sample.
//------------------------------------------------------------------------------

class uvme_coverage #(type T = uvm_sequence_item ) extends uvm_subscriber#(T);

  typedef uvme_coverage#(T) this_type;

  `uvm_component_param_utils(this_type)

  //Function: new
  //
  // Constructor

  function new (string name = "uvme_coverage", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: write
  //
  // Convert Write function to this.collect_func_cov

  virtual function void write(T t);
    this.collect_func_cov(t);
  endfunction : write


  //Function: collect_func_cov
  //
  // Collect function coverage

  virtual function void collect_func_cov(T tr);
    `uvme_no_child_imp_error("collect_func_cov")
  endfunction : collect_func_cov


endclass : uvme_coverage



//------------------------------------------------------------------------------
//
// CLASS: uvme_monitor
//
// The uvme_monitor class add a analysis port in order to send the trancaction
// received by monitor out to coverage or other components.
//------------------------------------------------------------------------------

class uvme_monitor #(type T = uvm_sequence_item) extends uvm_monitor;
 
  typedef uvme_monitor#(T) this_type;

  uvm_analysis_port#(T) item_collected_port;  //collect data from DUT

  `uvm_component_param_utils(this_type)


  //Function: new
  //
  // Constructor

  function new (string name = "uvme_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  // 
  //Standard UVM build_phase
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.item_collected_port = new("item_collected_port", this);
  endfunction : build_phase


endclass : uvme_monitor



//------------------------------------------------------------------------------
//
// CLASS: uvme_driver
//
// The uvme_driver class is the same as uvm_driver.
// Just allow user can use factory overwrite to change the type of driver.
//------------------------------------------------------------------------------

class uvme_driver #(type REQ = uvm_sequence_item, type RSP = REQ) extends uvm_driver#(REQ, RSP);  

  typedef uvme_driver#(REQ, RSP) this_type;

  `uvm_component_param_utils(this_type)


  //Function: new
  //
  // Constructor

  function new (string name = "uvme_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

endclass : uvme_driver



//------------------------------------------------------------------------------
//
// CLASS: uvme_agent
//
// The uvme_agent class is an agent type which will driver data to DUT and receive
// data from DUT.
//
//------------------------------------------------------------------------------

class uvme_agent #(type T = uvm_sequence_item) extends uvm_agent;

  typedef uvme_agent#(T) this_type;


  //Member: cfg
  //
  //DUT agent configuration. For example, active/passive mode

  uvme_agent_config             cfg;

  uvme_driver#(T)               drv;
  uvm_sequencer#(T)             seqr;


  //Member: mon
  //
  //monitor, receive data from DUT
  
  uvme_monitor#(T)              mon;

  
  //Member: cov
  //
  //coverage collector

  uvme_coverage#(T)             cov;   


  `uvm_component_param_utils_begin(this_type)
    `uvm_field_object(cfg,   UVM_ALL_ON)
    `uvm_field_object(drv,   UVM_ALL_ON)
    `uvm_field_object(mon,   UVM_ALL_ON)
    `uvm_field_object(seqr,  UVM_ALL_ON)
    `uvm_field_object(cov,   UVM_ALL_ON)
  `uvm_component_utils_end


  // Function: new
  //
  // Constructor
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //build_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(uvme_agent_config)::get(this, "", "cfg", this.cfg)) begin
      `uvm_info(this.get_type_name(), $psprintf("[%s] Create uvme_agent_config local", this.get_name()), UVM_DEBUG)
      this.cfg = uvme_agent_config::type_id::create("cfg");
    end

    //void'( this.cfg.print() );

    if (this.cfg.active == UVM_ACTIVE) begin
      this.drv  = uvme_driver#(T)::type_id::create("drv",   this);
      this.seqr = uvm_sequencer#(T)::type_id::create("seqr",  this);
    end

    this.mon = uvme_monitor#(T)::type_id::create("mon",   this);

    if(this.cfg.enable_func_cov) begin
      this.cov = uvme_coverage#(T)::type_id::create("cov", this);
    end

  endfunction : build_phase


  //Function: connect_phase
  //
  //connect_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(this.cfg.active == UVM_ACTIVE) begin
      this.drv.seq_item_port.connect(this.seqr.seq_item_export);
      this.drv.rsp_port.connect(this.seqr.rsp_export);
    end

    if(this.cfg.enable_func_cov) begin
      this.mon.item_collected_port.connect(this.cov.analysis_export);
    end
  endfunction : connect_phase


endclass : uvme_agent


`endif //UVME_AGENT_SVH

