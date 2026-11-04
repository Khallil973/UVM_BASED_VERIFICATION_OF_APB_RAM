///write data
class write_data extends uvm_sequence#(transaction);
  `uvm_object_utils(write_data)
  
  transaction tr;
  
  function new(string name = "write_data");
    super.new(name);
  endfunction
  
  
  virtual task body();
    repeat(15) begin
      
      tr = transaction::type_id::create("tr");
      tr.addr_c.constraint_mode(1);
      tr.addr_c_error.constraint_mode(0);
      start_item(tr);
      assert(tr.randomize());
      tr.op = writed;
      finish_item(tr);
    
    end
  	
  endtask
  
endclass



///read data
class read_data extends uvm_sequence#(transaction);
  `uvm_object_utils(read_data)
  
  transaction tr;
  
  function new(string name = "read_data");
    super.new(name);
  endfunction
  
  
  virtual task body();
    repeat(15) begin
      
      tr = transaction::type_id::create("tr");
      tr.addr_c.constraint_mode(1);
      tr.addr_c_error.constraint_mode(0);
      start_item(tr);
      assert(tr.randomize());
      tr.op = readd;
      finish_item(tr);
    
    end
  	
  endtask
  
endclass



///write and read
class write_read extends uvm_sequence#(transaction);
  
  `uvm_object_utils(write_read)
  
  transaction tr;
  
  function new(string name = "write_read");
    super.new(name);
  endfunction
  
  
  virtual task body();
    repeat(15) begin
      
    
   	  tr = transaction::type_id::create("tr");
      tr.addr_c.constraint_mode(1);
      tr.addr_c_error.constraint_mode(0);
    
      start_item(tr);
      assert(tr.randomize());
      tr.op = writed;
      finish_item(tr);
      
      
      start_item(tr);
      assert(tr.randomize());
      tr.op = readd;
      finish_item(tr);
    
    end
    
    
  endtask
    
endclass



////write bulk and read bulk
class writeb_readb extends uvm_sequence#(transaction);

  `uvm_object_utils(writeb_readb)
  
  transaction tr;
  
  function new(string name = "writeb_readb");
    super.new(name);
  endfunction
  
 //write bulk 
  virtual task body();
    
    repeat(15) begin
      
      tr = transaction::type_id::create("tr");
      tr.addr_c.constraint_mode(1);
      tr.addr_c_error.constraint_mode(0);
      start_item(tr);
    
      assert(tr.randomize());
      tr.op = writed;
 
      finish_item(tr);
      
    end
    

  
  //read bulk

    repeat(15) begin
      
      tr = transaction::type_id::create("tr");
      tr.addr_c.constraint_mode(1);
      tr.addr_c_error.constraint_mode(0);
      start_item(tr);
    
      assert(tr.randomize());
      tr.op = readd;
 
      finish_item(tr);
      
    end
    
  endtask  
  
endclass





///slave write error
// class write_err extends uvm_sequence#(transaction);
//   `uvm_object_utils(write_err)
  
//   transaction tr;
  
//   function new(string name = "write_err");
//     super.new(name);
//   endfunction
  
  
//   virtual task body();
//     repeat(15) begin
//       tr = transaction::type_id::create("tr");
      
//       tr.addr_c.constraint_mode(0);
//       tr.addr_c_error.constraint_mode(1);
      
//       start_item(tr);
//       assert(tr.randomize());
//       tr.op = writed;
//       finish_item(tr);
      
//     end
//   endtask
  
// endclass

class write_err extends uvm_sequence #(transaction);
  `uvm_object_utils(write_err)

  transaction tr;

  function new(string name = "write_err");
    super.new(name);
  endfunction

  virtual task body();

    repeat(15) begin

      tr = transaction::type_id::create("tr");

      start_item(tr);

      tr.addr_c.constraint_mode(0);
      tr.addr_c_error.constraint_mode(1);

      if (!tr.randomize() with {
          op == writed;
      }) begin
        `uvm_error("SEQ", "WRITE ERROR randomization failed")
        return;
      end

      `uvm_info("SEQ",
        $sformatf("Generated invalid WRITE address = %0d", tr.paddr),
        UVM_MEDIUM)

      finish_item(tr);

    end

  endtask
endclass




class read_err extends uvm_sequence #(transaction);
  `uvm_object_utils(read_err)

  transaction tr;

  function new(string name = "read_err");
    super.new(name);
  endfunction

  virtual task body();

    repeat(15) begin

      tr = transaction::type_id::create("tr");

      start_item(tr);

      tr.addr_c.constraint_mode(0);
      tr.addr_c_error.constraint_mode(1);

      if (!tr.randomize() with {
          op == readd;
      }) begin
        `uvm_error("SEQ", "READ ERROR randomization failed")
        return;
      end

      `uvm_info("SEQ",
        $sformatf("Generated invalid READ address = %0d", tr.paddr),
        UVM_MEDIUM)

      finish_item(tr);

    end

  endtask
endclass


//read slave error 
// class read_err extends uvm_sequence#(transaction);
//   `uvm_object_utils(read_err)
  
//   transaction tr;
  
//   function new(string name = "read_err");
//     super.new(name);
//   endfunction
  
//   virtual task body();
//     repeat(15) begin
//       tr = transaction::type_id::create("tr");
//       tr.addr_c.constraint_mode(0);
//       tr.addr_c_error.constraint_mode(1);
      
//       start_item(tr);
//       assert(tr.randomize());
//       tr.op = readd;
//       finish_item(tr);
      
//     end
    
//   endtask
  
// endclass



//reset dut
class reset_dut extends uvm_sequence#(transaction);
  `uvm_object_utils(reset_dut)
  
  transaction tr;
  
  function new(string name = "reset_dut");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15) begin
      tr = transaction::type_id::create("tr");
      tr.addr_c.constraint_mode(1);
      tr.addr_c_error.constraint_mode(0);
      
      start_item(tr);
      assert(tr.randomize());
      tr.op = rst;
      
      finish_item(tr);
      
    end
    
  endtask
  
endclass



// class data_seq extends uvm_sequence #(transaction);

//   `uvm_object_utils(data_seq)

//   transaction tr;

//   bit[31:0] pattern[7] = '{
//     32'h00000008,
//     32'h0000000A,
//     32'hFFFFFFFF,
//     32'hAAAAAAAA,
//     32'h55555555,
//     32'h00000000,
//     32'h00000005
//   };
  
  
//   function new(string name = "write_zero");
//     super.new(name);
//   endfunction

//   virtual task body();
//     foreach(pattern[i]) begin
      
//     tr = transaction::type_id::create("tr");
//       tr.addr_c.constraint_mode(1);
//       tr.addr_c_error.constraint_mode(0);
//     start_item(tr);

//     tr.op     = writed;
//     tr.paddr  = 32'h5;
//       tr.pwdata = pattern[i];

//     finish_item(tr);
//     end
//   endtask

// endclass

class data_seq extends uvm_sequence #(transaction);

  `uvm_object_utils(data_seq)

  transaction tr;

  function new(string name = "data_pattern_seq");
    super.new(name);
  endfunction

  virtual task body();

    repeat(15) begin

      tr = transaction::type_id::create("tr");

      start_item(tr);

      assert(tr.randomize() with {
        op == writed;
        paddr == 32'h5;

        pwdata inside {
          32'h00000008,
          32'h0000000A,
          32'hFFFFFFFF,
          32'hAAAAAAAA,
          32'h55555555,
          32'h00000000,
          32'h00000005
        };
      })
      else
        `uvm_fatal("SEQ", "Transaction randomization failed")

      finish_item(tr);

    end

  endtask

endclass