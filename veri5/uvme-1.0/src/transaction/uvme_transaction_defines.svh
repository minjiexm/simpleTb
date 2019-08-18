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

//-----------------------------------------------------------------------------
// Title: Log Macros
//
// These macros are used to unify log msg print format for some scenarios
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// MACRO: `uvme_header_randomize
//
//|  `uvme_header_randomize(packet, hdrName)
//
// Randomize a header in a packet.
//-----------------------------------------------------------------------------

`define uvme_header_randomize(packet, hdrName) \
  begin \
    uvme_layer_header hdrName; \
    `uvme_cast(hdrName, packet.get_hdr(`"hdrName`"), error); \
    void'( hdrName.randomize() ); \
  end


//-----------------------------------------------------------------------------
// MACRO: `uvme_header_randomize_with
//
//|  `uvme_header_randomize_with(packet, hdrName, hdrType, constrint)
//
// Randomize a header in a packet.
//
// Example:
//|`uvme_header_randomize_with(eth_pkt, payload, uvme_payload_header, { length == 64;})
//-----------------------------------------------------------------------------

`define uvme_header_randomize_with(packet, hdrName, hdrType, constrint) \
  begin \
    hdrType hdrName; \
    `uvme_cast(hdrName, packet.get_hdr(`"hdrName`"), error); \
    void'( hdrName.randomize() with constrint ); \
  end


//-----------------------------------------------------------------------------
// MACRO: `uvme_get_header_field
//
//|  `uvme_get_header_field(packet, hdrName, fieldName, value)
//
// Get a field from header in a packet.
//-----------------------------------------------------------------------------

`define uvme_get_header_field(packet, hdrName, hdrType, fieldName, value) \
  begin \
    hdrType hdrName; \
	uvme_layer_header hdr = packet.get_hdr(`"hdrName`"); \
    `uvme_cast(hdrName, hdr, error); \
    value = hdrName.fieldName; \
  end



//-----------------------------------------------------------------------------
// MACRO: `uvme_set_header_field
//
//|  `uvme_set_header_field(packet, hdrName, fieldName, value)
//
// Set value to a field within a header in a packet.
//-----------------------------------------------------------------------------

`define uvme_set_header_field(packet, hdrName, hdrType, fieldName, value) \
  begin \
    hdrType hdrName; \
	uvme_layer_header hdr = packet.get_hdr(`"hdrName`"); \
    `uvme_cast(hdrName, hdr, error); \
    hdrName.fieldName = value; \
  end



//-----------------------------------------------------------------------------
// MACRO: `uvme_header_print()
//
//|  `uvme_header_randomize(packet, hdrName)
//
// Randomize a header in a packet.
//-----------------------------------------------------------------------------

`define uvme_header_print(packet, hdrName, headType, func) \
  begin \
    headType hdrName; \
    `uvme_cast(hdrName, packet.get_hdr(`"hdrName`"), error); \
    hdrName.func; \
  end
