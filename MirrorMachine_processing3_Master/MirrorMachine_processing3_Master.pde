/*
 Mirror Machine 
 Chris Gantt | 2018 | facebook.com/gantt.art

 This program was designed to randomly take a section of an image, rotate it, 
 and mirror it across the y-axis to create a new symmetrical design. With a built-in
 gui, controlP5, Mirror Machine allows you to change the rotation and the percent of
 the image that is mirrored in real time. 
 
 Compatible with Processing version 3.3.7
 Requires controlP5 library http://www.sojamo.de/libraries/controlP5/#installation
   -upon downloading and unzipping the folder, place the controlP5 folder inside
    the Processing/libraries folder.
*/

import controlP5.*;
ControlP5 cp5;

Slider mirrorPercentageSlider;
Toggle horizontalFlipToggle;
Toggle verticalFlipToggle;
RadioButton imageRotationSelector;
int distanceFromEdge = 250;

PImage img;
PImage savingImage;
float randomNumber= random(.05, .99);
float mirror_percentage = randomNumber;
boolean imageFlippedHorizontally;
boolean imageFlippedVertically;
int mirrorType = 8; //for opening screen; mirrorType 8 has no mirrors


void setup() {  
  size(displayWidth, displayHeight); 
  img = loadImage("OpeningScreen.jpg");
  if (img.height!=displayHeight) {
    img.resize(0, displayHeight);
  }
PFont verdanaFont = createFont("Verdana", 11); 
ControlFont font = new ControlFont(verdanaFont);  

  cp5 = new ControlP5(this);
  cp5.setFont(font);
  cp5.addButton("choose_image")
    .setPosition(displayWidth-distanceFromEdge, 25)
      .setSize(115, 30)
        .setLabel("choose image")    
          ;
  mirrorPercentageSlider = cp5.addSlider("mirror_percentage", .05, .99, mirror_percentage, displayWidth-distanceFromEdge, 65, 100, 30)
    .setLabel("mirror percentage")
      ;     
  horizontalFlipToggle = cp5.addToggle("horizontal_flip")
    .setPosition(displayWidth-distanceFromEdge, 145)
      .setSize(60, 25)
        .setMode(ControlP5.SWITCH)
          .setLabel("horizontal flip");
  ; 
  verticalFlipToggle = cp5.addToggle("vertical_flip")
    .setPosition(displayWidth-distanceFromEdge, 195)
      .setSize(60, 25)
        .setMode(ControlP5.SWITCH)
          .setLabel("vertical flip");   
  ;     
  cp5.addButton("rotate_clockwise")   
    .setPosition(displayWidth-distanceFromEdge, 245)
      .setSize(140, 30)
        .setLabel("rotate clockwise");    
  ;     
  cp5.addButton("rotate_counterclockwise")   
    .setPosition(displayWidth-distanceFromEdge, 285)
      .setSize(195, 30)
        .setLabel("rotate counterclockwise");
  ;  
  cp5.addButton("random_mirror")
    .setPosition(displayWidth-distanceFromEdge, 105)
      .setSize(125, 30)
        .setLabel("random mirror");
  ;
  cp5.addButton("save_image")
    .setPosition(displayWidth-125, 25)
      .setSize(95, 30)
        .setLabel("save image");     
  ;
}

void draw() {
  background(0);
  image(img, 0, 0);

  if (mirrorType==0) {
    MirrorImageSectionAcrossYAxis(mirror_percentage);
    horizontalFlipToggle.setValue(false);
    verticalFlipToggle.setValue(false);
  } 
  if (mirrorType==1) {
    HorizontalFlipAndMirrorImageSectionAcrossYAxis(mirror_percentage);
    horizontalFlipToggle.setValue(true);
    verticalFlipToggle.setValue(false);
  }
  if (mirrorType==2) {
    MirrorUpsideDownSectionAcrossYAxis(mirror_percentage);
    horizontalFlipToggle.setValue(false);
    verticalFlipToggle.setValue(true);
  }
  if (mirrorType==3) {
    Mirror180DegreeRotatedImageSectionAcrossYAxis(mirror_percentage);
    horizontalFlipToggle.setValue(true);
    verticalFlipToggle.setValue(true);
  } 
  if (mirrorType==4) {
    Mirror90DegreeRotatedImageSectionAcrossYAxis(mirror_percentage);
    horizontalFlipToggle.setValue(false);
    verticalFlipToggle.setValue(false);
  }
  if (mirrorType==5) {
    Mirror90DegreeRotatedAndFlippedImageSectionAcrossYAxis(mirror_percentage);
    horizontalFlipToggle.setValue(true);
    verticalFlipToggle.setValue(false);
  }
  if (mirrorType==6) {
    Mirror270DegreeRotatedImageSectionAcrossYAxis(mirror_percentage);
    horizontalFlipToggle.setValue(false);
    verticalFlipToggle.setValue(true);
  }
  if (mirrorType==7) {
    Mirror270DegreeRotatedAndFlippedImageSectionAcrossYAxis(mirror_percentage);
    horizontalFlipToggle.setValue(true);
    verticalFlipToggle.setValue(true);
  }
}

