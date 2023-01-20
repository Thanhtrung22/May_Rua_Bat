//-----------------------------------------------------------------------------------------------------------
//    Copyright (C) 2022 by Hanoi University of Science and Technology
//    All right reserved.
//
//    Copyright Notification
//    No part may be reproduced except as authorized by written permission.
//
//    Module: controller.v
//    Author: Pham Ngoc Lam, Nguyen Viet Thi, Nguyen Huy Nam
//    Date: 11:20:49 06/21/22
//-----------------------------------------------------------------------------------------------------------
module controller #(
  parameter COUNT_SPRAY   = 5,
  parameter COUNT_DRYING  = 5,
  parameter COUNT_DIS     = 5
  )  (
  input         clk               ,  // Clock 1MHz
  input         reset_n           ,  // Asynchronous reset active low
  input         reg_user_en       , 
  input         reg_toilet_using  , 
  input         reg_spray_en      , 
  input         reg_sp_dr_auto_en , 
  input         reg_spray_mode    , 
  input         reg_auto_dis_en   , 
  input         reg_de_ur         , 
  input         ce                , 
  output  reg   enable            , 
  output  reg   open_toilet_lid   , 
  output  reg   led_using         , 
  output  reg   spray_an          , 
  output  reg   user_flushes      , 
  output  reg   dis_de            , 
  output  reg   count_spray_done  , 
  output  reg   count_drying_done , 
  output  reg   count_dis_done    , 
  output  reg   stt_ready         , 
  output  reg   stt_using         , 
  output  reg   stt_spraying      , 
  output  reg   stt_drying        , 
  output  reg   stt_discharge       
);

// -------------------------------------------------------------
// Signal Declaration
// -------------------------------------------------------------
wire [COUNT_SPRAY  - 1 : 0] count_spray ;
wire [COUNT_DRYING - 1 : 0] count_drying;
wire [COUNT_DIS    - 1 : 0] count_dis   ;
reg         inc_count_spray     ;
reg         clr_count_spray     ;
reg         inc_count_drying    ;
reg         clr_count_drying    ;
reg         inc_count_dis       ;
reg         clr_count_dis       ;
reg         open_toilet_lid_cld ;
reg         spray_an_cld        ;
reg         user_flushes_cld    ;
reg         dis_de_cld          ;
reg         ready               ;
reg         using               ;

reg [2:0] current_state, next_state;

localparam  IDLE      = 3'b000, 
            USING     = 3'b001, 
            SPRAY     = 3'b010, 
            DRYING    = 3'b011, 
            DISCHARGE = 3'b100; 

// -------------------------------------------------------------
// FSM
// -------------------------------------------------------------
always @(posedge clk or negedge reset_n) begin : proc_state
  if(~reset_n) begin
    current_state <= IDLE;
  end else begin
    current_state <= next_state;
  end
end

