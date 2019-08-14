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

`ifndef UVME_COMMON_SVH
`define UVME_COMMON_SVH

//Function: name_in_array
//
//Return the string name with the idx.
//
//For example:
//| string name = "myName";
//| string array_name = name_in_array(name, 4);
//| $display("array_name %s", array_name); 
//
// The array_name will be "myName[4]".

function string name_in_array(input string name, input int unsigned idx);
  string name_str;
  name_str.itoa(idx);
  if(idx <=9)
    name_str = {name, "[0", name_str, "]"};
  else
    name_str = {name, "[", name_str, "]"};
  
  return name_str;
endfunction : name_in_array


`endif  // UVME_COMMON_SVH
