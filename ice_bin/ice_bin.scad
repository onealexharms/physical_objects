wall_thickness=3;
outer_fillet=2;
inner_fillet=4;
outer_width=105-2*outer_fillet;
inner_width=outer_width-2*wall_thickness-2*inner_fillet;
outer_depth=265-2*outer_fillet;
inner_depth=outer_depth-2*wall_thickness-2*outer_fillet;
height=135;
handle_length=90;
bottom_thickness=wall_thickness*2;
center=true;

module inner() {
  minkowski() {
    translate([0,0,bottom_thickness]) {
      cube([inner_width, inner_depth, height], center);
    }
    sphere(inner_fillet);
  }
};

module outer() {
  minkowski() {
    cube([outer_width, outer_depth, height], center);
    sphere(outer_fillet);
  }
}

difference() {
  outer();
  inner();
};
