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

`ifndef UVME_CHECKER_DEFINES_SVH
`define UVME_CHECKER_DEFINES_SVH

//-----------------------------------------------------------------------------
// Title: Checker Macros
//
// These macros are used to identify the type of checker
//-----------------------------------------------------------------------------


// Types: uvme_checker_type_e
//
// uvme_checker_type_e defines the type of checker.
//
// UVME_CHECKER_TYPE_Inorder
// - in queue will in order, and no drop behavior expected.
// Performance is the best
//
// UVME_CHECKER_TYPE_Inorder_drop
// - in queue will in order, and drop behavior are expected.
//
// UVME_CHECKER_TYPE_Outorder
// - in queue will out of order, and no drop behavior expected.
//
// UVME_CHECKER_TYPE_Outorder_drop
// - in queue will out of order, and drop behavior are expected.

typedef enum {
  UVME_CHECKER_TYPE_Inorder,
  UVME_CHECKER_TYPE_Inorder_drop,
  UVME_CHECKER_TYPE_Outorder,
  UVME_CHECKER_TYPE_Outorder_drop
} uvme_checker_type_e;





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
  


`endif  // UVME_CHECKER_DEFINES_SVH
