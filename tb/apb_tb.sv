module tb;
  
    import uvm_pkg::*;
  	import apb_pkg::*;
  
  
  
  apb_if vif();
  
  apb_ram dut (.prstn(vif.prstn),
               .pclk(vif.pclk), 
               .psel(vif.psel), 
               .penable(vif.penable),
               .pwrite(vif.pwrite),
               .paddr(vif.paddr), 
               .pwdata(vif.pwdata), 
               .prdata(vif.prdata),
               .pready(vif.pready),
               .pslver(vif.pslver)
              );
  
  
  
  initial begin
    vif.pclk = 0;  
  end
  
  
  always #10 vif.pclk <= ~vif.pclk;
  
  
  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
    run_test("test");
  end
  
  
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end

   
  
endmodule