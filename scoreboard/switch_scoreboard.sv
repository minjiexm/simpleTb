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

`ifndef SWITCH_SCOREBOARD_SV
`define SWITCH_SCOREBOARD_SV

//Class: switch_scoreboard
//
//Top level switch scoreboad
//

class switch_scoreboard extends uvm_component;
  protected int unsigned port_size;
  
  switch_scoreboard_checker port_checker[];

  //Register with factory
  `uvm_component_utils_begin(switch_scoreboard);
    `uvm_field_int(port_size, UVM_ALL_ON)
    //`uvm_field_array_object(port_checker, UVM_ALL_ON)
  `uvm_component_utils_end
    
  //Function: new
  //
  //Constructor

  function new(string name = "switch_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Build phase - Construct the cfg and env class using factory
  //Get the virtual interface handle from Test and then set it config db for the env component
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(int)::get(this, "", "port_size", this.port_size))
      this.port_size = 4;  //default port size
	  
    this.port_checker = new[this.port_size];
	
	foreach(this.port_checker[cidx]) begin
      this.port_checker[cidx] = switch_scoreboard_checker::type_id::create(uvme_pkg::name_in_array("port_checker", cidx), this);
	end

  endfunction : build_phase

  
endclass : switch_scoreboard


`endif  // SWITCH_SCOREBOARD_SV

