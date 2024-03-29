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

`ifndef NETWORK_TOPOLOGY_DEMO_SVH
`define NETWORK_TOPOLOGY_DEMO_SVH

//------------------------------------------------------------------------------
// CLASS: network_topology_demo
//
// network_topology is the placeholder to instance network_components and
// connect them to each other.
// In run_phase, also call hosts send packets to genrate traffic.
//
//------------------------------------------------------------------------------


class network_topology_demo extends uvm_component;

  //Member: host
  //
  //Array of hosts.

  network_host hosts[];

  //Member: switch
  //
  //8 ports switchs

  network_switch switch;  

  //Member: switch_driver
  //
  //Ports wrapper refer to a real DUT

  network_switch_driver switch_DUT;

  //UVM factory macro
  `uvm_component_utils_begin(network_topology_demo)
  `uvm_component_utils_end

  // Constructor: new
  //
  // Initializes the object.

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase
  //create network_components like host/switch

  virtual function void build_phase(uvm_phase phase);
    network_switch_config cfg_8ports;
    network_switch_config cfg_4ports;

    super.build_phase(phase);
    
    this.hosts = new[11];  //instance 4 hosts here

    cfg_8ports = network_switch_config::type_id::create("cfg_8ports");
    cfg_8ports.port_num = 8;
    
    foreach(this.hosts[hidx]) begin
      string host_name = uvme_pkg::name_in_array("hosts", hidx);
      this.hosts[hidx] = network_host::type_id::create(host_name, this);
     end

    cfg_4ports = network_switch_config::type_id::create("cfg_4ports");
    cfg_4ports.port_num = 4;

    //Map to 4 ports fake DUT
    void'( uvm_config_db#(network_switch_config)::set(this, "switch_DUT", "cfg", cfg_4ports));
    this.switch_DUT = network_switch_driver::type_id::create("switch_DUT", this);
    void'( uvm_config_db#(network_switch_driver)::set(null, "*", "switch_driver", this.switch_DUT) );


    void'( uvm_config_db#(network_switch_config)::set(this, "switch", "cfg", cfg_8ports));    
    this.switch = network_switch::type_id::create("switch", this);

  endfunction : build_phase


  //Function: connect_phase
  //
  //Standard UVM connect_phase
  //Connect network component to each others.

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    for(int unsigned hidx = 0; hidx<8; hidx++) begin   //host 0 ~7 connect to switch ports 0 ~ 7
      this.hosts[hidx].connect_upstream(switch, hidx);  //hidx <-> pidx
     end

    this.switch.connect_upstream(this.switch_DUT, 0);

    //hosts 8 ~ 11 connect to switch_DUT ports 1 ~ 3
    this.hosts[ 8].connect_upstream(this.switch_DUT, 1);
    this.hosts[ 9].connect_upstream(this.switch_DUT, 2);
    this.hosts[10].connect_upstream(this.switch_DUT, 3);
  endfunction : connect_phase


  //Function: main_phase
  //
  //Standard UVM main_phase
  //Host send packets

  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);

    phase.raise_objection(this); //rasing objection

    this.hosts[ 8].send_l2_packet(this.hosts[2].address);
    this.hosts[ 8].send_l2_packet(this.hosts[2].address);
    this.hosts[ 8].send_l2_packet(this.hosts[2].address);

    //this.hosts[ 9].send_l2_packet(this.hosts[3].address);
    //this.hosts[10].send_l2_packet(this.hosts[4].address);

    phase.drop_objection(this); //rasing objection

  endtask : main_phase

   
endclass : network_topology_demo


`endif  //NETWORK_TOPOLOGY_DEMO_SVH
