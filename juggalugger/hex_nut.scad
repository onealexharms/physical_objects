use <../broom/threads.scad>;

module hex_nut() {
    difference() {
        translate([0,0,0.1])
        cylinder(h=23-0.2,d=27,$fn=6);
        broom_threads(inside=false);
    }
}

hex_nut();
