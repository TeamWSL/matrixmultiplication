// AXI has 5 channels: Write Address, Write Data, Write Response, Read Address, Read Data
// Each channel has a set of signals that are used to communicate with the master or slave

// AXI has a master and a slave interface. Master typically refers to the processor while slave typically refers to the memory in this case


module Accelerator_Top (
    input  logic                         s_axi_aclk,
    input  logic                         s_axi_aresetn,
    
    // Master Write Address Channel: To initiate a write operation to a slave. In this case, the CPU initiates a write to the accelerator
    output logic                         m_axi_awvalid,    // Valid is high when the master wants to write data
    output logic [11:0]                  m_axi_awid,    
    output logic [7:0]                   m_axi_awlen,       // Length is the number of data bursts in the write transaction
    output logic [2:0]                   m_axi_awsize,      // Size is the size of the data in the write transaction
    output logic [1:0]                   m_axi_awburst,     // Burst is the type of burst operation
    output logic                         m_axi_awlock,
    output logic [3:0]                   m_axi_awcache,
    output logic [3:0]                   m_axi_awqos,
    output logic [63:0]                  m_axi_awaddr,    // Address is the starting address of the write transaction
    output logic [2:0]                   m_axi_awprot,
    input  logic                         m_axi_awready,  // Ready is high when the slave is ready to accept the write address
    
    // Master Write Data Channel: To send data to the slave from master
    output logic                         m_axi_wvalid,
    output logic                         m_axi_wlast,
    output logic [63:0]                  m_axi_wdata,
    output logic [7:0]                   m_axi_wstrb,
    input  logic                         m_axi_wready,
    
    // Master Write Response Channel: To receive a response from the slave
    output logic                         m_axi_bready,
    input  logic                         m_axi_bvalid,
    input  logic [11:0]                  m_axi_bid,
    input  logic [1:0]                   m_axi_bresp,
    
    // Master Read Address Channel: To initiate a read operation from the slave
    output logic                         m_axi_arvalid,    // Valid is high when the master wants to read data
    output logic [11:0]                  m_axi_arid,        // ID is used to identify the read transaction
    output logic [7:0]                   m_axi_arlen,       // Length is the number of data bursts in the read transaction
    output logic [2:0]                   m_axi_arsize,      // Size is the size of the data in the read transaction
    output logic [1:0]                   m_axi_arburst,     // Burst is the type of burst operation
    output logic                         m_axi_arlock,      
    output logic [3:0]                   m_axi_arcache,
    output logic [3:0]                   m_axi_arqos,
    output logic [63:0]                  m_axi_araddr,      // Address is the starting address of the read transaction
    output logic [2:0]                   m_axi_arprot,      
    input  logic                         m_axi_arready,     // Ready is high when the slave is ready to accept the read address

    // Master Read Response Channel: To receive data from the slave
    output logic                         m_axi_rready,
    input  logic                         m_axi_rvalid,
    input  logic [11:0]                  m_axi_rid,
    input  logic                         m_axi_rlast,
    input  logic [1:0]                   m_axi_rresp,
    input  logic [63:0]                  m_axi_rdata,
    
    // Slave Write Address Channel: To receive a write address from the master
    input  logic [11:0]                  s_axi_awid,
    input  logic [63:0]                  s_axi_awaddr,
    input  logic [7:0]                   s_axi_awlen,
    input  logic [2:0]                   s_axi_awsize,
    input  logic [1:0]                   s_axi_awburst,
    input  logic                         s_axi_awlock,
    input  logic [3:0]                   s_axi_awcache,
    input  logic [2:0]                   s_axi_awprot,
    input  logic [3:0]                   s_axi_awqos,
    input  logic                         s_axi_awvalid,
    output logic                         s_axi_awready,
    
    // Slave Write Data Channel: To receive data from the master
    input  logic [63:0]                  s_axi_wdata,
    input  logic [7:0]                   s_axi_wstrb,
    input  logic                         s_axi_wlast,
    input  logic                         s_axi_wvalid,
    output logic                         s_axi_wready,
    
    // Slave Write Response Channel: To send a response to the master
    input  logic                         s_axi_bready,
    output logic [11:0]                  s_axi_bid,
    output logic [1:0]                   s_axi_bresp,
    output logic                         s_axi_bvalid,
    
    // Slave Read Address Channel: To receive a read address from the master
    input  logic [11:0]                  s_axi_arid,
    input  logic [63:0]                  s_axi_araddr,
    input  logic [7:0]                   s_axi_arlen,
    input  logic [2:0]                   s_axi_arsize,
    input  logic [1:0]                   s_axi_arburst,
    input  logic                         s_axi_arlock,
    input  logic [3:0]                   s_axi_arcache,
    input  logic [2:0]                   s_axi_arprot,
    input  logic [3:0]                   s_axi_arqos,
    input  logic                         s_axi_arvalid,
    output logic                         s_axi_arready,
    
    // Slave Read Data Channel: To send data to the master
    input  logic                         s_axi_rready,
    output logic [11:0]                  s_axi_rid,
    output logic [63:0]                  s_axi_rdata,
    output logic [1:0]                   s_axi_rresp,
    output logic                         s_axi_rlast,
    output logic                         s_axi_rvalid
);

