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

`ifndef AMIQ_ETH_SEQUENCE_LIB_SV
`define AMIQ_ETH_SEQUENCE_LIB_SV

typedef uvm_sequencer#(amiq_eth_packet) amiq_eth_sequencer;


//------------------------------------------------------------------------------
// CLASS: amiq_eth_seq_lib_default
//
// Simple sequence just send a random amiq_eth_packet.
//
//------------------------------------------------------------------------------

class amiq_eth_seq_lib_default extends uvm_sequence#(amiq_eth_packet);

  amiq_eth_packet item;

  // ***************************************************************
  // UVM registration macros
  // ***************************************************************
  `uvm_object_utils_begin(amiq_eth_seq_lib_default)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(amiq_eth_sequencer)


  //Function: new
  //
  //Constructor
 
  function new(string name = "amiq_eth_seq_lib_default");
    super.new(name);
  endfunction : new

  //Function: body
  //
  //create one random amiq_eth_packet and send out.
  
  virtual task body();
    `uvme_trace_func_start("body")
    `uvm_do(item);
    `uvme_trace_func_end("body")
  endtask : body
  
  
endclass : amiq_eth_seq_lib_default



`endif // AMIQ_ETH_SEQUENCE_LIB_SV
