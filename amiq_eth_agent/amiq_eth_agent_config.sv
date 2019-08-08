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

`ifndef  AMIQ_ETH_AGENT_CONFIG_SV
`define  AMIQ_ETH_AGENT_CONFIG_SV


//------------------------------------------------------------------------------
// CLASS: amiq_eth_active_agent_config
//
// Set amiq_eth_agent to active mode.
//------------------------------------------------------------------------------

class amiq_eth_active_agent_config extends uvme_agent_config;

  `uvm_object_utils(amiq_eth_active_agent_config)


  //Function: new
  //
  //Constructor

  function new (string name = "amiq_eth_active_agent_config");
    super.new(name);
    this.active = UVM_ACTIVE;
  endfunction : new

endclass : amiq_eth_active_agent_config


//------------------------------------------------------------------------------
// CLASS: amiq_eth_passive_agent_config
//
// Set amiq_eth_agent to passive mode.
//------------------------------------------------------------------------------

class amiq_eth_passive_agent_config extends uvme_agent_config;

  `uvm_object_utils(amiq_eth_passive_agent_config)


  //Function: new
  //
  //Constructor

  function new (string name = "amiq_eth_passive_agent_config");
    super.new(name);
    this.active = UVM_PASSIVE;
  endfunction : new


endclass : amiq_eth_passive_agent_config


`endif //AMIQ_ETH_AGENT_CONFIG_SV
