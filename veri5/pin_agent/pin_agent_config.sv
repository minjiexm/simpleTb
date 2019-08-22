///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_agent_config
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 2019-07-02 04:44:53
//     REVISION: ---
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef  PIN_AGENT_CONFIG_SV
`define  PIN_AGENT_CONFIG_SV

class pin_agent_config extends uvm_object;

  pin_config pin_cfg[];   //name to pin type map

  `uvm_object_utils_begin(pin_agent_config)
    `uvm_field_array_object(pin_cfg, UVM_ALL_ON)
  `uvm_object_utils_end

  // ***************************************************************
  // Constructor
  // ***************************************************************
  function new (string name = "pin_agent_config");
    super.new(name);
  endfunction : new

endclass : pin_agent_config



class pin_agent_config_demo extends pin_agent_config;

  `uvm_object_utils(pin_agent_config_demo)

  // ***************************************************************
  // Constructor
  // ***************************************************************
  function new (string name = "pin_agent_config");
    super.new(name);

    this.pin_cfg = new[5];  //one clk & one reset

    foreach(this.pin_cfg[idx]) begin
      string idx_str;
      idx_str.itoa(idx);
      this.pin_cfg[idx] = pin_config::type_id::create({"pin_cfg[", idx_str, "]"});
    end

    //100MHz Clock Setup
    pin_cfg[0].pinName     = "clk_100M";
    pin_cfg[0].pinType     = PIN_TYPE_Driver;
    pin_cfg[0].pinDrvType  = PIN_TYPE_DRV_Period;
    pin_cfg[0].initValue   = 0; //for clock it does not matter
  //pin_cfg[0].period      = 10000; //you need check the time unit of pin pkg, by default it is ps
    pin_cfg[0].period      = 0;     //by default not gen clock;
    pin_cfg[0].skew        = 0;     //1% jitter     

    //Reset Pin Setup
    pin_cfg[1].pinName     = "reset";
    pin_cfg[1].pinType     = PIN_TYPE_Driver;
    pin_cfg[1].pinDrvType  = PIN_TYPE_DRV_Async;
    pin_cfg[1].initValue   = 0; //high valid reset

    //Interrupt1 Monitor Pin Setup
    pin_cfg[2].pinName     = "MonIntr1";
    pin_cfg[2].pinType     = PIN_TYPE_Monitor;
    pin_cfg[2].pinMonType  = PIN_TYPE_MON_PosEdge;

    //Interrupt2 Monitor Pin Setup
    pin_cfg[3].pinName     = "MonIntr2";
    pin_cfg[3].pinType     = PIN_TYPE_Monitor;
    pin_cfg[3].pinMonType  = PIN_TYPE_MON_NegEdge;

    //Interrupt3 Monitor Pin Setup
    pin_cfg[4].pinName     = "MonIntr3";
    pin_cfg[4].pinType     = PIN_TYPE_Monitor;
    pin_cfg[4].pinMonType  = PIN_TYPE_MON_DualEdge;
  endfunction : new

endclass : pin_agent_config_demo


`endif //PIN_AGENT_CONFIG_SV
