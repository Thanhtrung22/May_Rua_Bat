#!/usr/bin/perl

# Library
  use Cwd;
  use Time::Local;
  use strict;
  use Spreadsheet::Read;   # Read the data from a spreadsheet
  use OpenOffice::OODoc;
#  use Win32::Word::Writer; # Manupulate MS doc OLE based.

# Log file
  open (my $log_fh, ">rb_gen.log") || die "Can't open new file: $! rb_gen.log\n";

# Sub Main Function ----------------------------------------------------------
  sub main {
    my  $rb_sheet       = $_[0];
    my  @rb_sheet_array = @{getSheetInfo($rb_sheet)};
    
    print  "successful Register Validation!\n";
    
    rbRegisterGen(\@rb_sheet_array);
    rbApbBridgeGen();
    rbTopBlockGen(\@rb_sheet_array);
    rbRegStructGen(\@rb_sheet_array);
    rbDefMSDocGen(\@rb_sheet_array);
  }
  
# Main Function ----------------------------------------------------------
  main(@ARGV);

#------------------------------------------------------------------------#
# GetSheetInfo Function
#------------------------------------------------------------------------#
  # Function Description
  # Parameters:
  #   $_[0]: Parameter Description
  # Return:
  #   None
  sub getSheetInfo (@) {
    my $rb_sheet_file   = $_[0];
    my $rb_sheet_array  = ReadData ("$rb_sheet_file");
    
    my      @rb_def_array;
    undef   @rb_def_array;
    
    my %sheet_ctrl_hash = %{$rb_sheet_array->[0]};
    
    $rb_def_array[0]{'sheet_no'}        = $sheet_ctrl_hash{'sheets'};
    $rb_def_array[0]{'sheet_type'}      = $sheet_ctrl_hash{'type'};
    $rb_def_array[0]{'sheet_parser'}    = $sheet_ctrl_hash{'parser'};
    $rb_def_array[0]{'sheet_ver'}       = $sheet_ctrl_hash{'version'};
    
    my $sheet_index = 0;        # Index of sheets
    my $sheet_row   = 0;        # Index of rows in a sheet
    my $sheet_col   = 0;        # Index of columns in a sheet
    my $reg_no      = 0;        # Number of registers
    my $field_index = 0;        # Index of register's fields
    
    $sheet_index    = 1;
    $reg_no         = 0;
    $field_index    = 0;
    
    my $sheet_label = $rb_sheet_array->[$sheet_index]{'label'};
    $rb_def_array[$sheet_index]{'sheet_label'} = $sheet_label;
    
    for ($sheet_row = 2; $sheet_row <= $rb_sheet_array->[$sheet_index]{'maxrow'}; $sheet_row++) {
      
      # Col 2: Register Name
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[2][$sheet_row] ) {
        $reg_no++;
        $field_index = 0;
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_name'} = $rb_sheet_array->[$sheet_index]{'cell'}[2][$sheet_row];
      }
      
      # Col 3: Register Description
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[3][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_des'} = $rb_sheet_array->[$sheet_index]{'cell'}[3][$sheet_row];
      }
      
      # Col 4: Register Address(Hex)
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[4][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_addr'} = $rb_sheet_array->[$sheet_index]{'cell'}[4][$sheet_row];
      }
      
      # Col 5: Number of Instances
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[5][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'num_inst'} = $rb_sheet_array->[$sheet_index]{'cell'}[5][$sheet_row];
      }
      
      # Col 6: Suffix
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[6][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'suffix'} = $rb_sheet_array->[$sheet_index]{'cell'}[6][$sheet_row];
      }
      
      # Col 7: Register Width
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[7][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_width'} = $rb_sheet_array->[$sheet_index]{'cell'}[7][$sheet_row];
      }
      
      # Col 8: Reset Value
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[8][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'rst_value'} = $rb_sheet_array->[$sheet_index]{'cell'}[8][$sheet_row];
      }
      
      # Col 9: Register SW Access
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[9][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_access'} = $rb_sheet_array->[$sheet_index]{'cell'}[9][$sheet_row];
      }
      
      # Col 10: Register Field
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[10][$sheet_row] ) {
        $field_index++;
        
        # Field Name
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_name'}  = $rb_sheet_array->[$sheet_index]{'cell'}[10][$sheet_row];
        
        # Field Description
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_des'}   = $rb_sheet_array->[$sheet_index]{'cell'}[11][$sheet_row];
        
        # Field Offset
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_off'}   = $rb_sheet_array->[$sheet_index]{'cell'}[12][$sheet_row];
        
        # Field Width
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_width'} = $rb_sheet_array->[$sheet_index]{'cell'}[13][$sheet_row];
        
        # Field Reset Value
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_reset'} = $rb_sheet_array->[$sheet_index]{'cell'}[14][$sheet_row];
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_reset'} =~ s/\&apos;/'/g;
        
        # Field SW Access
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_swacc'} = $rb_sheet_array->[$sheet_index]{'cell'}[15][$sheet_row];
        
        # Field HW Access
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_hwacc'} = $rb_sheet_array->[$sheet_index]{'cell'}[16][$sheet_row];
        
        # Field I/O Type
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_io'}    = $rb_sheet_array->[$sheet_index]{'cell'}[17][$sheet_row];
        
        # Simulation Value
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'sim_value'}   = $rb_sheet_array->[$sheet_index]{'cell'}[18][$sheet_row];
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'sim_value'} =~ s/\&apos;/'/g;
        
        # Field Derivation
        $rb_def_array[$sheet_index]{'reg'}[$reg_no]{'reg_field'}[$field_index]{'field_deriv'}    = $rb_sheet_array->[$sheet_index]{'cell'}[19][$sheet_row];
      }
    }
    
    # User Command Description
    $sheet_index = 2;
    my $cmd_no      = 0;
    for ($sheet_row = 2; $sheet_row <= $rb_sheet_array->[$sheet_index]{'maxrow'}; $sheet_row++) {
      # Command
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[1][$sheet_row] ) {
        $cmd_no ++;
        $rb_def_array[$sheet_index]{'cmd'}[$cmd_no]{'cmd_name'} = $rb_sheet_array->[$sheet_index]{'cell'}[1][$sheet_row];
      }
      # Opcode
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[2][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'cmd'}[$cmd_no]{'cmd_op'} = $rb_sheet_array->[$sheet_index]{'cell'}[2][$sheet_row];
      }
      # Description
      if ( $rb_sheet_array->[$sheet_index]{'cell'}[3][$sheet_row] ) {
        $rb_def_array[$sheet_index]{'cmd'}[$cmd_no]{'cmd_des'} = $rb_sheet_array->[$sheet_index]{'cell'}[3][$sheet_row];
      }
    }
    
    return \@rb_def_array;
  }
  
