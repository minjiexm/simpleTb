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
`ifndef VERI5_ETH_PKG_SV
`define VERI5_ETH_PKG_SV


package veri5_eth_pkg;

  `include "uvm_macros.svh"

  import uvm_pkg::*;
  import uvme_pkg::*;

  `include "veri5_eth_protocol_defines.svh"
  `include "veri5_eth_defines.svh"

  `include "veri5_eth_types.svh"
  `include "veri5_eth_hdr_l2.svh"    //Layer2 header
  `include "veri5_eth_hdr_ipv4.svh"

  `include "veri5_eth_packet.svh"     //payload packet
  `include "veri5_eth_packet_l2.svh"  //Layer2 Packet
  `include "veri5_eth_packet_ipv4.svh"
  
endpackage : veri5_eth_pkg


`endif // VERI5_ETH_PKG_SV
