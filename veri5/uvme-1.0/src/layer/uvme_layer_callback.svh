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

`ifndef UVME_LAYER_CALLBACK_SVH
`define UVME_LAYER_CALLBACK_SVH

//------------------------------------------------------------------------------
//
// CLASS: uvme_layer_callback
//
// The uvme_layer_callback class is a wrapper for layer_callback.
// This class will be used to exchange data between layer_callback_input and
// layer_callback_output.
//------------------------------------------------------------------------------


class uvme_layer_callback #(type T = uvm_sequence_item) extends uvm_callback;

  typedef uvme_layer_callback #(T) this_type;
  
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
  // callback function for layer_input
  // Use to get data

  virtual function void receive_cbF(T txn);
  endfunction : receive_cbF


  // Function: send_cbF
  //
  // callback function for layer_output

  virtual function void send_cbF(T txn);
  endfunction : send_cbF


  // Function: error_inject_cbF
  //
  // callback function for error_injection
  // like drop or modify packet

  virtual function void error_inject_cbF(T txn, output uvme_ei_enum ei);
  endfunction : error_inject_cbF


endclass : uvme_layer_callback

`endif  //UVME_LAYER_CALLBACK_SVH
