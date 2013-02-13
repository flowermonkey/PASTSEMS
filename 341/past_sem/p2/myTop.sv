`default_nettype none

typedef struct packed {
  bit [3:0] sourceID;
  bit [3:0] destID;
  bit [23:0] data;
} pkt_t;



module top;

  bit clk, rst_b;

  // Interface to TestBench
  pkt_t pkt_in;
  bit pkt_in_avail;
  bit cQ_full;
  pkt_t pkt_out;
  logic pkt_out_avail;

  // Endpoint -> Router transaction
  bit free_outbound; // Router -> Endpoint
  bit put_outbound; // Endpoint -> Router
  bit [7:0] payload_outbound;

  // Router -> Endpoint transaction
  bit free_inbound; // Endpoint -> Router
  bit put_inbound; // Router -> Endpoint
  bit [7:0] payload_inbound;
 
 node myNode(.*);
 tb_node myTB(.*);
 endmodule 
