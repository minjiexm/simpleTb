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

`ifndef NETWORK_SWITCH_DRIVER_SVH
`define NETWORK_SWITCH_DRIVER_SVH

//------------------------------------------------------------------------------
//
// CLASS: network_switch_driver
//
// The network_switch_driver class should map to a real Design (DUT).
// It will foward all packets received from network side to DUT driver.
// network_switch_driver should also connect to passive agent in order 
// to get DUT output packets and send back to network side for checking.
//
//|
//|         ----------------------------------------------------
//|         |               switch_driver                      | 
//|         |                                                  | 
//|  -------------------------------------------------------------------
//|  |  network -> port_ds_input     PORT 0   port_agent_output -> DUT |
//|  |  network <- port_ds_output             port_agent_input  <- DUT |
//|  ------------------------------------------------------------------
//|         |                        ........                  | 
//|         |                                                  | 
//|  ------------------------------------------------------------------
//|  |  network -> port_ds_input     PORT N   port_agent_output -> DUT |
//|  |  network <- port_ds_output             port_agent_input  <- DUT |
//|  ------------------------------------------------------------------
//|         |                                                  | 
//|         |                                                  | 
//|         ----------------------------------------------------
//|
//------------------------------------------------------------------------------

typedef class network_switch;

class network_switch_driver extends network_switch;

  network_port ports[];

  `uvm_component_utils_begin(network_switch_driver)
  `uvm_component_utils_end


  // Constructor: new
  //
  // Initializes the object.

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new


  // Function: build_phase
  //
  // Standard uvm build_phase function
  // build all inputs and outputs

  virtual function void build_phase (uvm_phase phase);
    int unsigned port_size;
	
    super.build_phase(phase);

    port_size = this.cfg.port_num;

    this.ports  = new[port_size];

    for(int unsigned port_idx = 0; port_idx < port_size; port_idx++) begin
      this.ports[port_idx] = network_port::type_id::create(uvme_pkg::name_in_array("ports", port_idx),  this);
    end
  endfunction : build_phase


  virtual task ds_input_process(uvm_sequence_item txn, int unsigned port_idx);
    `uvme_error($psprintf("[ds_input_process] should not be called for %s", this.get_type_name()))
  endtask : ds_input_process


  //Function: is_input_process
  //
  //Implment function which receive packets from upstreaports

  virtual task us_input_process(uvm_sequence_item txn);
    `uvme_error($psprintf("[us_input_process] should not be called for %s", this.get_type_name()))
  endtask : us_input_process


  //Function: connect_upstream
  //
  //Connect to a neighbour, the neighbour will be the upstearm neighbour
  //switch can connect to a port or a switch type component

  virtual function void connect_upstream(network_component neighbour, input int unsigned port_idx = 0);
    `uvme_error($psprintf("[connect_upstream] should not be called for %s", this.get_type_name()))
  endfunction : connect_upstream


  //Function: get_ds_input
  //
  //Return the downstream uvme_layer_input of giving index

  virtual function uvme_layer_input#(amiq_eth_packet) get_ds_input(int unsigned port_idx = 0);
    if(port_idx <= this.ports.size()) begin
      return this.ports[port_idx].get_ds_input();
    end
    else begin
      `uvme_error($psprintf("[get_ds_input] port_idx %s is out of range (max should be %0d)", port_idx, this.ports.size()))
      return null;
    end
  endfunction : get_ds_input


  //Function: get_ds_output
  //
  //Return the downstream uvme_layer_output of giving index

  virtual function uvme_layer_output#(amiq_eth_packet) get_ds_output(int unsigned port_idx = 0);
    if(port_idx <= this.ports.size()) begin
      return this.ports[port_idx].get_ds_output();
    end
    else begin
      `uvme_error($psprintf("[get_ds_output] port_idx %s is out of range (max should be %0d)", port_idx, this.ports.size()))
      return null;
    end
  endfunction : get_ds_output


  //Function: get_all_ds_neighour
  //
  //Get all downstream neighbours through internal network_outputs
  //network_switch should implement this function

  virtual function void get_all_ds_neighours(ref network_component ds_neighbour[$]);
    foreach(this.ports[pidx]) begin
	  this.ports[pidx].get_all_ds_neighours(ds_neighbour);
	end
  endfunction : get_all_ds_neighours


endclass : network_switch_driver


`endif  //NETWORK_SWITCH_DRIVER_SVH
