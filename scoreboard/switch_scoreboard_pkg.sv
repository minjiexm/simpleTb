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

`ifndef  SWITCH_SCOREBOARD_PKG_SV
`define  SWITCH_SCOREBOARD_PKG_SV

package switch_scoreboard_pkg;

  import uvm_pkg::*;
  import uvme_pkg::*;
  import veri5_eth_pkg::*;

  `include "switch_scoreboard_checker.sv"
  `include "switch_scoreboard.sv"

endpackage : switch_scoreboard_pkg

`endif //SWITCH_SCOREBOARD_PKG_SV
