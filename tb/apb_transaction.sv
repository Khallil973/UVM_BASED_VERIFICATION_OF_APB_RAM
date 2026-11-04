typedef enum bit [1:0] {readd = 0, writed = 1, rst= 2} oper_mode;


//////////////////////////////
class transaction extends uvm_sequence_item;
  
  
  rand oper_mode op;
  rand logic pwrite;
  rand logic [31:0] paddr;
  rand logic [31:0] pwdata;
  
  
  logic pready;
  logic pslver;
  logic [31:0] prdata;
  
  
  
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(pwrite, UVM_ALL_ON)
  `uvm_field_int(pwdata, UVM_ALL_ON)
  `uvm_field_int(paddr, UVM_ALL_ON)
  `uvm_field_int(pready, UVM_ALL_ON)
  `uvm_field_int(pslver, UVM_ALL_ON)
  `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_field_enum(oper_mode, op, UVM_DEFAULT)
  `uvm_object_utils_end 
  
  
  
//   constraint addr_c {paddr <= 31;}
//   constraint addr_c_error {paddr > 31;}
  
constraint addr_c {
    paddr inside {[0:31]};
}

constraint addr_c_error {
  paddr inside {[32'h00000000:32'hFFFF_FFFF]};
}
  
  function new(string name = "transaction");
    super.new(name);
  endfunction
  
  
  
endclass:transaction

