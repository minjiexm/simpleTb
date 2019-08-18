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


  //Member: pkt_drv_port
  //
  //veri5_eth_driver will send the data to fake DUT through this port.

  uvm_analysis_port#(veri5_eth_packet) dut_port;

  uvm_analysis_port#(veri5_eth_packet) model_port;

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
	this.dut_port   = new("dut_port", this);
	this.model_port = new("model_port", this);
  endfunction : build_phase


  //Function: run_phase
  //
  //Standard UVM run_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);

	  begin
	    veri5_eth_packet pkt4model;
		`uvme_cast(pkt4model, req.clone(), fatal)
        `uvme_trace_data($psprintf("[run_phase] Send the packet %s to Ref Model", pkt4model.convert2string()))
        this.model_port.write(pkt4model); //drive to refmodel
      end

      #100ns;  //wait for 100ns then start to send the packet, mimic DUT process delay
      begin //drive DUT
	    veri5_eth_packet pkt4dut;
		`uvme_cast(pkt4dut, req.clone(), fatal)
        `uvme_trace_data($psprintf("[run_phase] Send the packet %s to DUT", pkt4dut.convert2string()))
        this.dut_port.write(pkt4dut);  //drive to DUT
      end

      seq_item_port.item_done();

	  this.rsp_port.write(req);  //send req back as response
    end
  endtask : run_phase


endclass : veri5_eth_driver


`endif //VERI5_ETH_DRIVER_SV
