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

//`timescale 1ns/1ns

//-------------------------------------------
// Top level Test module
//  Includes all env component and sequences files 
//    (you could ideally create an env package and import that as well instead of including)
//-------------------------------------------

//--------------------------------------------------------
//Top level module that instantiates
//No real DUT or APB slave as of now
//--------------------------------------------------------

module testbench;

  //------------------------------------------------//
  // Instance Clock and Reset
  //------------------------------------------------//
  wire clk;
  wire rst;

  pin_intf pin_if();

  initial begin
    force clk = pin_if.pins[0];
    force rst = pin_if.pins[1];
  end

  //------------------------------------------------//
  // Instance Interfaces for drivers and monitors
  //------------------------------------------------//
  veri5_eth_intf p0_pkt_drv_intf(clk, rst);
  veri5_eth_intf p1_pkt_drv_intf(clk, rst);
  veri5_eth_intf p2_pkt_drv_intf(clk, rst);
  veri5_eth_intf p3_pkt_drv_intf(clk, rst);

  veri5_eth_intf p0_pkt_mon_intf(clk, rst);
  veri5_eth_intf p1_pkt_mon_intf(clk, rst);
  veri5_eth_intf p2_pkt_mon_intf(clk, rst);
  veri5_eth_intf p3_pkt_mon_intf(clk, rst);
  
  //------------------------------------------------//
  // Instance DUT
  //------------------------------------------------//
  logic [7:0]   p0_data_i          ;
  logic         p0_sop_i           ;
  logic         p0_eop_i           ;
  logic         p0_srdy_i          ;
  logic         p0_drdy_o          ;

  logic [7:0]   p0_data_o          ;
  logic         p0_sop_o           ;
  logic         p0_eop_o           ;
  logic         p0_srdy_o          ;
  logic         p0_drdy_i          ;

  logic [7:0]   p1_data_i          ;
  logic         p1_sop_i           ;
  logic         p1_eop_i           ;
  logic         p1_srdy_i          ;
  logic         p1_drdy_o          ;

  logic [7:0]   p1_data_o          ;
  logic         p1_sop_o           ;
  logic         p1_eop_o           ;
  logic         p1_srdy_o          ;
  logic         p1_drdy_i          ;

  logic [7:0]   p2_data_i          ;
  logic         p2_sop_i           ;
  logic         p2_eop_i           ;
  logic         p2_srdy_i          ;
  logic         p2_drdy_o          ;

  logic [7:0]   p2_data_o          ;
  logic         p2_sop_o           ;
  logic         p2_eop_o           ;
  logic         p2_srdy_o          ;
  logic         p2_drdy_i          ;

  logic [7:0]   p3_data_i          ;
  logic         p3_sop_i           ;
  logic         p3_eop_i           ;
  logic         p3_srdy_i          ;
  logic         p3_drdy_o          ;

  logic [7:0]   p3_data_o          ;
  logic         p3_sop_o           ;
  logic         p3_eop_o           ;
  logic         p3_srdy_o          ;
  logic         p3_drdy_i          ;


  switch_DUT_top switch_DUT_top(.*);

  initial begin
    force p0_data_i            = p0_pkt_drv_intf.data    ;
    force p0_sop_i             = p0_pkt_drv_intf.sop     ;
    force p0_eop_i             = p0_pkt_drv_intf.eop     ;
    force p0_srdy_i            = p0_pkt_drv_intf.srdy    ;
    force p0_pkt_drv_intf.drdy = p0_drdy_o               ;

    force p0_pkt_mon_intf.data = p0_data_o               ;
    force p0_pkt_mon_intf.sop  = p0_sop_o                ;
    force p0_pkt_mon_intf.eop  = p0_eop_o                ;
    force p0_pkt_mon_intf.srdy = p0_srdy_o               ;
    force p0_drdy_i            = p0_pkt_mon_intf.drdy    ;

    force p1_data_i            = p1_pkt_drv_intf.data    ;
    force p1_sop_i             = p1_pkt_drv_intf.sop     ;
    force p1_eop_i             = p1_pkt_drv_intf.eop     ;
    force p1_srdy_i            = p1_pkt_drv_intf.srdy    ;
    force p1_pkt_drv_intf.drdy = p1_drdy_o               ;

    force p1_pkt_mon_intf.data = p1_data_o               ;
    force p1_pkt_mon_intf.sop  = p1_sop_o                ;
    force p1_pkt_mon_intf.eop  = p1_eop_o                ;
    force p1_pkt_mon_intf.srdy = p1_srdy_o               ;
    force p1_drdy_i            = p1_pkt_mon_intf.drdy    ;

    force p2_data_i            = p2_pkt_drv_intf.data    ;
    force p2_sop_i             = p2_pkt_drv_intf.sop     ;
    force p2_eop_i             = p2_pkt_drv_intf.eop     ;
    force p2_srdy_i            = p2_pkt_drv_intf.srdy    ;
    force p2_pkt_drv_intf.drdy = p2_drdy_o               ;

    force p2_pkt_mon_intf.data = p2_data_o               ;
    force p2_pkt_mon_intf.sop  = p2_sop_o                ;
    force p2_pkt_mon_intf.eop  = p2_eop_o                ;
    force p2_pkt_mon_intf.srdy = p2_srdy_o               ;
    force p2_drdy_i            = p2_pkt_mon_intf.drdy    ;

    force p3_data_i            = p3_pkt_drv_intf.data    ;
    force p3_sop_i             = p3_pkt_drv_intf.sop     ;
    force p3_eop_i             = p3_pkt_drv_intf.eop     ;
    force p3_srdy_i            = p3_pkt_drv_intf.srdy    ;
    force p3_pkt_drv_intf.drdy = p3_drdy_o               ;

    force p3_pkt_mon_intf.data = p3_data_o               ;
    force p3_pkt_mon_intf.sop  = p3_sop_o                ;
    force p3_pkt_mon_intf.eop  = p3_eop_o                ;
    force p3_pkt_mon_intf.srdy = p3_srdy_o               ;
    force p3_drdy_i            = p3_pkt_mon_intf.drdy    ;
  end


  initial begin
    // units, precision, suffix, min field width
    $timeformat(-9, 0, "ns", 11);  
    
    uvm_config_db#(virtual pin_intf)::set(null, "*pin_agent", "vif", pin_if);

    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_env.drv_mon_subenv.active_agent[00].*", "vif", p0_pkt_drv_intf);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_env.drv_mon_subenv.active_agent[01].*", "vif", p1_pkt_drv_intf);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_env.drv_mon_subenv.active_agent[02].*", "vif", p2_pkt_drv_intf);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_env.drv_mon_subenv.active_agent[03].*", "vif", p3_pkt_drv_intf);

    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_env.drv_mon_subenv.active_agent[04].*", "vif", p0_pkt_mon_intf);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_env.drv_mon_subenv.active_agent[05].*", "vif", p1_pkt_mon_intf);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_env.drv_mon_subenv.active_agent[06].*", "vif", p2_pkt_mon_intf);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_env.drv_mon_subenv.active_agent[07].*", "vif", p3_pkt_mon_intf);

    //Call the test - but passing run_test argument as test class name
    //Another option is to not pass any test argument and use +UVM_TEST on command line to sepecify which test to run
    run_test();

  end
  
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0, testbench.rst);
    $dumpvars(0, testbench.clk);
	
	$dumpvars(0, testbench.switch_DUT_top);
    $dumpvars(0, testbench.switch_DUT_top.p0_pkt_in);
    $dumpvars(0, testbench.switch_DUT_top.p1_pkt_in);
    $dumpvars(0, testbench.switch_DUT_top.p2_pkt_in);
    $dumpvars(0, testbench.switch_DUT_top.p3_pkt_in);

    $dumpvars(0, testbench.switch_DUT_top.p0_pkt_out);
    $dumpvars(0, testbench.switch_DUT_top.p1_pkt_out);
    $dumpvars(0, testbench.switch_DUT_top.p2_pkt_out);
    $dumpvars(0, testbench.switch_DUT_top.p3_pkt_out);
	
    $dumpvars(0, testbench.p0_pkt_drv_intf);
    $dumpvars(0, testbench.p1_pkt_drv_intf);
    $dumpvars(0, testbench.p2_pkt_drv_intf);
    $dumpvars(0, testbench.p3_pkt_drv_intf);
    $dumpvars(0, testbench.p0_pkt_mon_intf);
    $dumpvars(0, testbench.p1_pkt_mon_intf);
    $dumpvars(0, testbench.p2_pkt_mon_intf);
    $dumpvars(0, testbench.p3_pkt_mon_intf);

  end
  
endmodule : testbench

