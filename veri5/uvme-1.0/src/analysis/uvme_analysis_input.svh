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
`ifndef UVME_ANALYSIS_INPUT_SV
`define UVME_ANALYSIS_INPUT_SV

//------------------------------------------------------------------------------
//
// CLASS: uvme_analysis_input
//
// Keep checking fifo, if the fifo is not empty will send the transaction
// to next analysis's input.
//------------------------------------------------------------------------------

typedef class uvme_analysis_output;

class uvme_analysis_input #(type T = uvm_sequence_item) extends uvm_component;
  
  typedef uvme_analysis_input#(T) this_input_type;
  typedef uvme_analysis_output#(T) this_output_type;

  typedef uvme_analysis_callback#(T) this_cb_type;
  typedef uvm_analysis_imp#(T, this_input_type) this_imp_type;

  protected this_imp_type m_imp;

  protected int unsigned m_label = 0;
    
  //Enable uvm callback
  `uvm_register_cb(this_input_type, this_cb_type)

  `uvm_component_param_utils_begin(this_input_type)
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
    this.m_imp = new("m_imp", this);
  endfunction : build_phase


  // Function : connect_phase
  //
  // Standard uvm connect_phase
  // Connect driver to sequencer
 
  //virtual function void connect_phase(uvm_phase phase);
  //  super.connect_phase(phase);
  //endfunction : connect_phase


  // Function: input_process
  //
  // Hooker to parent class.
  // User should overwrite this function.

  virtual function void receive(T txn);
    `uvme_no_child_imp_error("receive")
  endfunction : receive


  // Function : write
  //
  // When receiver get a data from sequencer, receive_know() will be
  // called 

  virtual function void write(T txn);
    T data;
    uvme_ei_enum ei_action = UVME_EI_NONE;
    `uvme_cast(data, txn.clone(), fatal); //create a local copy for further use
    `uvme_trace_data($psprintf("Input %s Received a transaction from %s", this.get_full_name(), data.convert2string()))
    `uvm_do_callbacks(this_input_type, this_cb_type, error_inject_cbF(data, ei_action))

    if(ei_action != UVME_EI_DROP) begin
      `uvm_do_callbacks(this_input_type, this_cb_type, receive_cbF(data))
      this.receive(data);
    end
    else
      `uvm_info("EI::DROP", $psprintf("[write] Drop the packet because receive UVME_EI_DROP from error_injuect_cbF : %s", data.convert2string()), UVM_DEBUG)

  endfunction : write


  // Function: link
  //
  // Used to connect uvme_transaction_input to
  // a uvme_transaction_output.
  // Use egrep "TRACE::CONNECT" log to get link information

  virtual function void link(this_output_type neighbour_output);
    neighbour_output.link(this);
  endfunction : link


  // Function: set_label
  //
  // Used for input group, each group has a uniq index called label,
  // Use this function to set the label.
  // this function should be used when using `uvme_analysis_input_imp_with_label_decl

  function void set_label(input int unsigned label);
    this.m_label = label;
  endfunction : set_label


  // Function: get_imp
  //
  // This should only called by analysis output for connection

  function this_imp_type get_imp();
    return this.m_imp;
  endfunction : get_imp


endclass : uvme_analysis_input


`endif //UVME_ANALYSIS_INPUT_SVH

