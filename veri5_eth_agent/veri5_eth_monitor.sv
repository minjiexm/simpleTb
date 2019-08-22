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

`ifndef  VERI5_ETH_MONITOR_SV
`define  VERI5_ETH_MONITOR_SV

//------------------------------------------------------------------------------
// CLASS: veri5_eth_monitor
//
// This monitor is used to receive veri5_eth_packet from a switch model (fake DUT).
//
//------------------------------------------------------------------------------

class veri5_eth_monitor extends veri5_eth_packet_monitor_base;

  int unsigned idle_timeout = 1024;
  int unsigned idle_cnt = 0;
  bit busy = 0;
  
  virtual veri5_eth_intf vif;

  `uvm_component_utils(veri5_eth_monitor)

  //Function: new
  //
  //Constructor

  function new (string name = "veri5_eth_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  //Function: build_phase
  //
  //Standard UVM build_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
    if( !uvm_config_db#(virtual veri5_eth_intf)::get(this, "", "vif", this.vif) ) begin
      `uvm_error(this.get_type_name(), $psprintf("[build_phase] %s can not get veri5_eth_intf from config db", this.get_name()))
    end

  endfunction : build_phase


  //Function: run_phase
  //
  //Standard UVM run_phase

  virtual task run_phase(uvm_phase phase);
    bit [7:0] pkt_data[$];

    `uvme_trace_func_start("run_phase")

    forever begin
      @vif.passive;

      //check idle
      begin : CHEKC_IDLE
	    if(vif.passive.srdy && vif.passive.drdy) begin
	      this.idle_cnt = this.idle_timeout;
		  if(this.busy == 0) begin
  		    this.busy = 1;
			phase.raise_objection(this);
		  end
		end
	    else if(this.idle_cnt > 0)
	      this.idle_cnt--;
		  
		if(this.busy == 1 && this.idle_cnt == 0) begin
		  this.busy = 0;
		  phase.drop_objection(this);
		end
      end


	  if(vif.passive.srdy && vif.passive.drdy && vif.passive.sop) begin
	    pkt_data = {};
	  end

	  if(vif.passive.srdy && vif.passive.drdy) begin	 
	    pkt_data.push_back(vif.passive.data);
	  end
	
	  if(vif.passive.srdy && vif.passive.drdy && vif.passive.eop) begin
	    bit [7:0] data_array[];
	    veri5_eth_packet pkt = veri5_eth_packet::type_id::create("pkt");
		`uvme_queue2array(pkt_data, data_array)
		if(pkt.unpack_bytes(data_array)) begin
	      `uvme_trace_data($psprintf("[receive_packet] Recevied a packet %s from Interface", pkt.convert2string()))
		  this.item_collected_port.write(pkt);
		end
		else
		  `uvme_error($psprintf("[receive_packet] %s Can not to receive the packet due to unpack fail!", this.get_name()))
	  end
	end

  endtask : run_phase


endclass : veri5_eth_monitor


`endif //VERI5_ETH_MONITOR_SV
