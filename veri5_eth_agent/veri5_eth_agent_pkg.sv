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

`ifndef  VERI5_ETH_AGENT_PKG_SV
`define  VERI5_ETH_AGENT_PKG_SV

package veri5_eth_agent_pkg;

  import uvm_pkg::*;
  import uvme_pkg::*;
  import veri5_eth_pkg::*;

  `include "veri5_eth_sequence_lib.sv"

  //define all base class
  //veri5_eth_packet_driver_base
  //veri5_eth_packet_monitor_base
  //veri5_eth_packet_agent_base
  //veri5_eth_packet_agent_env_base
  `uvme_agent_base_pkg(veri5_eth_packet)

  `include "veri5_eth_driver.sv"
  `include "veri5_eth_monitor.sv"
  `include "veri5_eth_agent_config.sv"
  `include "veri5_eth_agent.sv"
  `include "veri5_eth_agent_subenv.sv"

endpackage : veri5_eth_agent_pkg

`endif //VERI5_ETH_AGENT_PKG_SV
