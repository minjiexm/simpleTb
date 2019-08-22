///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: pin_sequence_lib
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 2019-06-14 18:41:05
//     REVISION: ---
//
///////////////////////////////////////////////////////////////////////////////////////////////////

typedef class pin_virtual_sequencer;

class pin_vir_seq_demo extends uvm_sequence#(pin_seq_item);

  // ***************************************************************
  // UVM registration macros
  // ***************************************************************
  `uvm_object_utils_begin(pin_vir_seq_demo)
  `uvm_object_utils_end

  `uvm_declare_p_sequencer(pin_virtual_sequencer)
 
  function new(string name = "pin_vir_seq_demo");
    super.new(name);
  endfunction : new
  
  virtual task body();
    //super.body();

    fork
      begin
        pin_seq_item clk_item;

        `uvm_create_on(clk_item, p_sequencer.clk_rst_seqr["clk_100M"])
        /*
        PIN_OPCODE_SetLevel 
        PIN_OPCODE_SetPeriod
        PIN_OPCODE_SetSkew  
        PIN_OPCODE_StartClk 
        PIN_OPCODE_StopClk  
        */
        clk_item.opCode    = PIN_OPCODE_SetPeriod;
        clk_item.value     = 10000; //10ns  100MHz
        clk_item.unit      = PIN_TIME_UNIT_ps;
        clk_item.dutyCycle = 50;
        `uvm_send(clk_item)

        clk_item.opCode = PIN_OPCODE_StartClk;
        `uvm_send(clk_item)
      end

      begin
        pin_seq_item rst_item;

        `uvm_create_on(rst_item, p_sequencer.clk_rst_seqr["reset"])
        rst_item.opCode = PIN_OPCODE_SetLevel;
        rst_item.value = 1;

        #10ns;
        `uvm_send(rst_item)

        #10ns;

        rst_item.value = 0;
        `uvm_send(rst_item)
      end
    join

  endtask : body
  
endclass : pin_vir_seq_demo

