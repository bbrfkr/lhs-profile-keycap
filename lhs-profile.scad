// stem def
// https://www.cherrymx.de/en/dev.html

$stem_height=3.8;
$stem_location=1.2;
$stem_diameter=5.5;

module stem_cross(){
    width=1.17;
    length=4.1;
    union(){
        cube([width, length, $stem_height], true);
        cube([length, width, $stem_height], true);
    }
}

module stem_base(){
    $fn=128;
    radius=$stem_diameter/2;
    cylinder($stem_height, radius, radius, true);
}

module stem(){
    translate([0,0,$stem_height/2+$stem_location]){
        difference(){
            stem_base();
            stem_cross();
        }
    }
}

// lhs profile
$lhs_top_side=10;
$lhs_wall_thick=1.4;
$lhs_hole_side=15.4;
$lhs_height=11;
$lhs_radius=42;

module lhs_outer(){
    bottom_side=$lhs_hole_side+$lhs_wall_thick*2;
    top_side=$lhs_top_side;
    hull(){
        cube([bottom_side,bottom_side,0.001], true);
        translate([0,0,$lhs_height]){
            cube([top_side,top_side,0.001], true);
        }
    }
}

module text_model(char=""){
    linear_extrude(0.5) {
        text(
            char,
            font = "DejaVu Sans:style=Bold",
            size = 3,
            halign = "center",
            valign = "center"
        );
    }
}


module lhs_inner(char=""){
    bottom_side=$lhs_hole_side;
    top_side=$lhs_top_side+3;
    union(){
        hull(){
            cube([bottom_side,bottom_side,0.001], true);
            translate([0,0,$stem_height+$stem_location]){
                cube([top_side,top_side,0.001], true);
            }
        }
        translate([0,$stem_diameter-1,$stem_height+$stem_location]){
            mirror([1,0,0]) text_model(char);
        }
    }    
}

module multi_unit_sphere(unit_count=1){
    $fn=80;
    hull(){
        translate([-19.05/2*(unit_count-1),0,0]) sphere($lhs_radius);
        translate([19.05/2*(unit_count-1),0,0]) sphere($lhs_radius);
    }
}

module lhs(y=0,z=0,char=""){
    union(){
        stem();
        difference(){
            difference(){
                lhs_outer();
                lhs_inner(char=char);
            }
            translate([
                0,
                y,
                $lhs_height+$lhs_radius-z
            ]) multi_unit_sphere(1);

        }
    }
}

module lhs_space(y=0,z=0){
    union(){
        stem();
        difference(){
            difference(){
                lhs_outer();
                lhs_inner();
            }
        }
        difference(){
            translate([
                0,
                y,
                -$lhs_height-$lhs_radius+z
            ])sphere($lhs_radius);
        }

    }
}
// space
//translate([0,19.05*-1,0]) lhs_space(8,3);
// r4
lhs(8,2.75, "R4");
// r3
//translate([0,19.05,0]) lhs(3,4.5, "R3");
// r2
//translate([0,19.05*2,0]) lhs(-4,4.4, "R2");
// r1
//translate([0,19.05*3,0]) lhs(-9,2.75, "R1");
