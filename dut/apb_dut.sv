
module apb_ram(
  	input  prstn,
    input  pclk,
   	input  psel,
  	input penable,
  	input  pwrite,
    input [31:0] paddr,
    input [31:0] pwdata,
    output reg [31:0] prdata,
    output reg pready,
  	output reg pslver

);
  
  //mem 
  logic [31:0] mem[32];
  
  //states
  typedef enum {idle, setup, access, transfer} state_t;
  
  state_t state;
  
  integer i ;
  
  always_ff @(posedge pclk) begin
    if(!prstn) begin
      state <= idle;
      prdata <= 32'b0;
      pready <= 1'b0;
      pslver <= 1'b0;
    
      for(int i = 0; i<32; i++)
        mem[i] <= 32'b0;
    end
    
    else begin
      case(state) 
        idle:
        begin
          prdata <= 32'b0;
          pready <= 1'b0;
          pslver <= 1'b0;
          state <= setup;
        end
              
        setup:
        begin
          if(psel == 1) begin
           	state <= access;
            
          end else begin
            state <= setup;
          end
        end
        
        access:
        begin
          if(pwrite == 1 && psel == 1 && penable == 1) begin //for write
            if(paddr < 32) begin
              mem[paddr] <= pwdata;
              pready <= 1'b1;
              pslver <= 1'b0;
              state <= transfer;
            end
            else begin
              pready <= 1'b1;
              pslver <= 1'b1;
              state <= transfer; //when paddr > 32 having pslverr so next state will be transfer
              
              $display("DUT: Invalid WRITE detected. Address=%0d", paddr);
            end
            
          end else if(!pwrite && psel  && penable) begin //read
            if(paddr < 32) begin
              prdata <= mem[paddr];
              pready <= 1'b1;
              pslver <= 1'b0;
              state <= transfer;
              
            end else begin
              pready <= 1'b1;
              pslver <= 1'b1;
              prdata <= 32'hxxxxxxxx;
              state <= transfer;
              
                 $display("DUT: Invalid READ detected. Address=%0d", paddr);

            end
          end

        end
        
        transfer:
          begin
            pready <= 1'b0;
            pslver <= 1'b0;
            state <= setup; 
          end
        
        default: state <= idle;
          
          
      endcase
    end        
    $display("Time=%0t State=%s PSEL=%b PENABLE=%b PREADY=%b PSLVER=%b",
         $time, state.name(), psel, penable, pready, pslver);    
  end
endmodule
        
        
   
//////////////////

interface apb_if ();
  // Signals
  logic              pclk;
  logic              prstn;
  logic       [31:0] paddr;
  logic              pwrite;
  logic       [31:0] pwdata;
  logic              penable;
  logic              psel;
  logic       [31:0] prdata;
  logic              pslver;
  logic              pready;
  
  `include "apb_assertion.sv"
  
  
endinterface : apb_if