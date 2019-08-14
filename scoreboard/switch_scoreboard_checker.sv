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

`ifndef SWITCH_SCOREBOARD_CHECKER_SV
`define SWITCH_SCOREBOARD_CHECKER_SV

//Class: switch_scoreboard_checker
//
//Top level switch scoreboad
//

class switch_scoreboard_checker extends uvme_checker#(amiq_eth_packet);


  //Register with factory
  `uvm_component_utils(switch_scoreboard_checker);
    
  //Function: new
  //
  //Constructor

  function new(string name = "switch_scoreboard_checker", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  
endclass : switch_scoreboard_checker


`endif  // SWITCH_SCOREBOARD_CHECKER_SV