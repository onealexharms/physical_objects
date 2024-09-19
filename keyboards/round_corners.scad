// creates rounded cube without minkowsi, this one performs
// a lot better than minowski cube which may be important larger designs
// https://pastebin.com/DJULjkMd
// reddit user wildjokers
//
// roundingSphere = one of "sphere" or "circle", a sphere rounds the object 
// along all edges, circle rounds just the corners
//
module roundedCube(length = 10, width = 10, height = 10, radius = 1, center = false, roundingShape = "sphere") {
  if (center) {
    centeredRoundedCube();
  } else {
    nonCenteredRoundedCube();
  }

  module centeredRoundedCube() {
    z = roundingShape == "sphere" ? (height - (radius * 2)) / 2 : height / 2;

    echo("Centered Rounded Cube");
    echo("height: ", height);
    echo("Z: ", z);

    hull() {
      translate([0, 0, -z]) rectangle(length, width, radius, roundingShape);
      translate([0,0, z]) rectangle(length, width, radius, roundingShape);
    }
  }

  module nonCenteredRoundedCube() {
    z1 = roundingShape == "sphere" ? height - radius : height ;
    z2 = roundingShape == "sphere" ? radius : 0;
    x = length / 2;
    y = width / 2;
    echo("Non-Centered Rounded Cube");
    echo("height: ", height);
    echo("x: ", x);
    echo("y: ", y);
    echo("Z1: ", z1);
    echo("Z2: ", z2);

    hull() {
      translate([x, y, z1]) rectangle(length, width, radius, roundingShape);
      translate([x, y, z2]) rectangle(length, width, radius, roundingShape);
    }
  }

  module rectangle(length, width, radius, roundingShape) {
    x = length - radius;
    y = width - radius;
    hull() {
      translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0]) roundingShape(radius, roundingShape);
      translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0]) roundingShape(radius, roundingShape);
      translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0]) roundingShape(radius, roundingShape);
      translate([(x/2)-(radius/2), (y/2)-(radius/2), 0]) roundingShape(radius, roundingShape);
    }
}
    module roundingShape(radius, roundingShape) {
      if (roundingShape == "sphere") {
        sphere(r = radius);
      } else {
        //make the extrusion small to make it a 3d object but don't add any size to the requested dimensions
        linear_extrude(0.000000000001) circle(r = radius);
        }
        }
