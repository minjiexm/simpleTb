//-----------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------

`ifndef AMIQ_ETH_AGENT_SUBENV_SV
`define AMIQ_ETH_AGENT_SUBENV_SV

//------------------------------------------------------------------------------
//
// CLASS: amiq_eth_agent_subenv
//
// amiq_eth_agent_subenv is a simple behavior model of switch.
// It will protend a DUT in this simple demo.
//
// amiq_eth_agent_subenv current only support mac address lookup function.
// It can forwad the packet to the right port and also havs simple flood feature.
// User can use +AMIQ_ETH_AGENT_SUBENV::PORT_NUM=4 to define the number of ports of the
// amiq_eth_agent_subenv, by default the port_num is 4.
//
// All ports type are uvme_layer_input and uvme_layer_output.
// User should connect those ports to DUT agents.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// CLASS: amiq_eth_agent_subenv_config
//
// amiq_eth_agent_subenv_config will config amiq_eth_agent_subenv with 4 active and 4 passive agents.
//------------------------------------------------------------------------------

class amiq_eth_agent_subenv_config extends uvme_agent_env_config;

  `uvm_object_utils(amiq_eth_agent_subenv_config)

  //Function: new
  //
  // Constructor

  function new (string name = "amiq_eth_agent_subenv_config");
    super.new(name);
    this.active_num  = 4;   //active agent number
    this.passive_num = 4;   //passvie agent number
  endfunction : new

endclass : amiq_eth_agent_subenv_config


//------------------------------------------------------------------------------
// CLASS: amiq_eth_agent_subenv
//
// amiq_eth_agent_subenv will instance 4 active and 4 passive agents.
//------------------------------------------------------------------------------
class amiq_eth_agent_subenv extends amiq_eth_packet_agent_env_base;

  amiq_eth_agent_subenv_config    cfg;

  amiq_eth_agent active_pkt_agent[];
  amiq_eth_agent passive_pkt_agent[];

  //uvm factory declare macro
  `uvm_component_utils_begin(amiq_eth_agent_subenv)
    `uvm_field_object(cfg, UVM_ALL_ON)
  `uvm_component_utils_end


  //Function: new
  //
  // Constructor
  //

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase implement.
  //Create config/in&out ports/mac_table/auto_init
  //

  virtual function void build_phase(uvm_phase phase);
    set_type_override_by_type(uvme_agent_env_config::get_type(), amiq_eth_agent_subenv_config::get_type());
  
    factory.set_inst_override_by_type(amiq_eth_packet_agent_base::get_type(), amiq_eth_active_agent::get_type(), {this.get_full_name(), ".", "active_agent*"});
    factory.set_inst_override_by_type(amiq_eth_packet_agent_base::get_type(), amiq_eth_passive_agent::get_type(), {this.get_full_name(), ".", "passive_agent*"});

    super.build_phase(phase);

    `uvme_cast(this.cfg, this.base_cfg, fatal)

    `uvme_cast_array(this.active_pkt_agent, this.active_agent, fatal)
    `uvme_cast_array(this.passive_pkt_agent, this.passive_agent, fatal)

  endfunction : build_phase


endclass : amiq_eth_agent_subenv


`endif // AMIQ_ETH_AGENT_SUBENV_SV