// Signal declarations
logic [31:0] s_s_axi_rdata;
logic [31:0] s_s_axi_wdata;
logic [3:0]  s_s_axi_wstrb;

logic s_acc_axi_awvalid;
logic [7:0] s_acc_axi_awlen;
logic [2:0] s_acc_axi_awsize;
logic [1:0] s_acc_axi_awburst;
logic s_acc_axi_awlock;
logic [3:0] s_acc_axi_awcache;
logic [3:0] s_acc_axi_awqos;
logic [63:0] s_acc_axi_awaddr;
logic [2:0] s_acc_axi_awprot;
logic s_acc_axi_wvalid;
logic [7:0] s_acc_axi_wid;
logic s_acc_axi_wlast;
logic [31:0] s_acc_axi_wdata;
logic [3:0] s_acc_axi_wstrb;
logic s_acc_axi_bready;
logic s_acc_axi_arvalid;
logic [7:0] s_acc_axi_arlen;
logic [2:0] s_acc_axi_arsize;
logic [1:0] s_acc_axi_arburst;
logic s_acc_axi_arlock;
logic [3:0] s_acc_axi_arcache;
logic [3:0] s_acc_axi_arqos;
logic [63:0] s_acc_axi_araddr;
logic [2:0] s_acc_axi_arprot;
logic s_acc_axi_rready;
logic s_acc_axi_awready;
logic s_acc_axi_wready;
logic s_acc_axi_bvalid;
logic [1:0] s_acc_axi_bresp;
logic s_acc_axi_arready;
logic s_acc_axi_rvalid;
logic s_acc_axi_rlast;
logic [1:0] s_acc_axi_rresp;
logic [31:0] s_acc_axi_rdata;
logic [0:0] s_acc_axi_awid;
logic [0:0] s_acc_axi_arid;
logic [0:0] s_acc_axi_rid;
logic [0:0] s_acc_axi_bid;
logic [3:0] s_acc_axi_awregion;
logic [3:0] s_acc_axi_arregion;

// Combinational logic
assign s_axi_rid   = s_axi_arid; // ID is used to identify the read transaction
assign s_axi_rlast = 1'b1;
assign s_axi_rdata = {s_s_axi_rdata, s_s_axi_rdata};
assign s_axi_bid   = s_axi_awid;

