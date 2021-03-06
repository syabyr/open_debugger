

//pcb长宽高
pcb_length=50;
pcb_width=25;
pcb_hight=1.6;

//typec连接器的宽和高
typec_hight=3.2;
typec_width=9;

//2.53牛角座的
dc5_hight=8.7;
dc5_width=dc5_hight;
dc5_length=20;

Case_Thickness = 1.5;     //Wall Thickness
Case_Gap = 0.25;


Case_L = pcb_length + Case_Thickness*2 + Case_Gap+2;
Case_W = pcb_width + Case_Thickness*2 + Case_Gap;
Case_Z = Case_Thickness + dc5_hight+2;      //Total height of case

//Shell hollow inside dimensions
CutOut_L = pcb_length + Case_Gap*2;
CutOut_W = pcb_width + Case_Gap*2;

CutOut_Z = Case_Z - Case_Thickness;


module MountingPeg()
{
	union() {
		cylinder(h=Case_PCB_Z, d=BB_Hole_OD, $fn=25);
		cylinder(h=Case_PCB_Z/2, d1=BB_Hole_OD*1.5, d2=BB_Hole_OD, $fn=25);
		translate([0,0,Case_PCB_Z-0.1]) cylinder(h=BB_Z/2+0.1,d=BB_Hole_ID, $fn=25);
		translate([0,0,Case_PCB_Z+BB_Z/2-0.1]) cylinder(h=BB_Z/2+0.1,d1=BB_Hole_ID, d2=BB_Hole_ID/2, $fn=25);
	}
}

module CornerGrip(R,T,Z,D,CutOff)
{
	rotate([0,0,D]) {
		difference() {
			translate([R,R,0]) cylinder(r=R, h=Z, $fn=50);
			translate([R,R,0]) cylinder(r=R, h=Z, $fn=50);
			translate([R-CutOff,0,0]) cylinder(r=R, h=Z, $fn=50);
			translate([0,R-CutOff,0]) cylinder(r=R, h=Z, $fn=50);
		}
	}
}



module Base()
{
	union() {
        //cube([pcb_length,pcb_width,pcb_hight+10],center = false);
	difference() {
		//Outer Shell of Case (Join two cubes together with different corner radii to achieve different size corners on each end)
		translate([-Case_Thickness-Case_Gap, -Case_Thickness-Case_Gap, -Case_Thickness]) {
		union() {
            cube([Case_L,Case_W,Case_Z],center = false);
			//roundCornersCube(Case_L, Case_W, Case_Z, Case_SmCurve_R);
			//translate ([Case_SmCurve_R,0,0]) roundCornersCube(Case_L-Case_SmCurve_R, Case_W, Case_Z, Case_SmCurve_R);
		}}
		
		//Hollow Out Inside of Case
        
		translate([-Case_Gap,-Case_Gap,0]) {
		union() {
            //挖空部分
            cube([pcb_length+Case_Gap/2,pcb_width+Case_Gap/2,pcb_hight+10],center = false);
		}}
		
		//Components Cutouts
        
        //DC10
        translate([pcb_length+dc5_width/2+0.5,pcb_width/2,(dc5_hight+2)/2]) cube([dc5_width+2, dc5_length+Case_Gap, dc5_hight+2],center = true);
        
        //USB-C
        translate([0, pcb_width/2, (pcb_hight+typec_hight+dc5_hight)/2]) cube([10, typec_width, typec_hight],center = true);
        
	}
		//Mounting pegs
		translate([3,3,0]) cylinder(h=(dc5_hight-pcb_hight)/2, r=1.5, $fn=25);
		translate([3,pcb_width-3,0]) cylinder(h=(dc5_hight-pcb_hight)/2, r=1.5, $fn=25);
		translate([pcb_length-3,3,0]) cylinder(h=(dc5_hight-pcb_hight)/2, r=1.5, $fn=25);
		translate([pcb_length-3,pcb_width-3,0]) cylinder(h=(dc5_hight-pcb_hight)/2, r=1.5, $fn=25);


		//Dev Station rails
        /*
		if (DevRails_Options == 1) {
			translate([Case_SmCurve_R-Case_Thickness-Case_Gap,Case_W-Case_Thickness-Case_Gap,-Case_Thickness]) DevRail(DSR_L, DSR_W, DSR_H);
			translate([DSR_L+Case_SmCurve_R-Case_Thickness-Case_Gap,-Case_Thickness-Case_Gap,-Case_Thickness]) rotate([0,0,180]) {
				DevRail(DSR_L, DSR_W, DSR_H);
			}
		}
        */

	}
}



color("Green"){
	render(convexity=4) {
		Base();
	}
}


