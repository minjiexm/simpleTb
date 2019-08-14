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

`ifndef UVME_COUNTER_SVH
`define UVME_COUNTER_SVH

//------------------------------------------------------------------------------
// CLASS: uvme_counter
//
// Counter class. Used to centralize the counter function.
// Support increment and decrement the couters.
// Support print the counters' value.
// Will print trace log message when changing counters' value.
//------------------------------------------------------------------------------

class uvme_counter extends uvm_object;

  //Member: pool
  //counter pool

  protected int pool[string];

  `uvm_object_utils_begin(uvme_counter)
    `uvm_field_aa_int_string(pool, UVM_ALL_ON)
  `uvm_object_utils_end


  //Function: new
  //
  // Constructor

  function new (string name = "uvme_counter");
    super.new(name);
  endfunction : new


  //Function: inc
  //
  // increment the counter with name

  function void incr (string cnt_name, int unsigned inc_num = 1, string reason = "UNKNOW");
    int cnt_org_value;
	
    if(this.pool.exists(cnt_name)) begin
	  cnt_org_value = this.pool[cnt_name];
	  this.pool[cnt_name] += inc_num;
	end
	else begin
	  cnt_org_value = 0;
	  this.pool[cnt_name] = inc_num;
	end
    `uvme_trace_cnt_incr(cnt_name, cnt_org_value, this.pool[cnt_name], reason)
  endfunction : incr


  //Function: decr
  //
  // decrement the counter with name

  function void decr (string cnt_name, int unsigned dec_num = 1, string reason = "UNKNOW");
    int cnt_org_value;

    if(this.pool.exists(cnt_name)) begin
	  cnt_org_value = this.pool[cnt_name];
	  this.pool[cnt_name] -= dec_num;
	end
	else begin
      cnt_org_value = 0;
	  this.pool[cnt_name] = -dec_num;
	end
	
    `uvme_trace_cnt_decr(cnt_name, cnt_org_value, this.pool[cnt_name], reason)
  endfunction : decr

  
  //Function: get_value
  //
  // get the counter value with name

  function int get_value (string cnt_name);
    if(this.pool.exists(cnt_name)) begin
	  return this.pool[cnt_name];
	end
	else
	  return 0;
  endfunction : get_value

  
  //Function: get_counter_name
  //
  // put all the counters' name to the given associative array
  // 

  function void get_counter_name (ref string cnt_name_q[$]);
    foreach(this.pool[cnt_name]) begin
	  cnt_name_q.push_back(cnt_name);
	end
  endfunction : get_counter_name

  
  //Function: report
  //
  // Print counter value. Should be used in report_phase

  function void report ();
    foreach(this.pool[cnt_name]) begin
      `uvme_trace_cnt_report(cnt_name, this.pool[cnt_name])
	end
  endfunction : report
 

endclass : uvme_counter



`endif  // UVME_COUNTER_SVH
