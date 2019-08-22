///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_virtual_sequencer
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 2019-06-14 18:41:05
//     REVISION: ---
//
///////////////////////////////////////////////////////////////////////////////////////////////////

class pin_virtual_sequencer extends uvm_sequencer;

  pin_sequencer clk_rst_seqr[string];

  // ***************************************************************
  // UVM registration macros
  // ***************************************************************
  `uvm_component_utils_begin(pin_virtual_sequencer)
    `uvm_field_aa_object_string(clk_rst_seqr, UVM_ALL_ON)
  `uvm_component_utils_end

  // ***************************************************************
  // Constructor
  // ***************************************************************
  function new(string name = "pin_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  
endclass : pin_virtual_sequencer

