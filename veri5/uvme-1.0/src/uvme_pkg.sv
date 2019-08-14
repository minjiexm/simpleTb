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
`ifndef UVME_PKG_SV
`define UVME_PKG_SV

  
package uvme_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;

  `include "uvme_macros.svh"

  `include "log/uvme_log.svh"
  `include "log/uvme_log_report_server.svh"
 
  `include "common/uvme_common.svh"
  `include "common/uvme_counter.svh"

  `include "layer/uvme_layer_callback.svh"
  `include "layer/uvme_layer_sequence.svh"
  `include "layer/uvme_layer_receiver.svh"
  `include "layer/uvme_layer_input.svh"
  `include "layer/uvme_layer_output.svh"

  `include "analysis/uvme_analysis_callback.svh"
  `include "analysis/uvme_analysis_input.svh"
  `include "analysis/uvme_analysis_output.svh"

  `include "event/uvme_event_pool.svh"

  `include "agent/uvme_agent.svh"
  `include "agent/uvme_agent_env.svh"

  `include "args/uvme_args.svh"

  `include "transaction/uvme_transaction.svh"

  `include "checker/uvme_checker.svh" 
  `include "checker/uvme_checker_array.svh"
  
endpackage : uvme_pkg

`endif

