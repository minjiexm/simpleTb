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

`ifndef NETWORK_TEST_SV
`define NETWORK_TEST_SV

import network_pkg::*;

//Class: network_test_base
//
//Top level Test class that instantiates env, configures and starts stimulus
//

class network_test_base extends uvm_test;

  switch_model           i_sw_dut;

  amiq_eth_agent_subenv  pkt_agent_subenv;

  //Register with factory
  `uvm_component_utils(network_test_base);
    
  //Function: new
  //
  //Constructor

  function new(string name = "network_test_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Build phase - Construct the cfg and env class using factory
  //Get the virtual interface handle from Test and then set it config db for the env component
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
	`uvme_set_report_server
	
    //create instance of fake switch DUT
    this.i_sw_dut = switch_model::type_id::create("i_sw_dut", this);
    this.pkt_agent_subenv = amiq_eth_agent_subenv::type_id::create("pkt_agent_subenv", this);
  endfunction : build_phase



  //Function: connect_phase
  //
  //Standard UVM connect_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	
    //connect Fake DUT sw_model to driver and monitor
    for(int unsigned idx = 0; idx < 4; idx++) begin
      //connect sw_model output to monitor
      this.i_sw_dut.out_port[idx].link_fifo(this.pkt_agent_subenv.passive_pkt_agent[idx].monitor.pkt_rcv_fifo);
      //connect driver to sw_model input
      this.pkt_agent_subenv.active_pkt_agent[idx].driver.pkt_drv_port.connect(this.i_sw_dut.in_port[idx].get_imp());
    end

  endfunction : connect_phase



  //Function: end_of_elaboration_phase
  //
  //Standard UVM end_of_elaboration_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    //this.i_sw_dut.print();
    //this.pkt_agent_subenv.print();
  endfunction : end_of_elaboration_phase


  
  //Function: report_phase
  //
  //Standard UVM report_phase

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvme_args_print_all
  endfunction : report_phase

  
endclass : network_test_base





//Class: network_test_sequence
//
//Use triditional sequence way to send a packet
//

class network_test_sequence extends network_test_base;
  
  //Register with factory
  `uvm_component_utils(network_test_sequence);
  
  
  //Function: new
  //
  //Constructor

  function new(string name = "network_test_sequence", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  
  //Function: connect_phase
  //
  //Standard UVM Run phase

  task main_phase( uvm_phase phase );
    super.main_phase(phase);
    
    phase.raise_objection(this); //rasing objection
    
    #1000;
    
    begin
      amiq_eth_seq_lib_default demo_seq = amiq_eth_seq_lib_default::type_id::create("demo_seq");
      demo_seq.start(this.pkt_agent_subenv.active_agent[0].seqr);
    end

    phase.drop_objection(this); //rasing objection
  endtask: main_phase
  

  
endclass : network_test_sequence






//Class: network_test_topology
//
//Use network topology way to send a packet and config DUT
//

class network_test_topology extends network_test_base;
  
  network_topology_demo topology_demo;
  
  //Register with factory
  `uvm_component_utils(network_test_topology);
  
  
  //Function: new
  //
  //Constructor

  function new(string name = "network_test_sequence", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Build phase - Construct the cfg and env class using factory
  //Get the virtual interface handle from Test and then set it config db for the env component
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    this.topology_demo = network_topology_demo::type_id::create("topology_demo", this);
  endfunction : build_phase



  //Function: connect_phase
  //
  //Standard UVM connect_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	
    //connect Fake DUT sw_model to driver and monitor
    for(int unsigned idx = 0; idx < 4; idx++) begin
	  this.topology_demo.switch_DUT.ports[idx].agent_output.link_sequencer(this.pkt_agent_subenv.active_pkt_agent[idx].seqr);
	  this.pkt_agent_subenv.passive_pkt_agent[idx].mon.item_collected_port.connect(this.topology_demo.switch_DUT.ports[idx].agent_input_fifo.analysis_export);
    end

  endfunction : connect_phase


endclass : network_test_topology



`endif  // NETWORK_TEST_SV
