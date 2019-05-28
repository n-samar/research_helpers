/* For 4-merger */
module BITONIC_NETWORK_8 (input i_clk,
			  input 		switch_output,
			  input 		stall,
			  input [4*32-1:0] 	top_tuple,
			  input [4*32-1:0] 	i_elems_0,
			  input [4*32-1:0] 	i_elems_1, 
			  output reg [4*32-1:0] o_elems_0,
			  output reg [4*32-1:0] o_elems_1,
			  output reg 		o_switch_output,
			  output reg 		o_stall,
			  output reg [4*32-1:0] o_top_tuple);

   reg 					stall_1, stall_2;
   reg 					switch_output_1, switch_output_2;
   reg [4*32-1:0] 			elems_1_0;
   reg [4*32-1:0] 			elems_1_1;   
   reg [4*32-1:0] 			elems_2_0;
   reg [4*32-1:0] 			elems_2_1;   
   wire [4*32-1:0] 			top_tuple_1;
   reg [4*32-1:0] 			top_tuple_2;

   assign top_tuple_1 = top_tuple;
   
   initial begin
      stall_1 <= 0;
      switch_output_1 <= 0;
      elems_1_0 <= 0;
      elems_1_1 <= 0;

      stall_2 <= 0;
      switch_output_2 <= 0;
      elems_2_0 <= 0;
      elems_2_1 <= 0;

      top_tuple_2 <= 0;
   end

   /* step 1 */
   always @(posedge i_clk) begin
      stall_1 <= stall;
      if (~stall) begin
	 switch_output_1 <= switch_output;	 

	 /* CAS(0, 7) */
	 if (i_elems_0[31:0] > i_elems_1[4*32-1:3*32]) begin
	    /* switch */
	    elems_1_0[31:0] <= i_elems_1[4*32-1:3*32];
	    elems_1_1[4*32-1:3*32] <= i_elems_0[31:0];
	 end
	 else begin
	    /* stay */
	    elems_1_1[4*32-1:3*32] <= i_elems_1[4*32-1:3*32];
	    elems_1_0[31:0] <= i_elems_0[31:0];	    
	 end

	 /* CAS(1, 6) */
	 if (i_elems_0[2*32-1:32] > i_elems_1[3*32-1:2*32]) begin
	    /* switch */
	    elems_1_0[2*32-1:32] <= i_elems_1[3*32-1:2*32];
	    elems_1_1[3*32-1:2*32] <= i_elems_0[2*32-1:32];
	 end
	 else begin
	    /* stay */
	    elems_1_0[2*32-1:32] <= i_elems_0[2*32-1:32];
	    elems_1_1[3*32-1:2*32] <= i_elems_1[3*32-1:2*32];	    
	 end	 
	 
	 /* CAS(2, 5) */
	 if (i_elems_0[3*32-1:2*32] > i_elems_1[2*32-1:32]) begin
	    /* switch */
	    elems_1_1[2*32-1:32] <= i_elems_0[3*32-1:2*32];
	    elems_1_0[3*32-1:2*32] <= i_elems_1[2*32-1:32];
	 end
	 else begin
	    /* stay */
	    elems_1_1[2*32-1:32] <= i_elems_1[2*32-1:32];
	    elems_1_0[3*32-1:2*32] <= i_elems_0[3*32-1:2*32];	    
	 end

	 /* CAS(3, 4) */
	 if (i_elems_0[4*32-1:3*32] > i_elems_1[31:0]) begin
	    /* switch */
	    elems_1_1[31:0] <= i_elems_0[4*32-1:3*32];
	    elems_1_0[4*32-1:3*32] <= i_elems_1[31:0];
	 end
	 else begin
	    /* stay */
	    elems_1_1[31:0] <= i_elems_1[31:0];
	    elems_1_0[4*32-1:3*32] <= i_elems_0[4*32-1:3*32];	    
	 end	 	 
      end // if (~stall)      
   end

   /* step 2 */
   always @(posedge i_clk) begin
      stall_2 <= stall_1;
      if (~stall_1) begin
	 switch_output_2 <= switch_output_1;
	 top_tuple_2 <= top_tuple_1;

	 /* CAS(0, 2) */
	 if (elems_1_0[31:0] > elems_1_0[3*32-1:2*32]) begin
	    /* switch */
	    elems_2_0[31:0] <= elems_1_0[3*32-1:2*32];
	    elems_2_0[3*32-1:2*32] <= elems_1_0[31:0];	    
	 end
	 else begin
	    /* stay */
	    elems_2_0[31:0] <= elems_1_0[31:0];
	    elems_2_0[3*32-1:2*32] <= elems_1_0[3*32-1:2*32];
	 end
	 
	 /* CAS(1, 3) */
	 if (elems_1_0[2*32-1:32] > elems_1_0[4*32-1:3*32]) begin
	    /* switch */
	    elems_2_0[2*32-1:32] <= elems_1_0[4*32-1:3*32];
	    elems_2_0[4*32-1:3*32] <= elems_1_0[2*32-1:32];	    
	 end
	 else begin
	    /* stay */
	    elems_2_0[2*32-1:32] <= elems_1_0[2*32-1:32];
	    elems_2_0[4*32-1:3*32] <= elems_1_0[4*32-1:3*32];
	 end

	 /* CAS(4, 6) */
	 if (elems_1_1[31:0] > elems_1_1[3*32-1:2*32]) begin
	    /* switch */
	    elems_2_1[31:0] <= elems_1_1[3*32-1:2*32];
	    elems_2_1[3*32-1:2*32] <= elems_1_1[31:0];	    
	 end
	 else begin
	    /* stay */
	    elems_2_1[31:0] <= elems_1_1[31:0];
	    elems_2_1[3*32-1:2*32] <= elems_1_1[3*32-1:2*32];
	 end
	 
	 /* CAS(5, 7) */
	 if (elems_1_1[2*32-1:32] > elems_1_1[4*32-1:3*32]) begin
	    /* switch */
	    elems_2_1[2*32-1:32] <= elems_1_1[4*32-1:3*32];
	    elems_2_1[4*32-1:3*32] <= elems_1_1[2*32-1:32];	    
	 end
	 else begin
	    /* stay */
	    elems_2_1[2*32-1:32] <= elems_1_1[2*32-1:32];
	    elems_2_1[4*32-1:3*32] <= elems_1_1[4*32-1:3*32];
	 end	 	 
      end
   end // always @ (posedge i_clk)

   /* step 3 */
   always @(posedge i_clk) begin
      o_stall <= stall_2;
      if (~stall_2) begin
	 o_switch_output <= switch_output_2;
	 o_top_tuple <= top_tuple_2;

	 /* CAS(0, 1) */
	 if (elems_2_0[31:0] > elems_2_0[2*32-1:32]) begin
	    /* switch */
	    o_elems_0[31:0] <= elems_2_0[2*32-1:32];
	    o_elems_0[2*32-1:32] <= elems_2_0[31:0];	    
	 end
	 else begin
	    /* stay */
	    o_elems_0[31:0] <= elems_2_0[31:0];
	    o_elems_0[2*32-1:32] <= elems_2_0[2*32-1:32];
	 end
	 
	 /* CAS(2, 3) */
	 if (elems_2_0[3*32-1:2*32] > elems_2_0[4*32-1:3*32]) begin
	    /* switch */
	    o_elems_0[3*32-1:2*32] <= elems_2_0[4*32-1:3*32];
	    o_elems_0[4*32-1:3*32] <= elems_2_0[3*32-1:2*32];	    
	 end
	 else begin
	    /* stay */
	    o_elems_0[3*32-1:2*32] <= elems_2_0[3*32-1:2*32];
	    o_elems_0[4*32-1:3*32] <= elems_2_0[4*32-1:3*32];
	 end

	 /* CAS(4, 5) */
	 if (elems_2_1[31:0] > elems_2_1[2*32-1:32]) begin
	    /* switch */
	    o_elems_1[31:0] <= elems_2_1[2*32-1:32];
	    o_elems_1[2*32-1:32] <= elems_2_1[31:0];	    
	 end
	 else begin
	    /* stay */
	    o_elems_1[31:0] <= elems_2_1[31:0];
	    o_elems_1[2*32-1:32] <= elems_2_1[2*32-1:32];
	 end
	 
	 /* CAS(6, 7) */
	 if (elems_2_1[3*32-1:2*32] > elems_2_1[4*32-1:3*32]) begin
	    /* switch */
	    o_elems_1[3*32-1:2*32] <= elems_2_1[4*32-1:3*32];
	    o_elems_1[4*32-1:3*32] <= elems_2_1[3*32-1:2*32];	    
	 end
	 else begin
	    /* stay */
	    o_elems_1[3*32-1:2*32] <= elems_2_1[3*32-1:2*32];
	    o_elems_1[4*32-1:3*32] <= elems_2_1[4*32-1:3*32];
	 end	 	 
      end
   end   
endmodule