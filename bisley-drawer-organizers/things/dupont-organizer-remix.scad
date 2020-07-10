include <MCAD/units.scad>

/* [Global] */
part = "plate"; // [comb:Comb Only,bridge:Bridge Only,plate:Build Plate,assembly:Assembled Parts]

// Length of the cables, excluding header connectors (mm)
cableLength = 200; 
// Number of cable slots per group (1 slot =~ 4 cables)
cablesPerGroup = 10;
// Number of cable groups
numGroups = 5;

/* [Comb] */

combThickness = 3;
combBaseWidth = 7;
combToothLength = 32;
combToothWidth = 1.2;
combSharpLength = 0;
combToothSpacing = 2;
combGroupSpacing = 4;
toothBumpLength = 4;
toothBumpThickness = 1;
teethPerGroup = cablesPerGroup + 1;

/* [Bridge] */

bridgeThickness = 3;
bridgeWidth = 12;
bridgeDentOffset = 5;
bridgeDentWidth = combBaseWidth + 1;
bridgeDentLength = combThickness;
bridgeHoleLength = 2;
bridgeHoleCornerRadius = 2;
bridgeLength = cableLength + bridgeDentOffset * 2;

/* [Hidden] */

combGroupWidth = teethPerGroup * (combToothWidth + combToothSpacing) - combToothSpacing;
combLength = combGroupWidth * numGroups + combGroupSpacing * (numGroups + 1) + combToothWidth * 2;

$fn = 60;

module CombTooth() {
    linear_extrude(combThickness)
    polygon([
        [0, 0], 
        [0, combToothLength],
        [combToothWidth / 2, combToothLength + combSharpLength],
        [combToothWidth, combToothLength],
        [combToothWidth, 0],
    ]);
}

module CombTeethGroup() {
    for (i = [0:teethPerGroup - 1])
        translate([(combToothWidth + combToothSpacing) * i, 0, 0])
        CombTooth();
}

module DupontComb() {
    cube([combLength, combBaseWidth, combThickness]);
    
    translate([0, combBaseWidth, 0]) {
        CombTooth();
    
        translate([combGroupSpacing + combToothWidth, 0, 0])
        for (g = [0:numGroups - 1]) 
        translate([g * (combGroupWidth + combGroupSpacing), 0, 0])
        CombTeethGroup();
        
        translate([combLength - combToothWidth, 0, 0])
        CombTooth();
    }
}

module BridgeIndentation() {
    cube([bridgeDentLength, bridgeDentWidth + epsilon, bridgeThickness + epsilon*2]);
}

module BridgeIndentations() {
  numberOfPairs = floor(bridgeLength/(bridgeDentLength + bridgeDentOffset)/2) - 1;
  for (i=[1:numberOfPairs]) {
    indentationSpacing = -bridgeLength/2 + i*(bridgeDentOffset + bridgeDentLength);
    leftIndentationSpacing = indentationSpacing - bridgeDentLength;
    rightIndentationSpacing = -indentationSpacing;
    translate([leftIndentationSpacing, 0, -epsilon]) 
    BridgeIndentation();
    translate([rightIndentationSpacing, 0, -epsilon]) 
    BridgeIndentation();
  }
}

module DupontBridge() {
    difference() {
        translate([-bridgeLength / 2, -bridgeWidth / 2, 0])
        cube([bridgeLength, bridgeWidth, bridgeThickness]);
        
        BridgeIndentations();
        }
}

module DupontOrganizerPlate() {
    itemSpacing = 4;
    combSize = combToothLength + combBaseWidth + itemSpacing;
    
    for (x = 0, 1) { 
      translate([-combLength / 2, 0, 0]) {
        
        DupontComb();
        translate([0, combSize, 0])
          DupontComb();
        translate([0, -combSize, 0])
          DupontComb();
        translate([0, -2*combSize, 0])
          DupontComb();
      }
    }
    
    for (g=[0:numGroups]) {
        translate([0, combSize * 2 + g * (bridgeWidth + itemSpacing) + bridgeWidth / 2, 0])
        DupontBridge();
    }
}

module DupontOrganizerAssembly() {
    rotate([90, 0, 0])
    DupontComb();
    
    translate([0, cableLength - combThickness, 0])
    rotate([90, 0, 0])
    DupontComb();
    
    color("orange")
    for (g=[0:numGroups]) {
        translate([g * (combGroupWidth + combGroupSpacing) + combToothWidth, bridgeLength / 2 - bridgeDentOffset - bridgeDentLength, bridgeWidth / 2])
        rotate([90, 0, 90])
        DupontBridge();
    }
}

if (part == "comb")
    DupontComb();

if (part == "bridge")
    DupontBridge();

if (part == "plate")
    DupontOrganizerPlate();

if (part == "assembly")
    DupontOrganizerAssembly();
