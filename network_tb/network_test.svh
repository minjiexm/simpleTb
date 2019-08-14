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
import switch_scoreboard_pkg::*;


//Class: network_test_base
//
//Top level Test class that instantiates env, configures and starts stimulus
//

class network_test_base extends uvm_test;

  int unsigned sw_port_sz = 4;

  //Member: DUT
  //
  //behavior model as Fake DUT

  switch_model           DUT;  //Fake Switch DUT


  //Member: ref_model
  //
  //behavior model as reference model

  switch_model           ref_model;


  //Member: sb
  //
  //switch Scoreboard
  switch_scoreboard      sb;

  //Member: pkt_agent_subenv
  //
  //subenv of drive and mointor agents
 
  amiq_eth_agent_subenv  pkt_agent_subenv;

  //Register with factory
  `uvm_component_utils(network_test_base)
    
	
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
    void'( uvm_config_db#(int)::set(this, "DUT", "port_size", this.sw_port_sz));
    this.DUT = switch_model::type_id::create("DUT", this);
	
	//create reference model
    void'( uvm_config_db#(int)::set(this, "ref_model", "port_size", this.sw_port_sz));
	this.ref_model = switch_model::type_id::create("ref_model", this);

	//create scoreboard to compare
	void'( uvm_config_db#(int)::set(this, "sw_scoreboard", "port_size", this.sw_port_sz));
    this.sb = switch_scoreboard::type_id::create("sb", this);

	//create agent which drive and receive data from DUT
    this.pkt_agent_subenv = amiq_eth_agent_subenv::type_id::create("pkt_agent_subenv", this);

 endfunction : build_phase



  //Function: connect_phase
  //
  //Standard UVM connect_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	
	//connect Fake DUT sw_model to driver and monitor
    for(int unsigned pidx = 0; pidx < this.sw_port_sz; pidx++) begin
      //connect DUT output to monitor
      this.DUT.out_port[pidx].link_fifo(this.pkt_agent_subenv.passive_pkt_agent[pidx].monitor.pkt_rcv_fifo);
      //connect driver to DUT input
      this.pkt_agent_subenv.active_pkt_agent[pidx].driver.dut_port.connect(this.DUT.in_port[pidx].get_imp());

	  //connect driver to Reference Model input
      this.pkt_agent_subenv.active_pkt_agent[pidx].driver.model_port.connect(this.ref_model.in_port[pidx].get_imp());
  
      //Connect DUT and Ref to Scoreboard
      this.ref_model.out_port[pidx].link_export(this.sb.port_checker[pidx].ref_in_exp);
      this.DUT.out_port[pidx].link_export(this.sb.port_checker[pidx].dut_in_exp);	 
    end
  endfunction : connect_phase



  //Function: end_of_elaboration_phase
  //
  //Standard UVM end_of_elaboration_phase

  function void end_of_elaboration_phase(uvm_phase phase);
  	uvm_phase main_phase = phase.find_by_name("main", 0);
    super.end_of_elaboration_phase(phase);
    main_phase.phase_done.set_drain_time(this, 1000ns);
    //this.i_sw_dut.print();
    //this.pkt_agent_subenv.print();();
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

