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
 * NAME:        veri5_eth_packet_l2.sv
 * PROJECT:     veri5_eth
 * Description: This file declare base Ethernet packet.
 *              The definition of this packet is described in IEEE 802.3-2012.
 *              For more details see file docs/ieee_802.3-2012/802.3-2012_section1.pdf,
 *              chapter 3. Media Access Control (MAC) frame and packet specifications
 *******************************************************************************/

`ifndef __VERI5_ETH_PACKET_L2
`define __VERI5_ETH_PACKET_L2

//basic class for declaring the Ethernet packets with Layer 2 Header
class veri5_eth_packet_l2 extends veri5_eth_packet;

  veri5_eth_fcs fcs; //4bytes crc for ether header

  `uvm_object_utils_begin(veri5_eth_packet_l2)
    `uvm_field_int(fcs, UVM_ALL_ON|UVM_NOPACK)
  `uvm_object_utils_end

  //constructor
  //@param name - the name assigned to the instance of this class
  function new(string name = "");
    super.new(name);
	
	begin
	  veri5_eth_hdr_l2 layer2_hdr;
      layer2_hdr = veri5_eth_hdr_l2::type_id::create("L2_HDR");
      void'( this.insert(layer2_hdr) );
	end
	
    fcs = 0;
  endfunction : new



  //pack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_pack(uvm_packer packer);
	super.do_pack(packer);
	`uvm_pack_int(this.fcs)
  endfunction : do_pack


  //unpack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_unpack(uvm_packer packer);
	super.do_unpack(packer);
	`uvm_unpack_int(this.fcs)
  endfunction : do_unpack


  //Function: payload_size_adjust
  //
  //Used for child class to addjust payload size
  //For ethernet packet, there are 4 bytes fcs behind payload,
  //So need adjust payload size for minus 4.

  virtual function int unsigned payload_size_adjust(int unsigned payload_size);
    payload_size_adjust = super.payload_size_adjust(payload_size);
    return payload_size_adjust- $bits(fcs)/8;
  endfunction : payload_size_adjust


  //update crc field
  //
  virtual function void update_crc();
    this.fcs = this.get_fcs();
  endfunction : update_crc
 
 
    //get the FCS
    //@return returns the value of the correct FCS
  virtual function veri5_eth_fcs get_fcs();
    bit bitstream[];
    byte unsigned byte_data [];
	byte unsigned byte_data_no_crc[];
	
    void'(this.pack(bitstream));
    byte_data = {>> {bitstream}};

    byte_data_no_crc = new[byte_data.size()-4](byte_data);

    get_fcs = veri5_eth_hdr_l2::get_crc32_802(byte_data_no_crc);
  endfunction : get_fcs


  //Function: get_mac_da
  //
  //get Destination Address from L2 Hdr
  
  function veri5_eth_address get_mac_da();
    veri5_eth_hdr_l2 l2_hdr;
	if($cast(l2_hdr, this.get_hdr("ETH_L2")))
	  return l2_hdr.destination_address;
	else
	  return 0;
  endfunction : get_mac_da


  //Function: get_mac_sa
  //
  //get Source Address from L2 Hdr
  
  function veri5_eth_address get_mac_sa();
    veri5_eth_hdr_l2 l2_hdr;
	if($cast(l2_hdr, this.get_hdr("ETH_L2")))
	  return l2_hdr.source_address;
	else
	  return 0;
  endfunction : get_mac_sa



  //Function: set_mac_da
  //
  //set Destination Address in L2 Hdr
  
  function void set_mac_da(veri5_eth_address da);
    veri5_eth_hdr_l2 l2_hdr;
	`uvme_cast(l2_hdr, this.get_hdr("ETH_L2"), error)
	l2_hdr.destination_address = da;
  endfunction : set_mac_da


  //Function: set_mac_sa
  //
  //set Source Address in L2 Hdr
  
  function void set_mac_sa(veri5_eth_address sa);
    veri5_eth_hdr_l2 l2_hdr;
	`uvme_cast(l2_hdr, this.get_hdr("ETH_L2"), error)
	l2_hdr.source_address = sa;
  endfunction : set_mac_sa


endclass : veri5_eth_packet_l2


`endif  //__VERI5_ETH_PACKET_L2
