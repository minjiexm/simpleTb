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

`ifndef  VERI5_ETH_INTF_SV
`define  VERI5_ETH_INTF_SV


interface veri5_eth_intf #(parameter tsu = 1, tco = 1) (input wire clk, input wire rst);

  logic [7:0] data;
  logic sop;
  logic eop;
  logic srdy;
  logic drdy;

  clocking transmit @ (posedge clk);
    input #tsu drdy;
    output #tco data, sop, eop, srdy;
  endclocking

  clocking receive @ (posedge clk);
    output #tco drdy;
  endclocking

  clocking passive @ (posedge clk);
    input #tsu drdy, data, sop, eop, srdy;
  endclocking

endinterface : veri5_eth_intf

`endif  //VERI5_ETH_INTF_SV
