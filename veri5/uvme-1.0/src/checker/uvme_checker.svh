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
`ifndef UVME_CHECKER_SVH
`define UVME_CHECKER_SVH

//------------------------------------------------------------------------------
//
// CLASS: uvme_checker
//
// uvme_checker is a mini scoreboard.
//
//------------------------------------------------------------------------------

`uvm_analysis_imp_decl(_uvme_checker_dut)
`uvm_analysis_imp_decl(_uvme_checker_ref)

class uvme_checker #(type T = uvm_sequence_item) extends uvm_component;

  typedef uvme_checker#(T) this_type;
  typedef uvm_analysis_imp_uvme_checker_dut#(T, this_type) dut_imp_type;
  typedef uvm_analysis_imp_uvme_checker_ref#(T, this_type) ref_imp_type;
  
  uvme_checker_type_e checker_type;

  uvm_analysis_export#(T) dut_in_exp;
  uvm_analysis_export#(T) ref_in_exp;

  // queues holding the transactions from different sources
  T dut_q[$];
  T ref_q[$];

  protected uvme_counter counter;

  // implementation ports instances
  protected dut_imp_type  dut_in_imp;
  protected ref_imp_type  ref_in_imp;

  `uvm_component_param_utils_begin(this_type)
    `uvm_field_enum(uvme_checker_type_e, checker_type, UVM_ALL_ON)
  `uvm_component_utils_end

  //Function: new
  //
  // Constructor

  function new (string name = "uvme_checker", uvm_component parent);
    super.new(name, parent);
	this.checker_type = UVME_CHECKER_TYPE_Inorder;
  endfunction : new


  //Function: build_phase
  //
  // Standard UVM build_phase function
  // create implementation port to receive data from DUT and reference model

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.counter = uvme_counter::type_id::create({this.get_full_name(),".counter"});
    this.dut_in_exp = new("dut_in_exp", this);
    this.ref_in_exp = new("ref_in_exp", this);
    this.dut_in_imp = new("dut_in_imp", this);
    this.ref_in_imp = new("ref_in_imp", this);
  endfunction : build_phase


  //Function: connect_phase
  //
  // Standard UVM connect_phase function
  // create implementation port to receive data from DUT and reference model

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.dut_in_exp.connect(this.dut_in_imp);
    this.ref_in_exp.connect(this.ref_in_imp);
  endfunction : connect_phase


  //Function: write_uvme_checker_dut
  //
  // Hooker function, link imp port to search_and_compare function
  
  virtual function void write_uvme_checker_dut(T dut_trans);
    this.write_dut(dut_trans);
  endfunction : write_uvme_checker_dut


  //Function: write_uvme_checker_ref
  //
  // Hooker function, link imp port to search_and_compare function
  
  virtual function void write_uvme_checker_ref(T ref_trans);
    this.write_ref(ref_trans);
  endfunction : write_uvme_checker_ref


  //Function: write_ref
  //
  // Function interface which can be used to get refer data through function call
  
  function void write_ref(T ref_trans);
    bit txn_is_dut = 0;
    this.search_and_compare(ref_trans, this.dut_q, this.ref_q, txn_is_dut);
  endfunction : write_ref
  
  
  //Function: write_dut
  //
// Function interface which can be used to get DUT data through function call
    
  function void write_dut(T dut_trans);
    bit txn_is_dut = 1;
    this.search_and_compare(dut_trans, this.ref_q, this.dut_q, txn_is_dut);
  endfunction : write_dut

    
  //Function: search_and_compare
  //
  // When DUT or Ref data come in, get the right data to compare.
  
  function void search_and_compare(T txn, ref T search_q[$], ref T save_q[$], bit txn_is_dut);
    case(this.checker_type)
	  UVME_CHECKER_TYPE_Inorder : begin
	    this.search_and_compare_in_order(txn, txn_is_dut);
	  end
	  UVME_CHECKER_TYPE_Outorder : begin
	    this.search_and_compare_out_order(txn, search_q, save_q, txn_is_dut);
	  end
	  default : `uvme_error($psprintf("[search_and_compare] Checker Mode %s not implemented!", this.checker_type.name))
	endcase
  endfunction : search_and_compare



  //Function: search_and_compare_in_order
  //
  // When DUT or Ref data come in, get the right data to compare.
  // This compare is expect there is no drop and out of order happen.
  
  function void search_and_compare_in_order(T txn, bit txn_is_dut);
    T dut_txn, ref_txn;
	
	if(txn_is_dut)
	   this.dut_q.push_back(txn);
	else
	   this.ref_q.push_back(txn);
	   
	while( this.dut_q.size() > 0 && this.ref_q.size() >0 ) begin
	  bit first_param_is_dut = 1;
	  dut_txn = this.dut_q.pop_front();
	  ref_txn = this.ref_q.pop_front();
	  void'( this.compare(dut_txn, ref_txn, first_param_is_dut) );
	end
	
  endfunction : search_and_compare_in_order
  


  //Function: search_and_compare_out_order
  //
  // When DUT or Ref data come in, get the right data to compare.
  // This compare is expect there is out of order behavior of DUT

  function void search_and_compare_out_order(T txn, ref T search_q[$], ref T save_q[$], bit txn_is_dut);
    int indexes[$];
    int matching_index = -1;

    indexes = search_q.find_first_index(it) with ( this.quiet_compare(txn, it));
	
    if (indexes.size() == 0) begin
      save_q.push_back(txn);
      return;
    end
    foreach(indexes[i]) begin
      if (this.compare(txn, search_q[indexes[i]], txn_is_dut)) begin
        matching_index = i;
        break;
      end
    end

    // how you handle the case of partial match depends a lot on your context
    // you can trigger an error, warning or just save the transaction in the queue
    if (matching_index == -1) begin
      save_q.push_back(txn);
      `uvm_warning("CHECKER_INCOMPLETE_MATCH_WRN", $sformatf("Found %d transactions that partially match the searched transaction", indexes.size()))
    end
  
    // sample a_trans coverage
    search_q.delete(matching_index);
  
  endfunction : search_and_compare_out_order
  
  
  
  //Function: quiet_compare
  //
  // Some protocol build sequence ID in the packets, so we can use the id to find the packets
  // instead do full compare
  // If there is any mismatch, no eror message will be printed;
  
  virtual function bit quiet_compare(T ref1, T ref2);
    return ref1.compare(ref2);
  endfunction : quiet_compare
  
  
  
  //Function: compare
  //
  //Compare dut data to ref data.
  //If there is any mismatch, eror message will be printed out;
  //
  //Parameter:
  //  first_param_is_dut
  //    - first_param_is_dut is 1 means first_txn is dut, sec_txn is ref
  //      otherwise sec_txn is dut, first_txn is ref
  //      first_param_is_dut is nothing else but for control log message print.
  //      You will know which side is DUT data content.
 
  virtual function bit compare(T first_txn, T sec_txn, bit first_param_is_dut = 1);
    T dut_txn, ref_txn;
	
	if(first_param_is_dut) begin
	  dut_txn = first_txn;
	  ref_txn = sec_txn;
	end
	else begin
	  dut_txn = sec_txn;
	  ref_txn = first_txn;
	end

    if(!first_txn.compare(sec_txn)) begin
	  compare = 0;
	  this.counter.incr("MISMATCH", 1, "compare");
	  `uvme_data_mismatch($psprintf("compare [DUT] %s mismatch with [REF] %s", dut_txn.convert2string(), ref_txn.convert2string()), error)
	end
	else begin
	  compare = 1;
	  this.counter.incr("MATCH", 1, "compare");
	  `uvme_info($psprintf("compare [DUT] match with [REF]. GOOD!"), UVM_HIGH)
	end
  endfunction : compare
  
  
  
  // at the end of the test we need to check that the two queues are empty
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    CHECKER_REF_Q_NOT_EMPTY_ERR : assert(this.ref_q.size() == 0) else
      `uvm_error("COMPARATOR_REF_Q_NOT_EMPTY_ERR", $sformatf("ref_q is not empty!!! It still contains %d transactions!", this.ref_q.size()))
    CHECKER_DUT_Q_NOT_EMPTY_ERR : assert(this.dut_q.size() == 0) else
      `uvm_error("COMPARATOR_DUT_Q_NOT_EMPTY_ERR", $sformatf("dut_q is not empty!!! It still contains %d transactions!", this.dut_q.size()))
  endfunction : check_phase


  // Function: report_phase
  //
  // Standard uvm report_phase function
  // Print Counters' value

  virtual function void report_phase (uvm_phase phase);
    super.report_phase(phase);
    this.counter.report();
  endfunction : report_phase


  
endclass : uvme_checker


`endif  // UVME_CHECKER_SVH