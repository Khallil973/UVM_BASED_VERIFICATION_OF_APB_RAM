
class apb_cov extends uvm_subscriber #(transaction);

  `uvm_component_utils(apb_cov)

  // Coverage sampling variables
  oper_mode op_cov;
  bit [31:0] addr_cov;
  bit [31:0] data_cov;
  bit err_cov;


  // Main APB coverage
  covergroup apb_cg;

    option.per_instance = 1;

    // Operation coverage
    oper_cp: coverpoint op_cov {
      bins write = {writed};
      bins read  = {readd};
      bins reset = {rst};
    }

    // Address coverage
    address_cp: coverpoint addr_cov {
      bins min_addr = {0};
      bins middle   = {[1:30]};
      bins max_addr = {31};
      bins invalid  = {[32:32'hFFFFFFFF]};
    }

    // Response coverage
    response_cp: coverpoint err_cov {
      bins success = {0};
      bins error   = {1};
    }

    // Cross coverage
    operation_address:
      cross oper_cp, address_cp;

    operation_response:
      cross oper_cp, response_cp;

  endgroup


  // Write data coverage
  covergroup data_cg;

    option.per_instance = 1;

    data_cp: coverpoint data_cov {

      bins zero = {32'h00000000};

      bins all_ones = {32'hFFFFFFFF};

      bins alternating = {
        32'hAAAAAAAA,
        32'h55555555
      };

      bins small_values = {
        32'h0000000A,
        32'h00000005
      };

      bins other_values = default;

    }

  endgroup


  // Constructor
  function new(string name = "apb_cov",
               uvm_component parent = null);

    super.new(name, parent);

    apb_cg  = new();
    data_cg = new();

  endfunction


  // Analysis implementation
  virtual function void write(transaction t);

    // Capture transaction information
    op_cov   = t.op;
    addr_cov = t.paddr;
    err_cov  = t.pslver;

    // Sample main APB coverage
    if(t.op inside {writed, readd, rst}) begin
      apb_cg.sample();
    end

    // Sample data coverage only for WRITE
    if(t.op == writed) begin

      data_cov = t.pwdata;
      data_cg.sample();

    end

    `uvm_info("COV_SAMPLE",
      $sformatf("Operation=%0s Address=%0d Error=%0b APB_Coverage=%0.2f%% Data_Coverage=%0.2f%%",
                t.op.name(),
                t.paddr,
                t.pslver,
                apb_cg.get_coverage(),
                data_cg.get_coverage()),
      UVM_MEDIUM)

  endfunction


  // Coverage reporting
  function void report_phase(uvm_phase phase);

    super.report_phase(phase);

    `uvm_info("APB_COVERAGE",
      $sformatf("Operation Coverage = %0.2f%%",
                apb_cg.oper_cp.get_coverage()),
      UVM_NONE)

    `uvm_info("APB_COVERAGE",
      $sformatf("Address Coverage = %0.2f%%",
                apb_cg.address_cp.get_coverage()),
      UVM_NONE)

    `uvm_info("APB_COVERAGE",
      $sformatf("Write Data Coverage = %0.2f%%",
                data_cg.data_cp.get_coverage()),
      UVM_NONE)

    `uvm_info("APB_COVERAGE",
      $sformatf("Response Coverage = %0.2f%%",
                apb_cg.response_cp.get_coverage()),
      UVM_NONE)
ACCC
    `uvm_info("APB_COVERAGE",
      $sformatf("Overall APB Coverage = %0.2f%%",
                apb_cg.get_coverage()),
      UVM_NONE)

  endfunction

endclass
