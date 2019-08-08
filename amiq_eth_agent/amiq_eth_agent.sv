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

`ifndef  AMIQ_ETH_AGENT_SV
`define  AMIQ_ETH_AGENT_SV


//------------------------------------------------------------------------------
// CLASS: amiq_eth_agent
//
// Top agent class which can drive and receive data from DUT.
//------------------------------------------------------------------------------


class amiq_eth_agent extends uvme_agent#(amiq_eth_packet);

  amiq_eth_driver driver;
  amiq_eth_monitor monitor;

  `uvm_component_utils(amiq_eth_agent)

  //Function: new
  //
  // Constructor

  function new (string name = "amiq_eth_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase function
  //Use factory overwrite to create amiq_eth_driver and monitor

  virtual function void build_phase(uvm_phase phase);
    set_type_override_by_type(  uvme_driver#(amiq_eth_packet)::get_type(), amiq_eth_driver::get_type());
    set_type_override_by_type( uvme_monitor#(amiq_eth_packet)::get_type(), amiq_eth_monitor::get_type());
    super.build_phase(phase);	

    if(this.drv != null) begin
      `uvme_cast(driver, this.drv, fatal);
    end

    if(this.mon != null) begin
      `uvme_cast(monitor, this.mon, fatal);
    end	
  endfunction : build_phase


endclass : amiq_eth_agent




//------------------------------------------------------------------------------
// CLASS: amiq_eth_active_agent
//
// Top active agent class which drive data to DUT.
//------------------------------------------------------------------------------

class amiq_eth_active_agent extends amiq_eth_agent;

  `uvm_component_utils(amiq_eth_active_agent)


  //Function: new
  //
  // Constructor

  function new (string name = "amiq_eth_active_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase

  virtual function void build_phase(uvm_phase phase);
    set_type_override_by_type(  uvme_agent_config::get_type(), amiq_eth_active_agent_config::get_type());
    super.build_phase(phase);
  endfunction : build_phase

endclass : amiq_eth_active_agent



//------------------------------------------------------------------------------
// CLASS: amiq_eth_passive_agent
//
// Top passie agent class which receie data from DUT.
//------------------------------------------------------------------------------

class amiq_eth_passive_agent extends amiq_eth_agent;

  `uvm_component_utils(amiq_eth_passive_agent)

  //Function: new
  //
  // Constructor

  function new (string name = "amiq_eth_passive_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase

  virtual function void build_phase(uvm_phase phase);
    set_type_override_by_type(  uvme_agent_config::get_type(), amiq_eth_passive_agent_config::get_type());
    super.build_phase(phase);
  endfunction : build_phase

endclass : amiq_eth_passive_agent



`endif //AMIQ_ETH_AGENT_SV
