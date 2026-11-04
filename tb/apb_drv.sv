class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
  
  virtual apb_if vif;
  transaction tr;
  
  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif", vif))//uvm_test_top.env.agent.drv.vif
      `uvm_error("drv", "unable to access interface");
  endfunction
  
  
  task reset_dut();
    repeat(5) begin
   	 vif.prstn   <= 1'b0;
     vif.paddr     <= 'h0;
     vif.pwdata    <= 'h0;
     vif.pwrite    <= 'b0;
     vif.psel      <= 'b0;
     vif.penable   <= 'b0; 
     `uvm_info("DRV", "System Reset : Start of Simulation", UVM_MEDIUM);
      @(posedge vif.pclk);
    end
  endtask

  
  
  task drive();
    reset_dut();
    
    forever begin
      seq_item_port.get_next_item(tr);
      
      
      if(tr.op ==  rst) begin
        
       vif.prstn   <= 1'b0;
       vif.paddr     <= 'h0;
       vif.pwdata    <= 'h0;
       vif.pwrite    <= 'b0;
       vif.psel      <= 'b0;
       vif.penable   <= 'b0;
       @(posedge vif.pclk);  
      
      end
      
      
      else if(tr.op == writed) begin
        vif.psel <= 1'b1; //psel directly 1
        vif.paddr <= tr.paddr;
        vif.pwdata <= tr.pwdata;
        vif.prstn <= 1'b1;
        vif.pwrite <= 1'b1;
        @(posedge vif.pclk);
        vif.penable <= 1'b1;
        `uvm_info("DRV", $sformatf("mode:%0s, addr:%0d, wdata:%0h, rdata:%0d, slverr:%0d",tr.op.name(),tr.paddr,tr.pwdata,tr.prdata,tr.pslver), UVM_NONE);
        @(posedge vif.pready);
        vif.penable <= 1'b0;
        tr.pslver <= vif.pslver;
        
      end
      
      
      else if (tr.op == readd) begin
        vif.psel <= 1'b1; //psel directly 1
        vif.paddr <= tr.paddr;
//        vif.pwdata <= tr.pwdata;
        vif.prstn <= 1'b1;
        vif.pwrite <= 1'b0; //if wrong that need to correct by 1'b1
        @(posedge vif.pclk);
        vif.penable <= 1'b1;
        `uvm_info("DRV", $sformatf("mode:%0s, addr:%0d, wdata:%0h, rdata:%0d, slverr:%0d",tr.op.name(),tr.paddr,tr.pwdata,tr.prdata,tr.pslver), UVM_NONE);
        @(posedge vif.pready);
        vif.penable <= 1'b0;
        tr.pslver <= vif.pslver;  
        tr.prdata <= vif.prdata;
        
        
      end
        
      seq_item_port.item_done();
          
    end
 
  endtask
  
  
  
  virtual task run_phase(uvm_phase phase);
    drive();
  endtask
  
  
  
endclass:driver