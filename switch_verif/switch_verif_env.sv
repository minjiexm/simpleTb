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

`ifndef SWITCH_VERIF_ENV_SV
`define SWITCH_VERIF_ENV_SV

//------------------------------------------------------------------------------
// CLASS: switch_verif_env
//
// switch_verif_env will instance 4 active and 4 passive agents.
//------------------------------------------------------------------------------
class switch_verif_env extends uvm_env;

  //Member: sw_port_sz
  //
  //Define the port number of switch model
  
  int unsigned sw_port_sz = 4;

  //Member: ref_model
  //
  //behavior model as reference model

  switch_model  ref_model;


  //Member: sb
  //
  //switch Scoreboard
  switch_scoreboard  sb;


  //Member: pkt_agent_subenv
  //
  //subenv of drive and mointor agents
 
  switch_verif_drv_mon_subenv  drv_mon_subenv;


  //uvm factory declare macro
  `uvm_component_utils_begin(switch_verif_env)
    `uvm_field_object(ref_model, UVM_ALL_ON)
    `uvm_field_object(sb, UVM_ALL_ON)
    `uvm_field_object(drv_mon_subenv, UVM_ALL_ON)
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

    super.build_phase(phase);

	//create reference model
    void'( uvm_config_db#(int)::set(this, "*", "port_size", this.sw_port_sz));
	
	this.ref_model = switch_model::type_id::create("ref_model", this);

	//create agent which drive and receive data from DUT
    this.drv_mon_subenv = switch_verif_drv_mon_subenv::type_id::create("drv_mon_subenv", this);
	
    this.sb = switch_scoreboard::type_id::create("sb", this);

  endfunction : build_phase


  //Function: connect_phase
  //
  //Standard UVM connect_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	
	//connect Fake DUT sw_model to driver and monitor
    for(int unsigned pidx = 0; pidx < this.sw_port_sz; pidx++) begin
	  //connect driver to Reference Model input
      this.drv_mon_subenv.pkt_transmitter[pidx].mon.item_collected_port.connect(this.ref_model.in_port[pidx].get_imp());
  
      //Connect Ref to Scoreboard
      this.ref_model.out_port[pidx].link_export(this.sb.port_checker[pidx].ref_in_exp);
    end

    for(int unsigned pidx = 0; pidx < this.sw_port_sz; pidx++) begin
	  //connect DUT monitor to Scoreboard DUT input
      this.drv_mon_subenv.pkt_receiver[pidx].mon.item_collected_port.connect(this.sb.port_checker[pidx].ref_in_exp);
    end
	
  endfunction : connect_phase


endclass : switch_verif_env


`endif // SWITCH_VERIF_ENV_SV
