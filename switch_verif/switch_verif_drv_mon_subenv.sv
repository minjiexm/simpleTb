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

`ifndef SWITCH_VERIF_DRV_MON_SUBENV_SV
`define SWITCH_VERIF_DRV_MON_SUBENV_SV

//------------------------------------------------------------------------------
//
// CLASS: switch_verif_drv_mon_subenv
//
// switch_verif_drv_mon_subenv is a simple behavior model of switch.
// It will protend a DUT in this simple demo.
//
// switch_verif_drv_mon_subenv current only support mac address lookup function.
// It can forwad the packet to the right port and also havs simple flood feature.
// User can use +SWITCH_VERIF_DRV_MON_SUBENV::PORT_NUM=4 to define the number of ports of the
// switch_verif_drv_mon_subenv, by default the port_num is 4.
//
// All ports type are uvme_layer_input and uvme_layer_output.
// User should connect those ports to DUT agents.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// CLASS: switch_verif_drv_mon_subenv
//
// switch_verif_drv_mon_subenv will instance 4 active and 4 passive agents.
//------------------------------------------------------------------------------
class switch_verif_drv_mon_subenv extends veri5_eth_packet_agent_env_base;

  int unsigned port_num = 4;
  
  veri5_eth_agent pkt_transmitter[];
  veri5_eth_agent pkt_receiver[];

  //uvm factory declare macro
  `uvm_component_utils(switch_verif_drv_mon_subenv)


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
    this.base_cfg = uvme_agent_env_config::type_id::create("base_cfg");
	
    if( uvm_config_db#(int)::get(this, "", "port_size", this.port_num)) begin
	  this.base_cfg.active_num = 2*this.port_num;
	  this.base_cfg.passive_num = 0;
	end

    for(int idx = 0; idx < this.port_num; idx++) begin
	  string active_agent_name = {this.get_full_name(), ".", uvme_pkg::name_in_array("active_agent", idx)};
      factory.set_inst_override_by_type(veri5_eth_packet_agent_base::get_type(), veri5_eth_active_transmit_agent::get_type(), active_agent_name);
	end

    for(int idx = 0; idx < this.port_num; idx++) begin
	  string active_agent_name = {this.get_full_name(), ".", uvme_pkg::name_in_array("active_agent", idx+this.port_num)};
      factory.set_inst_override_by_type(veri5_eth_packet_agent_base::get_type(), veri5_eth_active_receive_agent::get_type(), active_agent_name);
	end

    super.build_phase(phase);

    this.pkt_transmitter = new[this.port_num];
    for(int idx = 0; idx < this.port_num; idx++) begin
	  `uvme_cast(this.pkt_transmitter[idx], this.active_agent[idx], error)
	end

    this.pkt_receiver = new[this.port_num];
    for(int idx = 0; idx < this.port_num; idx++) begin
	  `uvme_cast(this.pkt_receiver[idx], this.active_agent[idx+this.port_num], error)
	end

  endfunction : build_phase


endclass : switch_verif_drv_mon_subenv


`endif // SWITCH_VERIF_DRV_MON_SUBENV_SV
