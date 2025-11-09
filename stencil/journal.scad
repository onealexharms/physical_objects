SMIDGE = 5;
PENCIL_GAP = 2;
FULL_WIDTH = 130;
FULL_DEPTH = 160;
THICKNESS = 2;
MARGIN = 10;
SIDE_MARGIN = MARGIN/2;
TOP_MARGIN = MARGIN/2;
LINE_WIDTH = FULL_WIDTH - MARGIN;
DOTS_SPACING = 5;
LINES_SPACING = DOTS_SPACING * 1.5;
LINES_START = FULL_DEPTH/2;
SQUARE_SIZE = 40;
CIRCLE_SIZE = 40;
BULLET_SIZE = 5;
CIRCLE_X = MARGIN + SQUARE_SIZE + CIRCLE_SIZE/2;
BULLETS_X = FULL_WIDTH - MARGIN - BULLET_SIZE/2;
BULLETS_Y = MARGIN + SQUARE_SIZE;
CALENDAR_X = 10;
CALENDAR_Y = BULLETS_Y;
HOLE_THICKNESS = THICKNESS + SMIDGE;
WEEKS = 6;
DAYS = 9;//put 9 to get 7 squares - fix fix fix

module writing_line(y) {
  translate([SIDE_MARGIN, y, -SMIDGE/2]) {
    cube([LINE_WIDTH, PENCIL_GAP, HOLE_THICKNESS]);
    }
  }

module writing_lines(y0, section_end) {
  for (y = [y0 : LINES_SPACING : section_end]) {
    writing_line(y);
    }
  }

module square_hole(x, y, size) {
  translate([x, y, -SMIDGE/2]) {
    cube([size,size,HOLE_THICKNESS]);
    }
  }

module round_hole(x, y, size) {
  translate([x, y+size/2, -SMIDGE/2]) {
    cylinder(h=HOLE_THICKNESS, d=size);
    }
  }

module bullets(x, y0, section_end) {
  for (y = [y0 :  LINES_SPACING : section_end]) {
    round_hole(x,y,BULLET_SIZE); 
    }
  }

module calendar() {
  // I'm printing the file as a basic test but this module is wrong
  for (y = [CALENDAR_Y : LINES_SPACING : WEEKS*DOTS_SPACING + CALENDAR_Y]) {
    for (x = [CALENDAR_X : LINES_SPACING : DAYS*DOTS_SPACING + CALENDAR_X]) {
      square_hole(x + CALENDAR_X, y, DOTS_SPACING);
    }
  }
}

module cut_outs() {
  union() {
    writing_lines(100,150);
    square_hole(SIDE_MARGIN,TOP_MARGIN,SQUARE_SIZE);
    round_hole(CIRCLE_X,TOP_MARGIN,CIRCLE_SIZE);
    bullets(110, 10, SQUARE_SIZE);
    calendar();
    }
  }

module stencil() {
  difference() {
    cube([FULL_WIDTH, FULL_DEPTH, THICKNESS]);
    cut_outs();
    }
  }

stencil();
