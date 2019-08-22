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

`ifndef VERI5_ETH_AGENT_TYPES_SVH
`define VERI5_ETH_AGENT_TYPES_SVH

// Types: veri5_eth_agent_type_e
//
// veri5_eth_agent_type_e defines the type of veri5_eth_agent.
//
// VERI5_ETH_AGENT_TYPE_Transmit
//  - Packet driver
//
// VERI5_ETH_AGENT_TYPE_Transmit
//  - Packet receiver, if in active mode will driver drdy.

typedef enum {
  VERI5_ETH_AGENT_TYPE_Transmit,
  VERI5_ETH_AGENT_TYPE_Receive
} veri5_eth_agent_type_e;

`endif // VERI5_ETH_AGENT_TYPES_SVH


