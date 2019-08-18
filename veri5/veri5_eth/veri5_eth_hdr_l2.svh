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
 * NAME:        veri5_eth_hdr_l2.sv
 * PROJECT:     veri5_eth
 * Description: This file declare base Ethernet packet.
 *              The definition of this packet is described in IEEE 802.3-2012.
 *              For more details see file docs/ieee_802.3-2012/802.3-2012_section1.pdf,
 *              chapter 3. Media Access Control (MAC) frame and packet specifications
 *******************************************************************************/

`ifndef __VERI5_ETH_HEADER_LAYER2
//protection against multiple includes
`define __VERI5_ETH_HEADER_LAYER2

//basic class for declaring the Ethernet packets
class veri5_eth_hdr_l2 extends uvme_layer_header;

  //Destination Address
  rand veri5_eth_address destination_address;

  //Source Address
  rand veri5_eth_address source_address;

  `uvm_object_utils_begin(veri5_eth_hdr_l2)
    `uvm_field_int(destination_address, UVM_ALL_ON)
    `uvm_field_int(     source_address, UVM_ALL_ON)
  `uvm_object_utils_end

  //constructor
  //@param name - the name assigned to the instance of this class
  function new(string name = "");
    super.new(name);
	this.m_hdr_len_in_bytes = 16;  //include 4bytes crc
  endfunction : new

  //converts the information containing in the instance of this class to an easy-to-read string
  //@return easy-to-read string with the information contained in the instance of this class
  virtual function string convert2string();
    string what_to_return = "[ETH] ";
    $sformat(what_to_return, {what_to_return,"DA: %012X ", `VERI5_ETH_FIELD_SEPARATOR}, destination_address);
    $sformat(what_to_return, {what_to_return,"SA: %012X "},source_address);
    return what_to_return;
  endfunction : convert2string

  //compares the current class instance with the one provided as an argument
  //@param rhs - Right Hand Side object
  //@param comparer - The UVM comparer object used in evaluating this comparison - default is "null"
  //@return 1 - objects are the same, 0 - objects are different
  virtual function bit compare (uvm_object rhs, uvm_comparer comparer=null);
    veri5_eth_hdr_l2 casted_rhs;

    if($cast(casted_rhs, rhs) == 0) begin
      return 0;
    end

    if(destination_address != casted_rhs.destination_address) begin
      return 0;
    end

    if(source_address != casted_rhs.source_address) begin
      return 0;
    end

    return 1;
  endfunction : compare


  static protected veri5_eth_fcs crc32_ccitt_table[] = {
    32'h00000000, 32'h77073096, 32'hee0e612c, 32'h990951ba, 32'h076dc419,
    32'h706af48f, 32'he963a535, 32'h9e6495a3, 32'h0edb8832, 32'h79dcb8a4,
    32'he0d5e91e, 32'h97d2d988, 32'h09b64c2b, 32'h7eb17cbd, 32'he7b82d07,
    32'h90bf1d91, 32'h1db71064, 32'h6ab020f2, 32'hf3b97148, 32'h84be41de,
    32'h1adad47d, 32'h6ddde4eb, 32'hf4d4b551, 32'h83d385c7, 32'h136c9856,
    32'h646ba8c0, 32'hfd62f97a, 32'h8a65c9ec, 32'h14015c4f, 32'h63066cd9,
    32'hfa0f3d63, 32'h8d080df5, 32'h3b6e20c8, 32'h4c69105e, 32'hd56041e4,
    32'ha2677172, 32'h3c03e4d1, 32'h4b04d447, 32'hd20d85fd, 32'ha50ab56b,
    32'h35b5a8fa, 32'h42b2986c, 32'hdbbbc9d6, 32'hacbcf940, 32'h32d86ce3,
    32'h45df5c75, 32'hdcd60dcf, 32'habd13d59, 32'h26d930ac, 32'h51de003a,
    32'hc8d75180, 32'hbfd06116, 32'h21b4f4b5, 32'h56b3c423, 32'hcfba9599,
    32'hb8bda50f, 32'h2802b89e, 32'h5f058808, 32'hc60cd9b2, 32'hb10be924,
    32'h2f6f7c87, 32'h58684c11, 32'hc1611dab, 32'hb6662d3d, 32'h76dc4190,
    32'h01db7106, 32'h98d220bc, 32'hefd5102a, 32'h71b18589, 32'h06b6b51f,
    32'h9fbfe4a5, 32'he8b8d433, 32'h7807c9a2, 32'h0f00f934, 32'h9609a88e,
    32'he10e9818, 32'h7f6a0dbb, 32'h086d3d2d, 32'h91646c97, 32'he6635c01,
    32'h6b6b51f4, 32'h1c6c6162, 32'h856530d8, 32'hf262004e, 32'h6c0695ed,
    32'h1b01a57b, 32'h8208f4c1, 32'hf50fc457, 32'h65b0d9c6, 32'h12b7e950,
    32'h8bbeb8ea, 32'hfcb9887c, 32'h62dd1ddf, 32'h15da2d49, 32'h8cd37cf3,
    32'hfbd44c65, 32'h4db26158, 32'h3ab551ce, 32'ha3bc0074, 32'hd4bb30e2,
    32'h4adfa541, 32'h3dd895d7, 32'ha4d1c46d, 32'hd3d6f4fb, 32'h4369e96a,
    32'h346ed9fc, 32'had678846, 32'hda60b8d0, 32'h44042d73, 32'h33031de5,
    32'haa0a4c5f, 32'hdd0d7cc9, 32'h5005713c, 32'h270241aa, 32'hbe0b1010,
    32'hc90c2086, 32'h5768b525, 32'h206f85b3, 32'hb966d409, 32'hce61e49f,
    32'h5edef90e, 32'h29d9c998, 32'hb0d09822, 32'hc7d7a8b4, 32'h59b33d17,
    32'h2eb40d81, 32'hb7bd5c3b, 32'hc0ba6cad, 32'hedb88320, 32'h9abfb3b6,
    32'h03b6e20c, 32'h74b1d29a, 32'head54739, 32'h9dd277af, 32'h04db2615,
    32'h73dc1683, 32'he3630b12, 32'h94643b84, 32'h0d6d6a3e, 32'h7a6a5aa8,
    32'he40ecf0b, 32'h9309ff9d, 32'h0a00ae27, 32'h7d079eb1, 32'hf00f9344,
    32'h8708a3d2, 32'h1e01f268, 32'h6906c2fe, 32'hf762575d, 32'h806567cb,
    32'h196c3671, 32'h6e6b06e7, 32'hfed41b76, 32'h89d32be0, 32'h10da7a5a,
    32'h67dd4acc, 32'hf9b9df6f, 32'h8ebeeff9, 32'h17b7be43, 32'h60b08ed5,
    32'hd6d6a3e8, 32'ha1d1937e, 32'h38d8c2c4, 32'h4fdff252, 32'hd1bb67f1,
    32'ha6bc5767, 32'h3fb506dd, 32'h48b2364b, 32'hd80d2bda, 32'haf0a1b4c,
    32'h36034af6, 32'h41047a60, 32'hdf60efc3, 32'ha867df55, 32'h316e8eef,
    32'h4669be79, 32'hcb61b38c, 32'hbc66831a, 32'h256fd2a0, 32'h5268e236,
    32'hcc0c7795, 32'hbb0b4703, 32'h220216b9, 32'h5505262f, 32'hc5ba3bbe,
    32'hb2bd0b28, 32'h2bb45a92, 32'h5cb36a04, 32'hc2d7ffa7, 32'hb5d0cf31,
    32'h2cd99e8b, 32'h5bdeae1d, 32'h9b64c2b0, 32'hec63f226, 32'h756aa39c,
    32'h026d930a, 32'h9c0906a9, 32'heb0e363f, 32'h72076785, 32'h05005713,
    32'h95bf4a82, 32'he2b87a14, 32'h7bb12bae, 32'h0cb61b38, 32'h92d28e9b,
    32'he5d5be0d, 32'h7cdcefb7, 32'h0bdbdf21, 32'h86d3d2d4, 32'hf1d4e242,
    32'h68ddb3f8, 32'h1fda836e, 32'h81be16cd, 32'hf6b9265b, 32'h6fb077e1,
    32'h18b74777, 32'h88085ae6, 32'hff0f6a70, 32'h66063bca, 32'h11010b5c,
    32'h8f659eff, 32'hf862ae69, 32'h616bffd3, 32'h166ccf45, 32'ha00ae278,
    32'hd70dd2ee, 32'h4e048354, 32'h3903b3c2, 32'ha7672661, 32'hd06016f7,
    32'h4969474d, 32'h3e6e77db, 32'haed16a4a, 32'hd9d65adc, 32'h40df0b66,
    32'h37d83bf0, 32'ha9bcae53, 32'hdebb9ec5, 32'h47b2cf7f, 32'h30b5ffe9,
    32'hbdbdf21c, 32'hcabac28a, 32'h53b39330, 32'h24b4a3a6, 32'hbad03605,
    32'hcdd70693, 32'h54de5729, 32'h23d967bf, 32'hb3667a2e, 32'hc4614ab8,
    32'h5d681b02, 32'h2a6f2b94, 32'hb40bbe37, 32'hc30c8ea1, 32'h5a05df1b,
    32'h2d02ef8d
  }; //crc32_ccitt_table

  static protected function int unsigned crc32_ccitt_seed(byte unsigned byte_data [], int unsigned seed);
    int unsigned crc32 = seed;

    for(int i = 0; i < byte_data.size(); i++) begin
      byte unsigned index = (crc32 ^ byte_data[i]) & 8'hff;
      crc32 = crc32_ccitt_table[index] ^ (crc32 >> 8);
    end //for

    return (~crc32);
  endfunction : crc32_ccitt_seed

  static protected function int unsigned get_crc32_ccitt(byte unsigned byte_data []);
    return (crc32_ccitt_seed(byte_data, `VERI5_ETH_CRC32_CCITT_SEED));
  endfunction : get_crc32_ccitt


  static protected function int unsigned swap_bytes(int unsigned data);
    byte unsigned byte_data [];

    byte_data = {>> {data}};
    byte_data.reverse();
    data = { >> {byte_data}};

    return data;
  endfunction : swap_bytes


  static function int unsigned get_crc32_802(byte unsigned byte_data []);
    int unsigned c_crc;
    c_crc = get_crc32_ccitt(byte_data);
    c_crc = swap_bytes(c_crc);
    return c_crc;
  endfunction : get_crc32_802


  //Function: get_hdr_name
  //
  //Return the nick name of the header,
  //like l2_hdr/ipv4_hdr ....
  
  virtual function string get_hdr_name();
    return "ETH_L2";
  endfunction : get_hdr_name

 
endclass : veri5_eth_hdr_l2

`endif  //__VERI5_ETH_HEADER_LAYER2
