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

`ifndef  ETH_PKT_RECEIVER_SV
`define  ETH_PKT_RECEIVER_SV

class veri5_eth_receiver extends uvm_driver#(uvm_sequence_item);

  rand bit busy;

  `uvm_component_utils(veri5_eth_receiver)

  virtual veri5_eth_intf vif;

  // ******************************************************************************
  // Constructor
  // ******************************************************************************
  function new (string name = "veri5_eth_receiver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  // *******************************************************************************
  // build_phase
  // *******************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if( !uvm_config_db#(virtual veri5_eth_intf)::get(this, "", "vif", this.vif) ) begin
      `uvm_error(this.get_type_name(), $psprintf("[build_phase] %s can not get veri5_eth_intf from config db", this.get_name()))
    end

  endfunction : build_phase

  // *******************************************************************************
  // drive Transaction
  // *******************************************************************************
  virtual task run_phase(uvm_phase phase);
    int unsigned byte_idx = 0;

    super.run_phase(phase);

    forever begin
      @vif.receive;
      void'( std::randomize(busy) );
      vif.receive.drdy <= busy;
    end

  endtask : run_phase

endclass : veri5_eth_receiver

`endif //ETH_PKT_RECEIVER_SV