#------------------------------------------------------------------------#
# rbRegisterGen Function
#------------------------------------------------------------------------#
  # Generate rb_regs.sv, Register Block Register File module
  # Parameters:
  #   $_[0]: Register Definition Array
  # Return:
  #   None
  
  sub rbRegisterGen (@) {
    my @reg_def_array    = @{$_[0]};
    
    my $rb_regs_filename = "..\/hdl\/rb_regs.sv";
    open (my $rb_regs_fh, ">$rb_regs_filename") || die "Can't open new file: $! $rb_regs_filename\n";
    
    # Header
    printHeader($rb_regs_fh, $rb_regs_filename, "Register File");
#    print $rb_regs_fh "\`include \"dti_global_defines.svh\"\n";
    # Module Declaration
    print $rb_regs_fh "module rb_regs ( \n";
    
    my @reg_array;   undef @reg_array;
    
    my $sheet_index     = 1;
    
    @reg_array = @{$reg_def_array[$sheet_index]{'reg'}};
    
    for ( my $reg_index = 1; $reg_index <= $#reg_array; $reg_index++ ){
      my @reg_field = @{$reg_array[$reg_index]{'reg_field'}};
      
      my $inst_no     = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        for ( my $field_index = 1; $field_index <= $#reg_field; $field_index++ ) {
          my $width           = $reg_field[$field_index]{'field_width'} - 1;
          my $reg_field_width = ($width > 0) ? "[$width:0]" : "";
          
          # New line in Description
          my $cmt_new_line   = "\n";
          my $cmt_apos       = "&apos;";
          my $description    = $reg_field[$field_index]{'field_des'};
          my $cmt_space      = " " x 61;
          $description    =~ s/$cmt_new_line/\n$cmt_space\/\/ /g;
          $description    =~ s/$cmt_apos/\'/g;
          my $signal_name = "";
          if ( $reg_index == $#reg_array ) {
            $signal_name = "$reg_field[$field_index]{'field_name'}"."$name_ext";
          }
          else {
            $signal_name = "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}";
          }
          if ( $reg_field[$field_index]{'field_hwacc'} =~ /WO/ ) {
            print $rb_regs_fh "  ","input";
            printSpace(8, $rb_regs_fh);
            print $rb_regs_fh "$reg_field_width";
            printSpace(9-length($reg_field_width), $rb_regs_fh);
            print $rb_regs_fh "$signal_name".",";
            printSpace(36-length($signal_name), $rb_regs_fh);
            print $rb_regs_fh "// ", "$description", "\n";
          }
          if ( $reg_field[$field_index]{'field_hwacc'} =~ /R(O|W)/ ) {
            if ($reg_array[$reg_index]{'reg_name'} =~ /NA/) {
              print $rb_regs_fh "  ","output wire  ";
            }
            else {
              print $rb_regs_fh "  ","output logic";
            }
            printSpace(1, $rb_regs_fh);
            print $rb_regs_fh "$reg_field_width";
            printSpace(9-length($reg_field_width), $rb_regs_fh);
            print $rb_regs_fh "$signal_name".",";
            printSpace(36-length($signal_name), $rb_regs_fh);
            print $rb_regs_fh "// ", "$description", "\n";
          }
        }
      }
    }
    
    # Global Signals
    print $rb_regs_fh "// Global Signals", "\n";
    print $rb_regs_fh "  ", "input";        printSpace(17, $rb_regs_fh);                                                                          print $rb_regs_fh "clk,";
    printSpace(36-length("clk"), $rb_regs_fh);
    print $rb_regs_fh "// ", "System Clock", "\n";
    print $rb_regs_fh "  ", "input";        printSpace(17, $rb_regs_fh);                                                                          print $rb_regs_fh "reset_n,";
    printSpace(36-length("reset_n"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Asynchronous Reset, Active LOW", "\n";
    
    # Read Write Control Signals
    print $rb_regs_fh "// Read Write Control Signals", "\n";
    print $rb_regs_fh "  ", "input";        printSpace( 8, $rb_regs_fh); print $rb_regs_fh "[7:0]"; printSpace(9-length("[7:0]"), $rb_regs_fh);   print $rb_regs_fh "waddr,";
    printSpace(36-length("waddr"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Write Address", "\n";
    print $rb_regs_fh "  ", "input";        printSpace( 8, $rb_regs_fh); print $rb_regs_fh "[7:0]"; printSpace(9-length("[7:0]"), $rb_regs_fh);   print $rb_regs_fh "raddr,";
    printSpace(36-length("raddr"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Read Address", "\n";
    print $rb_regs_fh "  ", "input";        printSpace( 8, $rb_regs_fh); print $rb_regs_fh "[31:0]"; printSpace(9-length("[31:0]"), $rb_regs_fh); print $rb_regs_fh "wdata,";
    printSpace(36-length("wdata"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Write Data", "\n";
    print $rb_regs_fh "  ", "output logic"; printSpace( 1, $rb_regs_fh); print $rb_regs_fh "[31:0]"; printSpace(9-length("[31:0]"), $rb_regs_fh); print $rb_regs_fh "rdata,";
    printSpace(36-length("rdata"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Read Data", "\n";
    print $rb_regs_fh "  ", "input";        printSpace(17, $rb_regs_fh);                                                                          print $rb_regs_fh "wstrobe,";
    printSpace(36-length("wstrobe"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Write Strobe", "\n";
    print $rb_regs_fh "  ", "input";        printSpace(17, $rb_regs_fh);                                                                          print $rb_regs_fh "rstrobe,";
    printSpace(36-length("rstrobe"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Read Strobe", "\n";
    print $rb_regs_fh "  ", "output logic"; printSpace(10, $rb_regs_fh);                                                                          print $rb_regs_fh "wack,";
    printSpace(36-length("wack"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Write ACK", "\n";
    print $rb_regs_fh "  ", "output logic"; printSpace(10, $rb_regs_fh);                                                                          print $rb_regs_fh "rack,";
    printSpace(36-length("rack"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Read ACK", "\n";
    print $rb_regs_fh "  ", "output logic"; printSpace(10, $rb_regs_fh);                                                                          print $rb_regs_fh "waddrerr,";
    printSpace(36-length("waddrerr"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Write Address Error", "\n";
    print $rb_regs_fh "  ", "output logic"; printSpace(10, $rb_regs_fh);                                                                          print $rb_regs_fh "raddrerr";
    printSpace(37-length("raddrerr"), $rb_regs_fh);
    print $rb_regs_fh "// ", "Read Address Error", "\n";
        
    print $rb_regs_fh ");\n";
    
    # Internal Signal
    print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
    print $rb_regs_fh "// Internal Signals\n";
    print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
    
    print $rb_regs_fh "// Enable Signals\n";
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      my $inst_no   = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        if ( $reg_array[$reg_index]{'reg_access'} =~ /RW/ ) {
          print $rb_regs_fh "  ", "wire ";   printSpace(17, $rb_regs_fh); print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_ren".";\n";
          print $rb_regs_fh "  ", "wire ";   printSpace(17, $rb_regs_fh); print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_wen".";\n";
        }
        if ( $reg_array[$reg_index]{'reg_access'} =~ /RO/ ) {
          print $rb_regs_fh "  ", "wire ";   printSpace(17, $rb_regs_fh); print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_ren".";\n";
        }
      }
    }
    
    print $rb_regs_fh "// Internal Registers\n";
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      my @reg_field   = @{$reg_array[$reg_index]{'reg_field'}};
      my $inst_no     = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        for ( my $field_index = 1; $field_index <= $#reg_field; $field_index++ ) {
          my $width           = $reg_field[$field_index]{'field_width'} - 1;
          my $reg_field_width = ($width > 0) ? "[$width:0]" : "";
          if ( $reg_field[$field_index]{'field_swacc'} =~ /RO/ ) {
            print $rb_regs_fh "  ", "logic";
            printSpace(8, $rb_regs_fh);
            print $rb_regs_fh "$reg_field_width";
            printSpace(9-length($reg_field_width), $rb_regs_fh);
            print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}"."_reg".";\n";
          }
        }
      }
    }
    
    print $rb_regs_fh "// Read Data Mux\n";
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      if ( $reg_array[$reg_index]{'reg_access'} =~ /R/ ) {
        my $inst_no     = $reg_array[$reg_index]{'num_inst'};
        my $inst_suffix = $reg_array[$reg_index]{'suffix'};
        for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
          my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
          print $rb_regs_fh "  ", "wire ";
          printSpace( 8, $rb_regs_fh);
          print $rb_regs_fh "[31:0]";
          printSpace(9-length("[31:0]"), $rb_regs_fh);
          print $rb_regs_fh "mux_"."$reg_array[$reg_index]{'reg_name'}"."$name_ext", ";\n";
        }
      }
    }
    
    # Read - Write Enable
    print $rb_regs_fh "\n";
    print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
    print $rb_regs_fh "// Read - Write Enable\n";
    print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      my $inst_no   = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        # Address of the instance
        my $inst_addr_dec = 0;
        $inst_addr_dec = hex($reg_array[$reg_index]{'reg_addr'}) + 4*$inst_index;
        
        my $inst_addr_hex = uc(sprintf("%02x", $inst_addr_dec));
        
        if ( $reg_array[$reg_index]{'reg_access'} =~ /RW/ ) {
          # Read Enable
          my $en_name = "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_ren";
          print $rb_regs_fh "  ", "assign ";
          print $rb_regs_fh "$en_name";
          printSpace(20-length($en_name), $rb_regs_fh);
          print $rb_regs_fh "= ";
          print $rb_regs_fh "rstrobe & (raddr == 8'h"."$inst_addr_hex".");\n";
          
          # Write Enable
          $en_name = "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_wen";
          print $rb_regs_fh "  ", "assign ";
          print $rb_regs_fh "$en_name";
          printSpace(20-length($en_name), $rb_regs_fh);
          print $rb_regs_fh "= ";
          print $rb_regs_fh "wstrobe & (waddr == 8'h"."$inst_addr_hex".");\n";
        }
        if ( $reg_array[$reg_index]{'reg_access'} =~ /RO/ ) {
          # Read Enable
          my $en_name = "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_ren";
          print $rb_regs_fh "  ", "assign ";
          print $rb_regs_fh "$en_name";
          printSpace(20-length($en_name), $rb_regs_fh);
          print $rb_regs_fh "= ";
          print $rb_regs_fh "rstrobe & (raddr == 8'h"."$inst_addr_hex".");\n";
        }
      }
    }
    
    # Write Address Decode Status
    print $rb_regs_fh "\n";
    print $rb_regs_fh "  ", "always_comb begin : WRITE_ADDR_ERROR_PROC\n";
    print $rb_regs_fh "  ", "  if (!wstrobe) begin\n";
    print $rb_regs_fh "  ", "    wack     = 1'b0;\n";
    print $rb_regs_fh "  ", "    waddrerr = 1'b0;\n";
    print $rb_regs_fh "  ", "  end\n";
    print $rb_regs_fh "  ", "  else begin\n";
    print $rb_regs_fh "  ", "    wack     = 1'b1;\n";
    print $rb_regs_fh "  ", "    waddrerr = ~|{", "\n";
    my $stt = 0;
    
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      my $inst_no   = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        if ( $reg_array[$reg_index]{'reg_access'} =~ /RW/ ) {
          if ($stt > 0) {
            print $rb_regs_fh ",\n";
          }
          printSpace(20, $rb_regs_fh); print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_wen";
          $stt++;
        }
      }
    }
    print $rb_regs_fh "\n";
    printSpace(18, $rb_regs_fh); print $rb_regs_fh "};\n";
    print $rb_regs_fh "  ", "  end\n";
    print $rb_regs_fh "  ", "end\n";
    
    # Read Address Decode Status
    print $rb_regs_fh "\n";
    print $rb_regs_fh "  ", "always_comb begin : READ_ADDR_ERROR_PROC\n";
    print $rb_regs_fh "  ", "  if (!rstrobe) begin\n";
    print $rb_regs_fh "  ", "    rack     = 1'b0;\n";
    print $rb_regs_fh "  ", "    raddrerr = 1'b0;\n";
    print $rb_regs_fh "  ", "  end\n";
    print $rb_regs_fh "  ", "  else begin\n";
    print $rb_regs_fh "  ", "    rack     = 1'b1;\n";
    print $rb_regs_fh "  ", "    raddrerr = ~|{", "\n";
    
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      my $inst_no   = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        if ( $reg_array[$reg_index]{'reg_access'} =~ /R[WO]/ ) {
          if ( ($reg_index == $#reg_array-1) && ($inst_index == $inst_no - 1) ) {
            printSpace(20, $rb_regs_fh); print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_ren"."\n";
          }
          else {
            printSpace(20, $rb_regs_fh); print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_ren".",\n";
          }
        }
      }
    }
    printSpace(18, $rb_regs_fh); print $rb_regs_fh "};\n";
    print $rb_regs_fh "  ", "  end\n";
    print $rb_regs_fh "  ", "end\n";
    
    # Register Declaration
    print $rb_regs_fh "\n";
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      my @reg_field = @{$reg_array[$reg_index]{'reg_field'}};
      my $inst_no   = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      
      # New line in Description
      my $cmt_space     = sprintf("%18s", "");
      my $reg_des       = $reg_array[$reg_index]{'reg_des'};
      $reg_des          =~ s/\n/\/\/$cmt_space/g;
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        # Address of the instance
        my $inst_addr_dec = 0;
        $inst_addr_dec = hex($reg_array[$reg_index]{'reg_addr'}) + 4*$inst_index;
        
        my $inst_addr_hex = uc(sprintf("%02x", $inst_addr_dec));
        
        print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
        print $rb_regs_fh "// Register";    printSpace(15-length("Register"),    $rb_regs_fh); print $rb_regs_fh ": "."$reg_array[$reg_index]{'reg_name'}"."$name_ext"."\n";
        print $rb_regs_fh "// Description"; printSpace(15-length("Description"), $rb_regs_fh); print $rb_regs_fh ": "."$reg_des"."\n";
        print $rb_regs_fh "// Address";     printSpace(15-length("Address"),     $rb_regs_fh); print $rb_regs_fh ": "."0x"."$inst_addr_hex"."\n";
        print $rb_regs_fh "// SW Access";   printSpace(15-length("SW Access"),   $rb_regs_fh); print $rb_regs_fh ": "."$reg_array[$reg_index]{'reg_access'}"."\n";
        print $rb_regs_fh "// Fields:\n";
        
        for ( my $field_index = 1; $field_index <= $#reg_field; $field_index++ ) {
          my $addr_start = $reg_field[$field_index]{'field_off'};
          my $addr_end   = $reg_field[$field_index]{'field_off'} + $reg_field[$field_index]{'field_width'} - 1;
          my $field_pos  = ($reg_field[$field_index]{'field_width'} > 1) ? "[$addr_end:$addr_start]" : "[$addr_start]";
          
          print $rb_regs_fh "//   ";
          print $rb_regs_fh "$field_pos"; printSpace(13-length($field_pos), $rb_regs_fh);
          print $rb_regs_fh ": "."$reg_field[$field_index]{'field_name'}";
          if ( $reg_field[$field_index]{'field_name'} =~ /^rfu$/ ) {
            print $rb_regs_fh " ("."$reg_field[$field_index]{'field_des'}".")\n";
          }
          else {
            print $rb_regs_fh " (SW Access: "."$reg_field[$field_index]{'field_swacc'}".", HW Access: "."$reg_field[$field_index]{'field_hwacc'}".")\n";
          }
        }
        print $rb_regs_fh "//-----------------------------------------------------------------------------\n\n";
        
        # Procedural Blocks For Register Fields
        for ( my $field_index = 1; $field_index <= $#reg_field; $field_index++ ) {
          # New line in Description
          my $cmt_space   = sprintf("%18s", "");
          my $field_des   = $reg_field[$field_index]{'field_des'};
          $field_des      =~ s/\n/\/\/$cmt_space/g;
          
          # Header of Register Fields
          print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
          print $rb_regs_fh "//   Field";       printSpace(13-length("Field"),       $rb_regs_fh); print $rb_regs_fh ": "."$reg_field[$field_index]{'field_name'}"."\n";
          print $rb_regs_fh "//   Description"; printSpace(13-length("Description"), $rb_regs_fh); print $rb_regs_fh ": "."$field_des"."\n";
          print $rb_regs_fh "//   Offset";      printSpace(13-length("Offset"),      $rb_regs_fh); print $rb_regs_fh ": "."$reg_field[$field_index]{'field_off'}"."\n";
          print $rb_regs_fh "//   Width";       printSpace(13-length("Width"),       $rb_regs_fh); print $rb_regs_fh ": "."$reg_field[$field_index]{'field_width'}"."\n";
          print $rb_regs_fh "//   SW Access";   printSpace(13-length("SW Access"),   $rb_regs_fh); print $rb_regs_fh ": "."$reg_field[$field_index]{'field_swacc'}"."\n";
          print $rb_regs_fh "//   HW Access";   printSpace(13-length("HW Access"),   $rb_regs_fh); print $rb_regs_fh ": "."$reg_field[$field_index]{'field_hwacc'}"."\n";
          print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
          
          # Procedural Blocks
          my $reg_field_name = "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}";
          my $proc_name = uc($reg_field_name)."_PROC";
          
          if ($reg_field[$field_index]{'field_swacc'} =~ /RW/ ) {
            my $addr_start = $reg_field[$field_index]{'field_off'};
            my $addr_end   = $reg_field[$field_index]{'field_off'} + $reg_field[$field_index]{'field_width'} - 1;
            my $field_pos  = ($reg_field[$field_index]{'field_width'} > 1) ? "[$addr_end:$addr_start]" : "[$addr_start]";
            
            print $rb_regs_fh "  ", "always_ff @(posedge clk, negedge reset_n) begin : ", "$proc_name\n";
            print $rb_regs_fh "  ", "  if (!reset_n) begin", "\n";
            print $rb_regs_fh "  ", "    ", "$reg_field_name", " <= ", "$reg_field[$field_index]{'field_reset'}", ";\n";
            print $rb_regs_fh "  ", "  end", "\n";
            print $rb_regs_fh "  ", "  else if ("."$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_wen".") begin", "\n";
            print $rb_regs_fh "  ", "    ", "$reg_field_name", " <= ", "wdata"."$field_pos", ";\n";
            print $rb_regs_fh "  ", "  end", "\n";
            print $rb_regs_fh "  ", "end", "\n";
          }
          if ($reg_field[$field_index]{'field_swacc'} =~ /RO/ ) {
            print $rb_regs_fh "  ", "always_ff @(posedge clk, negedge reset_n) begin : ", "$proc_name\n";
            print $rb_regs_fh "  ", "  if (!reset_n) begin", "\n";
            print $rb_regs_fh "  ", "    ", "$reg_field_name"."_reg", " <= ", "$reg_field[$field_index]{'field_reset'}", ";\n";
            print $rb_regs_fh "  ", "  end", "\n";
            print $rb_regs_fh "  ", "  else begin", "\n";
            print $rb_regs_fh "  ", "    ", "$reg_field_name"."_reg", " <= ", "$reg_field_name", ";\n";
            print $rb_regs_fh "  ", "  end", "\n";
            print $rb_regs_fh "  ", "end", "\n";
          }
        }
      }
    }
    
    # Read Data Mux
    print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
    print $rb_regs_fh "// Read Data Mux\n";
    print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
    
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      if ( $reg_array[$reg_index]{'reg_access'} =~ /R/ ) {
        my @reg_field = @{$reg_array[$reg_index]{'reg_field'}};
        my $inst_no   = $reg_array[$reg_index]{'num_inst'};
        my $inst_suffix = $reg_array[$reg_index]{'suffix'};
        
        for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
          my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
          my $mux_name  = "mux_"."$reg_array[$reg_index]{'reg_name'}"."$name_ext";
          print $rb_regs_fh "// ", "$mux_name", "\n";
          for ( my $field_index = 1; $field_index <= $#reg_field; $field_index++ ) {
            
            my $addr_start = $reg_field[$field_index]{'field_off'};
            my $addr_end   = $reg_field[$field_index]{'field_off'} + $reg_field[$field_index]{'field_width'} - 1;
            my $field_pos  = ($reg_field[$field_index]{'field_width'} > 1) ? "[$addr_end:$addr_start]" : "[$addr_start]";
            
            print $rb_regs_fh "  ", "assign ";
            print $rb_regs_fh "$mux_name";
            print $rb_regs_fh "$field_pos";
            printSpace(26-length($mux_name)-length($field_pos), $rb_regs_fh);
            print $rb_regs_fh "= ";
            if ( $reg_field[$field_index]{'field_name'} =~ /rfu/ ) {
              print $rb_regs_fh "\'"."0", ";\n";
            }
            else {
              if ( $reg_field[$field_index]{'field_hwacc'} =~ /R(O|W)/ ) {
                print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}", ";\n";
              }
              if ( $reg_field[$field_index]{'field_hwacc'} =~ /WO/ ) {
                print $rb_regs_fh "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}"."_reg", ";\n";
              }
            }
          }
        }
      }
    }
    
    # Read Data Procedural Block
    print $rb_regs_fh "\n";
    print $rb_regs_fh "  ", "always_comb begin : READ_DATA_PROC\n";
    print $rb_regs_fh "  ", "  rdata = '0;\n";
    print $rb_regs_fh "  ", "  case (1'b1)\n";
    for ( my $reg_index = 1; $reg_index < $#reg_array; $reg_index++ ) {
      if ( $reg_array[$reg_index]{'reg_access'} =~ /R/ ) {
        my $inst_no   = $reg_array[$reg_index]{'num_inst'};
        my $inst_suffix = $reg_array[$reg_index]{'suffix'};
        
        for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
          my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
          my $mux_sel  = "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_ren";
          my $mux_data = "mux_"."$reg_array[$reg_index]{'reg_name'}"."$name_ext";
          print $rb_regs_fh "      ", "$mux_sel";
          printSpace(17-length($mux_sel), $rb_regs_fh);
          print $rb_regs_fh ": ";
          print $rb_regs_fh "rdata = "; print $rb_regs_fh "$mux_data", ";\n";
        }
      }
    }
    print $rb_regs_fh "      default";
    printSpace(17-length("default"), $rb_regs_fh);
    print $rb_regs_fh ": rdata = '0;\n";
    print $rb_regs_fh "  ", "  endcase\n";
    print $rb_regs_fh "  ", "end\n";
    
   # # Procedural Block for Interrupt Signals
   #  print $rb_regs_fh "\n";
   #  print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
   #  print $rb_regs_fh "// Interrupt Signals\n";
   #  print $rb_regs_fh "//-----------------------------------------------------------------------------\n";
    
   #  my $reg_index   = $#reg_array;
   #  my $inst_no     = $reg_array[$reg_index]{'num_inst'};
   #  my $inst_suffix = $reg_array[$reg_index]{'suffix'};
   #  my @reg_field   = @{$reg_array[$reg_index]{'reg_field'}};
   #  for ( my $field_index = 1; $field_index <= $#reg_field; $field_index++ ) {
   #    for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
   #      my $name_ext    = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
   #      print $rb_regs_fh "  ", "assign ";
   #      print $rb_regs_fh "$reg_field[$field_index]{'field_name'}"."$name_ext";
   #      printSpace(20-length($reg_field[$field_index]{'field_name'})-length($name_ext), $rb_regs_fh);
   #      print $rb_regs_fh "= ctrl_intr_en ? ";
   #      # print $rb_regs_fh "stt0"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}"."_reg", " : 0;\n";
   #      print $rb_regs_fh "stt"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}"."_reg", " : 0;\n";
   #    }
   #  }
    print $rb_regs_fh "\n", "endmodule";

    print "Generating rb_regs: Done!\n";
    close($rb_regs_fh);
  }

#------------------------------------------------------------------------#
# rbApbBridgeGen Function
#------------------------------------------------------------------------#
# Generate rb_apb_bridge.sv, AXI4-Lite Read Controller
  # Parameters:
  #   None
  # Return:
  #   None
  sub rbApbBridgeGen {
    my $rb_apb_bridge_filename = "..\/hdl\/rb_apb_bridge.sv";
    open (my $rb_apb_bridge_fh, ">$rb_apb_bridge_filename") || die "Can't open new file: $! $rb_apb_bridge_filename\n";

    printHeader($rb_apb_bridge_fh, $rb_apb_bridge_filename, "APB Bridge");

    print $rb_apb_bridge_fh <<_RB_APB_BRIDGE_;
module rb_apb_bridge
( 
  // AMBA APB SIGNALS
  input                 presetn,   // AMBA APB Bus Reset. The APB reset signal is active LOW. This signal is normally connected directly to the system bus reset signal.
  input                 pclk,      // AMBA APB Bus Clock. The rising edge of PCLK times all transfers on the APB.
  input     [7:0]       paddr,     // AMBA APB Peripheral Address Bus. This is the APB address bus. It can be up to 32 bits wide and is driven by the peripheral bus bridge unit.
  input                 psel,      // AMBA APB Peripheral Select. The APB bridge unit generates this signal to each peripheral bus slave. It indicates that the slave device is selected and that a data transfer is required. There is a PSELx signal for each slave.
  input                 penable,   // AMBA APB Enable. Indicates 2nd and subsequent cycles of a transfer.
  input                 pwrite,    // AMBA APB Transfer Direction. This signal indicates an APB write access when HIGH and an APB read access when LOW.
  input     [31:0]      pwdata,    // AMBA APB Write Data. This bus is driven by the peripheral bus bridge unit during write cycles when PWRITE is HIGH. This bus can be up to 32 bits wide.
  output                pready,    // Ready. The slave uses this signal to extend an APB transfer.
  output    [31:0]      prdata,    // AMBA APB Read Data. The selected slave drives this bus during read cycles when PWRITE is LOW. This bus can be up to 32-bits wide.
  output                pslverr,   // This signal indicates a transfer failure. APB peripherals are not required to support the PSLVERR pin. This is true for both existing and new APB peripheral designs. Where a peripheral does not include this pin then the appropriate input to the APB bridge is tied LOW.
  // GENERIC BUS SIGNALS
  output                clk,       // Register Bus Clock
  output                reset_n,   // Register Bus Reset
  output                rstrobe,   // Read Strobe. Activates a register read access when HIGH.
  output    [7:0]       raddr,     // Read Address. Address of the register whose content is to be read.
  input     [31:0]      rdata,     // Read Data. The content of the addressed register is placed on this bus when RSTROBE is HIGH.
  input                 rack,      // Read Acknowledge. Asserted HIGH when RDATA is valid. This can be on the current clock edge if "Read Data Mux Logic Type" is set to ASYNC or the next clock edge if set to SYNC.
  input                 raddrerr,  // Read Address Error. Indicates an attempt to access an unmapped register address for read.
  output                wstrobe,   // Write Strobe. Activates a register write access when HIGH.
  output    [7:0]       waddr,     // Write Address. Address of the register whose content is to be written.
  output    [31:0]      wdata,     // Write Data. The content of the addressed register is placed on this bus and written to the register when WSTROBE is HIGH.
  input                 wack,      // Write Acknowledge. Asserted HIGH when WDATA has been assigned to the appropriate register. This can be on the current clock edge if "Address Decode Logic Type" is set to ASYNC or the next clock edge if set to SYNC.
  input                 waddrerr   // Write Address Error. Indicates an attempt to access an unmapped register address for write.
);

// COMMON MAPPING
// Internal Declarations
  assign reset_n        = presetn;  // RA Generic Bus reset must be configured to active low to work with APB
  assign clk            = pclk;     // RA Generic Bus clock must be configured to positive edge triggered to work with APB

  // WRITING
  assign wdata          = pwdata;
  assign wstrobe        = psel & pwrite & penable;
  assign waddr          = paddr;

  // READING
  assign prdata         = psel? rdata : 0;
  assign rstrobe        = psel & (~pwrite) & penable;
  assign raddr          = paddr;

  // SHARED SIGNALS
  assign pready         = psel? ((pwrite & wack) | ((~ pwrite) & rack)) : 0;
  assign pslverr        = psel? ((pwrite & waddrerr) | ((~ pwrite) & raddrerr)) : 0;

endmodule
_RB_APB_BRIDGE_

    print "Generating rb_apb_bridge: Done!\n";
    close($rb_apb_bridge_fh);
  }

#------------------------------------------------------------------------#
# rbTopBlockGen Function
#------------------------------------------------------------------------#
  # Generate register_block.sv, Registers Block
  # Parameters:
  #   $_[0]: Register Definition Array
  # Return:
  #   None
sub rbTopBlockGen (@) {
  my @reg_def_array = @{$_[0]};
  my @reg_array;   undef @reg_array;
  my $sheet_index   = 1;
  
  # Open sub-module RTL files
  open (my $rb_regs_fh,            "..\/hdl\/rb_regs.sv")       || die "Can't open file: $! ..\/hdl\/rb_regs.sv\n";
  open (my $rb_apb_bridge_fh,      "..\/hdl\/rb_apb_bridge.sv") || die "Can't open file: $! ..\/hdl\/rb_apb_bridge.sv\n";

  # Open new top module file
  open (my $rb_top_fh,            ">..\/hdl\/register_block.sv")     || die "Can't open new file: $! ..\/hdl\/register_block.sv\n";
  
  # Header
  printHeader($rb_top_fh, "..\/hdl\/register_block.sv", "Register Block Top Module");
  # Input Output Declarations
  print $rb_top_fh "module register_block ( \n";
  # Field Signals
  @reg_array = @{$reg_def_array[$sheet_index]{'reg'}};
  for (my $reg_index = 1; $reg_index <= $#reg_array; $reg_index++){
    my @reg_field   = @{$reg_array[$reg_index]{'reg_field'}};
    my $inst_no     = $reg_array[$reg_index]{'num_inst'};
    my $inst_suffix = $reg_array[$reg_index]{'suffix'};
    for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
      my $name_ext = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
      for ( my $field_index = 1; $field_index <= $#reg_field; $field_index++ ) {
        my $width           = $reg_field[$field_index]{'field_width'} - 1;
        my $reg_field_width = ($width > 0) ? "[$width:0]" : "";
        my $signal_name     = ($reg_array[$reg_index]{'reg_name'} =~ /NA/) ? "$reg_field[$field_index]{'field_name'}":
                                                                             "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}";
        if ( lc($reg_field[$field_index]{'field_io'}) =~ /input/ ) {
          print $rb_top_fh "  ", "input";
          printSpace(8, $rb_top_fh);
          print $rb_top_fh "$reg_field_width";
          printSpace(10-length($reg_field_width), $rb_top_fh);
          print $rb_top_fh "$signal_name".",\n";
        }
        if ( lc($reg_field[$field_index]{'field_io'}) =~ /output/ ) {
          print $rb_top_fh "  ","output wire ";
          printSpace(1, $rb_top_fh);
          print $rb_top_fh "$reg_field_width";
          printSpace(10-length($reg_field_width), $rb_top_fh);
          print $rb_top_fh "$signal_name".",\n";
        }
      }
    }
  }
  
  # AXI4-Lite Read
  print $rb_top_fh "// APB Bridge\n";
  my $current_line = "";
  my $rtl_infile   = $rb_apb_bridge_fh;
  my $get_line;

  seek($rtl_infile,0,0); # Start at the beginning of the file
  while ($current_line = <$rtl_infile>) {
    if ( $current_line =~ /AMBA APB SIGNALS/ ) {
      $get_line = 1;
    }
    if ( $current_line =~ /GENERIC BUS SIGNALS/ ) {
      $get_line = 0;
      last;
    }
    if ( ($current_line =~ /(input | output)/) && ($get_line == 1)) {
      $current_line =~ s/\n//g;
      $current_line =~ s/\,.*$//g;
      print $rb_top_fh "$current_line".",\n";
    }
  }

  # FIFO Signals
  print $rb_top_fh "// FIFO signals\n";
  print $rb_top_fh "  ", "output"; printSpace( 4, $rb_top_fh);  print $rb_top_fh "[7:0]";  printSpace(12-length("[7:0]"),  $rb_top_fh); print $rb_top_fh "waddr".",\n";
  print $rb_top_fh "  ", "output"; printSpace( 4, $rb_top_fh);  print $rb_top_fh "[7:0]";  printSpace(12-length("[7:0]"),  $rb_top_fh); print $rb_top_fh "raddr".",\n";
  print $rb_top_fh "  ", "output"; printSpace( 4, $rb_top_fh);  print $rb_top_fh "[31:0]"; printSpace(12-length("[31:0]"), $rb_top_fh); print $rb_top_fh "wdata".",\n";
  print $rb_top_fh "  ", "output"; printSpace(16, $rb_top_fh);                                                                          print $rb_top_fh "rstrobe".",\n";
  print $rb_top_fh "  ", "output"; printSpace(16, $rb_top_fh);                                                                          print $rb_top_fh "wstrobe"."\n";
  print $rb_top_fh ");\n";
  
  # Internal Signals
  print $rb_top_fh "\n";
  print $rb_top_fh "//-------------------------------------------------------------------------\n";
  print $rb_top_fh "// Internal Signals\n";
  print $rb_top_fh "//-------------------------------------------------------------------------\n";
  
  print $rb_top_fh "  ", "wire "; printSpace(17, $rb_top_fh);                                                                         print $rb_top_fh "clk".";\n";
  print $rb_top_fh "  ", "wire "; printSpace(17, $rb_top_fh);                                                                         print $rb_top_fh "reset_n".";\n";
  print $rb_top_fh "  ", "wire "; printSpace( 8, $rb_top_fh);  print $rb_top_fh "[31:0]"; printSpace(9-length("[31:0]"), $rb_top_fh); print $rb_top_fh "rdata".";\n";
  print $rb_top_fh "  ", "wire "; printSpace(17, $rb_top_fh);                                                                         print $rb_top_fh "waddrerr".";\n";
  print $rb_top_fh "  ", "wire "; printSpace(17, $rb_top_fh);                                                                         print $rb_top_fh "raddrerr".";\n";
  print $rb_top_fh "  ", "wire "; printSpace(17, $rb_top_fh);                                                                         print $rb_top_fh "wack".";\n";
  print $rb_top_fh "  ", "wire "; printSpace(17, $rb_top_fh);                                                                         print $rb_top_fh "rack".";\n";

  # Instance
  print $rb_top_fh "\n";
  print $rb_top_fh "//-------------------------------------------------------------------------\n";
  print $rb_top_fh "// Module Instances\n";
  print $rb_top_fh "//-------------------------------------------------------------------------\n";
  rbModuleInstGen($rb_top_fh, $rb_regs_fh,            "rb_regs");
  rbModuleInstGen($rb_top_fh, $rb_apb_bridge_fh,      "rb_apb_bridge");
  
  print $rb_top_fh "\n", "endmodule";
  
  close($rb_regs_fh);
  close($rb_apb_bridge_fh);
  close($rb_top_fh);
  print "Generating register_block: Done!\n";
}
  
