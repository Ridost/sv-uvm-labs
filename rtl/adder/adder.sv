module adder( adder_if adderif);

assign {adderif.carry,adderif.sum} = adderif.a+adderif.b;

endmodule
