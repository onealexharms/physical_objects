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
