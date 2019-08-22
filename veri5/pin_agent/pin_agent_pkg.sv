///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_agent_pkg
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 2019-07-02 04:44:53
//     REVISION: ---
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef  PIN_AGENT_PKG_SV
`define  PIN_AGENT_PKG_SV

`include "pin_defines.sv"
`timescale `pin_define_combine(`PIN_TIME_UNIT_NUM,`PIN_TIME_UNIT_UNIT)/`pin_define_combine(`PIN_TIME_PREC_NUM,`PIN_TIME_PREC_UNIT)

`include "pin_intf.sv"

package pin_agent_pkg;

import uvm_pkg::*;

`include "pin_typedef.sv"
`include "pin_seq_item.sv"

`include "pin_config.sv"
`include "pin_driver.sv"
`include "pin_monitor.sv"
`include "pin_virtual_sequence_lib.sv"
`include "pin_virtual_sequencer.sv"
`include "pin_agent_config.sv"
`include "pin_agent.sv"

endpackage : pin_agent_pkg

`endif //PIN_AGENT_PKG_SV
