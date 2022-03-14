module forward_logic (
  input me_valid, wb_valid,
  input [2:0] rsrc1, rsrc2,
  input [2:0] me_rdst, wb_rdst,
  output reg [1:0] fwd1, fwd2
);

  parameter NOF = 2'b00;
  parameter MEF = 2'b10;
  parameter WBF = 2'b11;

  always @(*) begin
    // default: no forward
    fwd1 = NOF;
    fwd2 = NOF;

    // calculate forward for rsrc1
    if (me_valid && rsrc1 == me_rdst)
      fwd1 = MEF;
    else if (wb_valid && rsrc1 == wb_rdst)
      fwd1 = WBF;

    // calculate forward for Rsrc2
    if (me_valid && rsrc2 == me_rdst)
      fwd2 = MEF;
    else if (wb_valid && rsrc2 == wb_rdst)
      fwd2 = WBF;
  end

endmodule