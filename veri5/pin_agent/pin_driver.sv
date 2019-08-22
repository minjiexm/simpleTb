///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_driver
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 2019-07-02 04:44:53
//     REVISION: ---
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef  PIN_DRIVER_SV
`define  PIN_DRIVER_SV

class pin_driver extends uvm_driver #(pin_seq_item);

  pin_config m_cfg;

  protected string timeUnitStr;
  protected process clk_process;

  protected int unsigned first_half_period;
  protected int unsigned second_half_period;
  protected int unsigned clk_skew;

  protected int pin_idx = -1;

  `uvm_component_utils_begin(pin_driver)
    `uvm_field_object(m_cfg, UVM_ALL_ON)
    `uvm_field_int(pin_idx, UVM_ALL_ON)
  `uvm_component_utils_end

  // Components
  virtual pin_intf vif;

  // Variables
  protected process proc_start_clk []; // each process corresponds to one clock

  //----------------------//
  // Construct
  //----------------------//
  function new(string name = "pin_driver", uvm_component parent);
    super.new(name, parent);
    this.timeUnitStr = `pin_define_string(`PIN_TIME_UNIT_UNIT);
  endfunction : new

  extern virtual function void set_index(input int unsigned idx);

  extern virtual function void setClkPol(input pin_seq_item it);

  extern virtual task          drive_init();
  extern virtual task          wait_clk  (input int unsigned clkNum);

  extern virtual task          stop_clk   ();
  extern virtual task          start_clk  ();
  extern virtual task          set_skew   (int unsigned value, pinTimeUnitT unit);
  extern virtual function void set_period (int unsigned period, int unsigned dutyCycle, pinTimeUnitT unit);

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task            run_phase(uvm_phase phase);

  extern virtual function int unsigned time_in_timeunit(int unsigned timeValue, pinTimeUnitT timeUnit);

  extern virtual task          clock_generate();

  extern virtual task          ctrl_level(pin_seq_item item, output pin_seq_item rsp);
  extern virtual task          ctrl_clock(pin_seq_item item, output pin_seq_item rsp);

endclass: pin_driver

//******************************************************************************
// Function/Task implementations
//******************************************************************************
  // *******************************************************************************
  // build_phase
  // *******************************************************************************
  function void pin_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(pin_config)::get(this, "", "config", this.m_cfg)) begin
      this.m_cfg = pin_config::type_id::create("m_cfg");
      `uvm_info(this.get_type_name(), $psprintf("Create pin_config local with type %s", this.get_type_name()), UVM_LOW)
      void'( this.m_cfg.print() );
    end

    if(this.m_cfg.pinType == PIN_TYPE_Monitor ) begin
      `uvm_fatal(this.get_type_name(), $psprintf("Pin Type is not PIN_TYPE_Driver! Please check m_cfg.pinType value!"))
    end

    if(!uvm_config_db#(virtual pin_intf)::get(this, "", "vif", this.vif)) begin
      `uvm_fatal(this.get_type_name(), $psprintf("Fail to get virtual pin_intf vif from config_db"))
    end
  endfunction : build_phase


  task pin_driver::drive_init();
    this.vif.pins[this.pin_idx] = this.m_cfg.initValue;  //assign initial value
  endtask: drive_init


  //----------------------------------------------------------------------------
  task pin_driver::wait_clk  (input int unsigned clkNum);
    if(this.m_cfg.pinType != PIN_TYPE_DRV_Period) begin
      `uvm_error(this.get_type_name(), $psprintf("Can not wait clock for a non-clock agent!!"))
    end
    else begin
      repeat (clkNum) begin
        @(posedge this.vif.pins[this.pin_idx]);
      end
    end
  endtask: wait_clk

  //----------------------------------------------------------------------------

  function void pin_driver::setClkPol(input pin_seq_item it);
  endfunction: setClkPol

  //----------------------------------------------------------------------------

  task pin_driver::start_clk();
    if(this.clk_process == null)
      this.clock_generate();   //start clock gen process
    else if( this.clk_process.status() == process::SUSPENDED) begin
      this.clk_process.resume(); 
      `uvm_info(this.get_type_name(), $psprintf("Clock %s resumed!", this.m_cfg.pinName), UVM_LOW)
    end
    else if( this.clk_process.status() == process::KILLED || this.clk_process.status() == process::FINISHED) begin
      this.clock_generate();   //start clock gen process
    end
  endtask: start_clk

  //----------------------------------------------------------------------------

  task pin_driver::stop_clk();
    if(this.clk_process != null) begin
      this.clk_process.suspend();
      `uvm_info(this.get_type_name(), $psprintf("Clock %s stopped!", this.m_cfg.pinName), UVM_LOW)
    end
  endtask : stop_clk


  //----------------------------------------------------------------------------
  function void pin_driver::set_index(input int unsigned idx);
    if(idx < `PIN_MAX) begin
      this.pin_idx = idx;
      `uvm_info(this.get_type_name(), $psprintf("Set index %0d", this.pin_idx), UVM_LOW)
    end
    else
      `uvm_fatal("OUT_RANGE", $psprintf("index %0d out of range %0d", idx, `PIN_MAX))
  endfunction: set_index


  //----------------------------------------------------------------------------
  task pin_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);

    if(this.pin_idx == -1) begin
      `uvm_fatal(this.get_type_name(), $psprintf("Index %0d is not set! Please call set_index at first!", this.pin_idx))
    end

    this.drive_init();

    if(this.m_cfg.pinType == PIN_TYPE_DRV_Period && this.m_cfg.period != 0) begin
      this.clock_generate();  //start default clk generation, customer no need to start a sequence
    end

    forever begin
      seq_item_port.get_next_item(req);

      if(this.m_cfg.pinDrvType == PIN_TYPE_DRV_Async) begin
        this.ctrl_level(req, rsp);
      end
      else if(this.m_cfg.pinType == PIN_TYPE_DRV_Period) begin
        this.ctrl_clock(req, rsp);
      end

      seq_item_port.item_done();
    end

  endtask: run_phase


  //----------------------------------------------------------------------------
  task pin_driver::clock_generate();  //clock generation main loop

    fork
    begin
      this.clk_process = process::self();
      `uvm_info(this.get_type_name(), $psprintf("Clock %s started at period %0d%s", this.m_cfg.pinName, this.m_cfg.period, this.timeUnitStr), UVM_LOW)

      this.first_half_period = this.m_cfg.period*this.m_cfg.dutyCycle/100;
      this.second_half_period = this.m_cfg.period-this.first_half_period;
      this.clk_skew = this.m_cfg.skew;

      `uvm_info(this.get_type_name(), $psprintf("this.first_half_period %0d this.second_half_period %0d", this.first_half_period, this.second_half_period), UVM_LOW)

      if(this.m_cfg.initValue == 0) begin
        #(this.second_half_period);
      end

      forever begin
        this.first_half_period = this.first_half_period + $urandom_range(clk_skew, 0) - clk_skew/2;  //+- skew
        this.second_half_period = this.second_half_period + $urandom_range(clk_skew, 0) - clk_skew/2;  //+- skew

        if(this.first_half_period == 0 && this.second_half_period == 0) begin //if half_perriod == 0 forever loop will happen
          `uvm_error(this.get_type_name(), $psprintf("Clock %s period is zero!", this.m_cfg.pinName))
        end

        this.vif.pins[this.pin_idx] = 1'b1;

        #(this.first_half_period)
        this.vif.pins[this.pin_idx] = ~this.vif.pins[this.pin_idx];

        #(this.second_half_period)
        this.vif.pins[this.pin_idx] = ~this.vif.pins[this.pin_idx];
      end
    end
    join_none
  endtask : clock_generate


  //----------------------------------------------------------------------------
  task pin_driver::ctrl_level(pin_seq_item item, output pin_seq_item rsp);
    case(item.opCode)
      PIN_OPCODE_SetLevel : begin
        this.vif.pins[this.pin_idx] = item.value;
        `uvm_info(this.get_type_name(), $psprintf("[ctrl_level] Set pin %s Level to %0d!", this.m_cfg.pinName, item.value), UVM_LOW)
      end
      default : begin
        `uvm_error(this.get_type_name(), $psprintf("[ctrl_level] Pin %s Unsupport opCode %s", this.m_cfg.pinName, item.opCode.name))
      end
    endcase
    rsp = item; //give response
  endtask: ctrl_level


  //----------------------------------------------------------------------------
  task pin_driver::set_skew(int unsigned value, pinTimeUnitT unit);
    this.m_cfg.skew = this.time_in_timeunit(value, unit);
    this.clk_skew    = this.m_cfg.skew;
    `uvm_info(this.get_type_name(), $psprintf("Set Clock %s Skew to %0d%s!", this.m_cfg.pinName, this.m_cfg.skew, this.timeUnitStr), UVM_LOW)
  endtask: set_skew


  //----------------------------------------------------------------------------
  function void pin_driver::set_period(int unsigned period, int unsigned dutyCycle, pinTimeUnitT unit);
    if(period == 0) begin
      `uvm_error(this.get_type_name(), $psprintf("Can not set Clock %s Period to %0d%s!", this.m_cfg.pinName, this.m_cfg.period, this.timeUnitStr))
      return;
    end

    if(dutyCycle >= 100 || dutyCycle == 0) begin
      `uvm_error(this.get_type_name(), $psprintf("Clock %s Duty Cycle %0d can not larger than 100 or equal to zero!", this.m_cfg.pinName, this.m_cfg.dutyCycle))
      return;
    end

    this.m_cfg.period = this.time_in_timeunit(period, unit);
    this.m_cfg.dutyCycle = dutyCycle;
    this.first_half_period = this.m_cfg.period*this.m_cfg.dutyCycle/100;
    this.second_half_period = this.m_cfg.period-this.first_half_period;
    `uvm_info(this.get_type_name(), $psprintf("Set Clock %s Period to %0d%s DutyCycle %0d%%!", this.m_cfg.pinName, this.m_cfg.period, this.timeUnitStr, this.m_cfg.dutyCycle), UVM_LOW)
      `uvm_info(this.get_type_name(), $psprintf("this.first_half_period %0d this.second_half_period %0d", this.first_half_period, this.second_half_period), UVM_LOW)
  endfunction : set_period


  //----------------------------------------------------------------------------
  task pin_driver::ctrl_clock(pin_seq_item item, output pin_seq_item rsp);
    case(item.opCode)
      PIN_OPCODE_SetPeriod : begin
        this.set_period(item.value, item.dutyCycle, item.unit);
      end
      PIN_OPCODE_SetSkew : begin
        this.set_skew(item.value, item.unit);
      end
      PIN_OPCODE_StartClk : begin
        this.start_clk();
      end
      PIN_OPCODE_StopClk : begin 
        this.stop_clk();
      end
      default : begin
        `uvm_error(this.get_type_name(), $psprintf("[Clock %s] Unsupport opCode %s", this.m_cfg.pinName, item.opCode.name))
      end
    endcase
    rsp = item; //give response
  endtask: ctrl_clock


  //----------------------------------------------------------------------------
  function int unsigned pin_driver::time_in_timeunit(int unsigned timeValue, pinTimeUnitT timeUnit);
    return timeValue; //implement later
  endfunction : time_in_timeunit

`endif //PIN_DRIVER_SV
