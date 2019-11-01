module within_triangle(triangle_P1_x, triangle_P1_y,
                       triangle_P2_x, triangle_P2_y,
                       triangle_P3_x, triangle_P3_y,
                       input_point_x, input_point_y,
                       is_inside_triangle);

   // These params should be overridden by defparam when this is instantiated
   parameter MAX_RESOLUTION_X = 1920;
   parameter MAX_RESOLUTION_Y = 1080;

   input [$clog2(MAX_RESOLUTION_X)-1:0] triangle_P1_x;
   input [$clog2(MAX_RESOLUTION_Y)-1:0] triangle_P1_y;

   input [$clog2(MAX_RESOLUTION_X)-1:0] triangle_P2_x;
   input [$clog2(MAX_RESOLUTION_Y)-1:0] triangle_P2_y;

   input [$clog2(MAX_RESOLUTION_X)-1:0] triangle_P3_x;
   input [$clog2(MAX_RESOLUTION_Y)-1:0] triangle_P3_y;

   input [$clog2(MAX_RESOLUTION_X)-1:0] input_point_x;
   input [$clog2(MAX_RESOLUTION_Y)-1:0] input_point_y;

   output is_inside_triangle;
   
   // TODO: Remove this!! It's a temporary placeholder to always return 0.
   assign is_inside_triangle = 0;

   /*
   always begin
      
   end // initial begin
   */

endmodule // within_triangle
