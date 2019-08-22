///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_defines
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: JIE MIN, 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 07/05/2019 10:44:16 PM
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef PIN_DEFINE_SV
`define PIN_DEFINE_SV

//define max clk/rst signals can be generated
`ifndef PIN_MAX
`define PIN_MAX 5
`endif

//time scale define
`define PIN_TIME_UNIT_NUM  1
`define PIN_TIME_PREC_NUM  1

`define PIN_TIME_UNIT_UNIT ps
`define PIN_TIME_PREC_UNIT ps

`define pin_define_combine(def1, def2)\
  def1``def2

`define pin_define_string(def) \
  `"def`"

`endif
