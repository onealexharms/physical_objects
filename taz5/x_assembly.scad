
use <x_motor_mount.scad>;
use <x_carriage.scad>;
use <x_idler.scad>;

translate([-25, 0, 35]) rotate([0, -90, 90]) x_motor_mount();
translate([100, -(6 + 28.5 + 4.25), -20]) rotate([90,0,180]) x_carriage();
translate([125, -17.5, 0]) rotate([0, 90, 180]) x_idler();

rail_thickness = 8;

translate([40, 0, 0])
color("grey") 
union() {
    translate([0, -20/2, 0]) cube([150, 20, 20], center=true);
    translate([0, -20 - rail_thickness/2, 0]) cube([150, rail_thickness, 12], center=true);
}

//TODO:

// - [ ] Extend the belt grippers
// - [ ] Make the limit switch work
// - [ ] Make the motor mount handle the extrusion/rail
// - [ ] Make the idler handle the extrusion/rail 
// - [ ] 
