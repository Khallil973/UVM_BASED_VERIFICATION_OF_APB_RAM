class mon extends uvm_monitor;
  
  `uvm_component_utils(mon)
  
  virtual apb_if vif;
  uvm_analysis_port#(transaction)send;
  transaction tr;
  
  
  function new(string	 name = "mon", uvm_component parent= null);
    super.new(name,parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    tr = transaction::type_id::create("tr");
    send = new("send", this);
    if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_error("MON","unable to access interfacte");                                    
  endfunction
  
                                           
                                           
  virtual task run_phase(uvm_phase phase);
    forever begin
      
      @(posedge vif.pclk);
      if(!vif.prstn) begin
        tr.op = rst;
        `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_NONE);
        send.write(tr);
       
      end
      else if(vif.prstn && vif.pwrite) begin
        @(posedge vif.pready);
        tr.op = writed;
        tr.paddr = vif.paddr;
        tr.pwdata = vif.pwdata;
        tr.pslver = vif.pslver;
        `uvm_info("MON", $sformatf("DATA WRITE addr:%0d data:%0d slver:%0d",tr.paddr,tr.pwdata,tr.pslver), UVM_NONE); 
        send.write(tr);
      
      end
      else if(vif.prstn && !vif.pwrite) begin
        @(posedge vif.pready);
        tr.op = readd;
        tr.paddr = vif.paddr;
        tr.prdata = vif.prdata;
        tr.pslver = vif.pslver;
        `uvm_info("MON", $sformatf("DATA READ addr:%0d data:%0d slver:%0d",tr.paddr, tr.prdata,tr.pslver), UVM_NONE); 
        send.write(tr);
      end
      
    end     
    
  endtask
                                           
            
endclass:mon