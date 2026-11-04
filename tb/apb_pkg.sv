`timescale 1ns/1ps

package apb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Configuration and transaction
  `include "apb_config.sv"
  `include "apb_transaction.sv"

  // Sequences and sequencer
  `include "apb_seq.sv"
//  `include "apb_sequencer.sv"

  // Driver and monitor
  `include "apb_drv.sv"
  `include "apb_mon.sv"

  // Scoreboard
  `include "apb_sco.sv"

  //Coverage
  `include "apb_cov.sv"	

  // Agent and environment
  `include "apb_agent.sv"
  `include "apb_env.sv"

  // Test
  `include "apb_test.sv"

endpackage