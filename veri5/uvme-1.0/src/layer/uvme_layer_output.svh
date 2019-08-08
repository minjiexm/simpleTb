//
//----------------------------------------------------------------------
//   Copyright 2019 Veri5.org
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
`ifndef UVME_LAYER_OUTPUT_SV
`define UVME_LAYER_OUTPUT_SV

//------------------------------------------------------------------------------
//
// CLASS: uvme_layer_output
//
// layer output has two side.
//   Inner side:
//     inner side the the module's inner processiong. it will call output.send to
//     send packets to the module's outside.
//
//   Out side:
//     Outside should connect to a layer input or a sequencer.
//
//   link function should be used to connect output to outside. for example, link 
//   output to a sequencer or a input.
//
//| ------------------
//| |    module      |
//| |               -----------------------------------------------------------
//| |               |                                                         |
//| | inner side -> | blocking    send()          output         layer seq -> |  out side
//| |               |                                                         |
//| |               |                                                         |
//| |               -----------------------------------------------------------
//| |                |
//| |----------------|
//
// function inner_connnect should be only used to connect output to a agent's analysis_port.
// The output should be a member of the agent.
//| -----------------------------------
//| |    DUT ageint                    |
//| |                             -----------------------------------------------------------
//| | inner side                  |                                                         |
//| | monitor    analysis_port -> | m_analysis_fifo      output               layer seq ->  |  out side
//| |                             |                                                         |
//| |                             -----------------------------------------------------------
//| |                                  |
//| |----------------------------------|


