
mouths = 10;

ring_diameter = 250;
//ring_minor_height = 20;
ring_major_height = 40;

wire_diameter = 0.0808 * 25.4; // 12 gauge


module ring_wire() {
    for (i = [0:mouths-1])
    rotate([0, 0, 360/mouths*i])
    translate([ring_diameter/2, 0, 0])
    cylinder($fn=15, d=wire_diameter, ring_major_height, center=true);

    major_distance = cos(360/mouths/2) * ring_diameter/2;
    ring_major_side_length = 2 * sin(360/mouths/2) * ring_diameter/2;

    for (i = [0:mouths-1])
    for (dir = [-1, 1])
    rotate([0, 0, 360/mouths*i + 360/mouths/2])
    translate([0, 0, dir*ring_major_height/2])
    rotate([90, 0, 0])
    translate([major_distance, 0, 0])
    cylinder($fn=15, d=wire_diameter, ring_major_side_length, center=true);
    
    for (i = [0:mouths-1])
    for (dir = [-1, 1])
    rotate([0, 0, 360/mouths*i])
    translate([0, 0, dir*ring_major_height/2])
    rotate([90, 0, 0])
    translate([ring_diameter/2, 0, 0])
    sphere($fn=50, d=12);
}

difference() {
    translate([0, 0, -ring_major_height/2 - 2.5]) cylinder($fn=50, d=ring_diameter+5,h=5, center=true);
    translate([0, 0, -ring_major_height/2 - 2.5]) cylinder($fn=50, d=ring_diameter-20,h=5.2, center=true);
    ring_wire();
}

