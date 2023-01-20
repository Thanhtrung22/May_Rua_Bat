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
