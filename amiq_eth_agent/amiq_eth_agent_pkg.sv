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

`ifndef  AMIQ_ETH_AGENT_PKG_SV
`define  AMIQ_ETH_AGENT_PKG_SV

package amiq_eth_agent_pkg;

  import uvm_pkg::*;
  import uvme_pkg::*;
  import amiq_eth_pkg::*;

  `include "amiq_eth_sequence_lib.sv"

  //define all base class
  //amiq_eth_packet_driver_base
  //amiq_eth_packet_monitor_base
  //amiq_eth_packet_agent_base
  //amiq_eth_packet_agent_env_base
  `uvme_agent_base_pkg(amiq_eth_packet)

  `include "amiq_eth_driver.sv"
  `include "amiq_eth_monitor.sv"
  `include "amiq_eth_agent_config.sv"
  `include "amiq_eth_agent.sv"
  `include "amiq_eth_agent_subenv.sv"

endpackage : amiq_eth_agent_pkg

`endif //AMIQ_ETH_AGENT_PKG_SV
