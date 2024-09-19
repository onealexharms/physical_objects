wall_thickness=3;
fillet=4;
outer_width=100-(2*fillet + 2*wall_thickness);
inner_width=outer_width-2*wall_thickness-2*fillet;
outer_depth=265-2*fillet;
inner_depth=outer_depth-2*wall_thickness-2*fillet;
height=100;
handle_length=90;
bottom_thickness=wall_thickness*2;
center=true;

module inner() {
  minkowski() {
    translate([0,0,bottom_thickness]) {
      cube([inner_width, inner_depth, height], center);
    }
    sphere(fillet);
  }
};

module outer() {
  minkowski() {
    cube([outer_width, outer_depth, height], center);
    sphere(fillet);
  }
}

difference() {
  outer();
  inner();
};
