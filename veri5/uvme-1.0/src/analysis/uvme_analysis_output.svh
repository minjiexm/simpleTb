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
`ifndef UVME_ANALYSIS_OUTPUT_SV
`define UVME_ANALYSIS_OUTPUT_SV

//------------------------------------------------------------------------------
//
// CLASS: uvme_analysis_output
//
// analysis output has two side.
//   Inner side:
//     inner side the the module's inner processiong. it will call output.send to
//     send packets to the module's outside.
//
//   Out side:
//     Outside should connect to a analysis input or a sequencer.
//
//   link function should be used to connect output to outside. for example, link 
//   output to a sequencer or a input.
//
//| ------------------
//| |    module      |
//| |               ------------------------------------------------------------------
//| |               |                                                                |
//| | inner side -> | non-blocking   send()          output         analysis port -> |  out side
//| |               |                                                                |
//| |               ------------------------------------------------------------------
//| |                |
//| |----------------|
//


class uvme_analysis_output #(type T = uvm_sequence_item) extends uvm_component;
  
  typedef uvme_analysis_output#(T) this_output_type;
  typedef uvme_analysis_input#(T)  this_input_type;
  typedef uvme_analysis_callback#(T) this_cb_type;
  
  protected uvm_analysis_port#(T) m_out_port;
  
  //protected this_input_type m_neighbour_input;
  
  //Enable uvm callback
  `uvm_register_cb(this_output_type, this_cb_type)

  `uvm_component_param_utils_begin(this_output_type)
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
    this.m_out_port = new("m_out_port", this);
  endfunction : build_phase


  // Function: send
  //
  // send data to output
  // This is the blocking method to send data through output.   
  virtual function void send(T txn);
    uvme_ei_enum ei_action = UVME_EI_NONE;  //by default no error injection
    `uvm_do_callbacks(this_output_type, this_cb_type, error_inject_cbF(txn, ei_action))

    if(ei_action != UVME_EI_DROP) begin
       T data;
      `uvme_cast(data, txn.clone(), fatal);  //Create a new clone and send to next input, so that the orignal handle still can be used by local.
      `uvm_do_callbacks(this_output_type, this_cb_type, send_cbF(txn))
      `uvme_trace_data($psprintf("[send] Transmit a transaction %s", data.convert2string()))
      this.m_out_port.write(txn); //blocking put
    end

 endfunction : send


  // Function: link
  //
  // connect output to an input
  // one output can only link to one input
 
  virtual function void link(this_input_type neighbour_input);
    //`uvme_cast(this.m_neighbour_input, neighbour_input)
    this.m_out_port.connect(neighbour_input.get_imp());
    `uvme_trace_connect($psprintf("[link] ----> %s", neighbour_input.get_full_name()))
  endfunction : link



  // Function : get_neighbour
  //
  // Get connected neighbour
 
  //virtual function this_input_type get_neighbour();
  //   if(this.m_neighbour_input != null) begin
  //     return this.m_neigbour_input.get_parent();
  //   end
  //   else
  //     return null;
  //endfunction : get_neighbour



  // Function: link_fifo
  //
  // connect the output to an analysis fifo

  virtual function void link_fifo(uvm_tlm_analysis_fifo#(T) fifo);
    this.m_out_port.connect(fifo.analysis_export);
    `uvme_trace_connect($psprintf("[link_fifo] ----> %s", fifo.get_full_name()))
  endfunction : link_fifo


  // Function: link_export
  //
  // connect the output to an analysis export

  virtual function void link_export(uvm_analysis_export#(T) analysis_export);
    this.m_out_port.connect(analysis_export);
    `uvme_trace_connect($psprintf("[link_export] ----> %s", analysis_export.get_full_name()))
  endfunction : link_export


endclass : uvme_analysis_output


`endif //UVME_ANALYSIS_OUTPUT_SVH