#------------------------------------------------------------------------#
# rbModuleInstGen Function
#------------------------------------------------------------------------#
  # Instantiating sub-module in top-level Register Block
  # Parameters:
  #   $_[0]: RTL outfile handle
  #   $_[1]: RTL infile handle
  #   $_[2]: RTL infile module name
  # Return:
  #   None
  sub rbModuleInstGen (@) {
    my $rtl_outfile = $_[0];
    my $rtl_infile = $_[1];
    my $module_name = $_[2];
    print $rtl_outfile "//-------------------------------------------------------------------------\n";
    print $rtl_outfile "// Module $module_name Instance\n";
    print $rtl_outfile "//-------------------------------------------------------------------------\n";
    my $current_line = "";
    seek($rtl_infile,0,0); # Start at the beginning of the file
    while ($current_line = <$rtl_infile>) {
      $current_line =~ s/\/\/.*//;
      if ($current_line =~ /\s*\)\;/) { last; } # Break at the end of module declaration
      if (($current_line =~ /module/) && ($current_line =~ /$module_name/)) {
         print $rtl_outfile "  ", "$module_name\n";
         print $rtl_outfile "  ", "$module_name ( \n";
      }
      if ($current_line =~ /\s*input/) {
        $current_line =~ s/\s*input\s*//;
        $current_line =~ s/\[//;
        $current_line =~ s/[0-9]+://;
        $current_line =~ s/[0-9]+\]\s*//;
        if ($current_line =~ /,/) {
          $current_line =~ s/,.*\n//;
          print $rtl_outfile "    ", ".$current_line";
          printSpace(35-length(".$current_line"), $rtl_outfile);
          print $rtl_outfile "($current_line";
          printSpace(35-length("$current_line"), $rtl_outfile);
          print $rtl_outfile "),\n";
        }
        else {
          $current_line =~ s/\/\/.*//;
          $current_line =~ s/\n//;
          $current_line =~ s/\s*//g;
          print $rtl_outfile "    ", ".$current_line";
          printSpace(35-length(".$current_line"), $rtl_outfile);
          print $rtl_outfile "($current_line";
          printSpace(35-length("$current_line"), $rtl_outfile);
          print $rtl_outfile ")\n";
        }
      }
      if ($current_line =~ /\s*output/) {
        $current_line =~ s/\s*output\s*//;
        $current_line =~ s/logic\s*//;
        $current_line =~ s/wire\s*//;
        $current_line =~ s/\[//;
        $current_line =~ s/[0-9]+://;
        $current_line =~ s/[0-9]+\]\s*//;
        if ($current_line =~ /,/) {
          $current_line =~ s/,.*\n//;
          print $rtl_outfile "    ", ".$current_line";
          printSpace(35-length(".$current_line"), $rtl_outfile);
          print $rtl_outfile "($current_line";
          printSpace(35-length("$current_line"), $rtl_outfile);
          print $rtl_outfile "),\n";
        }
        else {
          $current_line =~ s/\/\/.*//;
          $current_line =~ s/\n//;
          $current_line =~ s/\s*//g;
          print $rtl_outfile "    ", ".$current_line";
          printSpace(35-length(".$current_line"), $rtl_outfile);
          print $rtl_outfile "($current_line";
          printSpace(35-length("$current_line"), $rtl_outfile);
          print $rtl_outfile ")\n";
        }
      }
    }
    print $rtl_outfile "  ); \n"; # end of module instance
  }

