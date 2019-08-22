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

`ifndef SWITCH_DUT_MODEL_SV
`define SWITCH_DUT_MODEL_SV

//------------------------------------------------------------------------------
//
// CLASS: switch_DUT_model
//
// switch_DUT_model is a simple behavior model of switch.
// It will protend a DUT in this simple demo.
//
// switch_DUT_model current only support mac address lookup function.
// It can forwad the packet to the right port and also havs simple flood feature.
// User can use +SWITCH_MODEL::PORT_NUM=4 to define the number of ports of the
// switch_DUT_model, by default the port_num is 4.
//
// All ports type are uvme_analysis_input and uvme_analysis_output.
// User should connect those ports to DUT agents.
//------------------------------------------------------------------------------

class switch_DUT_model extends switch_model;

  uvme_layer_output#(veri5_eth_packet) layer_out_port[];


  //uvm factory declare macro
  `uvm_component_utils_begin(switch_DUT_model)
    `uvm_field_array_object(layer_out_port, UVM_ALL_ON)
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

    this.layer_out_port = new[this.cfg.port_num];

    for(int pidx=0; pidx<this.cfg.port_num; pidx++) begin
      this.layer_out_port[pidx] = new(uvme_pkg::name_in_array("layer_out_port", pidx), this);
    end

  endfunction : build_phase


  //Function: connect_phase
  //
  //Standard UVM connect_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    //connect Fake DUT sw_model to driver and monitor
    for(int unsigned pidx = 0; pidx < this.cfg.port_num; pidx++) begin
	  //convert analysis output to layer output which can connect to a agent
      this.out_port[pidx].link_fifo( this.layer_out_port[pidx].get_inner_side_tlm_fifo() );
	end
    
  endfunction : connect_phase


endclass : switch_DUT_model


`endif // SWITCH_DUT_MODEL_SV
