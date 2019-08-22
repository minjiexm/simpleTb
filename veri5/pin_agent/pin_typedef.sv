///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_typedef
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: JIE MIN, 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 07/05/2019 10:44:16 PM
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef PIN_TYPEDEF_SV
`define PIN_TYPEDEF_SV


typedef enum {
  PIN_TYPE_Driver   = 0,   //For example: Generate Clock
  PIN_TYPE_Monitor  = 1,   //For example: Detect Interrupt
  PIN_TYPE_Unknow   = 2
} pinTypeT;

typedef enum {
  PIN_TYPE_DRV_Period  = 0,   //For example: clk 
  PIN_TYPE_DRV_Async   = 1,   //For example: rst
  PIN_TYPE_DRV_Unknow  = 2
} pinDrvTypeT;


typedef enum {
  PIN_TYPE_MON_PosEdge  = 0,
  PIN_TYPE_MON_NegEdge  = 1,
  PIN_TYPE_MON_DualEdge = 2,
  PIN_TYPE_MON_Unknow   = 3
} pinMonTypeT;


typedef enum {
  PIN_TIME_UNIT_ps = 1,
  PIN_TIME_UNIT_ns = 1000
//PIN_TIME_UNIT_fs = 1,  
//PIN_TIME_UNIT_ps = 1000,
//PIN_TIME_UNIT_ns = 1000000,
//PIN_TIME_UNIT_us = 1000000000,  
//PIN_TIME_UNIT_ms = 1000000000000
} pinTimeUnitT;   //Current only support ps or ns time unit


typedef enum {
  PIN_OPCODE_SetLevel  = 0,   //Set Level 0 or 1 for a certen period and go back to initial value
  PIN_OPCODE_SetPeriod = 1,   //Only valid for clk pin, set Clock Period
  PIN_OPCODE_SetSkew   = 2,   //Only valid for clk pin, set Clock Skew
  PIN_OPCODE_SetDuty   = 3,   //Only valid for clk pin, set Clock Skew
  PIN_OPCODE_StartClk  = 4,   //Only valid for clk pin, if clk is not runing, will start
  PIN_OPCODE_StopClk   = 5,    //Only valid for clk pin, clk will not troggle, if peroid is 0 means stop until issue startClk command
  PIN_OPCODE_Unknow    = 6
} pinOpCodeT;  //operation code


`endif //PIN_TYPEDEF_SV
