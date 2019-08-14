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

`ifndef SWITCH_MODEL_SV
`define SWITCH_MODEL_SV

typedef class switch_model_config;
typedef class switch_model_auto_init;

`uvme_analysis_input_imp_with_label_decl(switch_model, packet_processing)

//------------------------------------------------------------------------------
//
// CLASS: switch_model
//
// switch_model is a simple behavior model of switch.
// It will protend a DUT in this simple demo.
//
// switch_model current only support mac address lookup function.
// It can forwad the packet to the right port and also havs simple flood feature.
// User can use +SWITCH_MODEL::PORT_NUM=4 to define the number of ports of the
// switch_model, by default the port_num is 4.
//
// All ports type are uvme_analysis_input and uvme_analysis_output.
// User should connect those ports to DUT agents.
//------------------------------------------------------------------------------

class switch_model extends uvm_agent;

  switch_model_config cfg;
  switch_mac_table mac_table;

  switch_model_auto_init auto_init;

  typedef `uvme_analysis_input_imp(amiq_eth_packet, switch_model, packet_processing) sw_input_type;

  //Member: in_port[]
  //
  //Receive amiq_eth_packet from actie Agent.driver
  
  sw_input_type                       in_port[];
  

  //Member: out_port[]
  //
  //Send amiq_eth_packet to Passive Agent.monitor

  uvme_analysis_output#(amiq_eth_packet) out_port[];


  //uvm factory declare macro
  `uvm_component_utils_begin(switch_model)
    `uvm_field_object(cfg, UVM_ALL_ON)
    `uvm_field_object(mac_table, UVM_ALL_ON)
    `uvm_field_object(auto_init, UVM_ALL_ON)
    `uvm_field_array_object(in_port, UVM_ALL_ON)
    `uvm_field_array_object(out_port, UVM_ALL_ON)
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

    if(!uvm_config_db #(switch_model_config)::get(this, "", "cfg", this.cfg)) begin	
      this.cfg = switch_model_config::type_id::create("cfg");
	  void'( uvm_config_db#(int)::get(this, "", "port_size", this.cfg.port_num) );
    end

    //this.cfg.print();

    this.mac_table = switch_mac_table::type_id::create("mac_table");

    this.auto_init = switch_model_auto_init::type_id::create("auto_init", this);

    this.in_port = new[this.cfg.port_num];

    this.out_port = new[this.cfg.port_num];

    for(int pidx=0; pidx<this.cfg.port_num; pidx++) begin
      this.in_port[pidx] = new(uvme_pkg::name_in_array("in_port", pidx), this);
	  this.in_port[pidx].set_label(pidx);
      this.out_port[pidx] = new(uvme_pkg::name_in_array("out_port", pidx), this);
    end

  endfunction : build_phase


  //
  //Function : connect_phase
  //

  //virtual function void connect_phase(uvm_phase phase);
  //  super.connect_phase(phase);
  //endfunction : connect_phase


  //Function: packet_processing
  //
  //Parameters:
  // - src_pidx : port index the packet received
  // Once switch received packet from in_port will trigger packetprocessing
 
  virtual function void packet_processing(amiq_eth_packet pkt, int unsigned src_pidx);
    int unsigned dst_pidx; //destination port index
    `uvm_info(this.get_type_name(), $psprintf("[%s] Ingeress received a packet from Port %0d", this.get_name(), src_pidx), UVM_LOW)

    //DA lookup;
    if( this.mac_table.lookup(pkt.destination_address, dst_pidx) ) begin
	  `uvme_trace_data($psprintf("[packet_proc] Unicast to Port : %0d  Packet : %s", dst_pidx, pkt.convert2string()))
      this.out_port[dst_pidx].send(pkt);
    end
    else begin //flood the packet to all port
      `uvm_info(this.get_type_name(), $psprintf("[%s] packet_processing : Lookup DA missed! Flood the packet to all ports!", this.get_name()), UVM_LOW)
      this.flood(pkt, src_pidx);
    end

    //SA lookup
    //update src port in mac table
    this.mac_table.lookup_learn(pkt.source_address, src_pidx);

  endfunction : packet_processing



  //Function: flood
  //
  // When use dst_mac lookup mac table and missed, switch will flood the packet to all ports.
  // flood : L2 Broadcast
  //

  virtual function void flood(amiq_eth_packet pkt, int unsigned src_pidx);
    foreach(this.out_port[port_idx]) begin
      if(port_idx != src_pidx) begin
	    `uvme_trace_data($psprintf("[flood] Flood to Port : %0d  Packet : %s", port_idx, pkt.convert2string()))
        this.out_port[port_idx].send(pkt);
      end
    end
  endfunction : flood


endclass : switch_model


`endif // SWITCH_MODEL_SV
