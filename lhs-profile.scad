// stem def
// https://www.cherrymx.de/en/dev.html

$stem_height=3.8;
$stem_location=1.2;
$stem_diameter=5.5;

// expansion rate for resin shrinkage
$shrink_rate=0;

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

module single_stem(){
    translate([0,0,$stem_height/2+$stem_location]){
        difference(){
            stem_base();
            stem_cross();
        }
    }
}

module stems(unit=1){
    if (unit < 2){
        single_stem();
    }
    if (unit >= 2 && unit < 3) {
        union(){
            single_stem();
            translate([11.938*(1+$shrink_rate),0,0]) single_stem();
            translate([-11.938*(1+$shrink_rate),0,0]) single_stem();
        }
    }
    if (unit == 6.25) {
        union(){
            single_stem();
            translate([50*(1+$shrink_rate),0,0]) single_stem();
            translate([-50*(1+$shrink_rate),0,0]) single_stem();
        }
    }
    if (unit == 7) {
        union(){
            single_stem();
            translate([57.15*(1+$shrink_rate),0,0]) single_stem();
            translate([-57.15*(1+$shrink_rate),0,0]) single_stem();
        }
    }
}

// lhs profile
$lhs_top_side=10;
$lhs_wall_thick=1.6;
$lhs_hole_side=15.4;
$lhs_height=11;
$lhs_radius=42;

module lhs_outer(unit=1){
    bottom_side=$lhs_hole_side+$lhs_wall_thick*2;
    top_side=$lhs_top_side;
    hull(){
        hull(){
            translate([19.05/2*(unit-1)*(1+$shrink_rate),0,0]){
                cube([bottom_side,bottom_side,0.001], true);
            }
            translate([-19.05/2*(unit-1)*(1+$shrink_rate),0,0]){
                cube([bottom_side,bottom_side,0.001], true);
            }
        }
        hull(){
            translate([19.05/2*(unit-1)*(1+$shrink_rate),0,$lhs_height]){
                cube([top_side,top_side,0.001], true);
            }
            translate([-19.05/2*(unit-1)*(1+$shrink_rate),0,$lhs_height]){
                cube([top_side,top_side,0.001], true);
            }
        }
    }
}

module text_model(char=""){
    linear_extrude(0.5) {
        text(
            char,
            font = "DejaVu Sans:style=Bold",
            size = 2,
            halign = "center",
            valign = "center"
        );
    }
}


module lhs_inner(char="",unit=1){
    bottom_side=$lhs_hole_side;
    top_side=$lhs_top_side+1.8;
    union(){
        hull(){
            hull(){
                translate([19.05/2*(unit-1)*(1+$shrink_rate),0,0]){
                    cube([bottom_side,bottom_side,0.001], true);
                }
                translate([-19.05/2*(unit-1)*(1+$shrink_rate),0,0]){
                    cube([bottom_side,bottom_side,0.001], true);
                }
            }
            hull(){
                translate([
                    19.05/2*(unit-1)*(1+$shrink_rate),
                    0,
                    $stem_height+$stem_location
                ]){
                    cube([top_side,top_side,0.001], true);
                }
                translate([
                    -19.05/2*(unit-1)*(1+$shrink_rate),
                    0,
                    $stem_height+$stem_location
                ]){
                    cube([top_side,top_side,0.001], true);
                }
            }
            cube([bottom_side,bottom_side,0.001], true);
            translate([0,0,$stem_height+$stem_location]){
                cube([top_side,top_side,0.001], true);
            }
        }
        if (char != ""){
            translate([0,$stem_diameter-1.2,$stem_height+$stem_location]){
                mirror([1,0,0]) text_model(char);
            }
        }
    }
}

module multi_unit_sphere(unit=1){
    $fn=128;
    scale([unit*1.5^(unit-1),1,1]) sphere($lhs_radius);
}

module lhs(y=0,z=0,char="",unit=1){
    union(){
        stems(unit);
        difference(){
            difference(){
                lhs_outer(unit=unit);
                lhs_inner(char=char,unit=unit);
            }
            translate([
                0,
                y,
                $lhs_height+$lhs_radius-z
            ]) multi_unit_sphere(unit=unit);

        }
    }
}

module lhs_convex(y=0,z=0,char="",unit=1){
    union(){
        stems(unit);
        intersection(){
            difference(){
                lhs_outer(unit=unit);
                lhs_inner(char=char,unit=unit);
            }
            rotate([0,90,0]) {
                $fn=128;
                rotate([0,0,15]) scale([1,1.8,1]) cylinder(19.05*unit*(1+$shrink_rate),8,8,true);
            }
        }
    }    
}

module lhs_r4(unit=1){
    lhs(4,3.75, "R4", unit);
}

module lhs_r3(unit=1){
    lhs(2,4.75, "R3", unit);
}

module lhs_r2(unit=1){
    lhs(-4,4.5, "R2", unit);
}

module lhs_r1(unit=1){
    lhs(-8,2.75, "R1", unit);
}

module lhs_home(){
    union(){
        lhs(3,4.5,char="R3",unit=1);
        hull(){
           translate([-3,-4.5,7]) sphere(0.5);
           translate([3,-4.5,7]) sphere(0.5);
        }
    }
}

module lhs_space(unit=1){
    lhs_convex(8,2.75,"R4",unit);
}

//$shrink_rate=0.003;
