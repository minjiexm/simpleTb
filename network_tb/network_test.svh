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
import veri5_eth_pkg::*;

//Class: network_test_base
//
//Top level Test class that instantiates env, configures and starts stimulus
//

class network_test_base extends uvm_test;

  pin_agent pins; 
  //clock and reset gen


  //Member: sw_DUT
  //Env Top of switch DUT behavior Model
 
  switch_DUT_core sw_DUT;


  //Member: sw_env
  //Env Top of switch verification
 
  switch_verif_env sw_env;

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
	
    factory.set_type_override_by_type(pin_agent_config::get_type(), pin_agent_config_demo::get_type());
    this.pins = pin_agent::type_id::create("pin_agent", this);

    //Switch DUT behavior model
    this.sw_DUT = switch_DUT_core::type_id::create("sw_DUT", this);

    //Switch Verification Env Top
    this.sw_env = switch_verif_env::type_id::create("sw_env", this);

 endfunction : build_phase



  //Function: connect_phase
  //
  //Standard UVM connect_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

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
  
  
  
  //Function: reset_phase
  //
  //Standard UVM reset_phase
  //Setup clock and reset DUT

  virtual task reset_phase(uvm_phase phase);
	
    super.reset_phase(phase);

    phase.raise_objection(this); //rasing objection
    
    begin //setup clock
      pin_vir_seq_demo clk_rst_setup_seq = pin_vir_seq_demo::type_id::create("clk_rst_setup_seq");
      clk_rst_setup_seq.start(this.pins.m_vseqr);
    end

    #100ns;

    phase.drop_objection(this); //rasing objection

  endtask : reset_phase

  
  
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
      veri5_eth_seq_lib_default demo_seq = veri5_eth_seq_lib_default::type_id::create("demo_seq");
      demo_seq.start(this.sw_env.drv_mon_subenv.active_agent[0].seqr);
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
	  this.topology_demo.switch_DUT.ports[idx].agent_output.link_sequencer(this.sw_env.drv_mon_subenv.pkt_transmitter[idx].seqr);
	  this.sw_env.drv_mon_subenv.pkt_receiver[idx].mon.item_collected_port.connect(this.topology_demo.switch_DUT.ports[idx].agent_input_fifo.analysis_export);
    end

  endfunction : connect_phase


endclass : network_test_topology




//Test for debug veri5 packet

class network_test_veri5_packet extends uvm_test;

  //Register with factory
  `uvm_component_utils(network_test_veri5_packet)

  //Function: new
  //
  //Constructor

  function new(string name = "network_test_veri5_packet", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Build phase - Construct the cfg and env class using factory
  //Get the virtual interface handle from Test and then set it config db for the env component
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	`uvme_set_report_server
  endfunction : build_phase



  //Function: connect_phase
  //
  //Standard UVM connect_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction : connect_phase



  //Function: end_of_elaboration_phase
  //
  //Standard UVM end_of_elaboration_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
  endfunction : end_of_elaboration_phase
  
  
  
  //Function: main_phase
  //
  //Standard UVM main_phase

  task main_phase(uvm_phase phase);
	veri5_eth_packet_ipv4 ipv4_pkt;
	
	veri5_eth_packet_l2 l2_pkt;
	
	byte unsigned byte_packed_data[];
	
    super.main_phase(phase);
	
	l2_pkt = veri5_eth_packet_l2::type_id::create("L2_PKT");
	void'( l2_pkt.randomize() );
	`uvme_header_randomize_with(l2_pkt, PAYLOAD, uvme_payload_header, { length == 64;})
	l2_pkt.print();
	void'( l2_pkt.pack_bytes(byte_packed_data) );    //pack method

    foreach(byte_packed_data[i]) begin
      `uvm_info("PACK",$sformatf("byte_packed_data[%0d] = 0x%0h",i,byte_packed_data[i]), UVM_LOW)
    end

	void'( l2_pkt.randomize() );
	`uvme_header_randomize_with(l2_pkt, PAYLOAD, uvme_payload_header, { length == 64;})
	l2_pkt.print();

	//TEST Pack
	void'( l2_pkt.unpack_bytes(byte_packed_data) );    //pack method
	l2_pkt.print();
	
	
	ipv4_pkt = veri5_eth_packet_ipv4::type_id::create("ipv4_packet");
	$display("JIEMIN --------------------------------->");
	void'( ipv4_pkt.randomize() );
	`uvme_header_randomize_with(ipv4_pkt, PAYLOAD, uvme_payload_header, { length == 64;})
	ipv4_pkt.print();
	`uvme_info($psprintf("ipv4_pkt %s", ipv4_pkt.convert2string()), UVM_NONE)
	//ipv4_pkt.update_crc();
	
	//TEST Pack
	void'( ipv4_pkt.pack_bytes(byte_packed_data) );    //pack method
	
    foreach(byte_packed_data[i]) begin
      `uvm_info("PACK",$sformatf("byte_packed_data[%0d] = 0x%0h",i,byte_packed_data[i]), UVM_LOW)
    end

    //TEST Unpack
	begin
	  veri5_eth_packet_ipv4 ipv4_pkt_1;
      ipv4_pkt_1 =  veri5_eth_packet_ipv4::type_id::create("ipv4_pkt_1");
	  void'( ipv4_pkt_1.unpack_bytes(byte_packed_data) );
      ipv4_pkt_1.print();
    end

	
	//TEST convert2string
	/*
	begin
	  veri5_eth_packet pkt = veri5_eth_packet::type_id::create("pkt");
	  void'( pkt.randomize() );
	  pkt.print();
	  `uvme_info($psprintf("pkt convert2string %s", pkt.convert2string()), UVM_NONE)

      begin
	  veri5_eth_packet pkt1;
      `uvme_cast(pkt1, ipv4_pkt.clone(), error);
	  pkt1.print();
	  
	  `uvme_info($psprintf("pkt1 convert2string %s", pkt1.convert2string()), UVM_NONE)
	  end
	end
	*/

  endtask : main_phase


  
  //Function: report_phase
  //
  //Standard UVM report_phase

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction : report_phase

  
endclass : network_test_veri5_packet



`endif  // NETWORK_TEST_SV