public void choose_image() {
  selectInput("Choose an image", "inputFile");
}
void inputFile(File selected) {           
  img = loadImage(selected.getAbsolutePath());  
  resizeImage();
  mirrorType=0;
  mirrorPercentageSlider.setValue(.5);
  horizontalFlipToggle.setValue(false);
  verticalFlipToggle.setValue(false);
}


void resizeImage() {
  if (img.height>=img.width) {
    img.resize(0, displayWidth/2);
  }
  if (img.width>img.height) {
    img.resize(displayWidth/2, 0);
  }
}


void save_image() {
  if (mirrorType<4) {
    savingImage = createImage(int((img.width * mirror_percentage * 2)-1), img.height, RGB);
    savingImage = get(1, 0, int((img.width * mirror_percentage * 2)-2), img.height);
  }
  if (mirrorType>3) {
    savingImage = createImage(int((img.height * mirror_percentage * 2)-1), img.width, RGB);
    savingImage = get(1, 0, int((img.height * mirror_percentage * 2)-2), img.width);
  } 
  selectOutput("Select a file to write to:", "fileSelected");
}
void fileSelected(File selection) { 
  savingImage.save(selection.getAbsolutePath()+"."+month()+day()+hour()+minute()+second()+".jpg");
}


void random_mirror() {
  randomNumber= random(.05, .99);
  mirror_percentage = randomNumber;
  mirrorPercentageSlider.setValue(mirror_percentage);
  mirrorType = int(random(8));
}


void rotate_clockwise() {
  if (mirrorType==0) { 
    mirrorType=4;
  } else if (mirrorType==4) { 
    mirrorType=3;
  } else if (mirrorType==3) { 
    mirrorType=6;
  } else if (mirrorType==6) { 
    mirrorType=0;
  } else if (mirrorType==1) { 
    mirrorType=7;
  } else if (mirrorType==7) { 
    mirrorType=2;
  } else if (mirrorType==2) { 
    mirrorType=5;
  } else if (mirrorType==5) { 
    mirrorType=1;
  }
}
void rotate_counterclockwise() {
  if (mirrorType==0) { 
    mirrorType=6;
  } else if (mirrorType==6) { 
    mirrorType=3;
  } else if (mirrorType==3) { 
    mirrorType=4;
  } else if (mirrorType==4) { 
    mirrorType=0;
  } else if (mirrorType==1) { 
    mirrorType=5;
  } else if (mirrorType==5) { 
    mirrorType=2;
  } else if (mirrorType==2) { 
    mirrorType=7;
  } else if (mirrorType==7) { 
    mirrorType=1;
  }
}


void horizontal_flip(boolean imageFlippedHorizontally) {
  if (imageFlippedHorizontally==true) {
    if (mirrorType==0) { 
      mirrorType=1;
    }
    if (mirrorType==2) { 
      mirrorType=3;
    }
    if (mirrorType==4) { 
      mirrorType=5;
    }
    if (mirrorType==6) { 
      mirrorType=7;
    }
  }
  if (imageFlippedHorizontally==false) {
    if (mirrorType==1) { 
      mirrorType=0;
    }
    if (mirrorType==3) { 
      mirrorType=2;
    }
    if (mirrorType==5) { 
      mirrorType=4;
    }
    if (mirrorType==7) { 
      mirrorType=6;
    }
  }
}

void vertical_flip(boolean imageFlippedVertically) {
  if (imageFlippedVertically==true) {
    if (mirrorType==0) { 
      mirrorType=2;
    }
    if (mirrorType==1) { 
      mirrorType=3;
    }
    if (mirrorType==4) { 
      mirrorType=7;
    }
    if (mirrorType==5) { 
      mirrorType=6;
    }
  }
  if (imageFlippedVertically==false) {
    if (mirrorType==2) { 
      mirrorType=0;
    }
    if (mirrorType==3) { 
      mirrorType=1;
    }
    if (mirrorType==7) { 
      mirrorType=4;
    }
    if (mirrorType==6) { 
      mirrorType=5;
    }
  }
}


//mirrorType Functions
//percentageWidth is between 0.05 to 1 for all functions
void MirrorImageSectionAcrossYAxis(float percentageWidth) { 
  background(0);    
  pushMatrix();
  copy(img, 0, 0, int(img.width*percentageWidth), img.height, 
  0, 0, int(img.width*(percentageWidth)), img.height); //left side
  scale(-1, 1);
  translate(int(-img.width*(2*percentageWidth)), 0);
  copy(img, 0, 0, int(img.width*percentageWidth), img.height, 
  1, 0, int(img.width*percentageWidth), img.height); //right side
  popMatrix();
}

