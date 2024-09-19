big_depth = 99.5;
big_width = 142;
min_height = 5;
max_height = 20;

module slab() {
  hull() {
    cube([big_width, big_depth, min_height]);
    cube([1,big_depth,max_height]);
  }
}

module front_remove() {
  linear_extrude(height=50, center=true, convexity=10, twist=0, slices=10, scale=1.0) {
  polygon(points=[[-1,-1],[108,-1],[65,21.5],[-1,21.5]]); 
  }
}

module back_remove() {
  linear_extrude(height=50, center=false, convexity=10, twist=0, slices=10, scale=1.0) {
  polygon(points=[[85,99.5],[142,78],[143,100]]);
  }
}

module side_remove() {
  linear_extrude(height=50, center=true, convexity=10, twist=0, slices=10, scale=1.0) {
  polygon(points=[[108,-1],[166,-1],[166,78]]);
  }
}

module clamp() {
  difference() {
    translate([0,50,-4])
      cube([142,90,4]);
    translate([-1,60,-1.99])
      cube([144,90,2]);
    }
  }

translate([0,0,4]) {
  difference() {
    union() {
      slab();
      clamp();
    }
    front_remove();
    back_remove();
    side_remove();
    }
  }
