/******************************************************************************
 * (C) Copyright 2019 VERI5 Consulting
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
 * NAME:        veri5_eth_hdr_ipv4.sv
 * PROJECT:     veri5_eth
 * Description: This file declare the IPV4 Ethernet packet. 
 *              Implementation is done based on: http://en.wikipedia.org/wiki/Internet_Protocol_version_4
 *******************************************************************************/

`ifndef __VERI5_ETH_HDR_IPV4
  //protection against multiple includes
  `define __VERI5_ETH_HDR_IPV4

//Ethernet IPV4 packet header
class veri5_eth_hdr_ipv4 extends uvme_layer_header;

  //Version
  rand veri5_eth_ipv4_header_version version;

  constraint version_c {
    version == `VERI5_ETH_IPV4_HEADER_VERSION_VALUE;
  }

  //Internet Header Length (IHL)
  rand veri5_eth_ipv4_header_ihl ihl;

  constraint ihl_c {
    ihl >= `VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_WORDS;
  }

  //Differentiated Services Code Point (DSCP)
  rand veri5_eth_ipv4_header_dscp dscp;

  //Explicit Congestion Notification (ECN)
  rand veri5_eth_ipv4_header_ecn ecn;

  //Total Length
  rand veri5_eth_ipv4_header_total_length total_length;

  constraint total_length_c {
    total_length >= (ihl * 4) & total_length <= `VERI5_ETH_IPV4_REQUIRED_REASSEMBLE_LENGTH;
  }

  //Identification
  rand veri5_eth_ipv4_header_identification identification;

  //Flags
  rand veri5_eth_ipv4_header_flags flags;

  //Fragment Offset
  rand veri5_eth_ipv4_header_fragment_offset fragment_offset;

  //Time To Live (TTL)
  rand veri5_eth_ipv4_header_ttl ttl;

  //Protocol
  rand veri5_eth_ipv4_header_protocol protocol;

  //Header Checksum
  rand veri5_eth_ipv4_header_checksum checksum;

  //determine if to use the correct checksum or not
  rand bit use_correct_checksum;

  constraint use_correct_checksum_c {
    use_correct_checksum == 1;
  }

  //Source address
  rand veri5_eth_ipv4_header_source_ip_address source_ip_address;

  //Destination address
  rand veri5_eth_ipv4_header_destination_ip_address destination_ip_address;

  //Options
  rand veri5_eth_ipv4_header_option options[];
  
  constraint options_c {
    solve  ihl before options;
    options.size() == (ihl - get_minimum_header_length_in_words());
  }

  `uvm_object_utils_begin(veri5_eth_hdr_ipv4)
    `uvm_field_int(destination_ip_address, UVM_ALL_ON)
    `uvm_field_int(source_ip_address,      UVM_ALL_ON)
    `uvm_field_int(ttl,                    UVM_ALL_ON)
    `uvm_field_int(protocol,               UVM_ALL_ON)
    `uvm_field_int(flags,                  UVM_ALL_ON)
    `uvm_field_int(fragment_offset,        UVM_ALL_ON)
    `uvm_field_int(identification,         UVM_ALL_ON)
    `uvm_field_int(total_length,           UVM_ALL_ON)
    `uvm_field_int(version,                UVM_ALL_ON)
    `uvm_field_int(ihl,                    UVM_ALL_ON)
    `uvm_field_int(dscp,                   UVM_ALL_ON)
    `uvm_field_int(ecn,                    UVM_ALL_ON)
    `uvm_field_array_int(options,          UVM_ALL_ON)
    `uvm_field_int(checksum,               UVM_ALL_ON)
  `uvm_object_utils_end

  //constructor
  //@param name - the name assigned to the instance of this class
  function new(string name = "");
    super.new(name);
  endfunction : new

  //get the minimum length of the header, in bits
  //@return the minimum length of the header, in bits
  virtual function int unsigned get_minimum_header_length_in_bits();
    return (`VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_BITS);
  endfunction : get_minimum_header_length_in_bits

  //get the minimum length of the header, in bytes
  //@return the minimum length of the header, in bytes
  virtual function int unsigned get_minimum_header_length_in_bytes();
    return (get_minimum_header_length_in_bits() / 8);
  endfunction : get_minimum_header_length_in_bytes

  //get the minimum length of the header, in words
  //@return the minimum length of the header, in words
  virtual function int unsigned get_minimum_header_length_in_words();
    return (get_minimum_header_length_in_bits() / 32);
  endfunction : get_minimum_header_length_in_words
  
  //get the header length in bytes
  //@return the header length in bytes
  virtual function int unsigned get_header_length_in_bytes();
    return (ihl * 4);
  endfunction : get_header_length_in_bytes
  
  //get the options size in words
  //@param local_ihl - Internet Header Length (IHL)
  //@return the options size in words
  virtual function int unsigned get_options_size_in_words(veri5_eth_ipv4_header_ihl local_ihl);
    if(local_ihl < get_minimum_header_length_in_words()) begin
      `uvm_fatal("VERI5_ETH", $sformatf("Internet Header Length (%0d) should be bigger or equal then Minimum Header Length in words (%0d) - VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_WORDS: %0d", 
        local_ihl, get_minimum_header_length_in_words(), `VERI5_ETH_MINIMUM_HEADER_LENGTH_IN_WORDS));
      return 0;
    end
    
    return (local_ihl - get_minimum_header_length_in_words());
  endfunction : get_options_size_in_words
  
  //get the data length in bytes
  //@return the data length in bytes
  virtual function int unsigned get_data_length_in_bytes();
    if(total_length < get_header_length_in_bytes()) begin
      `uvm_fatal("VERI5_ETH", $sformatf("Total Length (%0d) should be bigger or equal to IHL in bytes (%0d)", total_length, get_header_length_in_bytes()));  
    end
    
    return (total_length - get_header_length_in_bytes());
  endfunction : get_data_length_in_bytes

  //pack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_pack(uvm_packer packer);
    `uvm_pack_int(version);
    `uvm_pack_int(ihl);
    `uvm_pack_int(dscp);
    `uvm_pack_int(ecn);
    `uvm_pack_int(total_length);
    `uvm_pack_int(identification);
    `uvm_pack_int(flags);
    `uvm_pack_int(fragment_offset);
    `uvm_pack_int(ttl);
    `uvm_pack_int(protocol);
    `uvm_pack_int(checksum);
    `uvm_pack_int(source_ip_address);
    `uvm_pack_int(destination_ip_address);
    
    for (int index = 0; index < options.size(); index++) begin
      `uvm_pack_int(options[index]);
    end
  endfunction : do_pack

  //unpack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_unpack(uvm_packer packer);
    `uvm_unpack_int(version);
    `uvm_unpack_int(ihl);
    `uvm_unpack_int(dscp);
    `uvm_unpack_int(ecn);
    `uvm_unpack_int(total_length);
    `uvm_unpack_int(identification);
    `uvm_unpack_int(flags);
    `uvm_unpack_int(fragment_offset);
    `uvm_unpack_int(ttl);
    `uvm_unpack_int(protocol);
    `uvm_unpack_int(checksum);
    `uvm_unpack_int(source_ip_address);
    `uvm_unpack_int(destination_ip_address);

    begin
      int unsigned minimum_header_length = get_minimum_header_length_in_words();

      if(ihl < get_minimum_header_length_in_words()) begin
        `uvm_fatal("VERI5_ETH", $sformatf("Internet Header Length (%0d) should be bigger or equal to minimum length (%0d)", ihl, minimum_header_length))
      end

      options = new[ihl - minimum_header_length];
	  
      //`uvm_unpack_array(options);
	  foreach(options[idx]) begin
	    `uvm_unpack_int(options[idx])
	  end
    end
  endfunction : do_unpack
  
  //get an easy-to-read string containing the IP value
  //@param address - the IP address
  //@return easy-to-read string containing the IP value
  local function string get_printable_ip(bit[31:0] address);
    string result = "";
    
    for(int i = 3; i >= 0; i--) begin
      byte unsigned data = (address >> (8 * i)) & 8'hFF;
      result = $sformatf("%s%0d%s", result, data, ((i > 0) ? "." : ""));
    end
    
    return result;
  endfunction : get_printable_ip

  //converts the information containing in the instance of this class to an easy-to-read string
  //@return easy-to-read string with the information contained in the instance of this class
  virtual function string convert2string();
    string strValue = "[IPV4] ";
    string source_ip = get_printable_ip(source_ip_address);
    string destination_ip = get_printable_ip(destination_ip_address);
    
    strValue = {strValue, $sformatf("Version: %X%sIHL: %0d%sDSCP: %X%sECN: %X%sTotal Length: %0d%sIdentification: %X%sFlags: %X%sFragment Offset: %X%sTTL: %0d%sProtocol: %0d%sChecksum: %X%sSource IP: %s%sDestination IP: %s%sOptions size: %0d ",
      version, `VERI5_ETH_FIELD_SEPARATOR,
      ihl, `VERI5_ETH_FIELD_SEPARATOR,
      dscp, `VERI5_ETH_FIELD_SEPARATOR,
      ecn, `VERI5_ETH_FIELD_SEPARATOR,
      total_length, `VERI5_ETH_FIELD_SEPARATOR,
      identification, `VERI5_ETH_FIELD_SEPARATOR,
      flags, `VERI5_ETH_FIELD_SEPARATOR,
      fragment_offset, `VERI5_ETH_FIELD_SEPARATOR,
      ttl, `VERI5_ETH_FIELD_SEPARATOR,
      protocol, `VERI5_ETH_FIELD_SEPARATOR,
      checksum, `VERI5_ETH_FIELD_SEPARATOR,
      source_ip, `VERI5_ETH_FIELD_SEPARATOR,
      destination_ip, `VERI5_ETH_FIELD_SEPARATOR,
      options.size())};
	return strValue;
  endfunction : convert2string

  //compares the current class instance with the one provided as an argument
  //@param rhs - Right Hand Side object
  //@param comparer - The UVM comparer object used in evaluating this comparison - default is "null"
  //@return 1 - objects are the same, 0 - objects are different
  virtual function bit compare (uvm_object rhs, uvm_comparer comparer=null);
    veri5_eth_hdr_ipv4 casted_rhs;

    if($cast(casted_rhs, rhs) == 0) begin
      return 0;
    end

    if(ihl != casted_rhs.ihl) begin
      return 0;
    end

    if(dscp != casted_rhs.dscp) begin
      return 0;
    end

    if(ecn != casted_rhs.ecn) begin
      return 0;
    end

    if(total_length != casted_rhs.total_length) begin
      return 0;
    end

    if(identification != casted_rhs.identification) begin
      return 0;
    end

    if(flags != casted_rhs.flags) begin
      return 0;
    end

    if(fragment_offset != casted_rhs.fragment_offset) begin
      return 0;
    end

    if(ttl != casted_rhs.ttl) begin
      return 0;
    end

    if(protocol != casted_rhs.protocol) begin
      return 0;
    end

    if(checksum != casted_rhs.checksum) begin
      return 0;
    end

    if(source_ip_address != casted_rhs.source_ip_address) begin
      return 0;
    end

    if(destination_ip_address != casted_rhs.destination_ip_address) begin
      return 0;
    end

    if(options.size() != casted_rhs.options.size()) begin
      return 0;
    end

    for(int i = 0; i < options.size(); i++) begin
      if(options[i] != casted_rhs.options[i]) begin
        return 0;
      end
    end

    return 1;
  endfunction : compare

  //copy the right hand side class instance to this current instance
  //@param rhs - Right Hand Side object
  function void copy(uvm_object rhs);
    veri5_eth_hdr_ipv4 casted_rhs;

    if($cast(casted_rhs, rhs) == 0) begin
      `uvm_fatal("VERI5_ETH", "Could not cast object to a veri5_eth_hdr_ipv4");
    end

    version = casted_rhs.version;
    ihl = casted_rhs.ihl;
    dscp = casted_rhs.dscp;
    ecn = casted_rhs.ecn;
    total_length = casted_rhs.total_length;
    identification = casted_rhs.identification;
    flags = casted_rhs.flags;
    fragment_offset = casted_rhs.fragment_offset;
    ttl = casted_rhs.ttl;
    protocol = casted_rhs.protocol;
    checksum = casted_rhs.checksum;
    source_ip_address = casted_rhs.source_ip_address;
    destination_ip_address = casted_rhs.destination_ip_address;
    options = new[casted_rhs.options.size()];

    for(int i = 0; i < options.size(); i++) begin
      options[i] = casted_rhs.options[i];
    end

  endfunction : copy

  //get the correct checksum
  //@return returns the value of the correct checksum
  virtual function veri5_eth_ipv4_header_checksum get_correct_checksum();
    //this logic is based on wiki - http://en.wikipedia.org/wiki/IPv4_header_checksum
    veri5_eth_hdr_ipv4 header;
    bit unsigned bitstream[];
    bit[31:0] halfwords_sum = 0;
    bit[15:0] halfwords[];


    header = veri5_eth_hdr_ipv4::type_id::create("header");
    header.copy(this);
    header.checksum = 0;

    void'(header.pack(bitstream));

    //if(bitstream.size() != ihl * 32) begin
      //`uvm_fatal("VERI5_ETH", $sformatf("Bit stream size error detected - expected: %0d, received: %0d",
    //TODO : FIXME Not Clear why origial code use ihl*32, need check spec
    if(bitstream.size() != ihl * 64) begin
      `uvm_error("VERI5_ETH", $sformatf("Bit stream size error detected - expected: %0d, received: %0d",
          ihl * 32, bitstream.size()));
    end
    
    halfwords = { >> {bitstream}};

    //if(halfwords.size() != (2 * ihl)) begin
      //`uvm_fatal("VERI5_ETH", $sformatf("Halfwords size error detected - expected: %0d, received: %0d",
    //TODO : FIXME Not Clear why origial code use 2*ihl, need check spec
    if(halfwords.size() != (4 * ihl)) begin
      `uvm_error("VERI5_ETH", $sformatf("Halfwords size error detected - expected: %0d, received: %0d",
          (2 * ihl), halfwords.size()));
    end

    for(int i = 0; i < halfwords.size(); i++) begin
      halfwords_sum += halfwords[i];
    end
    
    get_correct_checksum = halfwords_sum[31:16] + halfwords_sum[15:0];
    get_correct_checksum = ~get_correct_checksum;
  endfunction : get_correct_checksum


  function void post_randomize();
    if(use_correct_checksum == 1) begin
      checksum = get_correct_checksum();
    end
  endfunction : post_randomize


  
  virtual function int unsigned get_hdr_length();
    return 18 + 4*options.size() + 2;
  endfunction : get_hdr_length


  //Function: get_hdr_name
  //
  //Return the nick name of the header,
  //like l2_hdr/ipv4_hdr ....
  
  virtual function string get_hdr_name();
    return "IPV4";
  endfunction : get_hdr_name


endclass : veri5_eth_hdr_ipv4


`endif //__VERI5_ETH_HDR_IPV4
