include <BOSL2/std.scad>;

$fn = 50;

module broom_threads(
    id = (17.5 - 2*1),
    thread_width = 3,
    thread_depth = 1,
    thread_pitch = 4.6,
    clearance = 0.5,
    length = 23,
    inside = true,
)
{
    chamfer_distance = 2;
    
    module part(n) {
        translate([0, 0, n])
        rotate([0, 0, 360 * (n/thread_pitch)])
        translate([-id/2 + thread_width/2 - thread_depth, 0])
        sphere(d=thread_width + (inside ? 0 : clearance));
    }
    
    module thread() {
        step = thread_pitch/25;
        for (n = [-thread_width/2 : step : length + thread_width/2]) 
        hull() {
            part(n);
            part(n+step);
        }
    }

    cylinder(d=id + (inside ? 0 : clearance), h=length);
    
    if (inside) {
        intersection() {
            thread();

            union() {
               cylinder(d = id + 2 * thread_depth + 1, h=length - chamfer_distance);

               // thread chamfer
               translate([0, 0, length-chamfer_distance])
               cylinder(d1 = id + 2 * thread_depth + 1, d2 = id, h=chamfer_distance);
            }
        }
    } else {
        intersection() {
            thread();
            cylinder(d = id + 2 * thread_depth + 1, h=length);
        }

        // hole chamfer
        translate([0, 0, length-chamfer_distance])
        cylinder(d2 = id + 2 * thread_depth + 1, d1 = id, h=chamfer_distance);
    }
}

module bracket(
    side=false,
    thread_diameter = 17.5,
    thread_tpi = 5,
    thread_height = 1*INCH,
    base_height = 3/8*INCH,
    base_width = 2.5*INCH,
    bolt_distance = 2*INCH,
    bolt_hole_diameter = 6.5,
    material_thickness = 10,
)
{
    module base() {
        translate([0, 0, base_height/2])
        cuboid([base_width, base_width, base_height], rounding=3, edges="Z");
    }

    module threads() {
        broom_threads(inside=false, length=thread_height);
    }
    
    module bolt_holes() {
        for (x = [-bolt_distance/2, +bolt_distance/2])
        for (y = [-bolt_distance/2, +bolt_distance/2])
        translate([x, y, -0.1])
        cylinder(d=bolt_hole_diameter, h=base_height+0.2);
    }

    if (side) {
        difference() {
            union() {
                translate([75, 0, 0])
                cylinder(d2=1*INCH, d1=1.5*INCH, h=25);
                
                //translate([50, 0, 2.5/2])
                //cuboid([100, 100, 2.5]);
                translate([75, 0, -material_thickness/2])
                cuboid([50, 50, material_thickness+0.2]);
                
                translate([50, 0, -(3/8*INCH)/2 - material_thickness])
                cuboid([100, 100, 3/8*INCH]);
            }

            translate([0, 0, -material_thickness/2])
            #cuboid([100, 100, material_thickness]);
            
            translate([75, 0, 0])
            threads();
        }
    } else {
        difference() {
            union() {
                cylinder(d2=1*INCH, d1=2*INCH, h=25);
                base();
            }

            threads();
            bolt_holes();
        }
    }
}

bracket(side=false, $fn=45);
