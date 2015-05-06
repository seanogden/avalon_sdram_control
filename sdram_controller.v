//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


//Legal Notice: (C)2015 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module bridge_0_avalon_master_arbitrator (
                                           // inputs:
                                            bridge_0_avalon_master_address,
                                            bridge_0_avalon_master_byteenable,
                                            bridge_0_avalon_master_read,
                                            bridge_0_avalon_master_write,
                                            bridge_0_avalon_master_writedata,
                                            bridge_0_granted_sdram_0_s1,
                                            bridge_0_qualified_request_sdram_0_s1,
                                            bridge_0_read_data_valid_sdram_0_s1,
                                            bridge_0_read_data_valid_sdram_0_s1_shift_register,
                                            bridge_0_requests_sdram_0_s1,
                                            clk,
                                            d1_sdram_0_s1_end_xfer,
                                            reset_n,
                                            sdram_0_s1_readdata_from_sa,
                                            sdram_0_s1_waitrequest_from_sa,

                                           // outputs:
                                            bridge_0_avalon_master_address_to_slave,
                                            bridge_0_avalon_master_readdata,
                                            bridge_0_avalon_master_waitrequest
                                         )
;

  output  [ 30: 0] bridge_0_avalon_master_address_to_slave;
  output  [ 15: 0] bridge_0_avalon_master_readdata;
  output           bridge_0_avalon_master_waitrequest;
  input   [ 30: 0] bridge_0_avalon_master_address;
  input   [  1: 0] bridge_0_avalon_master_byteenable;
  input            bridge_0_avalon_master_read;
  input            bridge_0_avalon_master_write;
  input   [ 15: 0] bridge_0_avalon_master_writedata;
  input            bridge_0_granted_sdram_0_s1;
  input            bridge_0_qualified_request_sdram_0_s1;
  input            bridge_0_read_data_valid_sdram_0_s1;
  input            bridge_0_read_data_valid_sdram_0_s1_shift_register;
  input            bridge_0_requests_sdram_0_s1;
  input            clk;
  input            d1_sdram_0_s1_end_xfer;
  input            reset_n;
  input   [ 31: 0] sdram_0_s1_readdata_from_sa;
  input            sdram_0_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  reg     [ 30: 0] bridge_0_avalon_master_address_last_time;
  wire    [ 30: 0] bridge_0_avalon_master_address_to_slave;
  reg     [  1: 0] bridge_0_avalon_master_byteenable_last_time;
  reg              bridge_0_avalon_master_read_last_time;
  wire    [ 15: 0] bridge_0_avalon_master_readdata;
  wire             bridge_0_avalon_master_run;
  wire             bridge_0_avalon_master_waitrequest;
  reg              bridge_0_avalon_master_write_last_time;
  reg     [ 15: 0] bridge_0_avalon_master_writedata_last_time;
  wire             r_0;
  wire    [ 15: 0] sdram_0_s1_readdata_from_sa_part_selected_by_negative_dbs;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (bridge_0_qualified_request_sdram_0_s1 | bridge_0_read_data_valid_sdram_0_s1 | ~bridge_0_requests_sdram_0_s1) & ((~bridge_0_qualified_request_sdram_0_s1 | ~bridge_0_avalon_master_read | (bridge_0_read_data_valid_sdram_0_s1 & bridge_0_avalon_master_read))) & ((~bridge_0_qualified_request_sdram_0_s1 | ~(bridge_0_avalon_master_read | bridge_0_avalon_master_write) | (1 & ~sdram_0_s1_waitrequest_from_sa & (bridge_0_avalon_master_read | bridge_0_avalon_master_write))));

  //cascaded wait assignment, which is an e_assign
  assign bridge_0_avalon_master_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign bridge_0_avalon_master_address_to_slave = {7'b0,
    bridge_0_avalon_master_address[23 : 0]};

  //Negative Dynamic Bus-sizing mux.
  //this mux selects the correct half of the 
  //wide data coming from the slave sdram_0/s1 
  assign sdram_0_s1_readdata_from_sa_part_selected_by_negative_dbs = ((bridge_0_avalon_master_address_to_slave[1] == 0))? sdram_0_s1_readdata_from_sa[15 : 0] :
    sdram_0_s1_readdata_from_sa[31 : 16];

  //bridge_0/avalon_master readdata mux, which is an e_mux
  assign bridge_0_avalon_master_readdata = sdram_0_s1_readdata_from_sa_part_selected_by_negative_dbs;

  //actual waitrequest port, which is an e_assign
  assign bridge_0_avalon_master_waitrequest = ~bridge_0_avalon_master_run;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //bridge_0_avalon_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_address_last_time <= 0;
      else 
        bridge_0_avalon_master_address_last_time <= bridge_0_avalon_master_address;
    end


  //bridge_0/avalon_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= bridge_0_avalon_master_waitrequest & (bridge_0_avalon_master_read | bridge_0_avalon_master_write);
    end


  //bridge_0_avalon_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_address != bridge_0_avalon_master_address_last_time))
        begin
          $write("%0d ns: bridge_0_avalon_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //bridge_0_avalon_master_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_byteenable_last_time <= 0;
      else 
        bridge_0_avalon_master_byteenable_last_time <= bridge_0_avalon_master_byteenable;
    end


  //bridge_0_avalon_master_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_byteenable != bridge_0_avalon_master_byteenable_last_time))
        begin
          $write("%0d ns: bridge_0_avalon_master_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //bridge_0_avalon_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_read_last_time <= 0;
      else 
        bridge_0_avalon_master_read_last_time <= bridge_0_avalon_master_read;
    end


  //bridge_0_avalon_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_read != bridge_0_avalon_master_read_last_time))
        begin
          $write("%0d ns: bridge_0_avalon_master_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //bridge_0_avalon_master_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_write_last_time <= 0;
      else 
        bridge_0_avalon_master_write_last_time <= bridge_0_avalon_master_write;
    end


  //bridge_0_avalon_master_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_write != bridge_0_avalon_master_write_last_time))
        begin
          $write("%0d ns: bridge_0_avalon_master_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //bridge_0_avalon_master_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          bridge_0_avalon_master_writedata_last_time <= 0;
      else 
        bridge_0_avalon_master_writedata_last_time <= bridge_0_avalon_master_writedata;
    end


  //bridge_0_avalon_master_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (bridge_0_avalon_master_writedata != bridge_0_avalon_master_writedata_last_time) & bridge_0_avalon_master_write)
        begin
          $write("%0d ns: bridge_0_avalon_master_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_bridge_0_avalon_master_to_sdram_0_s1_module (
                                                                  // inputs:
                                                                   clear_fifo,
                                                                   clk,
                                                                   data_in,
                                                                   read,
                                                                   reset_n,
                                                                   sync_reset,
                                                                   write,

                                                                  // outputs:
                                                                   data_out,
                                                                   empty,
                                                                   fifo_contains_ones_n,
                                                                   full
                                                                )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  reg              full_6;
  wire             full_7;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  wire             p6_full_6;
  wire             p6_stage_6;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  reg              stage_6;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_6;
  assign empty = !full_0;
  assign full_7 = 0;
  //data_6, which is an e_mux
  assign p6_stage_6 = ((full_7 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_6 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_6))
          if (sync_reset & full_6 & !((full_7 == 0) & read & write))
              stage_6 <= 0;
          else 
            stage_6 <= p6_stage_6;
    end


  //control_6, which is an e_mux
  assign p6_full_6 = ((read & !write) == 0)? full_5 :
    0;

  //control_reg_6, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_6 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_6 <= 0;
          else 
            full_6 <= p6_full_6;
    end


  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    stage_6;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    full_6;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_0_s1_arbitrator (
                               // inputs:
                                bridge_0_avalon_master_address_to_slave,
                                bridge_0_avalon_master_byteenable,
                                bridge_0_avalon_master_read,
                                bridge_0_avalon_master_write,
                                bridge_0_avalon_master_writedata,
                                clk,
                                reset_n,
                                sdram_0_s1_readdata,
                                sdram_0_s1_readdatavalid,
                                sdram_0_s1_waitrequest,

                               // outputs:
                                bridge_0_granted_sdram_0_s1,
                                bridge_0_qualified_request_sdram_0_s1,
                                bridge_0_read_data_valid_sdram_0_s1,
                                bridge_0_read_data_valid_sdram_0_s1_shift_register,
                                bridge_0_requests_sdram_0_s1,
                                d1_sdram_0_s1_end_xfer,
                                sdram_0_s1_address,
                                sdram_0_s1_byteenable_n,
                                sdram_0_s1_chipselect,
                                sdram_0_s1_read_n,
                                sdram_0_s1_readdata_from_sa,
                                sdram_0_s1_reset_n,
                                sdram_0_s1_waitrequest_from_sa,
                                sdram_0_s1_write_n,
                                sdram_0_s1_writedata
                             )
;

  output           bridge_0_granted_sdram_0_s1;
  output           bridge_0_qualified_request_sdram_0_s1;
  output           bridge_0_read_data_valid_sdram_0_s1;
  output           bridge_0_read_data_valid_sdram_0_s1_shift_register;
  output           bridge_0_requests_sdram_0_s1;
  output           d1_sdram_0_s1_end_xfer;
  output  [ 21: 0] sdram_0_s1_address;
  output  [  3: 0] sdram_0_s1_byteenable_n;
  output           sdram_0_s1_chipselect;
  output           sdram_0_s1_read_n;
  output  [ 31: 0] sdram_0_s1_readdata_from_sa;
  output           sdram_0_s1_reset_n;
  output           sdram_0_s1_waitrequest_from_sa;
  output           sdram_0_s1_write_n;
  output  [ 31: 0] sdram_0_s1_writedata;
  input   [ 30: 0] bridge_0_avalon_master_address_to_slave;
  input   [  1: 0] bridge_0_avalon_master_byteenable;
  input            bridge_0_avalon_master_read;
  input            bridge_0_avalon_master_write;
  input   [ 15: 0] bridge_0_avalon_master_writedata;
  input            clk;
  input            reset_n;
  input   [ 31: 0] sdram_0_s1_readdata;
  input            sdram_0_s1_readdatavalid;
  input            sdram_0_s1_waitrequest;

  wire             bridge_0_avalon_master_arbiterlock;
  wire             bridge_0_avalon_master_arbiterlock2;
  wire             bridge_0_avalon_master_continuerequest;
  wire    [ 31: 0] bridge_0_avalon_master_writedata_replicated;
  wire    [  3: 0] bridge_0_byteenable_sdram_0_s1;
  wire             bridge_0_granted_sdram_0_s1;
  wire             bridge_0_qualified_request_sdram_0_s1;
  wire             bridge_0_rdv_fifo_empty_sdram_0_s1;
  wire             bridge_0_rdv_fifo_output_from_sdram_0_s1;
  wire             bridge_0_read_data_valid_sdram_0_s1;
  wire             bridge_0_read_data_valid_sdram_0_s1_shift_register;
  wire             bridge_0_requests_sdram_0_s1;
  wire             bridge_0_saved_grant_sdram_0_s1;
  reg              d1_reasons_to_wait;
  reg              d1_sdram_0_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sdram_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 21: 0] sdram_0_s1_address;
  wire             sdram_0_s1_allgrants;
  wire             sdram_0_s1_allow_new_arb_cycle;
  wire             sdram_0_s1_any_bursting_master_saved_grant;
  wire             sdram_0_s1_any_continuerequest;
  wire             sdram_0_s1_arb_counter_enable;
  reg              sdram_0_s1_arb_share_counter;
  wire             sdram_0_s1_arb_share_counter_next_value;
  wire             sdram_0_s1_arb_share_set_values;
  wire             sdram_0_s1_beginbursttransfer_internal;
  wire             sdram_0_s1_begins_xfer;
  wire    [  3: 0] sdram_0_s1_byteenable_n;
  wire             sdram_0_s1_chipselect;
  wire             sdram_0_s1_end_xfer;
  wire             sdram_0_s1_firsttransfer;
  wire             sdram_0_s1_grant_vector;
  wire             sdram_0_s1_in_a_read_cycle;
  wire             sdram_0_s1_in_a_write_cycle;
  wire             sdram_0_s1_master_qreq_vector;
  wire             sdram_0_s1_move_on_to_next_transaction;
  wire             sdram_0_s1_non_bursting_master_requests;
  wire             sdram_0_s1_read_n;
  wire    [ 31: 0] sdram_0_s1_readdata_from_sa;
  wire             sdram_0_s1_readdatavalid_from_sa;
  reg              sdram_0_s1_reg_firsttransfer;
  wire             sdram_0_s1_reset_n;
  reg              sdram_0_s1_slavearbiterlockenable;
  wire             sdram_0_s1_slavearbiterlockenable2;
  wire             sdram_0_s1_unreg_firsttransfer;
  wire             sdram_0_s1_waitrequest_from_sa;
  wire             sdram_0_s1_waits_for_read;
  wire             sdram_0_s1_waits_for_write;
  wire             sdram_0_s1_write_n;
  wire    [ 31: 0] sdram_0_s1_writedata;
  wire    [ 30: 0] shifted_address_to_sdram_0_s1_from_bridge_0_avalon_master;
  wire             wait_for_sdram_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sdram_0_s1_end_xfer;
    end


  assign sdram_0_s1_begins_xfer = ~d1_reasons_to_wait & ((bridge_0_qualified_request_sdram_0_s1));
  //assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_readdata_from_sa = sdram_0_s1_readdata;

  assign bridge_0_requests_sdram_0_s1 = ({bridge_0_avalon_master_address_to_slave[30 : 24] , 24'b0} == 31'h0) & (bridge_0_avalon_master_read | bridge_0_avalon_master_write);
  //assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_waitrequest_from_sa = sdram_0_s1_waitrequest;

  //assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_0_s1_readdatavalid_from_sa = sdram_0_s1_readdatavalid;

  //sdram_0_s1_arb_share_counter set values, which is an e_mux
  assign sdram_0_s1_arb_share_set_values = 1;

  //sdram_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign sdram_0_s1_non_bursting_master_requests = bridge_0_requests_sdram_0_s1;

  //sdram_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sdram_0_s1_any_bursting_master_saved_grant = 0;

  //sdram_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sdram_0_s1_arb_share_counter_next_value = sdram_0_s1_firsttransfer ? (sdram_0_s1_arb_share_set_values - 1) : |sdram_0_s1_arb_share_counter ? (sdram_0_s1_arb_share_counter - 1) : 0;

  //sdram_0_s1_allgrants all slave grants, which is an e_mux
  assign sdram_0_s1_allgrants = |sdram_0_s1_grant_vector;

  //sdram_0_s1_end_xfer assignment, which is an e_assign
  assign sdram_0_s1_end_xfer = ~(sdram_0_s1_waits_for_read | sdram_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sdram_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sdram_0_s1 = sdram_0_s1_end_xfer & (~sdram_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sdram_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sdram_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sdram_0_s1 & sdram_0_s1_allgrants) | (end_xfer_arb_share_counter_term_sdram_0_s1 & ~sdram_0_s1_non_bursting_master_requests);

  //sdram_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_arb_share_counter <= 0;
      else if (sdram_0_s1_arb_counter_enable)
          sdram_0_s1_arb_share_counter <= sdram_0_s1_arb_share_counter_next_value;
    end


  //sdram_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_slavearbiterlockenable <= 0;
      else if ((|sdram_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sdram_0_s1) | (end_xfer_arb_share_counter_term_sdram_0_s1 & ~sdram_0_s1_non_bursting_master_requests))
          sdram_0_s1_slavearbiterlockenable <= |sdram_0_s1_arb_share_counter_next_value;
    end


  //bridge_0/avalon_master sdram_0/s1 arbiterlock, which is an e_assign
  assign bridge_0_avalon_master_arbiterlock = sdram_0_s1_slavearbiterlockenable & bridge_0_avalon_master_continuerequest;

  //sdram_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sdram_0_s1_slavearbiterlockenable2 = |sdram_0_s1_arb_share_counter_next_value;

  //bridge_0/avalon_master sdram_0/s1 arbiterlock2, which is an e_assign
  assign bridge_0_avalon_master_arbiterlock2 = sdram_0_s1_slavearbiterlockenable2 & bridge_0_avalon_master_continuerequest;

  //sdram_0_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sdram_0_s1_any_continuerequest = 1;

  //bridge_0_avalon_master_continuerequest continued request, which is an e_assign
  assign bridge_0_avalon_master_continuerequest = 1;

  assign bridge_0_qualified_request_sdram_0_s1 = bridge_0_requests_sdram_0_s1 & ~((bridge_0_avalon_master_read & ((|bridge_0_read_data_valid_sdram_0_s1_shift_register))));
  //unique name for sdram_0_s1_move_on_to_next_transaction, which is an e_assign
  assign sdram_0_s1_move_on_to_next_transaction = sdram_0_s1_readdatavalid_from_sa;

  //rdv_fifo_for_bridge_0_avalon_master_to_sdram_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_bridge_0_avalon_master_to_sdram_0_s1_module rdv_fifo_for_bridge_0_avalon_master_to_sdram_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (bridge_0_granted_sdram_0_s1),
      .data_out             (bridge_0_rdv_fifo_output_from_sdram_0_s1),
      .empty                (),
      .fifo_contains_ones_n (bridge_0_rdv_fifo_empty_sdram_0_s1),
      .full                 (),
      .read                 (sdram_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_0_s1_waits_for_read)
    );

  assign bridge_0_read_data_valid_sdram_0_s1_shift_register = ~bridge_0_rdv_fifo_empty_sdram_0_s1;
  //local readdatavalid bridge_0_read_data_valid_sdram_0_s1, which is an e_mux
  assign bridge_0_read_data_valid_sdram_0_s1 = sdram_0_s1_readdatavalid_from_sa;

  //replicate narrow data for wide slave
  assign bridge_0_avalon_master_writedata_replicated = {bridge_0_avalon_master_writedata,
    bridge_0_avalon_master_writedata};

  //sdram_0_s1_writedata mux, which is an e_mux
  assign sdram_0_s1_writedata = bridge_0_avalon_master_writedata_replicated;

  //master is always granted when requested
  assign bridge_0_granted_sdram_0_s1 = bridge_0_qualified_request_sdram_0_s1;

  //bridge_0/avalon_master saved-grant sdram_0/s1, which is an e_assign
  assign bridge_0_saved_grant_sdram_0_s1 = bridge_0_requests_sdram_0_s1;

  //allow new arb cycle for sdram_0/s1, which is an e_assign
  assign sdram_0_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sdram_0_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sdram_0_s1_master_qreq_vector = 1;

  //sdram_0_s1_reset_n assignment, which is an e_assign
  assign sdram_0_s1_reset_n = reset_n;

  assign sdram_0_s1_chipselect = bridge_0_granted_sdram_0_s1;
  //sdram_0_s1_firsttransfer first transaction, which is an e_assign
  assign sdram_0_s1_firsttransfer = sdram_0_s1_begins_xfer ? sdram_0_s1_unreg_firsttransfer : sdram_0_s1_reg_firsttransfer;

  //sdram_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sdram_0_s1_unreg_firsttransfer = ~(sdram_0_s1_slavearbiterlockenable & sdram_0_s1_any_continuerequest);

  //sdram_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_0_s1_reg_firsttransfer <= 1'b1;
      else if (sdram_0_s1_begins_xfer)
          sdram_0_s1_reg_firsttransfer <= sdram_0_s1_unreg_firsttransfer;
    end


  //sdram_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sdram_0_s1_beginbursttransfer_internal = sdram_0_s1_begins_xfer;

  //~sdram_0_s1_read_n assignment, which is an e_mux
  assign sdram_0_s1_read_n = ~(bridge_0_granted_sdram_0_s1 & bridge_0_avalon_master_read);

  //~sdram_0_s1_write_n assignment, which is an e_mux
  assign sdram_0_s1_write_n = ~(bridge_0_granted_sdram_0_s1 & bridge_0_avalon_master_write);

  assign shifted_address_to_sdram_0_s1_from_bridge_0_avalon_master = bridge_0_avalon_master_address_to_slave;
  //sdram_0_s1_address mux, which is an e_mux
  assign sdram_0_s1_address = shifted_address_to_sdram_0_s1_from_bridge_0_avalon_master >> 2;

  //d1_sdram_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sdram_0_s1_end_xfer <= 1;
      else 
        d1_sdram_0_s1_end_xfer <= sdram_0_s1_end_xfer;
    end


  //sdram_0_s1_waits_for_read in a cycle, which is an e_mux
  assign sdram_0_s1_waits_for_read = sdram_0_s1_in_a_read_cycle & sdram_0_s1_waitrequest_from_sa;

  //sdram_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign sdram_0_s1_in_a_read_cycle = bridge_0_granted_sdram_0_s1 & bridge_0_avalon_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sdram_0_s1_in_a_read_cycle;

  //sdram_0_s1_waits_for_write in a cycle, which is an e_mux
  assign sdram_0_s1_waits_for_write = sdram_0_s1_in_a_write_cycle & sdram_0_s1_waitrequest_from_sa;

  //sdram_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign sdram_0_s1_in_a_write_cycle = bridge_0_granted_sdram_0_s1 & bridge_0_avalon_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sdram_0_s1_in_a_write_cycle;

  assign wait_for_sdram_0_s1_counter = 0;
  //~sdram_0_s1_byteenable_n byte enable port mux, which is an e_mux
  assign sdram_0_s1_byteenable_n = ~((bridge_0_granted_sdram_0_s1)? bridge_0_byteenable_sdram_0_s1 :
    -1);

  //byte_enable_mux for bridge_0/avalon_master and sdram_0/s1, which is an e_mux
  assign bridge_0_byteenable_sdram_0_s1 = (bridge_0_avalon_master_address_to_slave[1] == 0)? bridge_0_avalon_master_byteenable :
    {bridge_0_avalon_master_byteenable, {2'b0}};


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sdram_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_controller_reset_clk_0_domain_synch_module (
                                                          // inputs:
                                                           clk,
                                                           data_in,
                                                           reset_n,

                                                          // outputs:
                                                           data_out
                                                        )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_controller (
                          // 1) global signals:
                           clk_0,
                           reset_n,

                          // the_bridge_0
                           acknowledge_from_the_bridge_0,
                           address_to_the_bridge_0,
                           byte_enable_to_the_bridge_0,
                           read_data_from_the_bridge_0,
                           read_to_the_bridge_0,
                           write_data_to_the_bridge_0,
                           write_to_the_bridge_0,

                          // the_sdram_0
                           zs_addr_from_the_sdram_0,
                           zs_ba_from_the_sdram_0,
                           zs_cas_n_from_the_sdram_0,
                           zs_cke_from_the_sdram_0,
                           zs_cs_n_from_the_sdram_0,
                           zs_dq_to_and_from_the_sdram_0,
                           zs_dqm_from_the_sdram_0,
                           zs_ras_n_from_the_sdram_0,
                           zs_we_n_from_the_sdram_0
                        )
;

  output           acknowledge_from_the_bridge_0;
  output  [ 15: 0] read_data_from_the_bridge_0;
  output  [ 11: 0] zs_addr_from_the_sdram_0;
  output  [  1: 0] zs_ba_from_the_sdram_0;
  output           zs_cas_n_from_the_sdram_0;
  output           zs_cke_from_the_sdram_0;
  output           zs_cs_n_from_the_sdram_0;
  inout   [ 31: 0] zs_dq_to_and_from_the_sdram_0;
  output  [  3: 0] zs_dqm_from_the_sdram_0;
  output           zs_ras_n_from_the_sdram_0;
  output           zs_we_n_from_the_sdram_0;
  input   [ 30: 0] address_to_the_bridge_0;
  input   [  1: 0] byte_enable_to_the_bridge_0;
  input            clk_0;
  input            read_to_the_bridge_0;
  input            reset_n;
  input   [ 15: 0] write_data_to_the_bridge_0;
  input            write_to_the_bridge_0;

  wire             acknowledge_from_the_bridge_0;
  wire    [ 30: 0] bridge_0_avalon_master_address;
  wire    [ 30: 0] bridge_0_avalon_master_address_to_slave;
  wire    [  1: 0] bridge_0_avalon_master_byteenable;
  wire             bridge_0_avalon_master_read;
  wire    [ 15: 0] bridge_0_avalon_master_readdata;
  wire             bridge_0_avalon_master_waitrequest;
  wire             bridge_0_avalon_master_write;
  wire    [ 15: 0] bridge_0_avalon_master_writedata;
  wire             bridge_0_granted_sdram_0_s1;
  wire             bridge_0_qualified_request_sdram_0_s1;
  wire             bridge_0_read_data_valid_sdram_0_s1;
  wire             bridge_0_read_data_valid_sdram_0_s1_shift_register;
  wire             bridge_0_requests_sdram_0_s1;
  wire             clk_0_reset_n;
  wire             d1_sdram_0_s1_end_xfer;
  wire    [ 15: 0] read_data_from_the_bridge_0;
  wire             reset_n_sources;
  wire    [ 21: 0] sdram_0_s1_address;
  wire    [  3: 0] sdram_0_s1_byteenable_n;
  wire             sdram_0_s1_chipselect;
  wire             sdram_0_s1_read_n;
  wire    [ 31: 0] sdram_0_s1_readdata;
  wire    [ 31: 0] sdram_0_s1_readdata_from_sa;
  wire             sdram_0_s1_readdatavalid;
  wire             sdram_0_s1_reset_n;
  wire             sdram_0_s1_waitrequest;
  wire             sdram_0_s1_waitrequest_from_sa;
  wire             sdram_0_s1_write_n;
  wire    [ 31: 0] sdram_0_s1_writedata;
  wire    [ 11: 0] zs_addr_from_the_sdram_0;
  wire    [  1: 0] zs_ba_from_the_sdram_0;
  wire             zs_cas_n_from_the_sdram_0;
  wire             zs_cke_from_the_sdram_0;
  wire             zs_cs_n_from_the_sdram_0;
  wire    [ 31: 0] zs_dq_to_and_from_the_sdram_0;
  wire    [  3: 0] zs_dqm_from_the_sdram_0;
  wire             zs_ras_n_from_the_sdram_0;
  wire             zs_we_n_from_the_sdram_0;
  bridge_0_avalon_master_arbitrator the_bridge_0_avalon_master
    (
      .bridge_0_avalon_master_address                     (bridge_0_avalon_master_address),
      .bridge_0_avalon_master_address_to_slave            (bridge_0_avalon_master_address_to_slave),
      .bridge_0_avalon_master_byteenable                  (bridge_0_avalon_master_byteenable),
      .bridge_0_avalon_master_read                        (bridge_0_avalon_master_read),
      .bridge_0_avalon_master_readdata                    (bridge_0_avalon_master_readdata),
      .bridge_0_avalon_master_waitrequest                 (bridge_0_avalon_master_waitrequest),
      .bridge_0_avalon_master_write                       (bridge_0_avalon_master_write),
      .bridge_0_avalon_master_writedata                   (bridge_0_avalon_master_writedata),
      .bridge_0_granted_sdram_0_s1                        (bridge_0_granted_sdram_0_s1),
      .bridge_0_qualified_request_sdram_0_s1              (bridge_0_qualified_request_sdram_0_s1),
      .bridge_0_read_data_valid_sdram_0_s1                (bridge_0_read_data_valid_sdram_0_s1),
      .bridge_0_read_data_valid_sdram_0_s1_shift_register (bridge_0_read_data_valid_sdram_0_s1_shift_register),
      .bridge_0_requests_sdram_0_s1                       (bridge_0_requests_sdram_0_s1),
      .clk                                                (clk_0),
      .d1_sdram_0_s1_end_xfer                             (d1_sdram_0_s1_end_xfer),
      .reset_n                                            (clk_0_reset_n),
      .sdram_0_s1_readdata_from_sa                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_waitrequest_from_sa                     (sdram_0_s1_waitrequest_from_sa)
    );

  bridge_0 the_bridge_0
    (
      .acknowledge        (acknowledge_from_the_bridge_0),
      .address            (address_to_the_bridge_0),
      .avalon_address     (bridge_0_avalon_master_address),
      .avalon_byteenable  (bridge_0_avalon_master_byteenable),
      .avalon_read        (bridge_0_avalon_master_read),
      .avalon_readdata    (bridge_0_avalon_master_readdata),
      .avalon_waitrequest (bridge_0_avalon_master_waitrequest),
      .avalon_write       (bridge_0_avalon_master_write),
      .avalon_writedata   (bridge_0_avalon_master_writedata),
      .byte_enable        (byte_enable_to_the_bridge_0),
      .clk                (clk_0),
      .read               (read_to_the_bridge_0),
      .read_data          (read_data_from_the_bridge_0),
      .write              (write_to_the_bridge_0),
      .write_data         (write_data_to_the_bridge_0)
    );

  sdram_0_s1_arbitrator the_sdram_0_s1
    (
      .bridge_0_avalon_master_address_to_slave            (bridge_0_avalon_master_address_to_slave),
      .bridge_0_avalon_master_byteenable                  (bridge_0_avalon_master_byteenable),
      .bridge_0_avalon_master_read                        (bridge_0_avalon_master_read),
      .bridge_0_avalon_master_write                       (bridge_0_avalon_master_write),
      .bridge_0_avalon_master_writedata                   (bridge_0_avalon_master_writedata),
      .bridge_0_granted_sdram_0_s1                        (bridge_0_granted_sdram_0_s1),
      .bridge_0_qualified_request_sdram_0_s1              (bridge_0_qualified_request_sdram_0_s1),
      .bridge_0_read_data_valid_sdram_0_s1                (bridge_0_read_data_valid_sdram_0_s1),
      .bridge_0_read_data_valid_sdram_0_s1_shift_register (bridge_0_read_data_valid_sdram_0_s1_shift_register),
      .bridge_0_requests_sdram_0_s1                       (bridge_0_requests_sdram_0_s1),
      .clk                                                (clk_0),
      .d1_sdram_0_s1_end_xfer                             (d1_sdram_0_s1_end_xfer),
      .reset_n                                            (clk_0_reset_n),
      .sdram_0_s1_address                                 (sdram_0_s1_address),
      .sdram_0_s1_byteenable_n                            (sdram_0_s1_byteenable_n),
      .sdram_0_s1_chipselect                              (sdram_0_s1_chipselect),
      .sdram_0_s1_read_n                                  (sdram_0_s1_read_n),
      .sdram_0_s1_readdata                                (sdram_0_s1_readdata),
      .sdram_0_s1_readdata_from_sa                        (sdram_0_s1_readdata_from_sa),
      .sdram_0_s1_readdatavalid                           (sdram_0_s1_readdatavalid),
      .sdram_0_s1_reset_n                                 (sdram_0_s1_reset_n),
      .sdram_0_s1_waitrequest                             (sdram_0_s1_waitrequest),
      .sdram_0_s1_waitrequest_from_sa                     (sdram_0_s1_waitrequest_from_sa),
      .sdram_0_s1_write_n                                 (sdram_0_s1_write_n),
      .sdram_0_s1_writedata                               (sdram_0_s1_writedata)
    );

  sdram_0 the_sdram_0
    (
      .az_addr        (sdram_0_s1_address),
      .az_be_n        (sdram_0_s1_byteenable_n),
      .az_cs          (sdram_0_s1_chipselect),
      .az_data        (sdram_0_s1_writedata),
      .az_rd_n        (sdram_0_s1_read_n),
      .az_wr_n        (sdram_0_s1_write_n),
      .clk            (clk_0),
      .reset_n        (sdram_0_s1_reset_n),
      .za_data        (sdram_0_s1_readdata),
      .za_valid       (sdram_0_s1_readdatavalid),
      .za_waitrequest (sdram_0_s1_waitrequest),
      .zs_addr        (zs_addr_from_the_sdram_0),
      .zs_ba          (zs_ba_from_the_sdram_0),
      .zs_cas_n       (zs_cas_n_from_the_sdram_0),
      .zs_cke         (zs_cke_from_the_sdram_0),
      .zs_cs_n        (zs_cs_n_from_the_sdram_0),
      .zs_dq          (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm         (zs_dqm_from_the_sdram_0),
      .zs_ras_n       (zs_ras_n_from_the_sdram_0),
      .zs_we_n        (zs_we_n_from_the_sdram_0)
    );

  //reset is asserted asynchronously and deasserted synchronously
  sdram_controller_reset_clk_0_domain_synch_module sdram_controller_reset_clk_0_domain_synch
    (
      .clk      (clk_0),
      .data_in  (1'b1),
      .data_out (clk_0_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0);


endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

// `ifdef USE_convert_hex2ver
// `else
// `define NO_PLI 1
// `endif

`include "c:/altera/11.0/quartus/eda/sim_lib/altera_mf.v"
`include "c:/altera/11.0/quartus/eda/sim_lib/220model.v"
`include "c:/altera/11.0/quartus/eda/sim_lib/sgate.v"
`include "bridge_0.v"
`include "sdram_0.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire             acknowledge_from_the_bridge_0;
  wire    [ 30: 0] address_to_the_bridge_0;
  wire    [  1: 0] byte_enable_to_the_bridge_0;
  wire             clk;
  reg              clk_0;
  wire    [ 15: 0] read_data_from_the_bridge_0;
  wire             read_to_the_bridge_0;
  reg              reset_n;
  wire    [ 15: 0] write_data_to_the_bridge_0;
  wire             write_to_the_bridge_0;
  wire    [ 11: 0] zs_addr_from_the_sdram_0;
  wire    [  1: 0] zs_ba_from_the_sdram_0;
  wire             zs_cas_n_from_the_sdram_0;
  wire             zs_cke_from_the_sdram_0;
  wire             zs_cs_n_from_the_sdram_0;
  wire    [ 31: 0] zs_dq_to_and_from_the_sdram_0;
  wire    [  3: 0] zs_dqm_from_the_sdram_0;
  wire             zs_ras_n_from_the_sdram_0;
  wire             zs_we_n_from_the_sdram_0;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  sdram_controller DUT
    (
      .acknowledge_from_the_bridge_0 (acknowledge_from_the_bridge_0),
      .address_to_the_bridge_0       (address_to_the_bridge_0),
      .byte_enable_to_the_bridge_0   (byte_enable_to_the_bridge_0),
      .clk_0                         (clk_0),
      .read_data_from_the_bridge_0   (read_data_from_the_bridge_0),
      .read_to_the_bridge_0          (read_to_the_bridge_0),
      .reset_n                       (reset_n),
      .write_data_to_the_bridge_0    (write_data_to_the_bridge_0),
      .write_to_the_bridge_0         (write_to_the_bridge_0),
      .zs_addr_from_the_sdram_0      (zs_addr_from_the_sdram_0),
      .zs_ba_from_the_sdram_0        (zs_ba_from_the_sdram_0),
      .zs_cas_n_from_the_sdram_0     (zs_cas_n_from_the_sdram_0),
      .zs_cke_from_the_sdram_0       (zs_cke_from_the_sdram_0),
      .zs_cs_n_from_the_sdram_0      (zs_cs_n_from_the_sdram_0),
      .zs_dq_to_and_from_the_sdram_0 (zs_dq_to_and_from_the_sdram_0),
      .zs_dqm_from_the_sdram_0       (zs_dqm_from_the_sdram_0),
      .zs_ras_n_from_the_sdram_0     (zs_ras_n_from_the_sdram_0),
      .zs_we_n_from_the_sdram_0      (zs_we_n_from_the_sdram_0)
    );

  initial
    clk_0 = 1'b0;
  always
    #10 clk_0 <= ~clk_0;
  
  initial 
    begin
      reset_n <= 0;
      #200 reset_n <= 1;
    end

endmodule


//synthesis translate_on