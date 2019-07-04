import processing.serial.*;
Serial myPort;
int distance = 0;
import
  ddf.minim.*;
Minim minim;
AudioPlayer player;

PFont myFont;
PImage img1;
PImage img2;
PImage palette;
PImage doodle;
PImage pika;
PImage canvas;
PImage easel;
PImage goBackButton;
PImage brush;
PImage homeButton;
int y, mo, d, h, m, s;

CTimer timer;
static int i=0;

PFont Jokerman;
//boolean jump;
boolean p1, p2, p3, p4;
boolean[]status=new boolean[4];
Block quadCube;

int pbLeRoller=0;
int pbLeFocus=0;
int pxX, pxY, pxW, pxH, pxID;
int ppxRoller, ppxID, ppxOffset;
String ppxLable;
EcSelector pbSelectorRed;
EcSelector pbSelectorGreen;
EcSelector pbSelectorBlue;
EcSelector selector;

ArrayList<Integer> brushXHistory = new ArrayList<Integer>(), brushYHistory = new ArrayList<Integer>(), brushDiaHistory = new ArrayList<Integer>();
int brushX;

int condition;


void setup() {
  minim = new
    Minim(this);
  player = minim.loadFile("群星 - CHANSON.mp3");

  size(800, 800);
  background(255);
  myFont=createFont("YaHei Consolas Hybrid", 18);
  textFont(myFont);
  img1 = loadImage("Clock1.png");
  img2 = loadImage("OnSeatLOGO.jpg");
  palette = loadImage("pallete.png");
  doodle = loadImage("doodle1.jpg");
  pika = loadImage("pikachu.png");
  canvas = loadImage("canvas.png");
  easel = loadImage("easel.png");
  goBackButton = loadImage("goBackButton.png");
  brush = loadImage("Brush.png");
  homeButton = loadImage("homeButton.png");
  frameRate(30);
  smooth();
  condition = 0;

  timer = new CTimer(10000);
  timer.start();

  quadCube = new Block(p1, p2, p3, p4);

  selector = new EcSelector(pxX, pxY, pxW, pxH, pxID);

  myPort = new Serial(this, "COM3", 9600);
}


void draw() {
  if (condition == 0) {
    background(255);
    image(img1, 200, 0);
    image(img2, 60, 360);
    text("Now you are on your seat again...", 236, 700);
    s = second();
    m = minute();
    h = hour();
    d = day();
    mo = month();
    y = year();
    myClockDraw();
    if ( timer.isFinished() ) {
      /*i++;
       if (i%2==1) {
       background(0, 255, 0);
       } 
       else {
       background(255, 0, 0);
       }*/
      timer.start();
      player.play();

      size(800, 800);
      background(0);
      frameRate(30);
      Jokerman=createFont("Jokerman", 95);
      textFont(Jokerman);
      fill(255);
      text("NOW", -140, -20);
      text("TIME TO", -200, 180);
      text("STAND UP!!!", -300, 380);
      condition=1;
    }
  } else if (condition == 1) {
    quadCube.sandWordsDraw();
    image(palette, 700, 50);

    if (mousePressed==true && dist(mouseX, mouseY, 700, 50)<=100) {
      //frameRate(16);
      //noStroke();
      int[] lpStep={
        0x11, 0x33, 0x66, 0x99, 0xCC, 0xEE, 
      };
      int lpStepNormal=10;
      int lpWidthNorm=(width-(lpStepNormal*4))/3;
      int lpYNormal=300;

      pbSelectorRed=new EcSelector(10, lpYNormal, lpWidthNorm, 60, 0);
      pbSelectorGreen=new EcSelector(pbSelectorRed.ccTellNextPointX(10), lpYNormal, lpWidthNorm, 60, 1);
      pbSelectorBlue=new EcSelector(pbSelectorGreen.ccTellNextPointX(10), lpYNormal, lpWidthNorm, 60, 2);
      for (int it : lpStep) {
        pbSelectorRed.cmColorModel.append(color(it, 0x00, 0x00));
        pbSelectorGreen.cmColorModel.append(color(0x00, it, 0x00));
        pbSelectorBlue.cmColorModel.append(color(0x00, 0x00, it));
      }
      condition = 2;
    }
  } else if (condition == 2) {
    selector.pickColor();
    image(pika, 700, 500);
    if (mousePressed == true && dist(mouseX, mouseY, 700, 700)<=100) {
      brushXHistory.clear();
      brushYHistory.clear();
      brushDiaHistory.clear();
      condition = 3;
    }
  } else if (condition == 3) {
    image(canvas, 0, 0);
    image(easel, 0, 0);

    if (myPort.available()>0) {
      distance=myPort.read();
      println(distance);
    }
    brushX=distance*20-10;
    float dia=random(20, 50);
    float brushY=random(800);
    brushXHistory.add(brushX);
    brushYHistory.add(int(brushY));
    brushDiaHistory.add(int(dia));
    selector.useTheColor();
    for (int i = 0; i < brushXHistory.size(); i++) {
      ellipse(brushXHistory.get(i), brushYHistory.get(i), brushDiaHistory.get(i), brushDiaHistory.get(i));
    }
    image(brush, brushX, brushY);
    image(goBackButton, 10, 750);
    image(homeButton, 0, 0);
    myPort.write("LitOn");

    if (mousePressed == true && dist(mouseX, mouseY, 10, 750)<100) {
      condition = 2;
    }
  }
  if (mousePressed == true && dist(mouseX, mouseY, 0, 0)<=100) {
    condition = 0;
  }
}


void myClockDraw() {
  translate(width/2, 220);
  fill(255, 50);
  ellipse(0, 0, 200, 200);
  stroke(0);
  textFont(myFont);
  fill(0);
  text("12", -10, -75);
  text("3", 78, 6);
  text("6", -6, 86);
  text("9", -88, 6);
  text(y+"-"+mo+"-"+d, -40, -23);
  for (int i=1; i<=60; i++) {
    pushMatrix();
    rotate(PI*2.0*i/60.0);
    stroke(0);
    if (i%15==0) {
      strokeWeight(3);
      line(0, -90, 0, -100);
    } else if ( i%5 ==0) {
      strokeWeight(2);
      line(0, -92, 0, -100);
    } else {
      strokeWeight(1);
      line(0, -95, 0, -100);
    }
    popMatrix();
  }
  pushMatrix();
  rotate(PI*2*s/60+PI);   
  stroke(0);
  strokeWeight(2);
  line(0, 0, 0, 90);
  popMatrix();
  pushMatrix();
  rotate(PI*2*m/60+PI);
  stroke(0);
  strokeWeight(3);
  line(0, 0, 0, 70);
  popMatrix();
  pushMatrix();
  rotate(PI*2*h/12+PI);
  stroke(0);
  strokeWeight(5);
  line(0, 0, 0, 50);
  popMatrix();
}

void mouseWheel(MouseEvent evt) {
  int lpShift=(int)evt.getCount();
  switch(pbLeFocus) {
  case 0:
    pbSelectorRed.ccShiftCursor(lpShift);
    break;
  case 1:
    pbSelectorGreen.ccShiftCursor(lpShift);
    break;
  case 2:
    pbSelectorBlue.ccShiftCursor(lpShift);
    break;
  default:
    break;
  }
} 
