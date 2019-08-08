//-----------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------

`ifndef UVME_LOG_SVH
`define UVME_LOG_SVH

//------------------------------------------------------------------------------
//
// CLASS: uvme_log
//
// uvme_log class is a placeholder for predefined trace id
// Those predefined trace id can be used for customer to grep information
// from log file by use egrep command.
//
//for example:
//| egrep "TRACE::DATA" can get all data print message.
//------------------------------------------------------------------------------

class uvme_log extends uvm_object;

  //Member: uvme_log::no_child_imp_msg_id
  //
  //Some time a function should be implmented by its child class.
  //But should defined in parent class.
  //Use this message ID for this kind of protection message print.
  
  static string no_child_imp_msg_id = "NO_CHILD_IMP";


  //Member: uvme_log::type_mismatch_msg_id
  //
  //Global Type mismach message id.
  
  static string type_mismatch_msg_id = "TYPE_MISMATCH";


  //Member: uvme_log::trace_msg_id
  //
  //Prefix of all trace message id
  
  static string trace_msg_id = "TRACE";


  //Member: uvme_log::trace_event
  //
  //Global trace event message id.
  //This message id is used to trace uvm_event trigger and wait_trigger.
  
  static string trace_event = {uvme_log::trace_msg_id, "::EVENT"};
  
  
  //Member: uvme_log::trace_event_verb
  //
  //Global trace event message print verbosity, default is UVM_HIGH.
  
  static uvm_verbosity trace_event_verb = UVM_HIGH;


  //Member: uvme_log::trace_data
  //
  //Global trace data message id.
  //This message id is used to trace data process message print.
  
  static string trace_data = {uvme_log::trace_msg_id, "::DATA"};


  //Member: uvme_log::trace_data_verb
  //
  //Global trace data message print verbosity, default is UVM_HIGH.

  static uvm_verbosity trace_data_verb = UVM_HIGH;


  //Member: uvme_log::trace_connect
  //
  //Global trace connect message id.
  //This message id is used to trace connect message print.
  //For example, port connection/layer_input output connection....
  
  static string trace_connect = {uvme_log::trace_msg_id, "::CONNECT"};
  
  
  //Member: uvme_log::trace_connect_verb
  //
  //Global trace connect message print verbosity, default is UVM_HIGH.

  static uvm_verbosity trace_connect_verb = UVM_HIGH;


  //Member: uvme_log::trace_func
  //
  //Global trace function message id.
  //This message id is used to trace function exec sequence.
  
  static string trace_func = {uvme_log::trace_msg_id, "::FUNC"};

  //Member: trace_func_verb
  //
  //Global trace funcion exec message print verbosity, default is UVM_DEBUG.
 
  static uvm_verbosity trace_func_verb = UVM_DEBUG;


  //Member: uvme_log::trace_task
  //
  //Global trace task message id.
  //This message id is used to trace task exec sequence.
    
  static string trace_task = {uvme_log::trace_msg_id, "::TASK"};


  //Member: uvme_log::trace_task_verb
  //
  //Global trace task exec message print verbosity, default is UVM_DEBUG.
  
  static uvm_verbosity trace_task_verb = UVM_DEBUG;


  //Member: uvme_log::trace_args
  //
  //Global trace args message id.
  //This message id is used to trace where user to get command line args.
    
  static string trace_arg = {uvme_log::trace_msg_id, "::ARG"};


  //Member: uvme_log::trace_arg_verb
  //
  //Global trace arg getting message print verbosity, default is UVM_HIGH.
  
  static uvm_verbosity trace_arg_verb = UVM_HIGH;

  //Member: uvme_log::trace_counter
  //
  //Global trace counter message id.
  //This message id is used to trace counter value change.
    
  static string trace_cnt = {uvme_log::trace_msg_id, "::CNT"};


  //Member: uvme_log::trace_cnt_verb
  //
  //Global trace counter value change message print verbosity, default is UVM_HIGH.
  
  static uvm_verbosity trace_cnt_verb = UVM_HIGH;


endclass : uvme_log


`endif  // UVME_LOG_SVH
