///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_intf
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: JIE MIN, 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 07/05/2019 10:44:16 PM
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////

interface pin_intf();

  timeunit      `pin_define_combine(`PIN_TIME_UNIT_NUM, `PIN_TIME_UNIT_UNIT);
  timeprecision `pin_define_combine(`PIN_TIME_PREC_NUM, `PIN_TIME_PREC_UNIT);

  //******************************************************************************
  // Ports
  //******************************************************************************
  logic [`PIN_MAX-1 : 0] pins;

endinterface : pin_intf
