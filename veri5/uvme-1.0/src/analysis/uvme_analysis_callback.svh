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

`ifndef UVME_ANALYSIS_CALLBACK_SVH
`define UVME_ANALYSIS_CALLBACK_SVH

//------------------------------------------------------------------------------
//
// CLASS: uvme_analysis_callback
//
// The uvme_analysis_callback class is the callback class used to some modify
// or even drop the transactions with out change the inerr codes of model.
//------------------------------------------------------------------------------


class uvme_analysis_callback #(type T = uvm_sequence_item) extends uvm_callback;

  typedef uvme_analysis_callback #(T) this_type;
  
  `uvm_object_param_utils_begin(this_type)
  `uvm_object_utils_end

  // Function: new
  //
  // Construction

  function new (string name = "trans");
    super.new(name);
  endfunction : new


  // Function: receive_cbF
  //
  // callback function for analysis_input
  // Use to get data

  virtual function void receive_cbF(T txn);
  endfunction : receive_cbF


  // Function: send_cbF
  //
  // callback function for analysis_output

  virtual function void send_cbF(T txn);
  endfunction : send_cbF


  // Function: error_inject_cbF
  //
  // callback function for error_injection
  // like drop or modify packet

  virtual function void error_inject_cbF(T txn, output uvme_ei_enum ei);
  endfunction : error_inject_cbF


endclass : uvme_analysis_callback


`endif  //UVME_ANALYSIS_CALLBACK_SVH
