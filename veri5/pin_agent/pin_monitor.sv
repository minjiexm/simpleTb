///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_monitor
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 2019-07-02 04:44:53
//     REVISION: ---
//
///////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef  PIN_MONITOR_SV
`define  PIN_MONITOR_SV

class pin_monitor extends uvm_monitor;

  pin_config m_cfg;
  uvm_event detect_ev;

  protected string timeUnitStr;
  protected process detect_process;

  protected int pin_idx = -1;

  `uvm_component_utils_begin(pin_monitor)
    `uvm_field_object(m_cfg, UVM_ALL_ON)
    `uvm_field_int(pin_idx, UVM_ALL_ON)
  `uvm_component_utils_end

  // Components
  virtual pin_intf vif;

  //----------------------//
  // Construct
  //----------------------//
  function new(string name = "pin_monitor", uvm_component parent);
    super.new(name, parent);
    this.timeUnitStr = `pin_define_string(`PIN_TIME_UNIT_UNIT);
  endfunction : new

  extern virtual function void set_index(input int unsigned idx);

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task            run_phase(uvm_phase phase);

  extern virtual task          detect_posedge();
  extern virtual task          detect_negedge();

endclass: pin_monitor

//******************************************************************************
// Function/Task implementations
//******************************************************************************
  // *******************************************************************************
  // build_phase
  // *******************************************************************************
  function void pin_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(pin_config)::get(this, "", "config", this.m_cfg)) begin
      this.m_cfg = pin_config::type_id::create("m_cfg");
      `uvm_info(this.get_type_name(), $psprintf("Create pin_config local with type %s", this.get_type_name()), UVM_LOW)
      void'( this.m_cfg.print() );
    end

    if(this.m_cfg.pinType == PIN_TYPE_Driver ) begin
      `uvm_fatal(this.get_type_name(), $psprintf("Pin Type is not PIN_TYPE_Monitor! Please check m_cfg.pinType value!"))
    end

    if(!uvm_config_db#(virtual pin_intf)::get(this, "", "vif", this.vif)) begin
      `uvm_fatal(this.get_type_name(), $psprintf("Fail to get virtual pin_intf vif from config_db"))
    end

    this.detect_ev = uvm_event_pool::get_global(this.m_cfg.pinName);
  endfunction : build_phase


  //----------------------------------------------------------------------------
  function void pin_monitor::set_index(input int unsigned idx);
    if(idx < `PIN_MAX) begin
      this.pin_idx = idx;
      `uvm_info(this.get_type_name(), $psprintf("Set index %0d", this.pin_idx), UVM_LOW)
    end
    else
      `uvm_fatal("OUT_RANGE", $psprintf("index %0d out of range %0d", idx, `PIN_MAX))
  endfunction: set_index


  //----------------------------------------------------------------------------
  task pin_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);

    if(this.pin_idx == -1) begin
      `uvm_fatal(this.get_type_name(), $psprintf("Index %0d is not set! Please call set_index at first!", this.pin_idx))
    end

    case(this.m_cfg.pinMonType)
      PIN_TYPE_MON_PosEdge : begin
        this.detect_posedge();
      end
      PIN_TYPE_MON_NegEdge : begin
        this.detect_negedge();
      end
      PIN_TYPE_MON_DualEdge : begin
        fork
          this.detect_posedge();
          this.detect_negedge();
        join
      end
      default : begin
        `uvm_error(this.get_type_name(), $psprintf("Unsupported detect type %s", this.m_cfg.pinMonType.name))
      end
    endcase

  endtask: run_phase


  //----------------------------------------------------------------------------
  task pin_monitor::detect_posedge();
    pin_seq_item posDetect = pin_seq_item::type_id::create("posDetect");
    posDetect.pinEvent = PIN_TYPE_MON_PosEdge; //posEdge

    forever begin
      @(posedge this.vif.pins[this.pin_idx]);
      this.detect_ev.trigger(posDetect);
    end
  endtask : detect_posedge


  //----------------------------------------------------------------------------
  task pin_monitor::detect_negedge();
    pin_seq_item negDetect = pin_seq_item::type_id::create("negDetect");
    negDetect.pinEvent = PIN_TYPE_MON_NegEdge; //negEdge

    forever begin
      @(negedge this.vif.pins[this.pin_idx]);
      this.detect_ev.trigger(negDetect);
    end
  endtask : detect_negedge


`endif //PIN_SV
