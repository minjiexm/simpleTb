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

`ifndef SWITCH_MODEL_CONFIG_SV
`define SWITCH_MODEL_CONFIG_SV

//------------------------------------------------------------------------------
//
// CLASS: switch_model_config
//
// switch_model_config is the base configuration class of switch_model.
// Right now only has port_num property of swtich.
// User should extend from this base class.
//
//------------------------------------------------------------------------------


class switch_model_config extends uvm_object;

  //Member: port_num
  //
  // Total port number of a switch_model.

  int unsigned port_num;

  //uvm factory macro
  `uvm_object_utils_begin(switch_model_config)
    `uvm_field_int(port_num, UVM_ALL_ON)
  `uvm_object_utils_end


  //Function: new
  //
  // Constructor

  function new (string name = "switch_model_config");
    super.new(name);

    begin
      //Setup uvm args for user to controll port number through command line args.
      `uvme_args_setup_int_arg("SWITCH_MODEL::PORT_NUM", "Define how many ports of the switch", 4)
      `uvme_args_get_int_arg("SWITCH_MODEL::PORT_NUM", this.port_num)
    end
  endfunction : new


endclass : switch_model_config


`endif //SWITCH_MODEL_CONFIG_SV