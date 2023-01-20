//-----------------------------------------------------------------------------------------------------------
//    Copyright (C) 2022 by Hanoi University of Science and Technology
//    All right reserved.
//
//    Copyright Notification
//    No part may be reproduced except as authorized by written permission.
//
//    Module: warm_up.v
//    Author: Nguyen Thanh Trung
//    Date: 11:20:49 12/28/22
//-----------------------------------------------------------------------------------------------------------
module warm_up (
  input       warm_en   ,
  output wire warm_up_on
);

assign warm_up_on = warm_en;

endmodule