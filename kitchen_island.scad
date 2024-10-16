board_x = 1.5;
board_z = 3.5;
trash_depth = 12;//width direction
trash_width = 24;//depth direction
width = 48 - trash_width;
depth = 17;
height = 35;

module stick(length) {
  cube([board_x, length, board_z]);
  };

module stick_width() {
  translate([0, board_x, 0]) {
    stick(width-2*board_x);
    };
  };

module stick_height() {
  translate([-board_z/2, 0, 0]) {
    rotate([90, 0, 90]) {
      stick(height);
      };
    };
  };

module stick_depth() {
  color("purple") {
    translate([-board_z/2, 0, 0]) {
      rotate([0, 0, 90]) {
        cube([board_x, depth-board_z, board_z]);
        };
      };
    };
  };

module top_widths() {
  translate([0, 0, height-board_z]) { 
    stick_width();
    translate([-depth -board_x, 0, 0]) {
      stick_width();
      };
    };
  };

module bottom_widths() {
  stick_width();
  translate([-depth -board_x, 0, 0]) {
    stick_width();
  };
};

module main_stick_widths() {
  top_widths();
  bottom_widths();
  };

module main_stick_verticals() {
  color("blue") {
    stick_height();
      translate([-depth, 0, 0]) {
        stick_height(); 
      };
    translate([0, width-board_x, 0]) { 
    stick_height();
      translate([-depth, 0, 0]) {
        stick_height(); 
        };
      };
    };
  };

module trash_stick_depth() {
  color("yellow") {
    translate([0, board_x, 0]) { 
    stick(trash_depth- 2*board_x);
    };
  };
};
module trash_stick_depths() {
  translate([trash_width/2-board_z-board_x, width, 0]) {
  trash_stick_depth();
    };
  translate([-depth-board_x, width, 0]) {
    trash_stick_depth();
    };
  };

module trash_stick_width() {
  color("orange") {
    translate([trash_width/2 - board_z, 0, 0]) {
      rotate([0, 0, 90]) {
        stick(trash_width);
        };
      };
    };
  };

module trash_stick_widths() {
    translate([0, width + trash_depth-board_x, 0]) {
      trash_stick_width();
    };
    translate([0, width, 0]) {
      trash_stick_width();
    };
  };

module top_stick_depths() {
  translate([0, 0, height-board_z]) {
    stick_depth();
    translate([0, width-board_x, 0]) {
      stick_depth();
      };
    };
  };

module bottom_stick_depths() {
  stick_depth();
  translate([0, width-board_x, 0]) {
    stick_depth();
    };
  };

module main_stick_depths() {
  bottom_stick_depths();
  top_stick_depths();
  };

main_stick_verticals();
main_stick_depths();
main_stick_widths();
//trash_stick_widths();
//trash_stick_depths();
