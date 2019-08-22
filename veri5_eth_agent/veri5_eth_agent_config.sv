//
//------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------

`ifndef  VERI5_ETH_AGENT_CONFIG_SV
`define  VERI5_ETH_AGENT_CONFIG_SV


//------------------------------------------------------------------------------
// CLASS: veri5_eth_agent_config
//
// veri5_eth_agent_config is the config class for veri5_eth_agent.
// It extends from uvme_agent_config.
// Add agent type property
//------------------------------------------------------------------------------

class veri5_eth_agent_config extends uvme_agent_config;

  uvm_active_passive_enum active;
  veri5_eth_agent_type_e agent_type;

  `uvm_object_utils_begin(veri5_eth_agent_config)
    `uvm_field_enum(uvm_active_passive_enum, active, UVM_ALL_ON)
    `uvm_field_enum(veri5_eth_agent_type_e, agent_type, UVM_ALL_ON)
  `uvm_object_utils_end

  //Function: new
  //
  //Constructor

  function new (string name = "veri5_eth_agent_config");
    super.new(name);
  endfunction : new

  virtual function void setup();
    if(this.agent_type == VERI5_ETH_AGENT_TYPE_Transmit && this.active == UVM_ACTIVE)
	  this.create_drv = 1;
	else
	  this.create_drv = 0;
  endfunction : setup

endclass : veri5_eth_agent_config


//------------------------------------------------------------------------------
// CLASS: veri5_eth_active_transmit_agent_config
//
// Set veri5_eth_agent to active transmit mode.
//------------------------------------------------------------------------------

class veri5_eth_active_transmit_agent_config extends veri5_eth_agent_config;

  `uvm_object_utils(veri5_eth_active_transmit_agent_config)


  //Function: new
  //
  //Constructor

  function new (string name = "veri5_eth_active_transmit_agent_config");
    super.new(name);
    this.active = UVM_ACTIVE;
	this.agent_type = VERI5_ETH_AGENT_TYPE_Transmit;
	this.setup();
  endfunction : new

endclass : veri5_eth_active_transmit_agent_config


//------------------------------------------------------------------------------
// CLASS: veri5_eth_active_receive_agent_config
//
// Set veri5_eth_agent to active receive mode.
//------------------------------------------------------------------------------

class veri5_eth_active_receive_agent_config extends veri5_eth_agent_config;

  `uvm_object_utils(veri5_eth_active_receive_agent_config)

  //Function: new
  //
  //Constructor

  function new (string name = "veri5_eth_active_receive_agent_config");
    super.new(name);
    this.active = UVM_ACTIVE;
	this.agent_type = VERI5_ETH_AGENT_TYPE_Receive;
	this.setup();
  endfunction : new

endclass : veri5_eth_active_receive_agent_config


//------------------------------------------------------------------------------
// CLASS: veri5_eth_passive_agent_config
//
// Set veri5_eth_agent to passive mode.
//------------------------------------------------------------------------------

class veri5_eth_passive_agent_config extends veri5_eth_agent_config;

  `uvm_object_utils(veri5_eth_passive_agent_config)


  //Function: new
  //
  //Constructor

  function new (string name = "veri5_eth_passive_agent_config");
    super.new(name);
    this.active = UVM_PASSIVE;
	this.setup();
  endfunction : new


endclass : veri5_eth_passive_agent_config


`endif //VERI5_ETH_AGENT_CONFIG_SV
