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

`ifndef NETWORK_ADDRESS_SVH
`define NETWORK_ADDRESS_SVH

typedef class network_address_generator;

//------------------------------------------------------------------------------
// CLASS: network_address
//
// The class is the placeholder of network address, like MAC addresss, IPV4 address
// IPV6 address.
// Also provide some APIs to config IP address.
//
//------------------------------------------------------------------------------

class network_address extends uvm_object;

  bit [`MAC_ADDR_SZ-1  : 0]  mac;

  bit [16:0] ipv6[8];          

  bit [7:0] ipv4[4];          //192.168.001.001 [3 - 0]
  bit [7:0] subnet_mask[4];   //255.255.255.000

  `uvm_object_utils_begin(network_address)
    `uvm_field_int(mac, UVM_ALL_ON)
    `uvm_field_sarray_int(ipv6, UVM_ALL_ON)
    `uvm_field_sarray_int(ipv4, UVM_ALL_ON)
    `uvm_field_sarray_int(subnet_mask, UVM_ALL_ON)
  `uvm_object_utils_end

  // Function: new
  //
  // Construction

  function new(string name = "network_address");
    super.new(name);
    //when network address newed, mac will be assigned a uniq value
    `network_uniq_mac_gen(this.mac)  
  endfunction : new


  // Function: get_ipv6_address
  //
  // Return the ipv6 address in 128bits format
  
  virtual function bit [127:0] get_ipv6_address();
    foreach(this.ipv6[idx]) begin
      get_ipv6_address[(idx*16+15) -: 15] = this.ipv6[idx];
    end
  endfunction : get_ipv6_address


  // Function: get_ipv4_address
  //
  // Return the ipv4 address in 32bits format
  
  virtual function bit [31:0] get_ipv4_address();
    foreach(this.ipv4[idx]) begin
      get_ipv4_address[(idx*8+7) -: 7] = this.ipv4[idx];
    end
  endfunction : get_ipv4_address


  // Function: set_ipv6_address
  //
  // Set IPV6 address in 8 parts, below is the example:
  //
  //| address.set_ipv6_address('h2001, 'hcda, 'h0000, 'h0000, 'h0000, 'h0000, 'h3257, 'h9652);
  
  virtual function void set_ipv6_address(bit [15:0] part7, bit [15:0] part6, bit [15:0] part5, bit [15:0] part4,
                                         bit [15:0] part3, bit [15:0] part2, bit [15:0] part1, bit [15:0] part0);
    this.ipv6[7] = part7;
    this.ipv6[6] = part6;
    this.ipv6[5] = part5;
    this.ipv6[4] = part4;
    this.ipv6[3] = part3;
    this.ipv6[2] = part2;
    this.ipv6[1] = part1;
    this.ipv6[0] = part0;
  endfunction : set_ipv6_address


  // Function: set_ipv4_address
  //
  // Set IPV6 address in 4 parts, below is the example:
  //
  //| address.set_ipv4_address(192, 168, 1, 1);
  
  virtual function void set_ipv4_address(bit [7:0] part3, bit [7:0] part2, bit [7:0] part1, bit [7:0] part0);
    this.ipv4[3] = part3;
    this.ipv4[2] = part2;
    this.ipv4[1] = part1;
    this.ipv4[0] = part0;
  endfunction : set_ipv4_address


  // Function: set_subnet_mask
  //
  // Set IPV4 network subnet mask
  //
  //| address.set_subnet_mask(255, 255, 255, 0);
  
  virtual function void set_subnet_mask(bit [7:0] part3, bit [7:0] part2, bit [7:0] part1, bit [7:0] part0);
    this.subnet_mask[3] = part3;
    this.subnet_mask[2] = part2;
    this.subnet_mask[1] = part1;
    this.subnet_mask[0] = part0;
  endfunction : set_subnet_mask


endclass : network_address


//------------------------------------------------------------------------------
// CLASS: network_address_generator
//
// The class is used to generate uniq network address, 
// for example mac address, ip address.....
// User can add address constraint here
//------------------------------------------------------------------------------

class network_address_generator extends uvm_object;

  protected static network_address_generator access;

  protected randc bit [`MAC_ADDR_SZ-1  : 0]  mac;

  `uvm_object_utils_begin(network_address_generator)
    `uvm_field_int(mac, UVM_ALL_ON)
  `uvm_object_utils_end


  // Function: new
  //
  // Construction

  function new(string name = "network_address_generator");
    super.new(name);
  endfunction : new


  // Function: get_inst
  //
  // Get gloabl access handle.
  
  static function network_address_generator get_inst();
    if(network_address_generator::access == null) begin
      network_address_generator::access = network_address_generator::type_id::create("network_address_generator");
    end
    return network_address_generator::access;
  endfunction : get_inst


  // Function: get_mac
  //
  // Get a uniq mac address.
  
  virtual function bit [`MAC_ADDR_SZ-1:0] get_mac();
    void'( this.randomize() );
    return this.mac;
  endfunction : get_mac


endclass : network_address_generator


`endif // NETWORK_ADDRESS_SVH
