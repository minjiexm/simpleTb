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

`ifndef  VERI5_ETH_DRIVER_SV
`define  VERI5_ETH_DRIVER_SV


//------------------------------------------------------------------------------
// CLASS: veri5_eth_driver
//
// Fake driver which will send the veri5_eth_packet received from sequencer to
// a switch model (fake DUT).
//
//------------------------------------------------------------------------------

class veri5_eth_driver extends veri5_eth_packet_driver_base; 

  bit srdy;
  int unsigned initial_delay = 10;

  //Member: vif
  //Virtual interface for driving signals
  
  virtual veri5_eth_intf vif;

  `uvm_component_utils(veri5_eth_driver)

  //Function: new
  //
  // Constructor

  function new (string name = "veri5_eth_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    if( !uvm_config_db#(virtual veri5_eth_intf)::get(this, "", "vif", this.vif) ) begin
      `uvm_error(this.get_type_name(), $psprintf("[build_phase] %s can not get veri5_eth_intf from config db", this.get_name()))
    end
  endfunction : build_phase


  //Function: run_phase
  //
  //Standard UVM run_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
	
	this.drive_idle();
	
	repeat(this.initial_delay) @vif.transmit;
	
    forever begin
      seq_item_port.get_next_item(req);

      @vif.transmit;

	  this.drive_packet(req);
      `uvme_trace_data($psprintf("[drive_packet] Done of sending the packet %s to DUT", req.convert2string()))

      seq_item_port.item_done();

	  this.rsp_port.write(req);  //send req back as response

    end
  endtask : run_phase


  // Function: drive packet
  //
  // drive a single packet
  
  virtual task drive_packet(veri5_eth_packet pkt);
    int unsigned byte_idx = 0;
    bit [7:0] pkt_data[];

	if(!pkt.pack_bytes(pkt_data))
  	  return;

	//pkt.print();

    while( byte_idx < pkt_data.size() ) begin
      //@vif.transmit;

      this.drive_srdy(1);

      if( !this.srdy )
        continue;

      if(byte_idx == 0) begin
        vif.transmit.sop  <= 1;
	  end
      else
        vif.transmit.sop  <= 0;

      if(byte_idx == (pkt_data.size()-1))
        vif.transmit.eop  <= 1;
      else
        vif.transmit.eop  <= 0;

      vif.transmit.data <= pkt_data[byte_idx++];

      do begin  //wait for drdy valid then can send next data
        @vif.transmit;
      end
      while( vif.transmit.drdy !== 1);
	  
    end

    this.drive_idle();

  endtask : drive_packet



  // Function: drive_srdy
  //
  // drive srdy signal
  
  virtual task drive_srdy(input bit ready);
    vif.transmit.srdy <= ready;
	this.srdy = ready;
  endtask : drive_srdy



  // Function: drive_idle
  //
  // drive idle status to bus
  
  virtual task drive_idle();
    this.drive_srdy(0);
	vif.transmit.data <= 0;
	vif.transmit.sop  <= 0;
	vif.transmit.eop  <= 0;
  endtask : drive_idle


endclass : veri5_eth_driver


`endif //VERI5_ETH_DRIVER_SV
