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

`ifndef UVME_ARGS_DEFINES_SVH
`define UVME_ARGS_DEFINES_SVH

                                                            
// Types: uvme_args_type_e                                      
//                                                          
// uvme_args_type_e defines the type of arguments.        
//                                                          
// UVME_ARGS_TYPE_int                                             
// - int type                                     
//                                                          
// UVME_ARGS_TYPE_string                                             
// - string type                                       
                                                            
typedef enum {
  UVME_ARGS_TYPE_int,      //int type
  UVME_ARGS_TYPE_string    //string type
} uvme_args_type_e;


                                        
// Types: uvme_args_property_e                                      
//                                                          
// uvme_args_property_e defines the property of the args.        
//                                                          
// UVME_ARGS_PROPERTY_value                                             
// - args' current value                                     
//                                                          
// UVME_ARGS_PROPERTY_desc                                             
// - args' description
                                      
// UVME_ARGS_PROPERTY_default                                             
// - args' default value

typedef enum {
  UVME_ARGS_PROPERTY_value,
  UVME_ARGS_PROPERTY_desc,
  UVME_ARGS_PROPERTY_default
} uvme_args_property_e;



//-----------------------------------------------------------------------------
// MACRO : `uvme_args_setup_int_arg
//
//| `uvme_args_setup_int_arg(argName, Desc, DefaultValue)
//
// API used to setup int type arguments.
// Need pass argument description and default value.
//-----------------------------------------------------------------------------

`define uvme_args_setup_int_arg(argName, Desc, Default) \
  begin \
    uvme_args args = uvme_args::get_inst(); \
    args.setup_int_arg(argName, Desc, Default); \
  end


//-----------------------------------------------------------------------------
// MACRO : `uvme_args_setup_str_arg
//
//| `uvme_args_setup_str_arg(argName, Desc, DefaultValue)
//
// API used to setup string type arguments.
// Need pass argument description and default value.
//-----------------------------------------------------------------------------

`define uvme_args_setup_str_arg(argName, Desc, Default) \
  begin \
    uvme_args args = uvme_args::get_inst(); \
    args.setup_string_arg(argName, Desc, Default); \
  end


//-----------------------------------------------------------------------------
// MACRO : `uvme_args_get_int_arg
//
//| `uvme_args_get_int_arg(argName, value)
//
// Get int value from args. if args already passed from run command,
// otherwise will use default value.
//-----------------------------------------------------------------------------

`define uvme_args_get_int_arg(argName, value) \
  begin \
    uvme_args args = uvme_args::get_inst(); \
    value = args.get_int_arg(argName); \
  end


//-----------------------------------------------------------------------------
// MACRO : `uvme_args_get_str_arg
//
//| `uvme_args_get_str_arg(argName, value)
//
// Get string value from args. if args already passed from run command,
// otherwise will use default value.
//-----------------------------------------------------------------------------

`define uvme_args_get_str_arg(argName, value) \
  begin \
    uvme_args args = uvme_args::get_inst(); \
    value = args.get_string_arg(argName, value); \
  end


//-----------------------------------------------------------------------------
// MACRO : `uvme_args_print_all
//
//| `uvme_args_print_all
//
// Print all Arguments detail. Use at report phase to show all
// arguments for user reference.
//-----------------------------------------------------------------------------

`define uvme_args_print_all\
  begin \
    uvme_args args = uvme_args::get_inst(); \
    args.print_all_args(); \
  end



//-----------------------------------------------------------------------------
// MACRO : `uvme_args_set_arg_property
//
//| `uvme_args_set_arg_property(propType, argName, prop, argValue)
//
// Internal define and should not be used by user
//-----------------------------------------------------------------------------

`define uvme_args_set_arg_property(propType, argName, prop, argValue) \
  begin \
    uvme_args_property_e prop_e = UVME_ARGS_PROPERTY_``prop; \
    uvm_config_db#(propType)::set(null, this.full_arg_name(argName), prop_e.name, argValue); \
  end



//-----------------------------------------------------------------------------
// MACRO : `uvme_args_get_arg_property
//
//| `uvme_args_get_arg_property(propType, argName, prop, argValue)
//
// Internal define and should not be used by user
//-----------------------------------------------------------------------------

`define uvme_args_get_arg_property(propType, argName, prop, argValue, sucess) \
  begin \
    sucess = 0; \
    if(this.exists(argName)) begin \
      uvme_args_property_e prop_e = UVME_ARGS_PROPERTY_``prop; \
      if(uvm_config_db#(propType)::get(null, this.full_arg_name(argName), prop_e.name, argValue)) begin \
        sucess = 1; \
      end \
    end \
  end
  


//-----------------------------------------------------------------------------
// MACRO : `uvme_args_get_arg_value_property
//
//| `uvme_args_get_arg_value_property(propType, argName, prop, argValue)
//
// Internal define and should not be used by user
// prop can be value and default only
//-----------------------------------------------------------------------------

`define uvme_args_get_arg_value_property(propType, argName, prop, argValue) \
  begin \
    if(this.exists(argName)) begin \
      uvme_args_property_e prop_e = UVME_ARGS_PROPERTY_``prop; \
	  if(this.args_type[argName] == UVME_ARGS_TYPE_``propType) begin \
        void'( uvm_config_db#(propType)::get(null, this.full_arg_name(argName), prop_e.name, argValue)); \
	  end \
  	  else begin \
	    `uvm_error(uvme_args::msg_id, $psprintf(`"Try to get prop from a non propType arg %s`", argName)) \
	  end \
    end \
    else begin \
  	  `uvm_error(uvme_args::msg_id, $psprintf(`"Arg %s does not exist!`", argName)) \
    end \
  end



//-----------------------------------------------------------------------------
// MACRO : `uvme_args_setup
//
//| `uvme_args_setup(argType, argName, description, defValue)
//
// Internal define and should not be used by user
//-----------------------------------------------------------------------------

`define uvme_args_setup(argType, argName, description, defValue) \
  begin \
    if(!this.exists(argName)) begin \
	  this.args_type[argName] = UVME_ARGS_TYPE_``argType; \
      `uvme_args_set_arg_property(string, argName, desc, description) \
	  `uvme_args_set_arg_property(argType, argName, default, defValue) \
    end \
    else begin \
      string desc; \
	  argType def_value; \
      desc = this.get_desc(argName); \
      `uvme_args_get_arg_value_property(argType, argName, default, def_value) \
\
      if(desc != description) begin \
	    `uvme_args_set_arg_property(string, argName, desc, description) \
        `uvm_warning(uvme_args::msg_id, $psprintf("Updating ARG: %s description from %s to %s!", argName, desc, description)) \
      end \
\
      if(def_value != defValue) begin \
        `uvm_fatal(uvme_args::msg_id, $psprintf("Fail to setup ARG: %s with default value %0d because it already exists with default value %0d!", argName, defValue, def_value)) \
      end \
    end \
    `uvme_trace_arg($psprintf(`"[setup_``artType``_args] ArgName: argName  Description: description`")) \
  end


`endif  // UVME_ARGS_DEFINES_SVH
