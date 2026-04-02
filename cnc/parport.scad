use <polyround.scad>;

$fn = 25;
inch = 25.4;

hole_width = 1.564 * inch;
hole_height = 0.414 * inch;
screw_distance = 1.868 * inch;
screw_diameter = 5;
jack_count = 3;
jack_diameter = 4.5;

total_width = screw_distance + 2*screw_diameter;
total_height = hole_height + 2*2;

inner_radius = 1.5;
outer_radius = 1.5;

module parportPlate() {
    module boss() {
        linear_extrude(6)
        polygon(points=polyRound([
            [ (total_width - hole_width)/2, (total_height - hole_height)/2, inner_radius ],
            [ (total_width - hole_width)/2, total_height - (total_height - hole_height)/2, inner_radius ],
            [ total_width - (total_width - hole_width)/2, total_height - (total_height - hole_height)/2, inner_radius ],
            [ total_width - (total_width - hole_width)/2, (total_height - hole_height)/2, inner_radius ],
        ]));
    }

    module plate() {
        linear_extrude(2)
        polygon(points=polyRound([
            [ 0, 0, outer_radius ],
            [ 0, total_height, outer_radius ],
            [ total_width, total_height, outer_radius ],
            [ total_width, 0, outer_radius ],
        ]));
    }

    module screw_positions() {
        for (x = [
            (total_width - screw_distance) / 2,
            total_width - (total_width - screw_distance) / 2
        ])
        translate([x, total_height/2, 0])
        children();
    }

    module jack_positions() {
        gap_width = hole_width / (jack_count + 1);
        for (x = [ gap_width : gap_width : hole_width - 0.1 ])
        translate([(total_width - hole_width) / 2 + x, total_height/2, 0])
        children();
    }

    difference() {
        union() {
            boss();
            plate();
        }
        screw_positions()
            translate([0, 0, -0.5])
            cylinder(d=screw_diameter + 0.5, h=10, $fn=25);
        jack_positions()
            translate([0, 0, -0.5])
            cylinder(d=jack_diameter + 0.5, h=10, $fn=25);
    }
}

parportPlate();
