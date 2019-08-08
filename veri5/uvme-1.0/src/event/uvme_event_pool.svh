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
`ifndef UVME_EVENT_POOL_SV
`define UVME_EVENT_POOL_SV

//------------------------------------------------------------------------------
//
// CLASS: uvme_event_pool
//
// The uvme_event_pool class is an enhancement class on top of uvm_event_pool.
// User no need to create uvm_event explicitly.
// User can directly call uvme_event_pool::trigger("myEvent"); and
// uvme_event_pool::wait_trigger("myEvent");
// There are build-in trace message print to help debug.
//------------------------------------------------------------------------------

class uvme_event_pool extends uvm_event_pool;

  static string glb_domain = "GLB";
  protected static int unsigned m_event_cnt[string];

  // Function: trigger
  //
  // Use event_name plus domain to tigger an event.
  // Domain means we can use same event name within different domain.
  // 
  //Parameters:
  //  event_name - string name of the event
  //  desc       - string description of the event, usally should put this.get_full_name()
  //               so that you will know where the event been triggered. 
  //  domain     - usally no need to pass, if you instance two top in one event, might need 
  //               use domain to seperate to event with same name.
  //
  //For example:
  //| uvme_event_pool::trigger("PKT_SEND_OUT", agentA.get_full_name());
  //| uvme_event_pool::trigger("PKT_SEND_OUT", agentB.get_full_name());

  static function void trigger(string event_name, string desc, string domain = uvme_event_pool::glb_domain);
    string ev_name;
    uvm_event ev;

    ev_name = {domain, "::", event_name};
    ev = uvm_event_pool::get_global(ev_name);

    ev.trigger();
    `uvme_trace_trigger_event(ev_name, desc)
  endfunction : trigger


  // Function: wait_trigger
  //
  // Use event_name plus domain to wait an event.
  // Domain means we can use same event name within different domain.
  // 
  //For example:
  //| uvme_event_pool::wait_trigger("PKT_SEND_OUT", agentA.get_name());
  //| uvme_event_pool::wait_trigger("PKT_SEND_OUT", agentB.get_name());
 
  static task wait_trigger(string event_name, string desc, string domain = uvme_event_pool::glb_domain);
    string ev_name;
    uvm_event ev;

    ev_name = {domain, "::", event_name};
    ev = uvm_event_pool::get_global(ev_name);

    if(uvme_event_pool::m_event_cnt.exists(ev_name))
      uvme_event_pool::m_event_cnt[ev_name]++;
    else
      uvme_event_pool::m_event_cnt[ev_name] = 1;

	`uvme_trace_wait_event(ev_name, desc)
    ev.wait_trigger();
	`uvme_trace_capture_event(ev_name, desc)
    ev.reset();
    uvme_event_pool::m_event_cnt[ev_name]--;

  endtask : wait_trigger


  // Function: report
  //
  // This function should be called at report_phase.
  // If user call wait_trigger() but the event never triggered.
  // It will report error to warning you that there is a event is still
  // waiting for be triggered.

  static function void report();
    foreach(uvme_event_pool::m_event_cnt[ev_name]) begin
      if(uvme_event_pool::m_event_cnt[ev_name] != 0) begin
        `uvm_error(uvme_log::trace_event, $psprintf("[Report] Some thread is still waiting for uvm_event %s", ev_name))
      end
    end
  endfunction : report


endclass : uvme_event_pool


`endif //UVME_EVENT_POOL_SVH

