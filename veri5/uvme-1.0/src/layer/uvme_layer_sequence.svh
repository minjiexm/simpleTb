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
`ifndef UVME_LAYER_SEQUENCE_SV
`define UVME_LAYER_SEQUENCE_SV

//------------------------------------------------------------------------------
//
// CLASS: uvme_layer_sequence
//
// Keep checking fifo, if the fifo is not empty will send the transaction to next layer's
// sequencer.
//------------------------------------------------------------------------------

class uvme_layer_sequence #(type T = uvm_sequence_item) extends uvm_sequence#(T, T);

  typedef uvme_layer_sequence#(T) this_layer_seqr_type; 
  typedef uvm_tlm_fifo#(T) layer_fifo_type;
  typedef uvm_sequencer#(T) layer_seqr_type;

  `uvm_declare_p_sequencer(layer_seqr_type)

  protected layer_fifo_type m_fifo;

  protected int unsigned trans_id;

  `uvm_object_param_utils_begin(this_layer_seqr_type)
  `uvm_object_utils_end

  // Function: new
  //
  // Constructor

  function new(string name = "");
    super.new(name);
  endfunction : new

  // Function: set_get_port
  //
  // layer get port should be created in parent class and use set_get_port to
  // assign to the sequence.

  function void set_fifo(layer_fifo_type fifo);
    `uvme_cast(this.m_fifo, fifo, error);
  endfunction : set_fifo
  

  // Function: body
  //
  // Use event_name plus domain to wait an event.
  // Domain means we can use same event name within different domain.
  
  task body();
    this.trans_id = 1; //start from 1
	
    if(this.m_fifo != null) begin
      forever begin
	    T txn4send;
        this.m_fifo.get(req); //blocking until get data
		//[NOTE]: For Layer Sequence, it must clone the data it received and then pass to next layer.
		//Otherwise, next layer sequence will get wrong sequencer from the transaction.
		//Sequencer and Sequence information will be carried with in the transaction.

		`uvme_cast(txn4send, req.clone(), fatal);
		txn4send.set_item_context(this, this.p_sequencer);
		txn4send.set_transaction_id(this.trans_id++);

	    //`uvm_info("TRACE::LAYER_SEQUENCE",$psprintf("[%s] Get a data from m_fifo and going to send to p sequencer %s", this.get_full_name(), this.p_sequencer.get_full_name()), UVM_LOW)
	    `uvm_send(txn4send)
	    //`uvme_info($psprintf("[%s] Send the data to p sequencer %s and waiting for response", this.get_full_name(), this.p_sequencer.get_full_name()), UVM_LOW)
	    get_response(rsp, txn4send.get_transaction_id()); //blocking until get response
		//`uvm_info("TRACE::LAYER_SEQUENCE", $psprintf("[%s] Get the response %s from p sequencer %s for transaction %0d", this.get_full_name(), rsp.convert2string(), this.p_sequencer.get_full_name(), txn4send.get_transaction_id()), UVM_LOW)
      end
    end
    else begin
      `uvme_error($psprintf("layer fifo is not assigned! Please use set_layer_fifo to assign a layer fifo at first!"))
    end
  endtask : body

endclass : uvme_layer_sequence


`endif //UVME_LAYER_SEQUENCE_SVH