#------------------------------------------------------------------------#
# rbRegStructGen Function
#------------------------------------------------------------------------#
  # Generate register_struct.txt for Register Block test
  # Parameters:
  #   $_[0]: Register Definition Array
  # Return:
  #   None
  sub rbRegStructGen (){
    my @reg_def_array = @{$_[0]};
    # Open new register_struct.txt
    open (my $rb_struct_fh, ">..\/sim\/register_struct.txt") || die "Can't open new file: $! ..\/sim\/register_struct.txt\n";
    my $sheet_index = 1;
    my @reg_array = @{$reg_def_array[$sheet_index]{'reg'}};
    
    for (my $reg_index = 1; $reg_index < $#reg_array; $reg_index++) {
      my @reg_field   = @{$reg_array[$reg_index]{'reg_field'}};
      my $inst_no     = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext      = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        my $inst_addr_dec = 0;
        $inst_addr_dec = hex($reg_array[$reg_index]{'reg_addr'}) + 4*$inst_index;
        
        my $inst_addr_hex = uc(sprintf("%03x", $inst_addr_dec));
        for ( my $field_index = 1; $field_index <= $#reg_field; $field_index++ ) {
          if ( $reg_field[$field_index]{'field_name'} !~ /rfu/ ) {
            my $signal_name = "$reg_array[$reg_index]{'reg_name'}"."$name_ext"."_"."$reg_field[$field_index]{'field_name'}";
            print $rb_struct_fh "$signal_name", " {\n";
            
            print $rb_struct_fh "  ", "name";
            printSpace(18-length("name"), $rb_struct_fh);
            print $rb_struct_fh ": ", "$signal_name", "\n";
            
            print $rb_struct_fh "  ", "addr";
            printSpace(18-length("addr"), $rb_struct_fh);
            print $rb_struct_fh ": ", "$inst_addr_hex", "\n";
            
            print $rb_struct_fh "  ", "start_bit";
            printSpace(18-length("start_bit"), $rb_struct_fh);
            print $rb_struct_fh ": ", "$reg_field[$field_index]{'field_off'}", "\n";
            
            print $rb_struct_fh "  ", "bit_numb";
            printSpace(18-length("bit_numb"), $rb_struct_fh);
            print $rb_struct_fh ": ", "$reg_field[$field_index]{'field_width'}", "\n";
            
            print $rb_struct_fh "  ", "default_value";
            printSpace(18-length("default_value"), $rb_struct_fh);
            print $rb_struct_fh ": ", "$reg_field[$field_index]{'field_reset'}", "\n";
            
            print $rb_struct_fh "  ", "set_value";
            printSpace(18-length("set_value"), $rb_struct_fh);
            print $rb_struct_fh ": ", "$reg_field[$field_index]{'field_reset'}", "\n";
            
            print $rb_struct_fh "}\n";
          }
        }
      }
    }
    close ($rb_struct_fh);
    print "Generating ..\/sim\/register_struct.txt: Done\n";
  }
  
  
