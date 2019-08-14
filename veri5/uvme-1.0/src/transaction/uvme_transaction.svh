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


  //UVM factory macro
  `uvm_object_utils_begin(uvme_layer_header)
    `uvm_field_object(prev_hdr, UVM_ALL_ON)
	`uvm_field_object(next_hdr, UVM_ALL_ON)
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

  //Function: insert_after
  //
  //Link next to a header, will be the next header of the header.

  virtual function bit insert_after(uvme_layer_header hdr);  
    if(!this.isolated) begin
	  `uvme_error($psprintf("[insert_after] %s is not an isolated header! Can not do insert_after action!", this.get_name()))
	  return 0;
	end
	else begin
      uvme_layer_header target_hdr_next;

      if(hdr.get_next() != null)
        `uvme_cast(target_hdr_next,	hdr.get_next(), error)

      if(target_hdr_next != null) begin
	    void'( target_hdr_next.link_prev(this) );
	  end

      void'( hdr.link_next(this) );
      void'( this.link_prev(hdr) );
	end
  endfunction : insert_after



  //Function: insert_ahead
  //
  //Insert before a header, will be the previous header of the header.

  virtual function bit insert_ahead(uvme_layer_header hdr);
    if(!this.isolated) begin
	  `uvme_error($psprintf("[insert_after] %s is not an isolated header! Can not do insert_after action!", this.get_name()))
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
  endfunction : insert_ahead




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

  bit [7:0] data[];

  int unsigned length;

  //UVM factory macro
  `uvm_object_utils_begin(uvme_payload_header)
    `uvm_field_array_int(data, UVM_ALL_ON)
    `uvm_field_int(length, UVM_ALL_ON)
  `uvm_object_utils_end

  // Function: new
  //
  // Constructor

  function new(string name = "uvme_payload_header");
    super.new(name);
  endfunction : new


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

  protected uvme_layer_header hdr_stack[string];

  protected uvme_layer_header first_hdr;

  //UVM factory macro
  `uvm_object_utils_begin(uvme_transaction)
  `uvm_object_utils_end


  // Function: new
  //
  // Constructor

  function new(string name = "uvme_payload_header");
    super.new(name);
	this.construct();
  endfunction : new



  // Function: construct
  //
  // User should insert more header here

  virtual function void construct();
    this.hdr_stack["payload"] = uvme_payload_header::type_id::create("payload");
    `uvme_cast(this.first_hdr, this.hdr_stack["payload"], error)
  endfunction : construct


  //Function: get_hdr
  //
  //Get layer header by name;
 
  virtual function uvme_layer_header get_hdr(string hdrName);
    if(this.hdr_stack.exists(hdrName))
	  return this.hdr_stack[hdrName];
	else
	  `uvme_error($psprintf("[get_hdr] There is no header whose name is %s", hdrName))
  endfunction : get_hdr


  //Function: delete_hdr
  //
  //delete layer header by name;
 
  function bit delete_hdr(string hdrName);
    if(this.hdr_stack.exists(hdrName)) begin
	  uvme_layer_header prev_hdr, next_hdr;
	  
	  if(this.hdr_stack[hdrName].get_prev() != null)
	    `uvme_cast(prev_hdr, this.hdr_stack[hdrName].get_prev(), error)
		
      if(this.hdr_stack[hdrName].get_next() != null)
	    `uvme_cast(next_hdr, this.hdr_stack[hdrName].get_next(), error)

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
	  
	  this.hdr_stack.delete(hdrName);
	  return 1;
	end
	else
	  `uvme_error($psprintf("[delete_hdr] There is no header whose name is %s", hdrName))
	return 0;
  endfunction : delete_hdr


  //Function: insert_after
  //
  //insert a header after the header with the given name;

  function bit insert_after(string hdrName, uvme_layer_header hdr);
    if(this.hdr_stack.exists(hdrName)) begin
      void'( hdr.insert_after(this.hdr_stack[hdrName]) );
	  return 1;
	end
	else
	  `uvme_error($psprintf("[insert_after] There is no header whose name is %s", hdrName))
	return 0;
  endfunction : insert_after


  //Function: insert_ahead
  //
  //insert a header before the header with the given name;

  function bit insert_ahead(string hdrName, uvme_layer_header hdr);
    if(this.hdr_stack.exists(hdrName)) begin
      void'( hdr.insert_ahead(this.hdr_stack[hdrName]) );
	  `uvme_cast(this.first_hdr, this.hdr_stack[hdrName].get_first(), error)
	  return 1;
	end
	else
	  `uvme_error($psprintf("[insert_ahead] There is no header whose name is %s", hdrName))
	return 0;
  endfunction : insert_ahead



  //Function: get_first_hdr
  //
  //get the header link list header;

  function uvme_layer_header get_first_hdr();
    return this.first_hdr;
  endfunction : get_first_hdr


endclass : uvme_transaction


`endif  // UVME_TRANSACTION_SV

