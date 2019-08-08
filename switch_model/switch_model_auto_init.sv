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

`ifndef SWITCH_MODEL_AUTO_INIT_SV
`define SWITCH_MODEL_AUTO_INIT_SV


typedef class switch_model;

//------------------------------------------------------------------------------
//
// CLASS: switch_model_auto_init
//
// switch_model_auto_init is the intellgent API which can automaitc grep information 
// from topology and call config API to config DUT automaticlly.
//
//------------------------------------------------------------------------------


class switch_model_auto_init extends uvm_component;

  network_switch_driver physical_switch; //the switch within topology

  switch_model    p_switch; //DUT reference model

  bit auto_mac_table_init;

  `uvm_component_utils_begin(switch_model_auto_init)
    `uvm_field_object(physical_switch , UVM_ALL_ON)
    `uvm_field_object(p_switch , UVM_ALL_ON)
  `uvm_component_utils_end

  // ******************************************************************************
  // Constructor
  // ****************************************************************************** 
  function new(string name, uvm_component parent);
    super.new(name, parent);

    if(!$cast(p_switch, parent)) begin
      `uvm_fatal(this.get_type_name(), $psprintf("switch_auto_init's parent type %s is not switch_model", parent.get_type_name()))
    end
  endfunction : new


  //Function: build_phase
  //
  //standard UVM build_phase
  //
  //Setup command line args to control whether do auto init.
 
  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    `uvme_args_setup_int_arg("AUTO_MAC_TABLE_INIT", "Control whether auto cnofig mac table!", 1)
    `uvme_args_get_int_arg("AUTO_MAC_TABLE_INIT", auto_mac_table_init)

  endfunction : build_phase


  //Function: run_phase
  //
  //standard UVM run_phase
  //

  virtual task run_phase(uvm_phase phase);
    network_switch topology_switch;

    super.run_phase(phase);

    if(this.auto_mac_table_init) begin
      if(!uvm_config_db #(network_switch_driver)::get(this, "", "switch_driver", physical_switch)) begin
        `uvm_warning(this.get_type_name(), $psprintf("switch_auto_init can not start because can not find the physical switch!"))
      end
      else begin
        this.auto_init();
      end
    end
    else begin
      `uvm_info(this.get_type_name(), $psprintf("Bypass auto host mac table config!"), UVM_LOW)
    end
  endtask : run_phase


  //Function: auto_init
  //
  // auto_init will automatic get information from topology and config DUT.
  //

  virtual task auto_init();
    `uvme_trace_func_start("auto_init")

    foreach( this.physical_switch.ports[pidx] ) begin
      network_component ds_neighbour[$];
      this.physical_switch.ports[pidx].get_all_ds_neighours(ds_neighbour);
	  //`uvm_info(this.get_type_name(), $psprintf("this.physical_switch.connector[%0d].neighbour full name %s hosts.size %0d",pidx, this.physical_switch.connector[pidx].neighbour.get_full_name(), hosts.size()), UVM_LOW)
      foreach( ds_neighbour[hidx] ) begin
	    network_host host;
		if($cast(host, ds_neighbour[hidx])) begin  //there are host has been connected to the port.
          `uvme_info($psprintf("Config Port %0d Host mac address 0x%0h to mac table", pidx, host.address.mac), UVM_LOW)
          this.p_switch.mac_table.setup(host.address.mac, pidx); //config mac table, so there is no flood
		end
      end
    end

    `uvme_trace_func_end("auto_init")
  endtask : auto_init


endclass : switch_model_auto_init


`endif // SWITCH_MODEL_AUTO_INIT_SV
