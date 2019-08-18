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

`ifndef  VERI5_ETH_AGENT_SV
`define  VERI5_ETH_AGENT_SV


//------------------------------------------------------------------------------
// CLASS: veri5_eth_agent
//
// Top agent class which can drive and receive data from DUT.
//------------------------------------------------------------------------------


class veri5_eth_agent extends veri5_eth_packet_agent_base;

  veri5_eth_driver driver;
  veri5_eth_monitor monitor;

  `uvm_component_utils(veri5_eth_agent)

  //Function: new
  //
  // Constructor

  function new (string name = "veri5_eth_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase function
  //Use factory overwrite to create veri5_eth_driver and monitor

  virtual function void build_phase(uvm_phase phase);
    set_type_override_by_type(  veri5_eth_packet_driver_base::get_type(), veri5_eth_driver::get_type());
    set_type_override_by_type( veri5_eth_packet_monitor_base::get_type(), veri5_eth_monitor::get_type());

    super.build_phase(phase);	

    if(this.drv != null) begin
      `uvme_cast(driver, this.drv, fatal);
    end

    if(this.mon != null) begin
      `uvme_cast(monitor, this.mon, fatal);
    end	
  endfunction : build_phase


endclass : veri5_eth_agent




//------------------------------------------------------------------------------
// CLASS: veri5_eth_active_agent
//
// Top active agent class which drive data to DUT.
//------------------------------------------------------------------------------

class veri5_eth_active_agent extends veri5_eth_agent;

  `uvm_component_utils(veri5_eth_active_agent)


  //Function: new
  //
  // Constructor

  function new (string name = "veri5_eth_active_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase

  virtual function void build_phase(uvm_phase phase);
    set_type_override_by_type(  uvme_agent_config::get_type(), veri5_eth_active_agent_config::get_type());
    super.build_phase(phase);
  endfunction : build_phase

endclass : veri5_eth_active_agent



//------------------------------------------------------------------------------
// CLASS: veri5_eth_passive_agent
//
// Top passie agent class which receie data from DUT.
//------------------------------------------------------------------------------

class veri5_eth_passive_agent extends veri5_eth_agent;

  `uvm_component_utils(veri5_eth_passive_agent)

  //Function: new
  //
  // Constructor

  function new (string name = "veri5_eth_passive_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase

  virtual function void build_phase(uvm_phase phase);
    set_type_override_by_type(  uvme_agent_config::get_type(), veri5_eth_passive_agent_config::get_type());
    super.build_phase(phase);
  endfunction : build_phase

endclass : veri5_eth_passive_agent



`endif //VERI5_ETH_AGENT_SV
