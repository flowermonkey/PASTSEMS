`default_nettype none

typedef struct packed {
  bit [3:0] sourceID;
  bit [3:0] destID;
  bit [23:0] data;
} pkt_t;

/*********************************************
 *  18-341 Spring 2012                       *
 *  Project 2                                *
 *  Network-on-Chip Topology                 *
 *                                           *
 *  You should not need to modify this file. *
 *********************************************/
module top();

  // top-level wires
  logic clk, rst_b;

  // node-testbench wires
  pkt_t pkt_in[6];
  bit pkt_in_avail[6];
  bit cQ_full[6];
  pkt_t pkt_out[6];
  bit pkt_out_avail[6];

  // node signals
  bit [5:0] free_node_router, put_node_router;
  bit [5:0] free_router_node, put_router_node;
  bit [5:0][7:0] payload_router_node;
  bit [5:0][7:0] payload_node_router;

  // router-router wires
  bit free_r0_r1, put_r0_r1;
  bit free_r1_r0, put_r1_r0;
  bit [7:0] payload_r1_r0;
  bit [7:0] payload_r0_r1;

  // router signals
  bit [1:0][3:0] free_router_out, put_router_in;
  bit [1:0][3:0] free_router_in, put_router_out;
  bit [1:0][3:0][7:0] payload_router_out;
  bit [1:0][3:0][7:0] payload_router_in;

  // connect node inputs to router outputs
  assign free_node_router[0] = free_router_out[0][0];
  assign free_node_router[1] = free_router_out[0][2];
  assign free_node_router[2] = free_router_out[0][3];
  assign free_node_router[3] = free_router_out[1][0];
  assign free_node_router[4] = free_router_out[1][1];
  assign free_node_router[5] = free_router_out[1][2];

  assign put_router_node[0] = put_router_out[0][0];
  assign put_router_node[1] = put_router_out[0][2];
  assign put_router_node[2] = put_router_out[0][3];
  assign put_router_node[3] = put_router_out[1][0];
  assign put_router_node[4] = put_router_out[1][1];
  assign put_router_node[5] = put_router_out[1][2];

  assign payload_router_node[0] = payload_router_out[0][0];
  assign payload_router_node[1] = payload_router_out[0][2];
  assign payload_router_node[2] = payload_router_out[0][3];
  assign payload_router_node[3] = payload_router_out[1][0];
  assign payload_router_node[4] = payload_router_out[1][1];
  assign payload_router_node[5] = payload_router_out[1][2];

  // connect router0 to router1
  assign free_r0_r1 = free_router_out[0][1];
  assign put_r0_r1 = put_router_out[0][1];
  assign payload_r0_r1 = payload_router_out[0][1];

  assign free_r1_r0 = free_router_out[1][3];
  assign put_r1_r0 = put_router_out[1][3];
  assign payload_r1_r0 = payload_router_out[1][3];

  // connect router inputs to node outputs
  assign free_router_in[0] =    { free_router_node[2],
                                  free_router_node[1],
                                  free_r1_r0,
                                  free_router_node[0] };

  assign put_router_in[0] =     { put_node_router[2],
                                  put_node_router[1],
                                  put_r1_r0,
                                  put_node_router[0] };

  assign payload_router_in[0] = { payload_node_router[2],
                                  payload_node_router[1],
                                  payload_r1_r0,
                                  payload_node_router[0] };

  assign free_router_in[1] =    { free_r0_r1,
                                  free_router_node[5],
                                  free_router_node[4],
                                  free_router_node[3] };

  assign put_router_in[1] =     { put_r0_r1,
                                  put_node_router[5],
                                  put_node_router[4],
                                  put_node_router[3] };

  assign payload_router_in[1] = { payload_r0_r1,
                                  payload_node_router[5],
                                  payload_node_router[4],
                                  payload_node_router[3] };

  genvar j, k;

  // generate routers
  generate
    for(k=0; k<2; k=k+1) begin : R1
      router #(k) router_inst(.clk, .rst_b,
                         .free_outbound(free_router_in[k]), 
                         .put_outbound(put_router_out[k]),
                         .payload_outbound(payload_router_out[k]),
                         .free_inbound(free_router_out[k]),
                         .put_inbound(put_router_in[k]),
                         .payload_inbound(payload_router_in[k]));
    end
  endgenerate

  // generate nodes
  generate
    for(j=0; j<6; j=j+1) begin : N1
      node #(j) node_inst(.clk, .rst_b,
                          .pkt_in(pkt_in[j]),
                          .pkt_in_avail(pkt_in_avail[j]),
                          .cQ_full(cQ_full[j]),
                          .pkt_out(pkt_out[j]),
                          .pkt_out_avail(pkt_out_avail[j]),
                          .free_inbound(free_router_node[j]), 
                          .put_inbound(put_router_node[j]),
                          .payload_inbound(payload_router_node[j]),
                          .free_outbound(free_node_router[j]),
                          .put_outbound(put_node_router[j]),
                          .payload_outbound(payload_node_router[j]));
    end
  endgenerate

  // testbench provides stimulus to the DUT
  tb tb1(.*);

endmodule 
