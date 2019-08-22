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

  bit create_drv;

  bit enable_func_cov = 0;

  `uvm_object_utils_begin(uvme_agent_config)
    `uvm_field_int(create_drv, UVM_ALL_ON)
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
// CLASS: uvme_agent_env_config
//
// The uvme_agent_env_config class is the configuration used by uvme_agent_env
// to controll how many passive and active uvme_agent will be instanced.
//------------------------------------------------------------------------------

class uvme_agent_env_config extends uvm_object;

  int unsigned active_num = 0;   //active agent number
  int unsigned passive_num = 0;   //passvie agent number

  uvme_agent_config active_cfg[int unsigned];
  uvme_agent_config passive_cfg[int unsigned];

  `uvm_object_utils_begin(uvme_agent_env_config)
    `uvm_field_int(active_num, UVM_ALL_ON)
    `uvm_field_int(passive_num, UVM_ALL_ON)
  `uvm_object_utils_end

  //Function: new
  //
  // Constructor

  function new (string name = "uvme_agent_env_config");
    super.new(name);
  endfunction : new

endclass : uvme_agent_env_config



//------------------------------------------------------------------------------
//
// CLASS: uvme_agent_env
//
// The uvme_agent_env class is the subenv which instance many uvme_agent.
// Both passive and active uvme_agent can be instanced in uvme_agent_env.
//------------------------------------------------------------------------------

class uvme_agent_env #(type AgentT = uvm_component, type VirSeqrT = uvm_component) extends uvm_agent;

  typedef uvme_agent_env#(AgentT, VirSeqrT) this_type;

  //Member: cfg
  //
  //agent_env configuration. top level config

  uvme_agent_env_config   base_cfg;


  //Member: vir_seqr
  //
  //virtual sequencer class, encap all sequence

  VirSeqrT                     vir_seqr;


  //Member: active_agent
  //
  //array to save active agent handle

  AgentT                       active_agent[];


  //Member: passive_agent
  //
  //array to save passive agent handle

  AgentT                       passive_agent[];


  `uvm_component_param_utils_begin(this_type)
    `uvm_field_object(base_cfg,   UVM_ALL_ON)
    `uvm_field_array_object(active_agent,   UVM_ALL_ON)
    `uvm_field_array_object(passive_agent,   UVM_ALL_ON)
  `uvm_component_utils_end


  // Function: new
  //
  // Constructor

  function new(string name = "uvme_agent_env", uvm_component parent);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //build_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(this.base_cfg == null) begin //user can create base_cfg before super.build_phase
      if(!uvm_config_db #(uvme_agent_env_config)::get(this, "", "cfg", this.base_cfg)) begin
        `uvm_info(this.get_type_name(), $psprintf("[%s] Create uvme_agent_env_config local", this.get_name()), UVM_DEBUG)
        this.base_cfg = uvme_agent_env_config::type_id::create("cfg");
      end
	end

    //void'( this.base_cfg.print() );

    this.vir_seqr = VirSeqrT::type_id::create("vir_seqr", this);

    if(this.base_cfg.active_num > 0) begin
      this.active_agent = new[this.base_cfg.active_num];
      this.vir_seqr.active_seqr = new[this.base_cfg.active_num];
    end

    if(this.base_cfg.passive_num > 0) begin
      this.passive_agent = new[this.base_cfg.passive_num];
      this.vir_seqr.passive_seqr = new[this.base_cfg.passive_num];
    end

    foreach(this.active_agent[idx]) begin
      string agent_name = uvme_pkg::name_in_array("active_agent", idx);
      if(this.base_cfg.active_cfg.exists(idx)) begin
        uvm_config_db#(uvme_agent_config)::set(this, agent_name, "cfg", this.base_cfg.active_cfg[idx] );
      end
      this.active_agent[idx] = AgentT::type_id::create(agent_name, this);
    end

    foreach(this.passive_agent[idx]) begin
      string agent_name = uvme_pkg::name_in_array("passive_agent", idx);
      if(this.base_cfg.passive_cfg.exists(idx)) begin
        uvm_config_db#(uvme_agent_config)::set(this, agent_name, "cfg", this.base_cfg.active_cfg[idx] );
      end
      this.passive_agent[idx] = AgentT::type_id::create(agent_name, this);
    end

  endfunction : build_phase


  //Function: connect_phase
  //
  //standard UVM connect_phase
  //Connect agent's sequence to virtual sequence 

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    foreach(this.active_agent[idx]) begin
      `uvme_cast(this.vir_seqr.active_seqr[idx], this.active_agent[idx].seqr, error)
    end

    foreach(this.passive_agent[idx]) begin
      `uvme_cast(this.vir_seqr.active_seqr[idx], this.passive_agent[idx].seqr, error)
    end

  endfunction : connect_phase


endclass : uvme_agent_env


`endif //UVME_AGENT_SVH

