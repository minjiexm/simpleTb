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

import uvm_pkg::*;

`include "uvme_pkg.sv"
import uvme_pkg::*;

`include "veri5_eth_pkg.sv"
import veri5_eth_pkg::*;

`include "veri5_eth_agent_pkg.sv"
import veri5_eth_agent_pkg::*;

`include "network_pkg.sv"
import network_pkg::*;

`include "pin_agent_pkg.sv"
import pin_agent_pkg::*;

`include "switch_model_pkg.sv"
import switch_model_pkg::*;

`include "switch_scoreboard_pkg.sv"
import switch_scoreboard_pkg::*;


`include "switch_DUT_model.sv"
`include "switch_DUT_interface.sv"
`include "switch_DUT_core.sv"
`include "switch_verif_drv_mon_subenv.sv"
`include "switch_verif_env.sv"

`include "network_topology_demo.svh"

`include "network_test.svh"
