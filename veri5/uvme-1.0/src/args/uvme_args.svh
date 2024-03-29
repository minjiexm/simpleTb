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

`ifndef UVME_ARGS_SVH
`define UVME_ARGS_SVH

//------------------------------------------------------------------------------
//
// CLASS: uvme_args
//
// The uvme_args class is an enhancement class on top of uvm_args.
// User no need to create uvm_event explicitly.
// User can directly call uvme_args::trigger("myEvent"); and
// uvme_args::wait_trigger("myEvent");
// There are build-in trace message print to help debug.
//------------------------------------------------------------------------------

class uvme_args extends uvm_object;

  protected static string msg_id = "UVME_ARGS";

  protected static uvme_args access = null;
  
  protected int unsigned totalArgNum = 0;

  protected uvme_args_type_e args_type[string];
  
  protected uvm_cmdline_processor cmdline_pro;
    
  protected bit not_print_args;

  `uvm_object_utils(uvme_args)

  //Function: new
  //
  //Constructor

  function new(string name = "uvme_args");
    super.new(name);
    this.cmdline_pro = uvm_cmdline_processor::get_inst();

    this.setup_int_arg("NOT_PRINT_ARGS", "Disable command line args description and value print at report phase", 0);
    this.not_print_args = this.get_int_arg("NOT_PRINT_ARGS");
  endfunction : new


  //Function: get_inst
  //Get global access object of uvme_args
  //For example:
  //| uvme_args args = uvme_args::get_inst();
  //
 
  static function uvme_args get_inst();
    if(uvme_args::access == null) begin
      uvme_args::access = new("uvem_args_access");
    end
    return uvme_args::access;
  endfunction : get_inst


  // Function : full_arg_name
  // uvme_args will add prefix "uvme_args" to the arg_name to make sure the args name will be uniq in config db.

  protected function string full_arg_name(input string argName);
    return {this.get_type_name(), "::", argName};
  endfunction : full_arg_name


  //Function: exists
  //
  // Check whether args exists
  
  function bit exists( input string argName);
    if(this.args_type.exists(argName))
      return 1;
    else
      return 0;
  endfunction : exists


  //Function: get_int_arg
  //
  // get an int value from an argument.

  function int get_int_arg( input string argName);
    int argValue;
    `uvme_args_get_arg_value_property(int, argName, value, argValue)
    //`uvme_trace_arg($psprintf("[get_int_arg] arg %s value %0d", argName, argValue))
    return argValue;
  endfunction : get_int_arg


  //Function: get_string_arg
  //
  // get an string value from an argument.

  function string get_string_arg( input string argName);
    string argValue;
    `uvme_args_get_arg_value_property(string, argName, value, argValue)
    //`uvme_trace_arg($psprintf("[get_string_arg] arg %s value %s", argName, argValue))
    return argValue;
  endfunction : get_string_arg



  //Function: get_int_arg_default
  //
  // get an int default arg value from an argument.

  function int get_int_arg_default( input string argName);
    int defValue;
    `uvme_args_get_arg_value_property(int, argName, default, defValue)
    return defValue;
  endfunction : get_int_arg_default


  //Function: get_string_arg_default
  //
  // get an string default arg value

  function string get_string_arg_default( input string argName);
    string defValue;
    `uvme_args_get_arg_value_property(string, argName, default, defValue)
    return defValue;
  endfunction : get_string_arg_default



  //Function: get_desc
  //
  // get an arg's description

  function string get_desc( input string argName);
    string strValue = "__UNDEFINE__";
    bit sucess = 0;
    `uvme_args_get_arg_property(string, argName, desc, strValue, sucess)
    if(sucess == 0) begin
      `uvm_error(uvme_args::msg_id, $psprintf("Fail to get description dut to arg %s does not exist!", argName))
    end
    return strValue;
  endfunction : get_desc


  //Function: setup_int_arg
  //
  // setup an int type argument

  function void setup_int_arg( input string argName, string argDesc, input int defValue = 0);
    string argValue;
    `uvme_args_setup(int, argName, argDesc, defValue)

    if(uvme_args::cmdline_pro.get_arg_value({"+", argName, "="}, argValue)) begin
      `uvme_args_set_arg_property(int, argName, value, argValue.atoi())
      `uvme_trace_arg($psprintf("[setup_int_arg] ArgName : %s get value %0d from command line", argName, argValue.atoi()))
    end
    else begin
      `uvme_args_set_arg_property(int, argName, value, defValue)
      `uvme_trace_arg($psprintf("[setup_int_arg] ArgName : %s get value %0d from default", argName, defValue))
    end
  endfunction : setup_int_arg



  //Function: setup_string_arg
  //
  // setup an string type argument

  function void setup_string_arg( input string argName, string argDesc, input string defValue ="__UNDEFINE__");
    string argValue;
    `uvme_args_setup(string, argName, argDesc, defValue)

    if(uvme_args::cmdline_pro.get_arg_value({"+", argName, "="}, argValue)) begin
      `uvme_args_set_arg_property(string, argName, value, argValue)
      `uvme_trace_arg($psprintf("[setup_string_arg] ArgName : %s get value %s from command line", argName, argValue))
    end
    else begin
      `uvme_args_set_arg_property(string, argName, value, defValue)
      `uvme_trace_arg($psprintf("[setup_int_arg] ArgName : %s get value %s from default", argName, defValue))
    end
  endfunction : setup_string_arg



  //Function: print_arg
  //
  // Pint give arg's description, type, default value and current value.

  function void print_arg(input string argName);
    if(this.exists(argName)) begin
      if(this.args_type[argName] == UVME_ARGS_TYPE_int) begin
        $display("Argument Name: %s", argName);
        $display("    Type: int");
        $display("    Desc: %s", this.get_desc(argName));
        $display("    Current Value: %0d", this.get_int_arg(argName));
        $display("    Default Value: %0d", this.get_int_arg_default(argName));
      end
      else begin
        $display("Argument Name: %s", argName);
        $display("    Type: string");
        $display("    Desc: %s", this.get_desc(argName));
        $display("    Current Value: %s", this.get_string_arg(argName));
        $display("    Default Value: %s", this.get_string_arg_default(argName));
      end
    end
  endfunction : print_arg



  //Function: print_all_args
  //
  // Pint out all args' description, type, default value and current value.

  function void print_all_args();
    if(!this.not_print_args) begin
      $display("\n");
      $display("********************************************************************************************************");
      $display("* Start to Print Arguments Used within uvm_enhance_args_center                                         *");
      $display("********************************************************************************************************");
      foreach (this.args_type[argName]) begin
        this.print_arg(argName);
      end
      $display("\n");
    end
  endfunction : print_all_args


endclass : uvme_args


`endif //UVME_ARGS_SVH

