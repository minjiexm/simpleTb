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
`ifndef VERI5_ETH_PACKET_SVH
`define VERI5_ETH_PACKET_SVH

//------------------------------------------------------------------------------
//
// CLASS: veri5_eth_packet
//
// veri5_eth_packet class is top transaction.
// Link list of layer header
//
//------------------------------------------------------------------------------

class veri5_eth_packet extends uvme_transaction;

  //UVM factory macro
  `uvm_object_utils(veri5_eth_packet)


  // Function: new
  //
  // Constructor

  function new(string name = "uvme_transaction");
    super.new(name);
	begin
      //there always should has just one payload header
      uvme_payload_header payload = uvme_payload_header::type_id::create("payload");
	  void'( this.insert(payload) );
	end
  endfunction : new


  //Function: payload_size_adjust
  //
  //Used for child class to addjust payload size
  //For ethernet packet, there are 4 bytes fcs behind payload,
  //So need adjust payload size for minus 4.

  virtual function int unsigned payload_size_adjust(int unsigned payload_size);
    return payload_size;
  endfunction : payload_size_adjust


  //unpack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_unpack(uvm_packer packer);
	uvme_layer_header header_in_op;
	int unsigned length_in_bytes = this.payload_size_adjust(packer.get_packed_size()/8);
	header_in_op = this.first_hdr;
	
	while(header_in_op != null) begin
      begin
	    //payload size is special, it is a dynamic array.
		//Only at last step then can adjust payload size.
	    uvme_payload_header pyld; 
	    if($cast(pyld, header_in_op)) //last header must be payload header
		  pyld.length = length_in_bytes;
	  end	  

	  header_in_op.do_unpack(packer);
	  length_in_bytes = length_in_bytes - header_in_op.get_hdr_length();
	  header_in_op = header_in_op.get_next();
	end
  endfunction : do_unpack



  //Function: delete_hdr
  //
  //delete layer header by name;
 
  function bit delete_hdr(uvme_layer_header hdr);
    if(hdr.get_hdr_name() == "PAYLOAD") begin
	  `uvme_error($psprintf("[delete_hdr] Can not delete the payload header from the packet!"))
	  return 0;
	end
	
	return super.delete_hdr(hdr);
  endfunction : delete_hdr



  //Function: add_hdr
  //
  //add a header into header array;

  protected function void add_hdr(uvme_layer_header hdr);
    uvme_payload_header pyld;
	if($cast(pyld, hdr) && this.m_header.size() > 0)begin
	  `uvme_error($psprintf("[add_hdr] Not allow to insert an other payload header! Only one payload header is allowed!"))	
	  return;
	end
	
    super.add_hdr(hdr);
  endfunction : add_hdr


endclass : veri5_eth_packet


`endif  // VERI5_ETH_PACKET_SVH

