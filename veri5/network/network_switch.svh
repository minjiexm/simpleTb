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

`ifndef NETWORK_SWITCH_SVH
`define NETWORK_SWITCH_SVH


class network_switch_config extends uvm_object;

  //Member: port_num;
  int unsigned port_num = 4; //default number is 4  


  //uvm factory macro  
  `uvm_object_utils_begin(network_switch_config)
    `uvm_field_int(port_num, UVM_ALL_ON)
  `uvm_object_utils_end


  // Constructor: new
  //
  // Initializes the object.

  function new (string name = "network_switch_config");
    super.new(name);
  endfunction : new


endclass : network_switch_config



//------------------------------------------------------------------------------
//
// CLASS: network_switch
//
// The network_switch class is a logic network swich class.
// It has no real packet switch function.
// network_switch has on upstream port and many downstream ports.
// the upstream port can connect to other network_switch downstream port or
// connect to network_port. network_switch can let network_host/network_swith
// and network_port connect to its downstream ports.
// network_switch class will forward all packets from downstream ports to its
// upstream port.
// Also the packets from upstream ports will send to downstream ports.
// You can add some packet encap & decap functions into network_switch.
//
//|     ----------------------------------------------------
//|     |                                                  |
//|     | ds_port[0]                                       |  
//|     |              ->ds_input_process                  |
//|     | .....                                   us_port  |
//|     |                us_input_process <-               |
//|     | ds_port[N]                                       |  
//|     |                                                  |
//|     ----------------------------------------------------
//
//------------------------------------------------------------------------------

typedef class network_switch;


`uvme_layer_input_imp_with_label_decl(network_switch, ds_input_process)
`uvme_layer_input_imp_decl(network_switch, us_input_process)


class network_switch extends network_component;

  typedef `uvme_layer_input_imp(amiq_eth_packet, network_switch, ds_input_process) ds_input_type;
  typedef `uvme_layer_input_imp(amiq_eth_packet, network_switch, us_input_process) us_input_type;
  typedef  uvme_layer_output#(amiq_eth_packet) network_output_type;

  // Member: cfg
  //
  // Config how many ports exits in the switch
  
  network_switch_config cfg;


  // Member: downstream ports
  //
  // channel for receive and send packets from lower layer

  protected ds_input_type       ds_input[];


  // Member: downstream inputs
  //
  // channel for receive and send packets from lower layer

  protected network_output_type ds_output[];


  // Member: upstream input
  //
  // channel for receive and send packets from higher layer

  protected us_input_type  us_input;


  // Member: upstream output
  //
  // channel for receive and send packets from higher layer

  protected network_output_type us_output;


  //uvm factory macro
  `uvm_component_param_utils_begin(network_switch)
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

    if(!uvm_config_db #(network_switch_config)::get(this, "", "cfg", this.cfg)) begin
      `uvm_info(this.get_type_name(), $psprintf("[%s] Create network_switch_config local", this.get_name()), UVM_LOW)
      this.cfg = network_switch_config::type_id::create("cfg");
    end

    port_size = this.cfg.port_num;

    this.ds_input  = new[port_size];
	this.ds_output = new[port_size];

    for(int unsigned port_idx = 0; port_idx < port_size; port_idx++) begin
      this.ds_input[port_idx]  = new(uvme_pkg::name_in_array("ds_input", port_idx),  this);
	  this.ds_input[port_idx].set_label(port_idx);

      this.ds_output[port_idx] = new(uvme_pkg::name_in_array("ds_output", port_idx), this);
	end
	
	this.us_input = new("us_input", this);
	this.us_output = new("us_output", this);
	
  endfunction : build_phase


  //Function: ds_input_process
  //
  //Implment function which receive packets from downstream_port

  virtual task ds_input_process(uvm_sequence_item txn, int unsigned port_idx);
    amiq_eth_packet pkt;
	`uvme_cast(pkt, txn, error)

    `uvme_info($psprintf("[ds_input_process] receive a packet %s", pkt.convert2string()), UVM_LOW)

    //here just simple fwd to upstream port
	this.us_output.send(pkt);
  endtask : ds_input_process


  //Function: is_input_process
  //
  //Implment function which receive packets from upstream_port

  virtual task us_input_process(uvm_sequence_item txn);
    amiq_eth_packet pkt;
	`uvme_cast(pkt, txn, error)
    void'(this.can_receive(pkt));  //broadcast the packet to all downstream components.
  endtask : us_input_process


  //Function: connect_upstream
  //
  //Connect to a neighbour, the neighbour will be the upstearm neighbour
  //switch can connect to a port or a switch type component

  virtual function void connect_upstream(network_component neighbour, input int unsigned port_idx = 0);
    begin
      this.us_input.link(neighbour.get_ds_output(port_idx));
      this.us_output.link(neighbour.get_ds_input(port_idx));
    end
  endfunction : connect_upstream


  //Function: get_ds_input
  //
  //Return the downstream uvme_layer_input of giving index

  virtual function uvme_layer_input#(amiq_eth_packet) get_ds_input(int unsigned port_idx = 0);
    if(port_idx <= ds_input.size()) begin
	  return this.ds_input[port_idx];
	end
	else begin
	  `uvme_error($psprintf("[get_ds_input] port_idx %s is out of range (max should be %0d)", port_idx, ds_input.size()))
	  return null;
	end
  endfunction : get_ds_input


  //Function: get_ds_output
  //
  //Return the downstream uvme_layer_output of giving index

  virtual function uvme_layer_output#(amiq_eth_packet) get_ds_output(int unsigned port_idx = 0);
    if(port_idx <= ds_output.size()) begin
	  return this.ds_output[port_idx];
	end
	else begin
	  `uvme_error($psprintf("[get_ds_output] port_idx %s is out of range (max should be %0d)", port_idx, ds_output.size()))
	  return null;
	end
  endfunction : get_ds_output



  //Function: get_all_ds_neighour
  //
  //Get all downstream neighbours through internal network_outputs
  //network_switch should implement this function

  virtual function void get_all_ds_neighours(ref network_component ds_neighbour[$]);
    foreach(this.ds_output[pidx]) begin
      network_component neighbour = this.get_ds_neighour(this.ds_output[pidx]);
	  
	  if(neighbour != null && neighbour != this) begin
        ds_neighbour.push_back(neighbour);
	    neighbour.get_all_ds_neighours(ds_neighbour);
	  end
	end
  endfunction : get_all_ds_neighours



  // Function: can_receive
  //
  // Does the packet can be received?
  // If one of the ds neighbour can received the packet, means switch should receive it.

  virtual function bit can_receive(amiq_eth_packet txn);
    network_component ds_neighbour[$];
    can_receive = 0;
    `uvme_trace_func_start("can_receive")
	this.get_all_ds_neighours(ds_neighbour);
	foreach(ds_neighbour[idx])begin
	  if(ds_neighbour[idx].can_receive(txn))begin
        can_receive = 1;
	  end
	end
  endfunction : can_receive


endclass : network_switch


`endif  //NETWORK_SWITCH_SVH
