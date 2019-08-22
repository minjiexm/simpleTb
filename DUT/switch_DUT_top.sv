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

`timescale 1ns/1ns

`ifndef TB_TOP
`define TB_TOP testbench
`endif

//--------------------------------------------------------
//Top level module that mimic switch DUT
// NOTE: Instance name must be the same as module name
//| switch_DUT_top switch_DUT_top(.*)
//--------------------------------------------------------

module switch_DUT_top (
  input wire                clk ,
  input wire                rst ,

  input wire [7 : 0]  p0_data_i ,
  input wire          p0_sop_i  ,
  input wire          p0_eop_i  ,
  input wire          p0_srdy_i ,
 output wire          p0_drdy_o ,

 output wire [7 : 0]  p0_data_o ,
 output wire          p0_sop_o  ,
 output wire          p0_eop_o  ,
 output wire          p0_srdy_o ,
  input wire          p0_drdy_i ,

  input wire [7 : 0]  p1_data_i ,
  input wire          p1_sop_i  ,
  input wire          p1_eop_i  ,
  input wire          p1_srdy_i ,
 output wire          p1_drdy_o ,

 output wire [7 : 0]  p1_data_o ,
 output wire          p1_sop_o  ,
 output wire          p1_eop_o  ,
 output wire          p1_srdy_o ,
  input wire          p1_drdy_i ,

  input wire [7 : 0]  p2_data_i ,
  input wire          p2_sop_i  ,
  input wire          p2_eop_i  ,
  input wire          p2_srdy_i ,
 output wire          p2_drdy_o ,

 output wire [7 : 0]  p2_data_o ,
 output wire          p2_sop_o  ,
 output wire          p2_eop_o  ,
 output wire          p2_srdy_o ,
  input wire          p2_drdy_i ,

  input wire [7 : 0]  p3_data_i ,
  input wire          p3_sop_i  ,
  input wire          p3_eop_i  ,
  input wire          p3_srdy_i ,
 output wire          p3_drdy_o ,

 output wire [7 : 0]  p3_data_o ,
 output wire          p3_sop_o  ,
 output wire          p3_eop_o  ,
 output wire          p3_srdy_o ,
  input wire          p3_drdy_i
 );

  //----------------------------------------------------//
  //Instance interface for connect signal to UVM domain
  //----------------------------------------------------//
  veri5_eth_intf p0_pkt_in(clk, rst);
  veri5_eth_intf p1_pkt_in(clk, rst);
  veri5_eth_intf p2_pkt_in(clk, rst);
  veri5_eth_intf p3_pkt_in(clk, rst);

  veri5_eth_intf p0_pkt_out(clk, rst);
  veri5_eth_intf p1_pkt_out(clk, rst);
  veri5_eth_intf p2_pkt_out(clk, rst);
  veri5_eth_intf p3_pkt_out(clk, rst);

  //----------------------------------------------------//
  //connect Interfaces to UVM domain
  //----------------------------------------------------//
  import uvm_pkg::*;

  initial begin
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_DUT.intf.active_agent[00].*", "vif", `TB_TOP.switch_DUT_top.p0_pkt_in);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_DUT.intf.active_agent[01].*", "vif", `TB_TOP.switch_DUT_top.p1_pkt_in);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_DUT.intf.active_agent[02].*", "vif", `TB_TOP.switch_DUT_top.p2_pkt_in);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_DUT.intf.active_agent[03].*", "vif", `TB_TOP.switch_DUT_top.p3_pkt_in);

    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_DUT.intf.active_agent[04].*", "vif", `TB_TOP.switch_DUT_top.p0_pkt_out);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_DUT.intf.active_agent[05].*", "vif", `TB_TOP.switch_DUT_top.p1_pkt_out);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_DUT.intf.active_agent[06].*", "vif", `TB_TOP.switch_DUT_top.p2_pkt_out);
    uvm_config_db#(virtual veri5_eth_intf)::set(null, "uvm_test_top.sw_DUT.intf.active_agent[07].*", "vif", `TB_TOP.switch_DUT_top.p3_pkt_out);
  end


  initial begin
    //----------------------------------------------------//
    // P0~P3 Input connection
    //----------------------------------------------------//
    force p0_pkt_in.data  = p0_data_i;
    force p0_pkt_in.sop   = p0_sop_i;
    force p0_pkt_in.eop   = p0_eop_i;
    force p0_pkt_in.srdy  = p0_srdy_i;
    force p0_drdy_o       = p0_pkt_in.drdy;

    force p1_pkt_in.data  = p1_data_i;
    force p1_pkt_in.sop   = p1_sop_i;
    force p1_pkt_in.eop   = p1_eop_i;
    force p1_pkt_in.srdy  = p1_srdy_i;
    force p1_drdy_o       = p1_pkt_in.drdy;

    force p2_pkt_in.data  = p2_data_i;
    force p2_pkt_in.sop   = p2_sop_i;
    force p2_pkt_in.eop   = p2_eop_i;
    force p2_pkt_in.srdy  = p2_srdy_i;
    force p2_drdy_o       = p2_pkt_in.drdy;

    force p3_pkt_in.data  = p3_data_i;
    force p3_pkt_in.sop   = p3_sop_i;
    force p3_pkt_in.eop   = p3_eop_i;
    force p3_pkt_in.srdy  = p3_srdy_i;
    force p3_pkt_in.drdy  = p3_pkt_in.drdy;
    force p3_drdy_o       = p3_pkt_in.drdy;

    //----------------------------------------------------//
    // P0~P3 Output connection
    //----------------------------------------------------//
    force p0_data_o                 = p0_pkt_out.data;
    force p0_sop_o                  = p0_pkt_out.sop;
    force p0_eop_o                  = p0_pkt_out.eop;
    force p0_srdy_o                 = p0_pkt_out.srdy;
    force p0_pkt_out.drdy           = p0_drdy_i;

    force p1_data_o                 = p1_pkt_out.data;
    force p1_sop_o                  = p1_pkt_out.sop;
    force p1_eop_o                  = p1_pkt_out.eop;
    force p1_srdy_o                 = p1_pkt_out.srdy;
    force p1_pkt_out.drdy           = p1_drdy_i;

    force p2_data_o                 = p2_pkt_out.data;
    force p2_sop_o                  = p2_pkt_out.sop;
    force p2_eop_o                  = p2_pkt_out.eop;
    force p2_srdy_o                 = p2_pkt_out.srdy;
    force p2_pkt_out.drdy           = p2_drdy_i;

    force p3_data_o                 = p3_pkt_out.data;
    force p3_sop_o                  = p3_pkt_out.sop;
    force p3_eop_o                  = p3_pkt_out.eop;
    force p3_srdy_o                 = p3_pkt_out.srdy;
    force p3_pkt_out.drdy           = p3_drdy_i;
  end
  
endmodule : switch_DUT_top

