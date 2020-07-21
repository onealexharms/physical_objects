translate([0,50,0])
  cube ([270,40,20]);
union() {
  cube([100,40,20]);
  translate([20,0,0])
    cube([5,40,25]);
}
