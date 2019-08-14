//
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------
`ifndef UVME_LAYER_RECEIVER_SV
`define UVME_LAYER_RECEIVER_SV

//------------------------------------------------------------------------------
//
// CLASS: uvme_layer_receiver
//
// Keep checking fifo, if the fifo is not empty will send the transaction to next layer's
// driverr.
//------------------------------------------------------------------------------

typedef class uvme_layer_input;

class uvme_layer_receiver #(type T = uvm_sequence_item) extends uvm_driver#(T);
  
  typedef uvme_layer_receiver#(T) this_type;

  protected uvme_layer_input#(T) m_parent;

  `uvm_component_param_utils_begin(this_type)
  `uvm_component_utils_end

  // Function: new
  //
  // Constructor

  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction : new


  // Function: build_phase
  //
  // Standard uvm build_phase
  // build driver and sequencer

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvme_cast(this.m_parent, this.get_parent(), fatal)
  endfunction : build_phase


  // Function: run_phase
  //
  // Standard uvm run_phase
  // Connect driver to sequencer
 
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever begin
      this.seq_item_port.get_next_item(req);
	  //`uvme_info($psprintf("[%s] Get a data from seq_item_port %s", this.get_full_name(), this.seq_item_port.get_full_name()), UVM_DEBUG)

      this.m_parent.receive_knob(req); //call parent to process the data

      this.seq_item_port.item_done();

      //just send req back as response
	  this.rsp_port.write(req);
    end

  endtask : run_phase

endclass : uvme_layer_receiver


`endif //UVME_LAYER_RECEIVER_SVH

