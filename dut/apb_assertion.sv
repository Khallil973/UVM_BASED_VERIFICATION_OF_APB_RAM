//Reset Assertion

property p_reset_check;
  
  @(posedge pclk)
  
  !prstn |=>  (prdata  == 0 && pready == 0 && pslver == 0);
  
  
endproperty


assert property (p_reset_check)
  $display("ASSERTION PASSED: RESET CHECK");
else
  $error("ASSERTION FAILED: RESET CHECK");
  
  
  
property p_setup_to_access;
  @(posedge pclk)
  disable iff(!prstn)
  
  (psel && !penable) |=> (psel && penable);
  
endproperty
  
  
assert property (p_setup_to_access)
  $display("ASSERTION PASSED: SETUP TO ACCESS");
  else 
    $error("ASSERTION FAILED: SETUP TO ACCESS");
   
 
  

property p_access_phase;
  @(posedge pclk)
  disable iff (!prstn)

  (psel && penable)
  |=> (psel && penable);

endproperty

assert property (p_access_phase)
  $display("ASSERTION PASSED: ACCESS PHASE");
  else $error("ASSERTION FAILED: ACCESS PHASE");  
  
  
  
  
property p_valid_write;
  @(posedge pclk)
  disable iff (!prstn)

  (psel && penable && pwrite && paddr < 32)
  |=> (pready && !pslver);

endproperty

assert property (p_valid_write)
  $display("ASSERTION PASSED: VALID WRITE");
  else $error("ASSERTION FAILED: VALID WRITE");  
  
  
  
  
// property p_invalid_write;
//   @(posedge pclk)
//   disable iff (!prstn)

//   (psel && penable && pwrite && paddr >= 32)
//   |=> (pready && pslver);

// endproperty

// assert property (p_invalid_write)
//   $display("ASSERTION PASSED: INVALID WRITE");
//   else $error("ASSERTION FAILED: INVALID WRITE");  
  
  
  
  
 property p_valid_read;
  @(posedge pclk)
  disable iff (!prstn)

  (psel && penable && !pwrite && paddr < 32)
  |=> (pready && !pslver);

endproperty

assert property (p_valid_read)
  $display("ASSERTION PASSED: VALID READ");
  else $error("ASSERTION FAILED: VALID READ"); 
  
  
  
property p_wait_stability;
  @(posedge pclk)
  disable iff (!prstn)

  (psel && penable && !pready)
  |=> $stable({psel, penable, paddr, pwrite, pwdata});

endproperty

assert property (p_wait_stability)
  $display("ASSERTION PASSED: WAIT STATE STABILITY");
  else $error("ASSERTION FAILED: WAIT STATE STABILITY");  
  
  
  
  
property p_error_response;
  @(posedge pclk)
  disable iff (!prstn)

  pslver |-> (psel && penable && pready);

endproperty

assert property (p_error_response)
  $display("ASSERTION PASSED: ERROR RESPONSE");  
  else $error("ASSERTION FAILED: ERROR RESPONSE");  
  
  
  
  
  
property p_transfer_completion;
  @(posedge pclk)
  disable iff (!prstn)

  (psel && penable && pready)
  |=> !penable;

endproperty

assert property (p_transfer_completion)
  $display("ASSERTION PASSED: TRANSFER COMPLETION");  
  else $error("ASSERTION FAILED: TRANSFER COMPLETION");  