///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_seq_item
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: JIE MIN, 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 07/05/2019 10:44:16 PM
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef PIN_SEQ_ITEM_SV
`define PIN_SEQ_ITEM_SV

class pin_seq_item extends uvm_sequence_item;

  // Variables
  pinOpCodeT   opCode;    //Operation code
  pinTimeUnitT unit;      //unit for value if opCode = setPeriod|setSkew
  pinMonTypeT  pinEvent;  //only used for pin monitor.
  int unsigned value;     //used for setLevel/setInit/setFreq
  int unsigned dutyCycle; //Only valid when opCode is SetPeriod

  //-------------------------------//
  // Constructor
  //-------------------------------//
  function new(string name = "pin_seq_item");
    super.new(name);
    this.unit = PIN_TIME_UNIT_ps; //by default time unit will be ps
    this.value = 0;
    this.pinEvent = PIN_TYPE_MON_Unknow;
    this.dutyCycle = 50;
  endfunction

  `uvm_object_utils_begin(pin_seq_item)
    `uvm_field_enum      ( pinOpCodeT,      opCode,  UVM_ALL_ON)
    `uvm_field_enum      ( pinTimeUnitT,      unit,  UVM_ALL_ON)
    `uvm_field_enum      ( pinMonTypeT,   pinEvent,  UVM_ALL_ON)
    `uvm_field_int       (                   value,  UVM_ALL_ON)
    `uvm_field_int       (               dutyCycle,  UVM_ALL_ON)
  `uvm_object_utils_end

endclass: pin_seq_item

typedef uvm_sequencer#(pin_seq_item) pin_sequencer;

`endif //PIN_SEQ_ITEM_SV
