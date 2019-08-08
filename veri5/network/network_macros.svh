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

`ifndef NETWORK_MACROS_SVH
`define NETWORK_MACROS_SVH


//-----------------------------------------------------------------------------
// MACRO: `MAC_ADDR_SZ
//
//| `MAC_ADDR_SZ
//
// define size of mac address in network_address
//-----------------------------------------------------------------------------
`define MAC_ADDR_SZ 8



//-----------------------------------------------------------------------------
// MACRO: `network_uniq_mac_gen
//
//| `network_uniq_mac_gen(mac_addr)
//
// Generate a uniq mac address and assign to mac_addr
//-----------------------------------------------------------------------------

`define network_uniq_mac_gen(mac_addr) \
  begin \
    network_address_generator mac_gen = network_address_generator::get_inst(); \
    mac_addr = mac_gen.get_mac(); \
  end


`endif  // NETWORK_MACROS_SVH
