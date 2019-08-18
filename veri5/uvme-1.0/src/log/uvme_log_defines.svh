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

`ifndef UVME_LOG_MACROS_SVH
`define UVME_LOG_MACROS_SVH

//-----------------------------------------------------------------------------
// Title: Log Macros
//
// These macros are used to unify log msg print format for some scenarios
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_trigger_event
//
//|  `uvme_trace_trigger_event(event_name, description)
//
//Parameters:
//  event_name - string name of the event
//  desc       - string description of the event, usally should put this.get_full_name()
//               so that you will know where the event been triggered. 
//
//Example:
//| uvm_event myEvent = new;
//| `uvme_trace_trigger_event(myEvent.get_name(), this.get_full_name())
//
// Print event trigger information for trace;
//-----------------------------------------------------------------------------
`define uvme_trace_trigger_event(eventName, desc) \
  `uvm_info(uvme_log::trace_event, $psprintf("[%s] %s triggered", desc, eventName), uvme_log::trace_event_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_wait_event
//
//|  `uvme_trace_wait_event(event_name, description)
//
//Parameters:
//  event_name - string name of the event
//  desc       - string description of the event, usally should put this.get_full_name()
//               so that you will know where the event been triggered. 
//
//Example:
//| uvm_event myEvent = new;
//| `uvme_trace_wait_event(myEvent.get_name(), this.get_full_name())
//| myEvent.wait_trigger();
//
// Print wait for event information for trace;
// This should be called before event.wait_trigger();
//-----------------------------------------------------------------------------
`define uvme_trace_wait_event(eventName, desc) \
  `uvm_info(uvme_log::trace_event, $psprintf("[%s] Start to wait for %s to be trigger!", desc, eventName), uvme_log::trace_event_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_capture_event
//
//|  `uvme_trace_capture_event(event_name, description)
//
//Parameters:
//  event_name - string name of the event
//  desc       - string description of the event, usally should put this.get_full_name()
//               so that you will know where the event been triggered. 
//
//Example:
//| uvm_event myEvent = new;
//| myEvent.wait_trigger();
//| `uvme_trace_capture_event(myEvent.get_name(), this.get_full_name())
//
// Print after captured event.trigger information for trace;
// This should be called after event.wait_trigger();
//-----------------------------------------------------------------------------
`define uvme_trace_capture_event(eventName, desc) \
  `uvm_info(uvme_log::trace_event, $psprintf("[%s] Captured %s trigger!", desc, eventName), uvme_log::trace_event_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_data
//
//| `uvme_trace_data(msg)
//
// Print data information for trace;
//-----------------------------------------------------------------------------
`define uvme_trace_data(msg) \
  `uvm_info(uvme_log::trace_data, $psprintf("[%s] %s", this.get_type_name(), msg), uvme_log::trace_data_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_connect
//
//| `uvme_trace_connect(msg)
//
// Print connect information for trace;
//-----------------------------------------------------------------------------
`define uvme_trace_connect(msg) \
  `uvm_info(uvme_log::trace_connect, $psprintf("[%s] %s", this.get_type_name(), msg), uvme_log::trace_connect_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_debug
//
//| `uvme_trace_debug(msg)
//
// Print a temp debug message;
//-----------------------------------------------------------------------------

`define uvme_trace_debug(msg) \
  `uvm_info(uvme_log::trace_debug, $psprintf("[%s] %s", this.get_type_name(), msg), uvme_log::trace_debug_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_func_start
//
//| `uvme_trace_func_start(funcName)
//
// Print a message when a function started for trace function exec sequence;
//-----------------------------------------------------------------------------

`define uvme_trace_func_start(func) \
  `uvm_info(uvme_log::trace_debug, $psprintf("[Func %s::%s] ........ Started ........", this.get_type_name(), func), uvme_log::trace_debug_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_func_end
//
//| `uvme_trace_func_end(funcName)
//
// Print a message when a function ended for trace function exec sequence;
//-----------------------------------------------------------------------------

`define uvme_trace_func_end(func) \
  `uvm_info(uvme_log::trace_debug, $psprintf("[Func %s::%s] ........ Ended ........", this.get_type_name(), func), uvme_log::trace_debug_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_task_start
//
//| `uvme_trace_task_start(taskName)
//
// Print a message when a task started for trace function exec sequence;
//-----------------------------------------------------------------------------

`define uvme_trace_task_start(taskName) \
  `uvm_info(uvme_log::trace_debug, $psprintf("[Task %s::%s] ........ Started ........", this.get_type_name(), taskName), uvme_log::trace_debug_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_task_ended
//
//| `uvme_trace_task_end(taskName)
//
// Print a message when a task ended for trace function exec sequence;
//-----------------------------------------------------------------------------

`define uvme_trace_task_end(taskName) \
  `uvm_info(uvme_log::trace_debug, $psprintf("[Task %s::%s] ........ Ended ........", this.get_type_name(), taskName), uvme_log::trace_debug_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_arg
//
//| `uvme_trace_arg(msg)
//
// Print messages for tracing get command line args history;
//-----------------------------------------------------------------------------

`define uvme_trace_arg(msg) \
  `uvm_info(uvme_log::trace_arg, $psprintf("[%s] %s", this.get_type_name(), msg), uvme_log::trace_arg_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_cnt
//
//| `uvme_trace_cnt(msg)
//
// Print messages for tracing counter change value;
//-----------------------------------------------------------------------------

`define uvme_trace_cnt(msg) \
  `uvm_info(uvme_log::trace_cnt, $psprintf("[%s::%s] %s",this.get_type_name(), this.get_full_name(), msg), uvme_log::trace_cnt_verb)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trce_cnt_format
//
//| `uvme_trce_cnt_format(counter_name, counter_value_before, counter_value_after_change, reason)
//
// Unifiy the message style for Printing tracing counter messages.
//-----------------------------------------------------------------------------
`define uvme_trce_cnt_format(counter_name, counter_value_before, counter_value_after_change, reason) \
  $psprintf("Counter: %s    Before:    %0d    After: %0d    Reason: %s", counter_name, counter_value_before, counter_value_after_change, reason)



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_cnt_incr
//
//| `uvme_trace_cnt_incr(counter_name, counter_value_before, counter_value_after_change, reason)
//
// Print messages for tracing counter increment history.
//-----------------------------------------------------------------------------
`define uvme_trace_cnt_incr(counter_name, counter_value_before, counter_value_after_change, reason) \
  `uvme_trace_cnt($psprintf("[INCR] %s", `uvme_trce_cnt_format(counter_name, counter_value_before, counter_value_after_change, reason)))



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_cnt_decr
//
//| `uvme_trace_cnt_decr(counter_name, counter_value_before, counter_value_after_change, reason)
//
// Print messages for tracing counter decrement history.
//-----------------------------------------------------------------------------

`define uvme_trace_cnt_decr(counter_name, counter_value_before, counter_value_after_change, reason) \
  `uvme_trace_cnt($psprintf("[DECR] %s", `uvme_trce_cnt_format(counter_name, counter_value_before, counter_value_after_change, reason)))



//-----------------------------------------------------------------------------
// MACRO: `uvme_trace_cnt_report
//
//| `uvme_trace_cnt_report(counter_name, counter_value)
//
// Report the counter value
//-----------------------------------------------------------------------------

`define uvme_trace_cnt_report(counter_name, counter_value) \
  `uvme_trace_cnt($psprintf("[REPORT] Counter: %s    Value: %0d", counter_name, counter_value), UVM_LOW)



//-----------------------------------------------------------------------------
// MACRO: `uvme_out_of_range
//
//| `uvme_out_of_range(msg, warning)
//| `uvme_out_of_range(msg, error)
//| `uvme_out_of_range(msg, fatal)
//
// Print messages for out of range error;
//-----------------------------------------------------------------------------

`define uvme_out_of_range(msg, errType) \
  `uvm_``errType(uvme_log::out_of_range_msg_id, $psprintf("[%s] %s", this.get_type_name(), msg))



//-----------------------------------------------------------------------------
// MACRO: `uvme_data_mismatch
//
//| `uvme_data_mismatch(msg, error)
//| `uvme_type_mismatch(msg, fatal)
//
// Print Error message when $cast type is mismatch ;
//-----------------------------------------------------------------------------
`define uvme_data_mismatch(msg, errType) \
  `uvm_``errType(uvme_log::data_mismatch_msg_id, $psprintf("[%s] %s", this.get_type_name(), msg))



//-----------------------------------------------------------------------------
// MACRO: `uvme_type_mismatch
//
//| `uvme_type_mismatch($psprintf("[%s] Failed to cast %s type %s to dst", src.get_type_name(), src_get_type_name()), error)
//| `uvme_type_mismatch($psprintf("[%s] Failed to cast %s type %s to dst", src.get_type_name(), src_get_type_name()), fatal)
//
// Print Error message when $cast type is mismatch ;
//-----------------------------------------------------------------------------
`define uvme_type_mismatch(msg, errType) \
  `uvm_``errType(uvme_log::type_mismatch_msg_id, $psprintf("[%s] %s", this.get_type_name(), msg))


//-----------------------------------------------------------------------------
// MACRO: `uvme_type_mismatch_error
//
//| `uvme_type_mismatch_error(expType, actType)
//
// Print Error message when $cast type is mismatch ;
//-----------------------------------------------------------------------------

`define uvme_type_mismatch_error(target, src) \
  `uvm_error(uvme_log::type_mismatch_msg_id, $psprintf(`"[%s] Fail to cast %s type %s to %s`", this.get_type_name(), src.get_full_name(), src.get_type_name(), target))


//-----------------------------------------------------------------------------
// MACRO: `uvme_type_mismatch_fatal
//
//| `uvme_type_mismatch_fatal(expType, actType)
//
// Print Fatal message when $cast type is mismatch ;
//-----------------------------------------------------------------------------

`define uvme_type_mismatch_fatal(target, src) \
  `uvm_fatal(uvme_log::type_mismatch_msg_id, $psprintf(`"[%s] Fail to cast %s type %s to %s`", this.get_type_name(), src.get_full_name(), src.get_type_name(), target))




//-----------------------------------------------------------------------------
// MACRO: `uvme_no_child_imp_error
//
//| `uvme_no_child_imp_error(funcTaskName)
//
// Report error message when the function should not be called by the 
// parent class and should be implement by a derived class. 

`define uvme_no_child_imp_error(funcTaskName) \
  `uvm_error(uvme_log::no_child_imp_msg_id, \
                 $psprintf("%s should not be called in class type %s! It must be overwritten and implement by a child class", \
				     funcTaskName, this.get_type_name))




//-----------------------------------------------------------------------------
// MACRO: `uvme_no_child_imp_fatal
//
//| `uvme_no_child_imp_fatal(funcTaskName)
//
// Report error message when the function should not be called by the 
// parent class and should be implement by a derived class. 

`define uvme_no_child_imp_fatal(funcTaskName)\
  `uvm_fatal(uvme_log::no_child_imp_msg_id,  \
                $psprintf("%s should not be called in class type %s! It must be overwritten and implement by a child class!", \
  				    funcTaskName, this.get_type_name))



//-----------------------------------------------------------------------------
// MACRO: `uvme_error
//
//| `uvme_error(msg)
//
// Report error message

`define uvme_error(msg) \
  `uvm_error(this.get_type_name(), $psprintf("[%s] %s", this.get_name(), msg))




//-----------------------------------------------------------------------------
// MACRO: `uvme_fatal
//
//| `uvme_fatal(msg)
//
// Report fatal message

`define uvme_fatal(msg) \
  `uvm_fatal(this.get_type_name(), $psprintf("[%s] %s", this.get_name(), msg))



//-----------------------------------------------------------------------------
// MACRO: `uvme_info
//
//| `uvme_info(msg, verb)
//
// Report error message when the function should not be called by the 
// parent class and should be implement by a derived class. 

`define uvme_info(msg, verb) \
  `uvm_info(this.get_type_name(), $psprintf("[%s] %s", this.get_name(), msg), verb)




//-----------------------------------------------------------------------------
// MACRO: `uvme_set_report_server
//
//| `uvme_set_report_server
//
// Setup report message format.

`define uvme_set_report_server \
  begin \
    uvme_log_report_server report_server = new(); \
	uvm_report_server::set_server(report_server); \
  end
  


`endif  // UVME_LOG_MACROS_SVH
