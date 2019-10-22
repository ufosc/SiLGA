# SiLGA
Simple Lightweight Graphics Accelerator (SiLGA) is a new Verilog-based project to create a device to render 2D images. Help is needed primarily in the form of digital design and writing test benches. People who have taken Digital Design can most easily work on this project, although those with who have taken Digital Logic and/or Computer Organization are also welcome to get involved and should be able to get up to speed. Since the hardware description language taught at University of Florida is VHDL, learning Verilog will be a new experience for almost everyone.

SiLGA itself is divided into three major parts:
* Handling input commands & translating into device functionality
* The graphics rendering pipeline
* Translating and outputting the rendered graphics to an external display protocol.

For version 0.0.1 these are the following goals for each portion, respectively:
* Take input commands via SPI which specify the points of static triangles to draw and an 8-bit color value.
* Render up to 8 triangles at a time, with proper layering of them, line-by-line for a computer screen.
* Translate the output of the render pipeline into a VGA output for a computer monitor.