class uvme_layer_output #(type T = uvm_sequence_item) extends uvm_component;
  
  typedef uvme_layer_output#(T) this_output_type;
  typedef uvme_layer_input#(T)  this_input_type;
  typedef uvme_layer_callback#(T) this_cb_type;
  
  protected uvm_sequencer#(T) m_neigbour_seqr;   //get from link

  protected uvme_layer_sequence#(T) m_seq;
  
  //protected uvm_get_port#(T) m_get_port;
  //protected uvm_put_port#(T) m_put_port;

  protected uvm_tlm_fifo#(T) m_fifo;  //buffer for blocking input from inner side
  protected uvm_tlm_analysis_fifo#(T) m_analysis_fifo;

  protected int unsigned m_label;
  
  //Enable uvm callback
  `uvm_register_cb(this_output_type, this_cb_type)

  `uvm_component_param_utils_begin(this_output_type)
  `uvm_component_utils_end

  // Function: new
  //
  // Constructor

  function new(string name = "", uvm_component parent);
    super.new(name, parent);
  endfunction : new


  // Function: build_phase
  //
  // Standard uvm build_phase
  // build driver and sequencer

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.m_fifo = new("m_fifo", this, 10);
    //this.m_put_port = new("m_put_port", this);    
    //this.m_get_port = new("m_get_port", this);    
    this.m_analysis_fifo = new("m_analysis_fifo", this);
  endfunction : build_phase


  // Function: connect_phase
  //
  // Standard uvm connect_phase
  // Connect put and get port to fifo
 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //this.m_get_port.connect(this.m_fifo.get_export);
    //this.m_put_port.connect(this.m_fifo.put_export);
  endfunction : connect_phase


  // Function: send
  //
  // send data to output
  // This is the blocking method to send data through output.   
  virtual task send(T txn);
    uvme_ei_enum ei_action = UVME_EI_NONE;  //by default no error injection
    `uvm_do_callbacks(this_output_type, this_cb_type, error_inject_cbF(txn, ei_action))

    if(ei_action != UVME_EI_DROP) begin
       T data;
      `uvme_cast(data, txn.clone(), fatal);  //Create a new clone and send to next input, so that the orignal handle still can be used by local.
      `uvm_do_callbacks(this_output_type, this_cb_type, send_cbF(txn))
	  `uvme_trace_data($psprintf("Output %s Transmit a transaction %s", this.get_full_name(), data.convert2string()))
      //`uvme_trace_data($psprintf("Output %s Neighbour %s", this.get_full_name(), this.neighbour.get_full_name()))
      this.m_fifo.put(txn); //blocking put
    end

 endtask : send



  // Function: run_phase
  //
  // Uvm standard run_phase
 
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvme_trace_task_start("run_phase")

    if(this.m_neigbour_seqr != null) begin
      fork
        begin
		  `uvme_info($psprintf("[run_phase] Start sequence on %s!", this.m_neigbour_seqr.get_full_name()), UVM_DEBUG)
          this.m_seq = uvme_layer_sequence#(T)::type_id::create("m_seq");
          this.m_seq.set_fifo(this.m_fifo); //link fifo to seq
          this.m_seq.start(this.m_neigbour_seqr);  //connect output to next layer
       end
        
        forever begin
          T txn;
          this.m_analysis_fifo.get(txn);
		  `uvme_info($psprintf("[run_phase] Get a data from m_analysis_fifo"), UVM_DEBUG)    
          this.send(txn);
        end
      join
    end
    else begin
      forever begin
        T txn;
        this.m_fifo.get(txn);
        `uvme_trace_data($psprintf("[run_phase] Output %s does not connect to any input, terminate the received packet %s!", this.get_full_name(), txn.convert2string()))      
      end
    end
    
    `uvme_trace_task_end("run_phase")
  endtask : run_phase


  // Function: link
  //
  // connect output to an input
  // one output can only link to one input
 
  virtual function void link(this_input_type neighbour_input);
    `uvme_cast(this.m_neigbour_seqr, neighbour_input.sequencer, error)
    `uvme_trace_connect($psprintf("Output %s -link-> Input %s", this.get_full_name(), neighbour_input.get_full_name()))
  endfunction : link



  // Function: get_connect_input
  //
  // Get connected uvm_layer_input
 
  virtual function uvm_component get_connect_input();
     if(this.m_neigbour_seqr != null) begin
	   `uvme_info($psprintf("m_neigbour_seqr name %s", this.m_neigbour_seqr.get_full_name()), UVM_DEBUG)
       return this.m_neigbour_seqr.get_parent();
	 end
     else
       return null;
  endfunction : get_connect_input



  // Function: link_sequencer
  //
  // connect the output to a real uvm_agent

  virtual function void link_sequencer(uvm_sequencer#(T) agent_seqr);
    `uvme_cast(this.m_neigbour_seqr, agent_seqr, error)
    `uvme_trace_connect($psprintf("[link_sequencer] Output %s -link-> Sequencer %s", this.get_full_name(), agent_seqr.get_full_name()))
  endfunction : link_sequencer


  // Function: inner_connect
  //
  // connect the output to agent monitor analysis_port.
  // This function can only be called between analysis_port and output whose parents are the same one.
  // This can be used for non-block write method to send data through output.
  //
 
  virtual function void inner_connect(uvm_analysis_port#(T) monitor_ap);
    uvm_component mon_ap_parent;
    uvm_component parent;
    `uvme_cast(mon_ap_parent, monitor_ap.get_parent(), fatal)
    `uvme_cast(parent, this.get_parent(), fatal)
    
    if(parent.get_full_name() == mon_ap_parent.get_full_name()) begin
      monitor_ap.connect(this.m_analysis_fifo.analysis_export);
      `uvme_trace_connect($psprintf("[inner_connect] analysis_port %s -inner-> output m_analysis_fifo %s", monitor_ap.get_full_name(), this.m_analysis_fifo.get_full_name()))
    end
    else begin
      `uvme_error($psprintf("[inner_connect] layer_output can only connect to monitor_ap %s with different parent %s!", monitor_ap.get_full_name(), mon_ap_parent.get_full_name()))
    end
  endfunction : inner_connect


endclass : uvme_layer_output



`endif //UVME_LAYER_OUTPUT_SVH

