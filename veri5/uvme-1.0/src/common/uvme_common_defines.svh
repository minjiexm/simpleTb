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

`ifndef UVME_COMMON_DEFINES_SVH
`define UVME_COMMON_DEFINES_SVH



// Types: uvme_ei_enum
//
// uvme_ei_enum defines the type of error injection.
//
// UVME_EI_NONE
// - No error injection
//
// UVME_EI_DROP
// - Drop the data

typedef enum {
  UVME_EI_NONE,
  UVME_EI_DROP
} uvme_ei_enum;



//-----------------------------------------------------------------------------
// MACRO: `uvme_undef_str
//
//| `uvme_undef_str
//
// Indicate that a string is not set a valid value;
//-----------------------------------------------------------------------------
`define uvme_undef_str "__UNDEFINED__"


//-----------------------------------------------------------------------------
// MACRO: `uvme_def_str(def)
//
//| `uvme_def_str(def)
//
// convert a define to a string, if define was changed, the content of output
// string will also be changed.
//-----------------------------------------------------------------------------

`define uvme_def_str(def) "``def"


//-----------------------------------------------------------------------------
// MACRO: `uvme_def_comb_str(def1, def2)
//
//| `uvme_def_comb_str(def1, def1)
//
// combine two defines into a string
//-----------------------------------------------------------------------------

`define uvme_def_comb_str(def1, def2) "``def1``def2"


//-----------------------------------------------------------------------------
// MACRO: `uvme_cast
//
//| `uvme_cast(dst, src, err_type)
//
// If $cast fail will report an error message or a fatal message with message
// id TYPE_MISMATCH
//
//For example : below codes will report error if type mismatch
//
//| `uvme_cast(txn, seq_item, error)
//|
//| `uvme_cast(txn, seq_item, fatal)
//-----------------------------------------------------------------------------

`define uvme_cast(dst, src, err_type) \
  if(!$cast(dst, src)) begin \
    `uvme_type_mismatch_``err_type(`"dst`", src) \
  end


//-----------------------------------------------------------------------------
// MACRO: `uvme_cast_array
//
//| `uvme_cast_array(dst_array, src_array, err_type)
//
// Will cast each item in the src_array to dst_array, If $cast fail will report
//  an error message or a fatal message with message id TYPE_MISMATCH
// If dst array is not newed, will new at first.
//
//For example : below codes will report error if type mismatch
//
//| myAgent agent_array[];
//
//| `uvme_cast(agent_array, org_agent_array, error)
//|
//| `uvme_cast(agent_array, org_agent_array, fatal)
//
//-----------------------------------------------------------------------------

`define uvme_cast_array(dst_array, src_array, err_type) \
  begin \
    if(dst_array.size() == 0) begin \
      dst_array = new[src_array.size()]; \
    end \
    foreach(src_array[idx]) begin \
      if(!$cast(dst_array[idx], src_array[idx])) begin \
        `uvme_type_mismatch($psprintf("Fail to cast array the %0dth item %s type %s to dst_array[%0d]", idx, src_array[idx].get_full_name(), src_array[idx].get_type_name(), idx), err_type) \
      end \
    end \
  end


//-----------------------------------------------------------------------------
// MACRO: `uvme_queue2array
//
//| `uvme_queue2array(queue, array)
//
// Copy queue content to an dynamic array.
// All content in dynamic array will be deleted before copy.
//-----------------------------------------------------------------------------

`define uvme_queue2array(queue, array) \
  begin \
    array.delete(); \
	array = new[queue.size()]; \
	foreach(array[idx]) begin \
      array[idx] = queue[idx]; \
    end \
  end
  
//-----------------------------------------------------------------------------
// MACRO: `uvme_array2queue
//
//| `uvme_array2queue(array, queue)
//
// Copy dynamic array content to an array.
// All content in queue will be deleted before copy.
//-----------------------------------------------------------------------------
  
`define uvme_array2queue(array, queue) \
  begin \
    queue = {}; \
	foreach(array[idx]) begin \
      queue.push_back(array[idx]); \
    end \
  end
 

`endif  // UVME_COMMON_DEFINES_SVH
