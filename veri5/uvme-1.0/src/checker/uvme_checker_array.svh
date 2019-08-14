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
`ifndef UVME_CHECKER_ARRAY_SVH
`define UVME_CHECKER_ARRAY_SVH

//------------------------------------------------------------------------------
//
// CLASS: uvme_checker_array
//
// uvme_checker is a mini scoreboard.
//
//------------------------------------------------------------------------------

class uvme_checker_array #(type T = uvm_sequence_item) extends uvme_checker#(T);

  typedef uvme_checker_array#(T) this_type;

  typedef uvme_checker#(T) pchecker_type;

  int unsigned checker_array_size;
  protected pchecker_type m_checker[];
  
  uvme_checker_type_e checker_type;

  `uvm_component_param_utils_begin(this_type)
    `uvm_field_enum(uvme_checker_type_e, checker_type, UVM_ALL_ON)
  `uvm_component_utils_end

  //Function: new
  //
  // Constructor

  function new (string name = "uvme_checker", uvm_component parent);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  // Standard UVM build_phase function
  // create implementation port to receive data from DUT and reference model

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
	if( uvm_config_db#(int)::get(this, "", "size", this.checker_array_size) ) begin
	  this.m_checker = new[this.checker_array_size];
	end
	else
	  this.m_checker = new[1];

    foreach(this.m_checker[idx]) begin
	   this.m_checker[idx] = new pchecker_type::type_id::create(uvme_pkg::name_in_array("checker",idx), this);
	   this.m_checker[idx].checker_type = this.checker_type;
	end
  endfunction : build_phase


  //Function: write_uvme_checker_array_dut
  //
  // Hooker function, link imp port to search_and_compare function
  
  virtual function void write_uvme_checker_dut(T dut_trans);
    int unsigned checker_idx = this.get_checker_index(dut_trans);
	if(checker_idx < this.m_checker.size()) begin
	  this.m_checker[checker_idx].write_dut(dut_trans);
	end
	else
	  `uvme_out_of_range($psprintf("[write_uvme_checker_array_dut] checker_idx %0d out of range %s", checker_idx, this.m_checker.size()), error)
  endfunction : write_uvme_checker_dut


  //Function: write_uvme_checker_ref
  //
  // Hooker function, link imp port to search_and_compare function
  
  virtual function void write_uvme_checker_ref(T ref_trans);
    int unsigned checker_idx = this.get_checker_index(ref_trans);
	if(checker_idx < this.m_checker.size()) begin
	  this.m_checker[checker_idx].write_ref(ref_trans);
	end
	else
	  `uvme_out_of_range($psprintf("[write_uvme_checker_ref] checker_idx %0d out of range %s", checker_idx, this.m_checker.size()), error)
  endfunction : write_uvme_checker_ref



  //Function: get_checker_index
  //
  //Get checker id from the packet.
  // For example, get vlan id from packet as checker idx, within a vlan there is no out of order happen.
 
  virtual function int unsigned get_checker_index(T trans);
    `uvme_no_child_imp_error("get_checker_index")
	return 0;
  endfunction : get_checker_index

  
endclass : uvme_checker_array


`endif  // UVME_CHECKER_ARRAY_SVH