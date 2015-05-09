
module test_sdram(REF_CLK, RESET_N, LEDR, LEDG,
	SA, BA, CS_N, CKE, RAS_N, CAS_N, WE_N, DQ, DQM, SDR_CLK);
//clock/reset
input REF_CLK;
input RESET_N;

// SDRAM Side
output  [11:0]                  SA;                     //SDRAM address output
output  [1:0]                   BA;                     //SDRAM bank address
output  [1:0]                   CS_N;                   //SDRAM Chip Selects
output                          CKE;                    //SDRAM clock enable
output                          RAS_N;                  //SDRAM Row address Strobe
output                          CAS_N;                  //SDRAM Column address Strobe
output                          WE_N;                   //SDRAM write enable
inout   [16:0]            		  DQ;                     //SDRAM data bus
output  [1:0]                   DQM;                    //SDRAM data mask lines
output							     SDR_CLK;				//SDRAM Clock
output [8:0]						  LEDG;
output [17:0]						  LEDR;

reg rWR;
reg rRD;
reg [22:0] rADDR;
reg [15:0] rDATAIN;
reg [15:0] rDATAOUT;
reg [3:0] ST;

wire mCLK;
wire mWR = rWR;
wire mRD = rRD;
wire [22:0] mADDR = rADDR;
wire mDONE;
wire [15:0] mDATAIN = rDATAIN;
wire [15:0] mDATAOUT;
wire mOUT_VALID;



Sdram_Controller sd(
		//	HOST
        .REF_CLK(REF_CLK),
        .RESET_N(RESET_N),
        .ADDR(mADDR),
		  .WR(mWR),
		  .RD(mRD),
		  .LENGTH(9'h80),
		  .ACT(),
		  .DONE(mDONE),
        .DATAIN(mDATAIN),
        .DATAOUT(mDATAOUT),
		  .IN_REQ(),
		  .OUT_VALID(mOUT_VALID),
        .DM(2'd00),
		//	SDRAM
        .SA(SA),
        .BA(BA),
        .CS_N(CS_N),
        .CKE(CKE),
        .RAS_N(RAS_N),
        .CAS_N(CAS_N),
        .WE_N(WE_N),
        .DQ(DQ),
        .DQM(DQM),
		  .SDR_CLK(SDR_CLK),
		  .CLK(mCLK)
        );
		  
	
	parameter write = 4'd1,
				 finish_write = 4'd2,
				 read = 4'd3,
				 finish_read = 4'd4, 
				 done = 4'd5;
	assign LEDG = ST;
	assign LEDR = {2'b11,mDATAOUT};
				 
	always@(posedge mCLK or negedge RESET_N)
	begin
		if(!RESET_N)
		begin
			rWR		<=	0;
			rRD		<=	0;
			rADDR	<=	0;
			ST <= write;
		end
		else
		begin
			case(ST)
				write: begin
					rADDR	<=	0;
					rDATAIN <= 16'hdead;
					rWR		<=	1;
					rRD		<=	0;
					ST <= finish_write;
				end
				
				finish_write: begin
					if (mDONE) begin
						rADDR <= 0;
						rWR <= 0;
						rRD <= 0;
						ST <= read;
					end
				end
				
				read: begin
					rADDR	<=	0;
					rWR		<=	0;
					rRD		<=	1;
					ST <= finish_read;
				end
				
				finish_read: begin
					if (mDONE) begin
						ST <= done;
						rDATAOUT <= mDATAOUT;
					end
				end
				
				done: ST <= done;
			endcase
		end
	end
endmodule
