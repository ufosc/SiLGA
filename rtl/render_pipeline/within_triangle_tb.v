module within_triangle_tb;
   parameter MAX_RESOLUTION_X = 1280;
   parameter MAX_RESOLUTION_Y = 720;

   reg [$clog2(MAX_RESOLUTION_X)-1:0] triangle_P1_x;
   reg [$clog2(MAX_RESOLUTION_Y)-1:0] triangle_P1_y;

   reg [$clog2(MAX_RESOLUTION_X)-1:0] triangle_P2_x;
   reg [$clog2(MAX_RESOLUTION_Y)-1:0] triangle_P2_y;

   reg [$clog2(MAX_RESOLUTION_X)-1:0] triangle_P3_x;
   reg [$clog2(MAX_RESOLUTION_Y)-1:0] triangle_P3_y;

   reg [$clog2(MAX_RESOLUTION_X)-1:0] input_point_x;
   reg [$clog2(MAX_RESOLUTION_Y)-1:0] input_point_y;

   wire is_inside_triangle;

   reg [$clog2(MAX_RESOLUTION_Y)-1:0] end_row;

   defparam U0.MAX_RESOLUTION_X = MAX_RESOLUTION_X;
   defparam U0.MAX_RESOLUTION_Y = MAX_RESOLUTION_Y;
   within_triangle U0 (
                       .triangle_P1_x (triangle_P1_x),
                       .triangle_P1_y (triangle_P1_y),

                       .triangle_P2_x (triangle_P2_x),
                       .triangle_P2_y (triangle_P2_y),

                       .triangle_P3_x (triangle_P3_x),
                       .triangle_P3_y (triangle_P3_y),

                       .input_point_x (input_point_x),
                       .input_point_y (input_point_y),

                       .is_inside_triangle (is_inside_triangle)
);


   // The following 2 functions are based off of code for checking if a point is
   // inside of a triangle from GeeksforGeeks.
   // URL: https://www.geeksforgeeks.org/check-whether-a-given-point-lies-inside-a-triangle-or-not/

   function real area;
      input [$clog2(MAX_RESOLUTION_X)-1:0] x1;
      input [$clog2(MAX_RESOLUTION_Y)-1:0] y1;
      input [$clog2(MAX_RESOLUTION_X)-1:0] x2;
      input [$clog2(MAX_RESOLUTION_Y)-1:0] y2;
      input [$clog2(MAX_RESOLUTION_X)-1:0] x3;
      input [$clog2(MAX_RESOLUTION_Y)-1:0] y3;

      real                                 x1_real,
                                           y1_real,
                                           x2_real,
                                           y2_real,
                                           x3_real,
                                           y3_real;

      real                                 area_val;

      begin
         x1_real = x1;
         y1_real = y1;
         x2_real = x2;
         y2_real = y2;
         x3_real = x3;
         y3_real = y3;

         area_val = ((x1_real * (y2_real - y3_real)) +
                     (x2_real * (y3_real - y1_real)) +
                     (x3_real * (y1_real - y2_real))) / 2.0;

         // take the absolute value
         if(area_val < 0)
           area_val = -1 * area_val;

         area = area_val;
      end
   endfunction // area

   function inside_triangle;
      // point A
      input [$clog2(MAX_RESOLUTION_X)-1:0] x1;
      input [$clog2(MAX_RESOLUTION_Y)-1:0] y1;
      // point B
      input [$clog2(MAX_RESOLUTION_X)-1:0] x2;
      input [$clog2(MAX_RESOLUTION_Y)-1:0] y2;
      // point C
      input [$clog2(MAX_RESOLUTION_X)-1:0] x3;
      input [$clog2(MAX_RESOLUTION_Y)-1:0] y3;
      // point P
      input [$clog2(MAX_RESOLUTION_X)-1:0] xp;
      input [$clog2(MAX_RESOLUTION_Y)-1:0] yp;

      real                                 area_ABC, // area of ABC
                                           area_PBC, // area of PBC
                                           area_PAC, // area of PAC
                                           area_PAB, // area of PAB
                                           area_sum, // sum of PBC,PAC,PAB areas
                                           area_dif; // area_ABC - area_sum
      begin
         area_ABC = area(x1, y1, x2, y2, x3, y3);
         area_PBC = area(xp, yp, x2, y2, x3, y3);
         area_PAC = area(x1, y1, xp, yp, x3, y3);
         area_PAB = area(x1, y1, x2, y2, xp, yp);

         area_sum = area_PBC + area_PAC + area_PAB;
         area_dif = area_sum - area_ABC;

         // take absolute value of area_dif
         if(area_dif < 0)
           area_dif = -1.0 * area_dif;

         inside_triangle = (area_dif <  0.001);

      end
   endfunction // inside_triangle

   initial begin
      $dumpfile("test.vcd");
      $dumpvars;
   end // initial begin

   initial begin
      triangle_P1_x = $urandom_range(MAX_RESOLUTION_X);
      triangle_P1_y = $urandom_range(MAX_RESOLUTION_Y);

      triangle_P2_x = $urandom_range(MAX_RESOLUTION_X);
      triangle_P2_y = $urandom_range(MAX_RESOLUTION_Y);

      triangle_P3_x = $urandom_range(MAX_RESOLUTION_X);
      triangle_P3_y = $urandom_range(MAX_RESOLUTION_Y);

      // Assign input point x as 0 to start
      input_point_x = 0;

      // Have the input point y moved to the beginning row of the triangle
      if((triangle_P1_y < triangle_P2_y) && (triangle_P1_y < triangle_P3_y))
        input_point_y = triangle_P1_y;
      else if(triangle_P2_y < triangle_P3_y)
        input_point_y = triangle_P2_y;
      else
        input_point_y = triangle_P3_y;

      // If the triangle doesn't start at the lowest possible value already move
      // the input point 1 position earlier to verify that an empty line is
      // correctly read as empty.
      if(input_point_y > 0)
        input_point_y = input_point_y - 1;

      if((triangle_P1_y >= triangle_P2_y) && (triangle_P1_y >= triangle_P3_y))
        end_row = triangle_P1_y;
      else if(triangle_P2_y >= triangle_P3_y)
        end_row = triangle_P2_y;
      else
        end_row = triangle_P3_y;

      // Have end_row moved 1 row beyond the end of the triangle if it isn't
      // already at the last row
      if(end_row < $clog2(MAX_RESOLUTION_Y) - 1)
        end_row = end_row + 1;

   end // initial begin

   initial begin
      $display ("Triangle points are\n");
      $display ("\tx1:%d, y1:%d,\n\tx2:%d, y2:%d,\n\tx3:%d, y3:%d\n",
                triangle_P1_x, triangle_P1_y,
                triangle_P2_x, triangle_P2_y,
                triangle_P3_x, triangle_P3_y,
                input_point_x, input_point_y);

      while(input_point_y <= end_row) begin
         if(is_inside_triangle != inside_triangle(triangle_P1_x, triangle_P1_y,
                                                  triangle_P2_x, triangle_P2_y,
                                                  triangle_P3_x, triangle_P3_y,
                                                  input_point_x, input_point_y))
           begin
              $display ("%g: Calculation incorrect at px = %d, py = %d\n",
                        $time,input_point_x, input_point_y);
           end

         #10;
         // increment the input point, accounting for the end of a row
         if(input_point_x < MAX_RESOLUTION_X)
           begin
              input_point_x = input_point_x + 1;
           end
         else
           begin
              input_point_x = 0;
              input_point_y = input_point_y + 1;
           end
      end // while (input_point_y <= end_row)

      $finish;

   end // initial begin
endmodule // within_triangle_tb
