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

`ifndef UVME_AGENT_DEFINES_SVH
`define UVME_AGENT_DEFINES_SVH

//-----------------------------------------------------------------------------
// Title: uvme_agent class define Macros
//
// These macros are used to define standard structure uvm_agent
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// MACRO: `uvme_coverage
//
//| `uvme_coverage(TransType)
//
// The uvme_coverage class is the class where user should implement function
// function coverage sample.
//-----------------------------------------------------------------------------
`define uvme_coverage(txnType) \
class txnType``_coverage_base extends uvm_subscriber#(txnType); \
\
  `uvm_component_utils(txnType``_coverage_base) \
\
  function new (string name = `"txnType``_coverage_base`", uvm_component parent = null); \
    super.new(name, parent); \
  endfunction : new \
\
 virtual function void write(txnType t); \
    this.collect_func_cov(t); \
  endfunction : write \
\
  virtual function void collect_func_cov(txnType tr); \
    `uvme_no_child_imp_error(`"collect_func_cov`") \
  endfunction : collect_func_cov \
\
endclass : txnType``_coverage_base



//-----------------------------------------------------------------------------
// MACRO: `uvme_monitor
//
//| `uvme_monitor(TransType)
//
// The uvme_monitor class add a analysis port in order to send the trancaction
// received by monitor out to coverage or other components.
//------------------------------------------------------------------------------
`define uvme_monitor(txnType) \
class txnType``_monitor_base extends uvm_monitor; \
\
  uvm_analysis_port#(txnType) item_collected_port; \
\
  `uvm_component_utils(txnType``_monitor_base) \
\
  function new (string name = `"txnType``_monitor_base`", uvm_component parent = null); \
    super.new(name, parent); \
  endfunction : new \
\
  virtual function void build_phase(uvm_phase phase); \
    super.build_phase(phase); \
    this.item_collected_port = new(`"item_collected_port`", this); \
  endfunction : build_phase \
\
endclass : txnType``_monitor_base


//-----------------------------------------------------------------------------
// MACRO: `uvme_driver
//
//| `uvme_driver(TransType)
//------------------------------------------------------------------------------
// The uvme_driver class is the same as uvm_driver.
// Just allow user can use factory overwrite to change the type of driver.
//------------------------------------------------------------------------------
`define uvme_driver(txnType) \
class txnType``_driver_base extends uvm_driver#(txnType, txnType);  \
\
  `uvm_component_utils(txnType``_driver_base) \
\
  function new (string name = `"txnType``_driver_base`", uvm_component parent = null); \
    super.new(name, parent); \
  endfunction : new \
\
endclass : txnType``_driver_base



//-----------------------------------------------------------------------------
// MACRO: `uvme_agent
//
//| `uvme_agent(TransType)
//------------------------------------------------------------------------------
// The uvme_agent class is an agent type which will driver data to DUT and receive
// data from DUT.
//
//------------------------------------------------------------------------------
`define uvme_agent(txnType) \
`uvme_coverage(txnType) \
`uvme_monitor(txnType) \
`uvme_driver(txnType) \
\
class txnType``_agent_base extends uvm_agent; \
\
  uvme_agent_config        base_cfg;  \
  txnType``_driver_base         drv;  \
  uvm_sequencer#(txnType)       seqr; \
  txnType``_monitor_base        mon;  \
  txnType``_coverage_base       cov;  \
\
  `uvm_component_utils_begin(txnType``_agent_base) \
    `uvm_field_object(base_cfg,   UVM_ALL_ON) \
    `uvm_field_object(drv,        UVM_ALL_ON) \
    `uvm_field_object(mon,        UVM_ALL_ON) \
    `uvm_field_object(seqr,       UVM_ALL_ON) \
    `uvm_field_object(cov,        UVM_ALL_ON) \
  `uvm_component_utils_end \
\
  function new(string name = `"txnType``_agent_base`", uvm_component parent); \
    super.new(name, parent); \
  endfunction : new \
\
  virtual function void build_phase(uvm_phase phase); \
    super.build_phase(phase); \
\
    if(this.base_cfg == null) begin \
      if(!uvm_config_db #(uvme_agent_config)::get(this, `"`", `"cfg`", this.base_cfg)) begin \
        `uvm_info(this.get_type_name(), $psprintf(`"[%s] Create default uvme_agent_config local`", this.get_name()), UVM_DEBUG) \
        this.base_cfg = uvme_agent_config::type_id::create(`"base_cfg`"); \
      end \
	end \
\
    if (this.base_cfg.create_drv == 1) begin \
      this.drv  = txnType``_driver_base::type_id::create(`"drv`",   this); \
      this.seqr = uvm_sequencer#(txnType)::type_id::create(`"seqr`",  this); \
    end \
\
    this.mon = txnType``_monitor_base::type_id::create(`"mon`",   this); \
\
    if(this.base_cfg.enable_func_cov) begin \
      this.cov = txnType``_coverage_base::type_id::create(`"cov`", this); \
    end \
\
  endfunction : build_phase \
\
  virtual function void connect_phase(uvm_phase phase); \
    super.connect_phase(phase); \
\
    if(this.base_cfg.create_drv == 1) begin \
      this.drv.seq_item_port.connect(this.seqr.seq_item_export); \
      this.drv.rsp_port.connect(this.seqr.rsp_export); \
    end \
\
    if(this.base_cfg.enable_func_cov) begin \
      this.mon.item_collected_port.connect(this.cov.analysis_export); \
    end \
  endfunction : connect_phase \
\
endclass : txnType``_agent_base


//------------------------------------------------------------------------------
// CLASS: uvme_agent_virtual_sequencer
//
// The uvme_agent_env_config class is the configuration used by uvme_agent_env
// to controll how many passive and active uvme_agent will be instanced.
//------------------------------------------------------------------------------
`define uvme_agent_vir_seq(txnType) \
class txnType``_agent_virtual_sequencer_base extends uvm_sequencer#(txnType); \
\
  typedef uvm_sequencer#(txnType) seqr_type; \
\
  seqr_type active_seqr[]; \
  seqr_type passive_seqr[]; \
\
  `uvm_component_utils_begin(txnType``_agent_virtual_sequencer_base) \
    `uvm_field_array_object(active_seqr, UVM_ALL_ON) \
    `uvm_field_array_object(passive_seqr, UVM_ALL_ON) \
  `uvm_component_utils_end \
\
  function new (string name = `"txnType``_agent_virtual_sequencer_base`", uvm_component parent); \
    super.new(name, parent); \
  endfunction : new \
\
endclass : txnType``_agent_virtual_sequencer_base


//-----------------------------------------------------------------------------
// MACRO: `uvme_driver
//
//| `uvme_driver(TransType)
//------------------------------------------------------------------------------
// The uvme_agent class is an agent type which will driver data to DUT and receive
// data from DUT.
//
//------------------------------------------------------------------------------
`define uvme_agent_base_pkg(txnType) \
`uvme_agent(txnType) \
`uvme_agent_vir_seq(txnType) \
\
class txnType``_agent_env_base extends uvme_agent_env#(txnType``_agent_base, txnType``_agent_virtual_sequencer_base); \
\
  `uvm_component_utils(txnType``_agent_env_base) \
\
  function new (string name = `"txnType``_agent_env_base`", uvm_component parent); \
    super.new(name, parent); \
  endfunction : new \
\
endclass : txnType``_agent_env_base

`endif //UVME_AGENT_DEFINES_SVH

