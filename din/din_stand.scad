use <polyround.scad>;

module dinRail(
   width=35,         /* DIN rail total width (usually 35) */
   pocket_width=25,  /* width of the indented portion of the rail (usually 25) */
   depth=7.5,        /* Total thickness of the rail */
   thickness=1,      /* Thickness of the rail sheet metal */
   length=6*25.4     /* Length of rail */
) {
    id = 0.5;
    od = id + thickness;

    linear_extrude(length)
    polygon(points=polyRound([
        [  0, 0, 0],
        [  0, width/2 - pocket_width/2, od ],
        [  -depth + thickness, width/2 - pocket_width/2, id ],
        [  -depth + thickness,  width - (width/2 - pocket_width/2), id ],
        [  0, width - (width/2 - pocket_width/2), od ],
        [  0, width, 0 ],
        [  -thickness, width, 0 ],
        [  -thickness, width - (width/2 - pocket_width/2) + thickness, id ],
        [  -depth, width - (width/2 - pocket_width/2) + thickness, od ],
        [  -depth, width/2 - pocket_width/2 - thickness, od ],
        [  -thickness, width/2 - pocket_width/2 - thickness, id ],
        [  -thickness, 0, 0 ],
    ]));
}

module dinStand(
    display_angle=30,      /* Angle back from straight up and down to hold the rail */
    display_height=89.25,  /* Height of the bottom of the rail */
    din_width=35,          /* DIN rail total width (usually 35) */
    din_pocket_width=25,   /* width of the indented portion of the rail (usually 25) */
    din_depth=7.5,         /* Total thickness of the rail */
    din_thickness=1,       /* Thickness of the rail sheet metal */
    toe_angle=55,          /* Angle for the bottom "toe" */
    toe_length=115         /* How far forward the toe comes */
) {
    borders = 9;
    corner_radius = 3;

    module top() {
        rail_skew_height = din_width * cos(display_angle);
        stand_height = display_height + rail_skew_height + borders;

        cutout_x = borders + (stand_height - display_height)*tan(display_angle);

        difference() {
            polygon(points=polyRound([
                [ 0, 0, corner_radius ],
                [ 0, stand_height, corner_radius ],
                [ borders, stand_height, corner_radius ],
                [ borders + tan(display_angle)*(stand_height - borders), borders, 0 ],
                [ borders + tan(display_angle)*(stand_height - borders), 0, 0 ]
            ]));

            translate([cutout_x, display_height])
            rotate([0, 0, display_angle])
            translate([-din_depth+din_thickness, din_width/2-din_pocket_width/2 - din_thickness - 1])
            square([din_depth-din_thickness, din_pocket_width+2*din_thickness+1]);
        }
    }

    module toe() {
        toe_height = (toe_length - borders)/tan(toe_angle);
        polygon(points=polyRound([
            [ borders, 0, 0 ],
            [ borders, toe_height, 0 ],
            [ toe_length, borders, corner_radius ],
            [ toe_length - borders/3*2, 0, corner_radius ],
        ]));
    }

    linear_extrude(4)
    union() {
        top();
        toe();
    }
}

translate([33, 89.25])
rotate([0,0,30])
#dinRail();

dinStand();