#------------------------------------------------------------------------#
# rbDefMSDocGen Function
#------------------------------------------------------------------------#
  # Generate Register Documentation
  # Parameters:
  #   $_[0]: Register Definition Array
  # Return:
  #   None
  sub rbDefMSDocGen (@) {
    print "Generating Register Definition MS Doc: \n";
    my @reg_def_array = @{$_[0]};
    my $rb_def_doc    = odfDocument
                        (
                          file            => "..\/doc\/register_definition.odt",
                          create          => 'text'
                        );
    my $doc_content   = odfDocument
                        (
                          container => $rb_def_doc,
                          part      => 'content'
                        );
    my $doc_style     = odfDocument
                        (
                          container => $rb_def_doc,
                          part      => 'styles'
                        );
                        
    $doc_content->appendParagraph
                        (
                          text      => "Register Definition",
                          style     => "Title"
                        );
    $doc_content->appendParagraph
                        (
                          text      => "Register Summary",
                          style     => "Heading 1"
                        );
    $doc_content->appendParagraph
                        (
                          text      => "Registers in Address Order",
                          style     => "Table"
                        );
    
    my $table = $doc_content->appendTable
                              (
                                "Table_0", 1, 4,
                                'table-style' => 'Table1',
                                'text-style' => 'Text body'
                              );
    $doc_content->cellValue($table, 0, 0, "Register Name");
    $doc_content->cellValue($table, 0, 1, "Address (Hex)");
    $doc_content->cellValue($table, 0, 2, "SW Access");
    $doc_content->cellValue($table, 0, 3, "Description");
    
    my $sheet_index = 1;
    my @reg_array = @{$reg_def_array[$sheet_index]{'reg'}};
    
    # Register Summary
    my $table_row = 1;
    for (my $reg_index = 1; $reg_index < $#reg_array; $reg_index++) {
      my $inst_no     = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext      = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        my $des_ext       = "";
        if ( $inst_suffix eq "ch" ) {
          $des_ext = " - Channel "."$inst_index";
        }
        elsif ( $inst_suffix eq "rt" ) {
          $des_ext = " - Route "."$inst_index";
        }
        else {
          $des_ext       = "";
        }
        
        my $inst_addr_dec = 0;
        $inst_addr_dec = hex($reg_array[$reg_index]{'reg_addr'}) + 4*$inst_index;
        
        my $inst_addr_hex = uc(sprintf("%03x", $inst_addr_dec));
        my $reg_name      = "$reg_array[$reg_index]{'reg_name'}"."$name_ext";
        
        $doc_content->appendRow($table);
        $doc_content->cellValue($table, $table_row, 0, "$reg_name");
        $doc_content->cellValue($table, $table_row, 1, "$inst_addr_hex");
        $doc_content->cellValue($table, $table_row, 2, "$reg_array[$reg_index]{'reg_access'}");
        $doc_content->cellValue($table, $table_row, 3, "$reg_array[$reg_index]{'reg_des'}"."$des_ext");
        $table_row = $table_row + 1;
      }
    }

    # Register Description
    my $table_index = 1;
    for (my $reg_index = 1; $reg_index < $#reg_array; $reg_index++) {
      my $inst_no     = $reg_array[$reg_index]{'num_inst'};
      my $inst_suffix = $reg_array[$reg_index]{'suffix'};
      for ( my $inst_index = 0; $inst_index < $inst_no; $inst_index++) {
        my $name_ext      = ( $inst_no > 1 ) ? "_"."$inst_suffix"."$inst_index" : "";
        my $des_ext       = "";
        if ( $inst_suffix eq "ch" ) {
          $des_ext = " - Channel "."$inst_index";
        }
        elsif ( $inst_suffix eq "rt" ) {
          $des_ext = " - Route "."$inst_index";
        }
        else {
          $des_ext       = "";
        }
        
        my $inst_addr_dec = 0;
        $inst_addr_dec = hex($reg_array[$reg_index]{'reg_addr'}) + 4*$inst_index;
        
        my $inst_addr_hex = uc(sprintf("%03x", $inst_addr_dec));
        my $reg_name      = "$reg_array[$reg_index]{'reg_name'}"."$name_ext";
        
        $doc_content->appendParagraph
                        (
                          text      => "$reg_name",
                          style     => "Heading 3"
                        );
        $doc_content->appendParagraph
                        (
                          text      => "Address: 0x$inst_addr_hex",
                          style     => "Text body"
                        );
        $doc_content->appendParagraph
                        (
                          text      => "SW Access: $reg_array[$reg_index]{'reg_access'}",
                          style     => "Text body"
                        );
        $doc_content->appendParagraph
                        (
                          text      => "Description: $reg_array[$reg_index]{'reg_des'}$des_ext",
                          style     => "Text body"
                        );

        # Field Table
        $doc_content->appendParagraph
                        (
                          text      => "$reg_name Field Definitions",
                          style     => "Table"
                        );
        my $table = $doc_content->appendTable
                                    (
                                      "Table_$table_index", 1, 4,
                                      'table-style' => 'Table1',
                                      'text-style' => 'Text body'
                                    );
        $doc_content->cellValue($table, 0, 0, "Register Field");
        $doc_content->cellValue($table, 0, 1, "Position");
        $doc_content->cellValue($table, 0, 2, "Reset");
        $doc_content->cellValue($table, 0, 3, "Description");
        $table_index = $table_index + 1;
        
        my @reg_field = @{$reg_array[$reg_index]{'reg_field'}};
        for (my $field_index = 1; $field_index <= $#reg_field; $field_index++) {
          if (!($reg_array[$reg_index]{'reg_field'}[$field_index]{'field_name'} =~ /rfu/)) {
            my $field_name = "$reg_name"."_"."$reg_field[$field_index]{'field_name'}";
            my $addr_start = $reg_field[$field_index]{'field_off'};
            my $addr_end   = $reg_field[$field_index]{'field_off'} + $reg_field[$field_index]{'field_width'} - 1;
            my $field_pos  = ($reg_field[$field_index]{'field_width'} > 1) ? "[$addr_end:$addr_start]" : "[$addr_start]";
            my $cmt_new_line   = "&#10;";
            my $cmt_apos       = "&apos;";
            my $description    = "$reg_field[$field_index]{'field_des'}"."$des_ext";
            $description    =~ s/$cmt_new_line/\n/g;
            $description    =~ s/$cmt_apos/\'/g;
            
            $doc_content->appendRow($table);
            $doc_content->cellValue($table, $field_index, 0, "$field_name");
            $doc_content->cellValue($table, $field_index, 1, "$field_pos");
            $doc_content->cellValue($table, $field_index, 2, "$reg_field[$field_index]{'field_reset'}");
            $doc_content->cellValue($table, $field_index, 3, "$description");
          }
        }
      }
    }
    
    $rb_def_doc->save;
    print "!Done\n";
  }

