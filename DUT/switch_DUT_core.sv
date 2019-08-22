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

`ifndef SWITCH_DUT_CORE_ENV_SV
`define SWITCH_DUT_CORE_ENV_SV

//------------------------------------------------------------------------------
// CLASS: switch_DUT_core
//
// switch_DUT_core will instance 4 active and 4 passive agents.
//------------------------------------------------------------------------------
class switch_DUT_core extends uvm_env;

  //Member: sw_port_sz
  //
  //Define the port number of switch model
  
  int unsigned sw_port_sz = 4;

  //Member: sw_DUT_model
  //
  //behavior model as switch DUT sw_DUT_model

  switch_DUT_model  sw_DUT_model;


  //Member: pkt_agent_subenv
  //
  //subenv of drive and mointor agents
 
  switch_DUT_interface  intf;


  uvme_layer_output#(veri5_eth_packet) layer_out[];

  //uvm factory declare macro
  `uvm_component_utils_begin(switch_DUT_core)
    `uvm_field_int(sw_port_sz, UVM_ALL_ON)
    `uvm_field_object(sw_DUT_model, UVM_ALL_ON)
    `uvm_field_object(intf, UVM_ALL_ON)
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
    
    this.sw_DUT_model = switch_DUT_model::type_id::create("sw_DUT_model", this);

    //create agent which drive and receive data from DUT
    this.intf = switch_DUT_interface::type_id::create("intf", this);
    
	this.layer_out = new[this.sw_port_sz];
	foreach(this.layer_out[idx]) begin
	  this.layer_out[idx] = new(uvme_pkg::name_in_array("layer_out", idx), this);
	end
	
  endfunction : build_phase


  //Function: connect_phase
  //
  //Standard UVM connect_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    //connect Fake DUT sw_model to driver and monitor
    for(int unsigned pidx = 0; pidx < this.sw_port_sz; pidx++) begin
      //connect driver to Reference Model input
      this.intf.pkt_receiver[pidx].mon.item_collected_port.connect(this.sw_DUT_model.in_port[pidx].get_imp());
      this.sw_DUT_model.layer_out_port[pidx].link_sequencer(this.intf.pkt_transmitter[pidx].seqr);
    end
    
  endfunction : connect_phase


endclass : switch_DUT_core


`endif // SWITCH_DUT_CORE_ENV_SV
