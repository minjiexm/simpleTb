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

`ifndef UVME_EVENT_MACROS_SVH
`define UVME_EVENT_MACROS_SVH

//-----------------------------------------------------------------------------
// Title: Event Macros
//
// These macros are used for VIP implement.
//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// MACRO: `uvme_event_trigger()
//
//| `uvme_event_trigger("myEvent")
//
//  User use this to insert a event
//
// For example
//|  `uvme_event_trigger(myEvName)
//-----------------------------------------------------------------------------


`define uvme_event_trigger(event_name) \
  uvme_event_pool::trigger(event_name, this.get_full_name());


//-----------------------------------------------------------------------------
// MACRO: `uvme_event_wait
//
//| `uvme_event_wait("myEvent")
//
//  User use this to wait for an event
//
// For example
//|  `uvme_event_wait(myEvName)
//-----------------------------------------------------------------------------

`define uvme_event_wait(event_name) \
  uvme_event_pool::wait_trigger(event_name, this.get_full_name());


`endif  // UVME_EVENT_MACROS_SVH