assign m_axi_arid  = {1'b0, s_acc_axi_arid};
assign m_axi_awid  = {1'b0, s_acc_axi_awid};

assign s_s_axi_wstrb = (s_axi_awaddr[2] == 1'b1) ? s_axi_wstrb[7:4] : s_axi_wstrb[3:0];
assign s_s_axi_wdata = (s_axi_awaddr[2] == 1'b1) ? s_axi_wdata[63:32] : s_axi_wdata[31:0];

// Instantiate the accelerator
accelerator u_accelerator ( // Rest of the accelerator code needs to go here
    .ap_local_block           (),
    .ap_clk                   (s_axi_aclk),
    .ap_rst_n                 (s_axi_aresetn),
    
    .m_axi_gmem_AWVALID       (s_acc_axi_awvalid),
    .m_axi_gmem_AWREADY       (s_acc_axi_awready),
    .m_axi_gmem_AWADDR        (s_acc_axi_awaddr),
    .m_axi_gmem_AWID          (s_acc_axi_awid),
    .m_axi_gmem_AWLEN         (s_acc_axi_awlen),
    .m_axi_gmem_AWSIZE        (s_acc_axi_awsize),
    .m_axi_gmem_AWBURST       (s_acc_axi_awburst),
    .m_axi_gmem_AWLOCK        (s_acc_axi_awlock),
    .m_axi_gmem_AWCACHE       (s_acc_axi_awcache),
    .m_axi_gmem_AWPROT        (s_acc_axi_awprot),
    .m_axi_gmem_AWQOS         (s_acc_axi_awqos),
    .m_axi_gmem_AWREGION      (s_acc_axi_awregion),
    .m_axi_gmem_AWUSER        (),
    
    .m_axi_gmem_WVALID        (s_acc_axi_wvalid),
    .m_axi_gmem_WREADY        (s_acc_axi_wready),
    .m_axi_gmem_WDATA         (s_acc_axi_wdata),
    .m_axi_gmem_WSTRB         (s_acc_axi_wstrb),
    .m_axi_gmem_WLAST         (s_acc_axi_wlast),
    .m_axi_gmem_WID           (),
    .m_axi_gmem_WUSER         (),
    
    .m_axi_gmem_ARVALID       (s_acc_axi_arvalid),
    .m_axi_gmem_ARREADY       (s_acc_axi_arready),
    .m_axi_gmem_ARADDR        (s_acc_axi_araddr),
    .m_axi_gmem_ARID          (s_acc_axi_arid),
    .m_axi_gmem_ARLEN         (s_acc_axi_arlen),
    .m_axi_gmem_ARSIZE        (s_acc_axi_arsize),
    .m_axi_gmem_ARBURST       (s_acc_axi_arburst),
    .m_axi_gmem_ARLOCK        (s_acc_axi_arlock),
    .m_axi_gmem_ARCACHE       (s_acc_axi_arcache),
    .m_axi_gmem_ARPROT        (s_acc_axi_arprot),
    .m_axi_gmem_ARQOS         (s_acc_axi_arqos),
    .m_axi_gmem_ARREGION      (s_acc_axi_awregion),
    .m_axi_gmem_ARUSER        (),
    
    .m_axi_gmem_RVALID        (s_acc_axi_rvalid),
    .m_axi_gmem_RREADY        (s_acc_axi_rready),
    .m_axi_gmem_RDATA         (s_acc_axi_rdata),
    .m_axi_gmem_RLAST         (s_acc_axi_rlast),
    .m_axi_gmem_RID           (s_acc_axi_rid),
    .m_axi_gmem_RUSER         (1'b0),
    .m_axi_gmem_RRESP         (s_acc_axi_rresp),
    
    .m_axi_gmem_BVALID        (s_acc_axi_bvalid),
    .m_axi_gmem_BREADY        (s_acc_axi_bready),
    .m_axi_gmem_BRESP         (s_acc_axi_bresp),
    .m_axi_gmem_BID           (s_acc_axi_bid),
    .m_axi_gmem_BUSER         (1'b0),
    
    .s_axi_control_AWVALID    (s_axi_awvalid),
    .s_axi_control_AWREADY    (s_axi_awready),
    .s_axi_control_AWADDR     (s_axi_awaddr[5:0]),
    
    .s_axi_control_WVALID     (s_axi_wvalid),
    .s_axi_control_WREADY     (s_axi_wready),
    .s_axi_control_WDATA      (s_s_axi_wdata),
    .s_axi_control_WSTRB      (s_s_axi_wstrb),
    
    .s_axi_control_ARVALID    (s_axi_arvalid),
    .s_axi_control_ARREADY    (s_axi_arready),
    .s_axi_control_ARADDR     (s_axi_araddr[5:0]),
    
    .s_axi_control_RVALID     (s_axi_rvalid),
    .s_axi_control_RREADY     (s_axi_rready),
    .s_axi_control_RDATA      (s_s_axi_rdata),
    .s_axi_control_RRESP      (s_axi_rresp),
    
    .s_axi_control_BVALID     (s_axi_bvalid),
    .s_axi_control_BREADY     (s_axi_bready),
    .s_axi_control_BRESP      (s_axi_bresp),
    
    .interrupt                ()
);

// Instantiate the AXI width converter
axi_acc_dwidth_converter_0 u_axi_acc_dwidth_converter_0 (
    .s_axi_aclk             (s_axi_aclk),
    .s_axi_aresetn          (s_axi_aresetn),
    
    .s_axi_awregion         (s_acc_axi_awregion),
    .s_axi_arregion         (s_acc_axi_arregion),
    .s_axi_awvalid          (s_acc_axi_awvalid),
    .s_axi_awid             (s_acc_axi_awid),
    .s_axi_awlen            (s_acc_axi_awlen),
    .s_axi_awsize           (s_acc_axi_awsize),
    .s_axi_awburst          (s_acc_axi_awburst),
    .s_axi_awlock           (s_acc_axi_awlock),
    .s_axi_awcache          (s_acc_axi_awcache),
    .s_axi_awqos            (s_acc_axi_awqos),
    .s_axi_awaddr           (s_acc_axi_awaddr),
    .s_axi_awprot           (s_acc_axi_awprot),
    
    .s_axi_wvalid           (s_acc_axi_wvalid),
    .s_axi_wlast            (s_acc_axi_wlast),
    .s_axi_wdata            (s_acc_axi_wdata),
    .s_axi_wstrb            (s_acc_axi_wstrb),
    .s_axi_bready           (s_acc_axi_bready),
    
    .s_axi_arvalid          (s_acc_axi_arvalid),
    .s_axi_arid             (s_acc_axi_arid),
    .s_axi_arlen            (s_acc_axi_arlen),
    .s_axi_arsize           (s_acc_axi_arsize),
    .s_axi_arburst          (s_acc_axi_arburst),
    .s_axi_arlock           (s_acc_axi_arlock),
    .s_axi_arcache          (s_acc_axi_arcache),
    .s_axi_arqos            (s_acc_axi_arqos),
    .s_axi_araddr           (s_acc_axi_araddr),
    .s_axi_arprot           (s_acc_axi_arprot),
    .s_axi_rready           (s_acc_axi_rready),
    
    .s_axi_awready          (s_acc_axi_awready),
    .s_axi_wready           (s_acc_axi_wready),
    .s_axi_bvalid           (s_acc_axi_bvalid),
    .s_axi_bid              (s_acc_axi_bid),
    .s_axi_bresp            (s_acc_axi_bresp),
    .s_axi_arready          (s_acc_axi_arready),
    .s_axi_rvalid           (s_acc_axi_rvalid),
    .s_axi_rid              (s_acc_axi_rid),
    .s_axi_rlast            (s_acc_axi_rlast),
    .s_axi_rresp            (s_acc_axi_rresp),
    .s_axi_rdata            (s_acc_axi_rdata),
    
    .m_axi_awregion         (),
    .m_axi_arregion         (),
    .m_axi_awvalid          (m_axi_awvalid),
    .m_axi_awlen            (m_axi_awlen),
    .m_axi_awsize           (m_axi_awsize),
    .m_axi_awburst          (m_axi_awburst),
    .m_axi_awlock           (m_axi_awlock),
    .m_axi_awcache          (m_axi_awcache),
    .m_axi_awqos            (m_axi_awqos),
    .m_axi_awaddr           (m_axi_awaddr),
    .m_axi_awprot           (m_axi_awprot),
    .m_axi_wvalid           (m_axi_wvalid),
    .m_axi_wlast            (m_axi_wlast),
    .m_axi_wdata            (m_axi_wdata),
    .m_axi_wstrb            (m_axi_wstrb),
    .m_axi_bready           (m_axi_bready),
    .m_axi_arvalid          (m_axi_arvalid),
    .m_axi_arlen            (m_axi_arlen),
    .m_axi_arsize           (m_axi_arsize),
    .m_axi_arburst          (m_axi_arburst),
    .m_axi_arlock           (m_axi_arlock),
    .m_axi_arcache          (m_axi_arcache),
    .m_axi_arqos            (m_axi_arqos),
    .m_axi_araddr           (m_axi_araddr),
    .m_axi_arprot           (m_axi_arprot),
    .m_axi_rready           (m_axi_rready),
    
    .m_axi_awready          (m_axi_awready),
    .m_axi_wready           (m_axi_wready),
    .m_axi_bvalid           (m_axi_bvalid),
    .m_axi_bresp            (m_axi_bresp),
    .m_axi_arready          (m_axi_arready),
    .m_axi_rvalid           (m_axi_rvalid),
    .m_axi_rlast            (m_axi_rlast),
    .m_axi_rresp            (m_axi_rresp),
    .m_axi_rdata            (m_axi_rdata)
);

endmodule