#------------------------------------------------------------------------#
# printHeader Functions
#------------------------------------------------------------------------#
  # Print Sheet Information
  # Parameters:
  #   $_[0]: File Handle
  #   $_[1]: File Name
  #   $_[2]: File Brief Desciption
  # Return:
  #   None
  sub printHeader (@) {
    #get data from argument
    my $FileHandle = $_[0];
    my $filename = $_[1];
    my $brief = $_[2];
    
    # #print header to RTl file
    # print $FileHandle "//-----------------------------------------------------------------------------\n";
    # print $FileHandle "//    Copyright (C) 2016 by Dolphin Technology\n";
    # print $FileHandle "//    All right reserved.\n";
    # print $FileHandle "//    \n";
    # print $FileHandle "//    Copyright Notification\n";
    # print $FileHandle "//    No part may be reproduced except as authorized by written permission.\n";
    # print $FileHandle "//    \n";
    # print $FileHandle "//    File: $filename\n";
    # print $FileHandle "//    Project: Dynamo\n";
    # print $FileHandle "//    Author: Huylq0\n";
    # print $FileHandle "//    Created: ",&getDate, "\n";
    # print $FileHandle "//    Description:\n";
    # print $FileHandle "//       $brief\n";
    # print $FileHandle "//    \n";
    # print $FileHandle "//    History:\n";
    # print $FileHandle "//    Date ------------ By ------------ Change Description\n";
    # print $FileHandle "//------------------------------------------------------------------------------\n";
  }
#------------------------------------------------------------------------#
# getDate Function
#------------------------------------------------------------------------#
  # Get Date
  # Parameters:
  #   None
  # Return:
  #   Date
  sub getDate {
    my $date_time_return ="";
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900;
    my @mon_abrr = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
    my $day = "";
    if (($mday == 1)||($mday == 21)||($mday == 31)) {
        $day = $mday .'st';
    }
    elsif (($mday == 2)||($mday == 22)) {
        $day = $mday .'nd';
    }
    elsif (($mday == 3)||($mday == 23)) {
        $day = $mday .'rd';
    }
    else {
        $day = $mday .'th';
    }

    $date_time_return = $mon_abrr[$mon] ." " .$day ." " .$year;

    return $date_time_return;
  }

#------------------------------------------------------------------------#
# printSpace Function
#------------------------------------------------------------------------#
  sub printSpace (@) {
    my $num_space = $_[0];
    my $fileHandle = $_[1];
    for (my $i = 0; $i < $num_space; $i++) {
      print $fileHandle " ";
    }
  }