void HorizontalFlipAndMirrorImageSectionAcrossYAxis(float percentageWidth) {
  background(0);
  pushMatrix();
  copy(img, int(img.width*(1-percentageWidth)), 0, int(img.width*percentageWidth), img.height, 
  int(img.width*percentageWidth), 0, int(img.width*percentageWidth), img.height); 
  scale(-1, 1);
  translate(int(-img.width), 0);
  copy(img, int(img.width*(1-percentageWidth)), 0, int(img.width*percentageWidth), img.height, 
  int(img.width*(1-percentageWidth)), 0, int(img.width*percentageWidth), img.height);
  popMatrix();
}

void MirrorUpsideDownSectionAcrossYAxis(float percentageWidth) {
  background(0);
  pushMatrix();  
  scale(1, -1);//left side
  translate(0, -img.height);
  copy(img, 0, 0, int(img.width*percentageWidth), img.height, 
  0, 0, int(img.width*percentageWidth), img.height);
  scale(-1, 1);//right side
  translate(int(-img.width*(2*percentageWidth)), 0);
  copy(img, 0, 0, int(img.width*percentageWidth), img.height, 
  1, 0, int(img.width*percentageWidth), img.height);
  popMatrix();
}

void Mirror180DegreeRotatedImageSectionAcrossYAxis(float percentageWidth) { 
  background(0);
  pushMatrix(); //right; non-mirrored
  scale(1, -1);
  translate(0, -img.height);
  copy(img, int(img.width*(1-percentageWidth)), 0, int(img.width*percentageWidth), img.height, 
  int(img.width*percentageWidth), 0, int(img.width*percentageWidth), img.height);
  popMatrix();
  pushMatrix(); //left; mirrored
  scale(1, -1);
  translate(0, -img.height);
  scale(-1, 1);
  translate(int(-img.width), 0);
  copy(img, int(img.width*(1-percentageWidth)), 0, int(img.width*percentageWidth), img.height, 
  int(img.width*(1-percentageWidth)), 0, int(img.width*percentageWidth), img.height);
  popMatrix();
}

void Mirror90DegreeRotatedImageSectionAcrossYAxis(float percentageWidth) {  
  background(0);
  pushMatrix();//left side
  rotate(radians(90));
  translate(0, -img.height);
  copy(img, 0, int(img.height*(1-percentageWidth)), img.width, int(img.height*percentageWidth), 
  0, int(img.height*(1-percentageWidth)), img.width, int(img.height*percentageWidth));
  popMatrix();
  pushMatrix();//right side
  rotate(radians(90));
  scale(1, -1);
  copy(img, 0, int(img.height*(1-percentageWidth)), img.width, int(img.height*percentageWidth), 
  0, int(img.height*percentageWidth), img.width, int(img.height*percentageWidth));
  popMatrix();
}

void Mirror90DegreeRotatedAndFlippedImageSectionAcrossYAxis(float percentageWidth) {   
  background(0);
  pushMatrix();//right side
  rotate(radians(90));
  translate(0, int(-img.height*2));
  copy(img, 0, 0, 
  img.width, int(img.height*percentageWidth), 
  0, int(img.height*((1-percentageWidth)*2))+2, 
  img.width, int(img.height*percentageWidth));
  popMatrix();
  pushMatrix();//left side
  rotate(radians(90));
  scale(1, -1);
  copy(img, 0, 0, img.width, int(img.height*percentageWidth), 
  0, 0, img.width, int(img.height*percentageWidth));
  popMatrix();
}

void Mirror270DegreeRotatedImageSectionAcrossYAxis(float percentageWidth) {
  background(0);
  pushMatrix(); //left side
  rotate(radians(270));
  translate(-img.width, 0);
  copy(img, 0, 0, img.width, int(img.height*percentageWidth), 
  0, 0, img.width, int(img.height*percentageWidth));
  popMatrix(); 
  pushMatrix();
  rotate(radians(270));
  scale(1, -1);
  translate(-img.width, -img.height*2);
  copy(img, 0, 0, 
  img.width, int(img.height*percentageWidth), 
  0, int(img.height*((1-percentageWidth)*2))+2, 
  img.width, int(img.height*percentageWidth));
  popMatrix();
}

void Mirror270DegreeRotatedAndFlippedImageSectionAcrossYAxis(float percentageWidth) {
  background(0);
  pushMatrix(); //left side
  rotate(radians(270));
  scale(1, -1);
  translate(-img.width, -img.height);
  copy(img, 0, int(img.height*(1-percentageWidth)), img.width, int(img.height*percentageWidth), 
  0, int(img.height*(1-percentageWidth)), img.width, int(img.height*percentageWidth));
  popMatrix();
  pushMatrix(); //right side
  rotate(radians(270));
  translate(-img.width, 0);
  copy(img, 0, int(img.height*(1-percentageWidth)), img.width, int(img.height*percentageWidth), 
  0, int(img.height*percentageWidth), img.width, int(img.height*percentageWidth));
  popMatrix();
}
