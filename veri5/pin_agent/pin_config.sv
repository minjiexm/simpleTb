///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_config
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 2019-07-02 04:44:53
//     REVISION: ---
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef  PIN_DRVIER_CONFIG_SV
`define  PIN_DRVIER_CONFIG_SV

class pin_config extends uvm_object;

  string             pinName    ;

  pinTypeT           pinType    ;
  pinDrvTypeT        pinDrvType ;  //only valid when pinType = PIN_TYPE_Driver
  pinMonTypeT        pinMonType ;  //only valid when pinType = PIN_TYPE_Monitor

  bit                initValue  ;  //for a reset ping, if initValue is 1 means rst is low active
  int unsigned       period     ;  //If give a non zero value:
                                   // For reset ping, drive will insert ~initValue for period time.
                                   // For clk, it will be clock period and clock will be generated automaticly
  int unsigned       skew       ;
  int unsigned       dutyCycle  ;  //within 0 : 100

  `uvm_object_utils_begin(pin_config)
    `uvm_field_string(pinName,                   UVM_ALL_ON)
    `uvm_field_enum  (pinTypeT,      pinType,    UVM_ALL_ON)
    `uvm_field_enum  (pinDrvTypeT,   pinDrvType, UVM_ALL_ON)
    `uvm_field_enum  (pinMonTypeT,   pinMonType, UVM_ALL_ON)
    `uvm_field_int   (initValue,                 UVM_ALL_ON)
    `uvm_field_int   (dutyCycle,                 UVM_ALL_ON)
    `uvm_field_int   (period,                    UVM_ALL_ON)
    `uvm_field_int   (skew,                      UVM_ALL_ON)
  `uvm_object_utils_end

  // ***************************************************************
  // Constructor
  // ***************************************************************
  function new (string name = "pin_config");
    super.new(name);
    this.pinName    = name;
    this.pinType    = PIN_TYPE_Driver;
    this.pinDrvType = PIN_TYPE_DRV_Period; //by default will be clock pin
    this.initValue  = 0;
    this.period     = 0;
    this.skew       = 0;
    this.dutyCycle  = 50;
    this.pinMonType = PIN_TYPE_MON_DualEdge; //by default detect both negedge and posedge
  endfunction : new

endclass : pin_config


`endif //PIN_DRVIER_CONFIG_SV
