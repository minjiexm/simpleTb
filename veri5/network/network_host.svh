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

`ifndef NETWORK_HOST_SVH
`define NETWORK_HOST_SVH

//------------------------------------------------------------------------------
//
// CLASS: network_host
//
// The network_host class is a traffic generator.
// You can think network_host as a PC, it can send out IP packets to network.
//
//|     --------------------------------------------
//|     |                                          |
//|     | send_packet()      -> network output --> | --> 
//|     |                                          |
//|     | receive_proc()     <- network input  <-- | <--
//|     |                                          |
//|     --------------------------------------------
//
//------------------------------------------------------------------------------

typedef class network_host;

`uvme_layer_input_imp_decl(network_host, receive_process)

class network_host extends network_component;

  typedef `uvme_layer_input_imp(veri5_eth_packet, network_host, receive_process) network_input_type;
  typedef uvme_layer_output#(veri5_eth_packet) network_output_type;

  // Member: network_output
  //
  // channel for sending packet to network (topology)

  network_output_type network_output;


  // Member: network_input
  //
  // receive data from network (topology)

  network_input_type  network_input;


  // Member: address
  //
  // placeholder for mac address/ip address

  network_address address;


  `uvm_component_utils_begin(network_host)
    `uvm_field_object(address, UVM_ALL_ON)
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
    super.build_phase(phase);

    this.address = network_address::type_id::create("address");
	
    this.network_input  = new("network_input",  this);
    this.network_output = new("network_output", this);
  endfunction : build_phase


  //Function: connect_upstream
  //
  //Connect to a neighbour, the neighbour will be the upstearm neighbour
  //host can connect to a port or a switch type component

  virtual function void connect_upstream(network_component neighbour, input int unsigned port_idx = 0);
    begin
      this.network_input.link(neighbour.get_ds_output(port_idx));
      this.network_output.link(neighbour.get_ds_input(port_idx));
    end
  endfunction : connect_upstream


  // Function: can_receive
  //
  // Does the packet can be received?

  virtual function bit can_receive(veri5_eth_packet txn);
    //`uvme_trace_func_start("can_receive")
	veri5_eth_address destination_address;
	veri5_eth_packet_l2 l2_pkt;
	`uvme_cast(l2_pkt, txn, error)
    destination_address = l2_pkt.get_mac_da();
    if(destination_address == this.address.mac) begin
	  this.receive_process(txn); //if can receive it.
 	  return 1;
	end
	else begin
	  return 0;
	end
  endfunction : can_receive



  // Function: receive_process
  //
  // knob function for processing input from network side

  virtual function void receive_process(veri5_eth_packet txn);
    //`uvme_trace_func_start("receive_process")
    veri5_eth_address destination_address;
	veri5_eth_packet_l2 l2_pkt;
	`uvme_cast(l2_pkt, txn, error)
    destination_address = l2_pkt.get_mac_da();
    if(destination_address == this.address.mac) begin
 	  this.counter.incr("RX", 1, "receive_process");
	end
	else begin
	  `uvme_trace_data($psprintf("[receive_process] Host %s received a packet %s with wrong mac address 0x%0h and will drop it", this.get_name(), txn.convert2string(), destination_address))
 	  this.counter.incr("DROP", 1, "receive_process");
	end
  endfunction : receive_process


  // Function: send_l2_packet
  //
  // send out a L2 Packet from host to network

  virtual task send_l2_packet(network_address dest_addr);
    veri5_eth_packet_l2 l2_pkt = veri5_eth_packet_l2::type_id::create("l2_pkt");
	void'( l2_pkt.randomize() );
	l2_pkt.set_mac_sa(this.address.mac);
	l2_pkt.set_mac_da(dest_addr.mac);
    `uvme_trace_data($psprintf("[send_l2_packet] Host %s send a L2 packet %s to Address 0x%0h", this.get_name(), l2_pkt.convert2string(), dest_addr.mac))
	this.network_output.send(l2_pkt);
	this.counter.incr("TX", 1, "send_l2_packet");
  endtask : send_l2_packet



  //Function: get_all_ds_neighour
  //
  //Get all downstream neighbours through internal network_outputs
  //network_switch should implement this function

  virtual function void get_all_ds_neighours(ref network_component ds_neighbour[$]);
    //do nothing
	//host has no downstream neighbours
  endfunction : get_all_ds_neighours



  // Function: report_phase
  //
  // Standard uvm report_phase function
  // Print Counters' value

  virtual function void report_phase (uvm_phase phase);
    super.report_phase(phase);
    this.counter.report();
  endfunction : report_phase



endclass : network_host

`endif  //NETWORK_HOST_SVH
