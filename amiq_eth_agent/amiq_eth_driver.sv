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

`ifndef  AMIQ_ETH_DRIVER_SV
`define  AMIQ_ETH_DRIVER_SV


//------------------------------------------------------------------------------
// CLASS: amiq_eth_driver
//
// Fake driver which will send the amiq_eth_packet received from sequencer to
// a switch model (fake DUT).
//
//------------------------------------------------------------------------------

class amiq_eth_driver extends uvme_driver#(amiq_eth_packet); 


  //Member: pkt_drv_port
  //
  //amiq_eth_driver will send the data to fake DUT through this port.

  uvm_analysis_port#(amiq_eth_packet) pkt_drv_port;

  `uvm_component_utils(amiq_eth_driver)


  //Function: new
  //
  // Constructor

  function new (string name = "amiq_eth_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	this.pkt_drv_port = new("pkt_drv_port", this);
  endfunction : build_phase


  //Function: run_phase
  //
  //Standard UVM run_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);

      `uvm_info(this.get_type_name(), $psprintf("Get a packet from Seqr"), UVM_LOW)

      this.pkt_drv_port.write(req);  //send to analysis_port

      seq_item_port.item_done();

      begin
        amiq_eth_packet rsp = amiq_eth_packet::type_id::create("rsp");
	    rsp.set_id_info(req);
	    this.rsp_port.write(rsp);
      end
    end
  endtask : run_phase


endclass : amiq_eth_driver


`endif //AMIQ_ETH_DRIVER_SV
