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

`ifndef NETWORK_COMPONENT_SVH
`define NETWORK_COMPONENT_SVH

//------------------------------------------------------------------------------
// CLASS: network_component
//
// network_component is the base class for network classes like host/port/switch ....
//
//------------------------------------------------------------------------------

class network_component extends uvm_component;

  uvme_counter counter;
  
  `uvm_component_utils_begin(network_component)
  `uvm_component_utils_end

  // Constructor: new
  //
  // Initializes the object.

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new



  //Function: build_phase
  //
  //Connect to a neighbour, the neighbour will be the upstearm neighbour

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	this.counter = uvme_counter::type_id::create({this.get_full_name(),".counter"});
  endfunction : build_phase




  //Function: connect_upstream
  //
  //Connect to a neighbour, the neighbour will be the upstearm neighbour

  virtual function void connect_upstream(network_component neighbour, input int unsigned port_idx = 0);
    `uvme_no_child_imp_error("connect_upstream")
  endfunction : connect_upstream



  //Function: get_network_input
  //
  //Return uvme_transaction_input of giving index

  virtual function uvme_layer_input#(veri5_eth_packet) get_ds_input(int unsigned port_idx = 0);
    `uvme_no_child_imp_error("get_network_input")
	return null;
  endfunction : get_ds_input


  //Function: get_network_output
  //
  //Return uvme_transaction_output of giving index

  virtual function uvme_layer_output#(veri5_eth_packet) get_ds_output(int unsigned port_idx = 0);
    `uvme_no_child_imp_error("get_network_output")
	return null;
  endfunction : get_ds_output


  //Function: get_ds_neighour
  //
  //Get the downstream neighbour through a network_output

  virtual function network_component get_ds_neighour(input uvme_layer_output#(veri5_eth_packet) network_output);
	uvm_component next_input;
	network_component neighbour;
	
	`uvme_cast(next_input, network_output.get_connect_input(), fatal)
	
	if($cast(neighbour, next_input.get_parent())) begin
	  `uvme_info($psprintf("Get downstream neighbour %s through network_output %s", neighbour.get_name(), network_output.get_name()), UVM_DEBUG)
	end
	return neighbour;
  endfunction : get_ds_neighour


  //Function: get_all_ds_neighour
  //
  //Get all downstream neighbours through internal network_outputs
  //network_switch should implement this function

  virtual function void get_all_ds_neighours(ref network_component ds_neighbour[$]);
    `uvme_no_child_imp_error("get_all_ds_neighours")
  endfunction : get_all_ds_neighours



  // Function: can_receive
  //
  // Does the packet can be received?

  virtual function bit can_receive(veri5_eth_packet txn);
    `uvme_no_child_imp_error("can_receive")
	return 0;
  endfunction : can_receive



endclass : network_component


`endif  //NETWORK_COMPONENT_SVH
