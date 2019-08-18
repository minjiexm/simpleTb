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

`ifndef NETWORK_PORT_SVH
`define NETWORK_PORT_SVH

//------------------------------------------------------------------------------
//
// CLASS: network_port
//
// The network_port class is a connector.
// One side will be connected to network layer,
// The other side should be connected to a uvm_agent which will drive or
// collect data from DUT.
//
//|     ----------------------------------------------------------------
//|     |                                                              |
//|     | --> network input   ->network2dut_proc->  dut output     --> |  
//|     |                                                              |  to DUT agent
//|     | <-- network output  <-dut2network_proc<-  dut input fifo <-- |  
//|     |                                                              |
//|     ----------------------------------------------------------------
//
//------------------------------------------------------------------------------

typedef class network_port;

`uvme_layer_input_imp_decl(network_port, network_input_process)

class network_port extends network_component;

  typedef `uvme_layer_input_imp(veri5_eth_packet, network_port, network_input_process) network_input_type;
  typedef uvme_layer_output#(veri5_eth_packet) this_output_type;
  typedef uvm_tlm_analysis_fifo#(veri5_eth_packet) this_fifo_type;


  network_input_type network_input;
  protected this_output_type   network_output;


  // Member: agent_input
  //
  // receive data from uvm_agent (DUT)

  this_fifo_type    agent_input_fifo;
  this_output_type  agent_output;


  //UVM factory macro
  `uvm_component_utils_begin(network_port)
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
    this.network_input    = new("network_input",    this);
    this.network_output   = new("network_output",   this);
    this.agent_input_fifo = new("agent_input_fifo", this);
    this.agent_output     = new("agent_output",     this);
  endfunction : build_phase


  // Function: agent_input_process
  //
  // knob function for processing input from agent side


  virtual task agent_input_process(veri5_eth_packet txn);
    this.network_output.send(txn);
  endtask : agent_input_process


  // Function: network_input_process
  //
  // knob function for processing input from network side

  virtual task network_input_process(veri5_eth_packet txn);
    //here just pass network packet to agent output
	veri5_eth_packet txn4send;
	$cast(txn4send, txn); 	//need clone?
 	this.agent_output.send(txn4send);
  endtask : network_input_process



  //Function: get_ds_input
  //
  //Return the downstream uvme_layer_input of giving index

  virtual function uvme_layer_input#(veri5_eth_packet) get_ds_input(int unsigned port_idx = 0);
    if(port_idx != 0) begin
	  `uvme_error($psprintf("[get_ds_input] port_idx %s should always be 0 for %s", port_idx, this.get_type_name()))
	end
	return this.network_input;
  endfunction : get_ds_input


  //Function: get_ds_output
  //
  //Return the downstream uvme_layer_output of giving index

  virtual function uvme_layer_output#(veri5_eth_packet) get_ds_output(int unsigned port_idx = 0);
    if(port_idx != 0) begin
      `uvme_error($psprintf("[get_ds_output] port_idx %s should always be 0 for %s", port_idx, this.get_type_name()))
    end
	//`uvme_trace_connect($psprintf("[get_ds_output] %s return %s for connection", this.get_full_name(), this.network_output.get_full_name()))
    return this.network_output;
  endfunction : get_ds_output


  //Function: connect_to_port
  //
  //Connect two ports' network side together, this is kind of back to back

  virtual function void connect_to_port(network_port neighbour_port);
    this.network_output.link(neighbour_port.get_ds_input());
    this.network_input.link(neighbour_port.get_ds_output());
    `uvme_trace_connect($psprintf("[connect_to_port] Port %s <-connect-> Port %s", this.get_full_name(), neighbour_port.get_full_name()))
  endfunction : connect_to_port


  //Function: get_all_ds_neighour
  //
  //Get all downstream neighbours through internal network_outputs
  //network_switch should implement this function

  virtual function void get_all_ds_neighours(ref network_component ds_neighbour[$]);
    network_component neighbour = this.get_ds_neighour(this.network_output);
	if(neighbour != this) begin
      ds_neighbour.push_back(neighbour);
	  neighbour.get_all_ds_neighours(ds_neighbour);
	end
  endfunction : get_all_ds_neighours


  //Function: run_phase
  //
  //Keep check agent_info_fifo, if received data from DUT. call agent_input_process.
  
  virtual task run_phase(uvm_phase phase);
    forever begin
	  veri5_eth_packet pkt;
	  this.agent_input_fifo.get(pkt); //blocking
	  this.agent_input_process(pkt);
	end
  endtask : run_phase



endclass : network_port


`endif  //NETWORK_HOST_SVH
