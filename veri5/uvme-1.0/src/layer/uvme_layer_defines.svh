//-----------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------

`ifndef UVME_LAYER_MACROS_SVH
`define UVME_LAYER_MACROS_SVH

//-----------------------------------------------------------------------------
// Title: Layer Macros
//
// These macros are used to define imp class to hook uvme_layer_input to other
// classes
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// MACRO: `uvme_layer_input_imp_decl
//
//| `uvme_layer_input_imp_decl(IMP, SFX)
//
// Hook ;
//-----------------------------------------------------------------------------
//
// declair final layer_input class which link to its parent's receive
// function.
//
// Parameter:
//   IMP : real type of layer input's parant.
//   SFX : final receive function which layer input should call.
//         IMP::SFX()
//
//| `uvme_layer_input_imp_decl(packet, myModel, ingress)
//
//| class myModel extends uvm_component;
//|   
//|   `uvme_layer_input_imp(IMP, SFX) ingress_input;
//|
//|   virtual function void ingress(T txn);
//|
//| endclass : myModel
//
//-----------------------------------------------------------------------------

`define uvme_layer_input_imp_decl(IMP, SFX) \
  class uvme_layer_input_``IMP``_``SFX #(type T = uvm_sequence_item) extends uvme_layer_input#(T); \
    IMP m_imp; \
\
    `uvm_component_param_utils(uvme_layer_input_``IMP``_``SFX) \
\
    function new(string name, uvm_component parent); \
      super.new(name, parent); \
      `uvme_cast(m_imp, parent, fatal); \
    endfunction : new \
\
    virtual task receive(T txn); \
      this.m_imp.SFX(txn); \
    endtask : receive \
\
  endclass : uvme_layer_input_``IMP``_``SFX



//-----------------------------------------------------------------------------
// MACRO: `uvme_layer_input_imp_with_label_decl
//
//| `uvme_layer_input_imp_with_label_decl(IMP, SFX)
//
//-----------------------------------------------------------------------------
//
// declair final analysis_input class which link to its parent's receive
// function. The difference between `uvme_layer_input_imp_with_label_decl 
// with `uvme_layer_input_imp_decl is that uvme_layer_input_imp_with_label_decl
// will call SFX(txn, idx) (means will pass a int label to SFX function).
// `uvme_layer_input_imp_with_label_decl should be used that several input share 
// same SFX function. Int Label is used to identify which input the txn come from.
//
// Parameter:
//   IMP : real type of analysis input's parant.
//   SFX : final receive function which analysis input should call.
//         IMP::SFX()
//
//| `uvme_layer_input_imp_with_label_decl(packet, myModel, ingress)
//|
//| class myModel extends uvm_component;
//|   
//|   `uvme_layer_input_imp(IMP, SFX) ingress_input[4];
//|
//|   virtual function void build_phase(phase);
//|     foreach(this.ingress_input[idx]) begin
//|       this.ingress_input[idx] = new("ingress_input", this);
//|       this.ingress_input[idx].set_label(idx);
//|     end
//|   endfunction : build_phase
//|
//|   virtual function void ingress(T txn, int unsigned idx);
//|
//| endclass : myModel
//
//-----------------------------------------------------------------------------

`define uvme_layer_input_imp_with_label_decl(IMP, SFX) \
  class uvme_layer_input_``IMP``_``SFX #(type T = uvm_sequence_item) extends uvme_layer_input#(T); \
    IMP m_imp; \
\
    `uvm_component_param_utils(uvme_layer_input_``IMP``_``SFX) \
\
    function new(string name, uvm_component parent); \
      super.new(name, parent); \
      `uvme_cast(m_imp, parent, fatal); \
    endfunction : new \
\
    virtual task receive(T txn); \
      this.m_imp.SFX(txn, this.m_label); \
    endtask : receive \
\
  endclass : uvme_layer_input_``IMP``_``SFX



//-----------------------------------------------------------------------------
// MACRO: `uvme_layer_input_imp
//
//| `uvme_layer_input_imp(T IMP, SFX)
//
//-----------------------------------------------------------------------------
//
// This define is the final type of uvme_layer_input_imp.
//
// Parameter:
//   T   : uvm_sequence_item type.
//   IMP : real type of analysis input's parant.
//   SFX : final receive function which analysis input should call.
//         IMP::SFX()
//
//| `uvme_layer_input_imp(packet, myModel, ingress) ingress_input;
//
//-----------------------------------------------------------------------------

`define uvme_layer_input_imp(T, IMP, SFX) uvme_layer_input_``IMP``_``SFX#(T)


`endif  // UVME_LAYER_MACROS_SVH
