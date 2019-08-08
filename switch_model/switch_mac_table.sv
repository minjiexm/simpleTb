///////////////////////////////////////////////////////////////////////////////////////////////////
//
//        CLASS: switch_mac_table
//  DESCRIPTION: 
//         BUGS: ---
//       AUTHOR: jiemin 
// ORGANIZATION: 
//      VERSION: 1.0
//      CREATED: 06/15/2019 11:56:19 PM
//     REVISION: ---
///////////////////////////////////////////////////////////////////////////////////////////////////

`define MAC_TB_KEY_SZ `MAC_ADDR_SZ

class switch_mac_table extends uvm_object;

  typedef bit[`MAC_TB_KEY_SZ-1:0] mac_key_type;
  typedef int unsigned            mac_rslt_type;

  protected int unsigned lookup_table[mac_key_type];

  `uvm_object_utils_begin(switch_mac_table)
  `uvm_object_utils_end

  // ******************************************************************************
  // Constructor
  // ****************************************************************************** 
  function new(string name = "switch_mac_table");
    super.new(name);
  endfunction : new

  // *******************************************************************************
  // setup : config mac table, index is mac address, content is port index
  // *******************************************************************************
  virtual function void setup(input mac_key_type key, mac_rslt_type port_idx);
    `uvm_info(this.get_type_name(), $psprintf("[setup] Config Mac Address 0x%0h with Port Index 0x%0h", key, port_idx), UVM_LOW)
    this.lookup_table[key] = port_idx;
  endfunction : setup

  // *******************************************************************************
  // lookup : DA lookup to get dest port index
  // *******************************************************************************
  virtual function bit lookup(input mac_key_type key, output mac_rslt_type port_idx);
    if(this.lookup_table.exists(key)) begin
      port_idx = this.lookup_table[key];
      `uvm_info(this.get_type_name(), $psprintf("[DA lookup] Lookup Mac Address 0x%0h hit with Port Index 0x%0h", key, port_idx), UVM_LOW)
      return 1;
    end
    else begin
      `uvm_info(this.get_type_name(), $psprintf("[DA lookup] Lookup Mac Address 0x%0h missed!", key), UVM_LOW)
      return 0; //lookup fail
    end
  endfunction : lookup

  // *******************************************************************************
  // lookup_learn : SA lookup, update SA's port idx
  // *******************************************************************************
  virtual function void lookup_learn(input mac_key_type key, input mac_rslt_type port_idx);
    if(this.lookup_table.exists(key)) begin
      mac_rslt_type old_port_idx = this.lookup_table[key];
      `uvm_info(this.get_type_name(), $psprintf("[SA lookup_learn] Lookup Mac Address 0x%0h hit with Port Index 0x%0h", key, old_port_idx), UVM_LOW)
      if(old_port_idx != port_idx) begin //learn
        `uvm_info(this.get_type_name(), $psprintf("[SA lookup_learn] Update Mac Address 0x%0h Port Index from %0h to 0x%0h", key, old_port_idx, port_idx), UVM_LOW)
        this.setup(key, port_idx);
      end
    end
    else begin
      `uvm_info(this.get_type_name(), $psprintf("[SA lookup_learn] New Learn Mac Address 0x%0h with Port Index 0x%0h", key, port_idx), UVM_LOW)
      this.setup(key, port_idx);
    end
  endfunction : lookup_learn

endclass : switch_mac_table