// -------------------------------------------------------------
// FSM ouput signal
// -------------------------------------------------------------
always @(*) begin : proc_fsm_output
  enable              = 0;
  inc_count_spray     = 0;
  clr_count_spray     = 0;
  inc_count_drying    = 0;
  clr_count_drying    = 0;
  inc_count_dis       = 0;
  clr_count_dis       = 0;
  open_toilet_lid_cld = 0;
  spray_an_cld        = 0;
  user_flushes_cld    = 0;
  dis_de_cld          = 0;
  ready               = 0;
  using               = 0;
  case (current_state)
    IDLE: begin
      ready = 1;
      if (reg_user_en) begin
        open_toilet_lid_cld = 1;
        if (reg_toilet_using) begin
          next_state = USING;
        end else begin 
          next_state = IDLE;
        end
      end else begin 
        next_state = IDLE;
      end
    end

    USING: begin
      using = 1;
      if (reg_spray_en) begin
        if (reg_sp_dr_auto_en) begin
          next_state = SPRAY;
        end else begin
          next_state = DISCHARGE;
        end
      end else begin 
        next_state = USING;
      end
    end

    SPRAY: begin
      enable              = 1;
      inc_count_spray     = 1;
      if (count_spray == 5'd20) begin
        count_spray_done  = 1;
        clr_count_spray   = 1;
        enable            = 0;
        next_state        = DRYING;
      end else begin
        if (reg_spray_mode) begin
          spray_an_cld    = 1;
        end else begin
          spray_an_cld    = 0;
        end
        next_state        = SPRAY;
      end
    end

    DRYING: begin
      enable              = 1;
      inc_count_drying    = 1;
      if (count_drying == 5'd20) begin
        count_drying_done = 1;
        clr_count_drying  = 1;
        enable            = 0;
        next_state        = DISCHARGE;
      end else begin
        next_state        = DRYING;
      end
    end
    
    DISCHARGE: begin
      if (~reg_toilet_using) begin
        if (reg_auto_dis_en) begin
          enable          = 1;
          inc_count_dis   = 1;
          if (count_dis == 5'd3) begin
            count_dis_done= 1;
            clr_count_dis = 1;
            enable        = 0;
            next_state    = IDLE;
          end else begin
            if (reg_de_ur) begin
              dis_de_cld  = 0;
            end else begin 
              dis_de_cld  = 1;
            end
            next_state    = DISCHARGE;
          end
        end else begin
          user_flushes_cld= 1;
          next_state      = IDLE;
        end
      end
      else begin 
        next_state        = DISCHARGE;
      end
    end
    default : next_state  = IDLE;
  endcase
end

// -------------------------------------------------------------
// Counter
counter counter_spray (
  .clk    (clk            ),
  .reset_n(reset_n        ),
  .ce     (ce             ),
  .inc    (inc_count_spray),
  .clr    (clr_count_spray),
  .count  (count_spray    )
  );

counter counter_drying (
  .clk    (clk              ),
  .reset_n(reset_n          ),
  .ce     (ce               ),
  .inc    (inc_count_drying ),
  .clr    (clr_count_drying ),
  .count  (count_drying     )
  );

counter counte_dis (
  .clk    (clk              ),
  .reset_n(reset_n          ),
  .ce     (ce               ),
  .inc    (inc_count_dis    ),
  .clr    (clr_count_dis    ),
  .count  (count_dis        )
  );


// -------------------------------------------------------------
// Output
// -------------------------------------------------------------
always @(posedge clk or negedge reset_n) begin : proc_output
  if(~reset_n) begin
    open_toilet_lid   <= 0;
    led_using         <= 0;
    spray_an          <= 0;
    user_flushes      <= 0;
    dis_de            <= 0;
    count_spray_done  <= 0;
    count_drying_done <= 0;
    count_dis_done    <= 0;
    stt_ready         <= 0;
    stt_using         <= 0;
    stt_spraying      <= 0;
    stt_drying        <= 0;
  end
  else begin 
    if (open_toilet_lid_cld) begin
      open_toilet_lid <= 1;
    end else begin 
      open_toilet_lid <= 0;
    end

    if (using) begin
      stt_using <= 1;
      led_using <= 1;
    end else begin 
      stt_using <= 0;
      led_using <= 0;
    end

    if (spray_an_cld) begin
      spray_an <= 1;
    end else begin 
      spray_an <= 0;
    end

    if (inc_count_spray) begin
      stt_spraying <= 1;
    end else begin 
      stt_spraying <= 0;
    end

    if (inc_count_drying) begin
      stt_drying <= 1;
    end else begin 
      stt_drying <= 0;
    end

    if (inc_count_dis) begin
      stt_discharge <= 1;
    end else begin 
      stt_discharge <= 0;
    end

    if (user_flushes_cld) begin
      user_flushes <= 1;
    end else begin 
      user_flushes <= 0;
    end

    if (dis_de_cld) begin
      dis_de <= 1;
    end else begin 
      dis_de <= 0;
    end

    if (ready) begin
      stt_ready <= 1;
    end else begin 
      stt_ready <= 0;
    end

    if (using) begin
      stt_using <= 1;
    end else begin
      stt_using <= 0;
    end
  end
end

endmodule : controller