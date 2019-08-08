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

`ifndef  AMIQ_ETH_MONITOR_SV
`define  AMIQ_ETH_MONITOR_SV

//------------------------------------------------------------------------------
// CLASS: amiq_eth_monitor
//
// This monitor is used to receive amiq_eth_packet from a switch model (fake DUT).
//
//------------------------------------------------------------------------------

class amiq_eth_monitor extends uvme_monitor#(amiq_eth_packet);


  //Member: pkt_rcv_fifo
  //
  //Monitor will get the data from DUT.
  //Because in this simple TB there is no real DUT.
  //So we use this pkt_rcv_fifo to connect to a fake DUT model
  //and receive data from it.

  uvm_tlm_analysis_fifo#(amiq_eth_packet) pkt_rcv_fifo;
  
  `uvm_component_utils(amiq_eth_monitor)


  //Function: new
  //
  //Constructor

  function new (string name = "amiq_eth_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	this.pkt_rcv_fifo = new("pkt_rcv_fifo", this);
  endfunction : build_phase


  //Function: run_phase
  //
  //Standard UVM run_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
	  amiq_eth_packet pkt;
      this.pkt_rcv_fifo.get(pkt);
	  `uvme_trace_data($psprintf("Pkt Monitor %s recevied a packet %s from pkt_rcv_fifo", this.get_full_name(), pkt.convert2string()))
	  this.item_collected_port.write(pkt);
    end

  endtask : run_phase


endclass : amiq_eth_monitor


`endif //AMIQ_ETH_MONITOR_SV
