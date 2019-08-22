
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
`ifndef UVME_TRANSACTION_SV
`define UVME_TRANSACTION_SV

//------------------------------------------------------------------------------
//
// CLASS: uvme_layer_header
//
// uvme_layer_header class is the basic header class.
// use layer_header can form a header link list
//------------------------------------------------------------------------------

class uvme_layer_header extends uvm_sequence_item;

  protected uvme_layer_header prev_hdr;
  protected uvme_layer_header next_hdr;

  protected int unsigned m_hdr_len_in_bytes = 0;

  //UVM factory macro
  `uvm_object_utils_begin(uvme_layer_header)
    //`uvm_field_object(prev_hdr, UVM_ALL_ON)
	//`uvm_field_object(next_hdr, UVM_ALL_ON)
  `uvm_object_utils_end

   
  // Function: new
  //
  // Constructor

  function new(string name = "uvme_layer_header");
    super.new(name);
  endfunction : new


  //Function: isolated
  //
  //if isolated means header not link to any ohter header
  
  function bit isolated();
     if(this.prev_hdr == null && this.next_hdr == null)
	   return 1;
	 else
	   return 0;
  endfunction : isolated


  //Function: insert_back
  //
  //Link next to a header, will be the next header of the header.

  virtual function bit insert_back(uvme_layer_header hdr);  
    if(!this.isolated) begin
	  `uvme_error($psprintf("[insert_back] %s is not an isolated header! Can not do insert_back action!", this.get_name()))
	  return 0;
	end
	else begin
      uvme_layer_header target_hdr_next;

      if(hdr.get_next() != null)
        `uvme_cast(target_hdr_next,	hdr.get_next(), error)

      if(target_hdr_next != null) begin
	    void'( target_hdr_next.link_prev(this) );
		void'( this.link_next(target_hdr_next) );
	  end

      void'( hdr.link_next(this) );
      void'( this.link_prev(hdr) );
	end
  endfunction : insert_back



  //Function: insert_front
  //
  //Insert before a header, will be the previous header of the header.

  virtual function bit insert_front(uvme_layer_header hdr);
    if(!this.isolated) begin
	  `uvme_error($psprintf("[insert_front] %s is not an isolated header! Can not do insert_front action!", this.get_name()))
	  return 0;
	end
    else begin
      uvme_layer_header target_hdr_prev;
	  
	  if(hdr.get_prev() != null)
        `uvme_cast(target_hdr_prev, hdr.get_prev(), error)

      if(target_hdr_prev != null) begin
	    void'( target_hdr_prev.link_next(this) );
        void'( this.link_prev(target_hdr_prev) );
	  end
	
      void'( hdr.link_prev(this) );
      void'( this.link_next(hdr) );
	end
  endfunction : insert_front




  //Function: disconnect_next
  //
  //disconnect from next header.

  virtual function void disconnect_next();
    if(this.next_hdr != null)
     `uvme_info($psprintf("[disconnect_next] %s disconnect from next header to %s", this.get_name(), this.next_hdr.get_name()), UVM_DEBUG)

    this.next_hdr = null;
  endfunction : disconnect_next



  //Function: disconnect_prev
  //
  //disconnect from previous header.

  virtual function void disconnect_prev();
    if(this.prev_hdr != null)
      `uvme_info($psprintf("[disconnect_prev] %s disconnect from next header to %s", this.get_name(), this.prev_hdr.get_name()), UVM_DEBUG)
	  
    this.prev_hdr = null;
  endfunction : disconnect_prev



  //Function: link_next
  //
  //Link previous to a header, will be the previous header of the header.

  virtual function void link_next(uvme_layer_header hdr);
    if(this.next_hdr != null) begin
      `uvme_info($psprintf("[link_next] %s will disconnect from next header %s", this.get_name(), this.next_hdr.get_name()), UVM_DEBUG)
	end
	`uvme_cast(this.next_hdr, hdr, error)
    `uvme_info($psprintf("[link_next] %s link its next header to %s", this.get_name(), hdr.get_name()), UVM_DEBUG)
  endfunction : link_next



  //Function: link_prev
  //
  //Link previous to a header, will be the previous header of the header.

  virtual function void link_prev(uvme_layer_header hdr);
    if(this.prev_hdr != null) begin
      `uvme_info($psprintf("[link_prev] %s will disconnect from prevous header %s", this.get_name(), this.prev_hdr.get_name()), UVM_DEBUG)
	end
	`uvme_cast(this.prev_hdr, hdr, error)
    `uvme_info($psprintf("[link_prev] %s link its prevous header to %s", this.get_name(), hdr.get_name()), UVM_DEBUG)
  endfunction : link_prev



  //Function: get_prev
  //
  //Return the previous header
  
  virtual function uvme_layer_header get_prev();
    return this.prev_hdr;
  endfunction : get_prev


  //Function: get_next
  //
  //Return the next header
  
  virtual function uvme_layer_header get_next();
    return this.next_hdr;
  endfunction : get_next



  //Function: get_last
  //
  //Return the last header
  
  virtual function uvme_layer_header get_last();
    if(this.next_hdr != null) begin
	  return this.next_hdr.get_last();
	end
	else
      return this;  //I am the last header
  endfunction : get_last


  //Function: get_first
  //
  //Return the first header
  
  virtual function uvme_layer_header get_first();
    if(this.prev_hdr != null) begin
	  return this.prev_hdr.get_first();
	end
	else
      return this;  //I am the first header
  endfunction : get_first


  //Function: get_hdr_length
  //
  //Return the bytes length of the header
  
  virtual function int unsigned get_hdr_length();
    return m_hdr_len_in_bytes;
  endfunction : get_hdr_length



  //Function: get_hdr_name
  //
  //Return the nick name of the header,
  //like l2_hdr/ipv4_hdr ....
  
  virtual function string get_hdr_name();
    return "UNKNOW";
  endfunction : get_hdr_name


endclass : uvme_layer_header


//------------------------------------------------------------------------------
//
// CLASS: uvme_multi_format_header
//
// uvme_multi_format_header class is the header which has multiple format
//
//------------------------------------------------------------------------------

class uvme_multi_format_header #(type T = int unsigned) extends uvme_layer_header;
  T format_type;

  protected uvme_multi_format_header format_hdr[T];


  //UVM factory macro
  `uvm_object_utils_begin(uvme_multi_format_header)
  `uvm_object_utils_end


  // Function: new
  //
  // Constructor

  function new(string name = "uvme_multi_format_header");
    super.new(name);
  endfunction : new


  // Function: get_format
  //
  // get_format will return the real type of the header.
  // later user can cast the handle to the right type then
  // can access the field with the right format.

  virtual function uvme_multi_format_header get_format();
    //A::type_id::set_type_override( AA::get_type() );
	return null;
  endfunction : get_format
  
  
endclass : uvme_multi_format_header



//------------------------------------------------------------------------------
//
// CLASS: uvme_payload_header
//
// uvme_payload_header class is the header store the payload
//
//------------------------------------------------------------------------------


class uvme_payload_header extends uvme_layer_header;

  rand bit [7:0] data[];

  rand int unsigned length;

  constraint data_length {
    soft length inside {[64 : 1024]};
    data.size() == length;
    solve data before length;
  };

  //UVM factory macro
  `uvm_object_utils_begin(uvme_payload_header)
    `uvm_field_array_int(data, UVM_ALL_ON|UVM_NOPACK)
    `uvm_field_int(length, UVM_ALL_ON|UVM_NOPACK)
  `uvm_object_utils_end

  // Function: new
  //
  // Constructor

  function new(string name = "uvme_payload_header");
    super.new(name);
  endfunction : new


  //Function: convert2string
  //
  //Convert Packet content to string;

  virtual function string convert2string();
    string strValue = "[PYLD] ";
	int unsigned max_print_bytes = 64;  //max print 64 bytes

	strValue = {strValue, $sformatf("Length %0d", length), " Data: "};
	if(max_print_bytes > this.data.size())
	  max_print_bytes = this.data.size();
		
    for(int unsigned idx = 0; idx < max_print_bytes; idx++) begin
	  strValue = {strValue, $sformatf("%0h ", this.data[idx])};
   	end
	
	if(max_print_bytes < this.data.size())
	  strValue = {strValue, " ........"};

	return strValue;
  endfunction : convert2string


  //Function: post_randomize
  //
  //Update header length;

  function void post_randomize ();
    this.m_hdr_len_in_bytes = this.length;
  endfunction : post_randomize



  //pack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_pack(uvm_packer packer);
    foreach(this.data[idx]) begin
      `uvm_pack_int(this.data[idx]);
	end
  endfunction : do_pack



  //underpack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_unpack(uvm_packer packer);
	this.data.delete();
	this.data = new[this.length];
	foreach (this.data[i]) `uvm_unpack_int(this.data[i])
    this.m_hdr_len_in_bytes = this.length;
  endfunction : do_unpack



  //Function: get_hdr_name
  //
  //Return the nick name of the header,
  //like l2_hdr/ipv4_hdr ....
  
  virtual function string get_hdr_name();
    return "PAYLOAD";
  endfunction : get_hdr_name



  //Function: get_hdr_length
  //
  //Return the bytes length of the header
  
  virtual function int unsigned get_hdr_length();
    this.length = this.data.size();
	this.m_hdr_len_in_bytes = this.length;
    return m_hdr_len_in_bytes;
  endfunction : get_hdr_length


endclass : uvme_payload_header



//------------------------------------------------------------------------------
//
// CLASS: uvme_transaction
//
// uvme_transaction class is top transaction.
// Link list of layer header
//
//------------------------------------------------------------------------------

class uvme_transaction extends uvm_sequence_item;
  
  protected uvme_layer_header m_header_stack[$];  //this queue will always inorder;
  protected uvme_layer_header m_header[string][$];  //use type to map header
  protected uvme_layer_header first_hdr;

  //UVM factory macro
  `uvm_object_utils_begin(uvme_transaction)
    `uvm_field_queue_object(m_header_stack, UVM_ALL_ON|UVM_NOPACK|UVM_NOCOMPARE|UVM_NOCOPY)  //just for display
  `uvm_object_utils_end


  // Function: new
  //
  // Constructor

  function new(string name = "uvme_transaction");
    super.new(name);
  endfunction : new


  //Function: pre_randomize
  //
  //randomize all headers;

  function void pre_randomize ();
    foreach(this.m_header[key]) begin
	  uvme_layer_header hdr_q[$];
	  hdr_q = this.m_header[key];
	  foreach(hdr_q[idx]) begin
        void'( hdr_q[idx].randomize() );
	  end
	end
  endfunction : pre_randomize



  //Function: add_hdr
  //
  //add a header into header array;

  protected function void add_hdr(uvme_layer_header hdr);
    `uvme_info($psprintf("[add_hdr] %s", hdr.get_hdr_name()), UVM_NONE)
    this.m_header[hdr.get_hdr_name()].push_back(hdr);
  endfunction : add_hdr


  //Function: remove_hdr
  //
  //add a header into header array;

  protected function bit remove_hdr(uvme_layer_header hdr);
    if(this.m_header.exists(hdr.get_hdr_name())) begin
	  uvme_layer_header hdr_q[$];
	  hdr_q = this.m_header[hdr.get_hdr_name()];
	  foreach(hdr_q[idx]) begin
	    if(hdr_q[idx] == hdr) begin
		   hdr_q.delete(idx);
		   return 1;
		end
	  end
	end
	else begin
	  `uvme_error($psprintf("No header type %s inserted!", hdr.get_hdr_name()))
	end
	return 0;
  endfunction : remove_hdr


  //Function: chk_hdr
  //
  //check whether a header is in he link list

  protected function bit chk_hdr(uvme_layer_header hdr);
	chk_hdr = 0;
    if(this.m_header.exists(hdr.get_hdr_name())) begin
      foreach(this.m_header_stack[idx]) begin
        if(this.m_header_stack[idx] == hdr) begin
		  chk_hdr = 1;
		  break;
		end
	  end
	end
  endfunction : chk_hdr


  //Function: get_hdr_length
  //
  //Return the bytes length of the header
  
  virtual function int unsigned get_hdr_length();
    int unsigned hdr_len_in_bytes = 0;
    foreach(this.m_header_stack[hidx]) begin
      hdr_len_in_bytes = hdr_len_in_bytes + this.m_header_stack[hidx].get_hdr_length();
	end
    return hdr_len_in_bytes;
  endfunction : get_hdr_length


  //pack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_pack(uvm_packer packer);
 	uvme_layer_header header_in_op;
	header_in_op = this.first_hdr;
	while(header_in_op != null) begin
	  header_in_op.do_pack(packer);
	  header_in_op = header_in_op.get_next();
	end
  endfunction : do_pack


  //unpack the entire Ethernet packet
  //@param packer - the packer used by this function
  virtual function void do_unpack(uvm_packer packer);
	uvme_layer_header header_in_op;
	int unsigned length_in_bytes = packer.get_packed_size()/8;
	header_in_op = this.first_hdr;
	
	while(header_in_op != null) begin
	  header_in_op.do_unpack(packer);
	  length_in_bytes = length_in_bytes - header_in_op.get_hdr_length();
	  header_in_op = header_in_op.get_next();
	end
  endfunction : do_unpack



  //Function: delete_hdr
  //
  //delete layer header by name;
 
  function bit delete_hdr(uvme_layer_header hdr);
    if(!this.chk_hdr(hdr)) begin
	  `uvme_error($psprintf("No header %s exist in %s", hdr.get_name(), this.get_name()))
	  return 0;
    end
	
    begin
	  uvme_layer_header prev_hdr, next_hdr;
	  
	  if(hdr.get_prev() != null)
	    `uvme_cast(prev_hdr, hdr.get_prev(), error)
		
      if(hdr.get_next() != null)
	    `uvme_cast(next_hdr, hdr.get_next(), error)

	  if(prev_hdr != null && next_hdr != null) begin
	    void'( prev_hdr.link_next(next_hdr) );
	    void'( next_hdr.link_prev(prev_hdr) );
		`uvme_cast(this.first_hdr, prev_hdr.get_first(), error)
	  end
	  else if(prev_hdr == null && next_hdr != null) begin  //delete the first header
        void'( next_hdr.disconnect_prev() );
		`uvme_cast(this.first_hdr, next_hdr, error)
	  end
	  else if(prev_hdr != null && next_hdr == null) begin  //delete the last header
        void'( prev_hdr.disconnect_next() );
		`uvme_cast(this.first_hdr, prev_hdr.get_first(), error)
	  end
	  
	  return this.remove_hdr(hdr);
	end
  endfunction : delete_hdr


  //Function: insert_back
  //
  //insert a header after the header with the given name;

  function bit insert_back(uvme_layer_header curHdr, uvme_layer_header hdr);
    if(!this.chk_hdr(curHdr)) begin
	  `uvme_error($psprintf("No header %s exist in %s", curHdr.get_name(), this.get_name()))
	  return 0;
	end

    if(this.chk_hdr(hdr)) begin //can not insert twice
	  `uvme_error($psprintf("The header %s already exist in %s", hdr.get_name(), this.get_name()))
	  return 0;
	end

    begin
      void'( hdr.insert_back(curHdr) );
	  void'( this.add_hdr(hdr) );
	  this.build_header_stack();
	  return 1;
	end
  endfunction : insert_back


  //Function: insert_front
  //
  //insert a header before the header with the given name;

  function bit insert_front(uvme_layer_header curHdr, uvme_layer_header hdr);
    if(!this.chk_hdr(curHdr)) begin
	  `uvme_error($psprintf("No header %s exist in %s", curHdr.get_name(), this.get_name()))
	  return 0;
	end

    if(this.chk_hdr(hdr)) begin //can not insert twice
	  `uvme_error($psprintf("The header %s already exist in %s", hdr.get_name(), this.get_name()))
	  return 0;
	end

    begin
      void'( hdr.insert_front(curHdr) );
	  `uvme_cast(this.first_hdr, hdr.get_first(), error)
	  void'( this.add_hdr(hdr) );
	  this.build_header_stack();
	  return 1;
	end
  endfunction : insert_front



  //Function: insert
  //
  //Always insert a header at the begining;

  function bit insert(uvme_layer_header hdr);
    if(this.first_hdr != null) begin
      return this.insert_front(this.first_hdr, hdr);
	end
	else begin
	  `uvme_cast(this.first_hdr, hdr.get_first(), error)
	  void'( this.add_hdr(hdr) );
	  this.build_header_stack();
	end
  endfunction : insert



  //Function: build_header_stack
  //
  //create an array which follow the sequence of the header link list;

  protected function void build_header_stack();
  	uvme_layer_header header_in_op;
	header_in_op = this.first_hdr;
	this.m_header_stack = {};
	while(header_in_op != null) begin
	  this.m_header_stack.push_back(header_in_op);
	  header_in_op = header_in_op.get_next();
	end
  endfunction : build_header_stack



  //Function: get_first_hdr
  //
  //get the header link list header;

  //function uvme_layer_header get_first_hdr();
  //  return this.first_hdr;
  //endfunction : get_first_hdr

  function uvme_layer_header get_first_hdr();
	string one_key;
    uvme_layer_header hdr_q[$];
    void'( this.m_header.first(one_key) );
	hdr_q = this.m_header[one_key];
	get_first_hdr = hdr_q[0].get_first();
  endfunction : get_first_hdr



  //Function: get_hdr
  //
  //get_hdr from packet with typeName, by default will get the first hdr of the save type.

  virtual function uvme_layer_header get_hdr(string typeName, int unsigned idx = 0);
    if(!this.m_header.exists(typeName)) begin
	  `uvme_error($psprintf("[get_hdr] No header with type %s in the packet!", typeName))
	  return null;
	end
	else if(idx < this.m_header[typeName].size()) begin
	  return this.m_header[typeName][idx];
	end
	else begin
	  `uvme_error($psprintf("[get_hdr] Idx %0d is out of range %0d!", idx, this.m_header[typeName].size()))
	  return null;
	end
  endfunction : get_hdr



  //Function: get_hdr_num
  //
  //get_hdr_num return the number of header with typeName.

  virtual function int unsigned get_hdr_num(string typeName);
    if(!this.m_header.exists(typeName)) begin
	  `uvme_error($psprintf("[get_hdr_num] No header with type %s in the packet!", typeName))
	  return 0;
	end
	else begin
	  return this.m_header[typeName].size();
	end
  endfunction : get_hdr_num



  //Function: convert2string
  //
  //Convert Packet content to string;

  virtual function string convert2string();
    string strValue;
	uvme_layer_header header_in_op;
	header_in_op = this.first_hdr;
	strValue = "";
	while(header_in_op != null) begin
	  strValue = {strValue, header_in_op.convert2string()};
	  header_in_op = header_in_op.get_next();
	end
	return strValue;
  endfunction : convert2string


  //Function: do_copy
  //
  // do_copy method
  // If two uvme_transaction what to do copy
  // Must have same header stack.
  
  function void do_copy(uvm_object rhs);
    uvme_transaction rhs_;
 
    if(!$cast(rhs_, rhs)) begin
      uvm_report_error("do_copy:", "Cast failed");
      return;
    end

    super.do_copy(rhs); // Chain the copy with parent classes

    this.m_header_stack = {};
	this.m_header.delete();
	this.first_hdr = null;

    begin
      uvme_layer_header rhs_first_header, src_header;
	  rhs_first_header = rhs_.get_first_hdr();
	  src_header = rhs_first_header.get_last();
	  while(src_header != null) begin
		begin
		  uvme_layer_header inert_header;
		  `uvme_cast(inert_header, src_header.clone(), fatal)
	      void'( this.insert(inert_header) );
		end
		src_header = src_header.get_prev();
	  end
    end       

  endfunction: do_copy


endclass : uvme_transaction


`endif  // UVME_TRANSACTION_SV

