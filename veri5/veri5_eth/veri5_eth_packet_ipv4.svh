/******************************************************************************
 * (C) Copyright 2014 VERI5 Consulting
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * NAME:        veri5_eth_packet_ipv4.sv
 * PROJECT:     veri5_eth
 * Description: This file declare base Ethernet packet.
 *              The definition of this packet is described in IEEE 802.3-2012.
 *              For more details see file docs/ieee_802.3-2012/802.3-2012_section1.pdf,
 *              chapter 3. Media Access Control (MAC) frame and packet specifications
 *******************************************************************************/

`ifndef __VERI5_ETH_PACKET_IPV4
//protection against multiple includes
`define __VERI5_ETH_PACKET_IPV4

//basic class for declaring the Ethernet packets
class veri5_eth_packet_ipv4 extends veri5_eth_packet_l2;

  `uvm_object_utils(veri5_eth_packet_ipv4)

  //constructor
  //@param name - the name assigned to the instance of this class
  function new(string name = "eth_ipv4_packet");
    super.new(name);

	begin
	  veri5_eth_hdr_ipv4 ipv4_hdr;
	  veri5_eth_hdr_l2 l2_hdr;
      ipv4_hdr = veri5_eth_hdr_ipv4::type_id::create("ipv4_hdr");
	  `uvme_cast(l2_hdr, this.get_hdr("ETH_L2"), error)
      void'( this.insert_back(l2_hdr, ipv4_hdr) );
	end
  endfunction : new


  //Function: get_ip_da
  //
  //get IP Destination Address from IPV4 Hdr
  
  function veri5_eth_ipv4_header_destination_ip_address get_ip_da(int unsigned ipv4HdIdx = 0);
    veri5_eth_hdr_ipv4 ipv4_hdr;
	`uvme_cast(ipv4_hdr, this.get_hdr("IPV4", ipv4HdIdx), error)
	return ipv4_hdr.destination_ip_address;
  endfunction : get_ip_da


  //Function: get_ip_sa
  //
  //get IP Source Address from IPV4 Hdr
  
  function veri5_eth_ipv4_header_source_ip_address get_ip_sa(int unsigned ipv4HdIdx = 0);
    veri5_eth_hdr_ipv4 ipv4_hdr;
	`uvme_cast(ipv4_hdr, this.get_hdr("IPV4", ipv4HdIdx), error)
	return ipv4_hdr.source_ip_address;
  endfunction : get_ip_sa



  //Function: set_ip_da
  //
  //Set IP Destination IP Address to IPV4 Hdr
  
  function void set_ip_da(veri5_eth_ipv4_header_destination_ip_address ipda, int unsigned ipv4HdIdx = 0);
    veri5_eth_hdr_ipv4 ipv4_hdr;
	`uvme_cast(ipv4_hdr, this.get_hdr("IPV4", ipv4HdIdx), error)
	ipv4_hdr.destination_ip_address = ipda;
  endfunction : set_ip_da


  //Function: set_ip_sa
  //
  //Set IP Source IP Address to IPV4 Hdr
  
  function void set_ip_sa(veri5_eth_ipv4_header_source_ip_address ipsa, int unsigned ipv4HdIdx = 0);
    veri5_eth_hdr_ipv4 ipv4_hdr;
	`uvme_cast(ipv4_hdr, this.get_hdr("IPV4", ipv4HdIdx), error)
	ipv4_hdr.source_ip_address = ipsa;
  endfunction : set_ip_sa


endclass : veri5_eth_packet_ipv4


`endif  //__VERI5_ETH_PACKET_IPV4
