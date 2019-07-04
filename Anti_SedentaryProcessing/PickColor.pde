class EcSelector {

  IntList cmColorModel;

  int cmX, cmY, cmW, cmH;
  int cmTotalH;
  int cmCursor;
  int cmID;

  String cmLable;
  boolean cmIsFocused;

  EcSelector(int pxX, int pxY, int pxW, int pxH, int pxID) {
    cmX=pxX;
    cmY=pxY;
    cmW=pxW;
    cmH=pxH;
    cmColorModel=new IntList();
    cmTotalH=0;
    cmCursor=0;
    cmLable="..";
    cmID=pxID;
    cmIsFocused=false;
  }


  void pickColor() {
    background(0);
    image(doodle, 0, 0);

    pbLeRoller++;
    pbLeRoller&=0x0F;

    int lpCurrentRed=(int)red(pbSelectorRed.ccTellCurrentColor());
    int lpCurrentGreen=(int)green(pbSelectorGreen.ccTellCurrentColor());
    int lpCurrentBlue=(int)blue(pbSelectorBlue.ccTellCurrentColor());
    int lpCurrentColor=color(lpCurrentRed&0xFF, lpCurrentGreen&0xFF, lpCurrentBlue&0xFF);

    pbSelectorRed.ccSetLable("R:"+hex(lpCurrentRed, 2));
    pbSelectorRed.ccUpdate(pbLeRoller);
    pbSelectorGreen.ccSetLable("G:"+hex(lpCurrentGreen, 2));
    pbSelectorGreen.ccUpdate(pbLeRoller);
    pbSelectorBlue.ccSetLable("B:"+hex(lpCurrentBlue, 2));
    pbSelectorBlue.ccUpdate(pbLeRoller);

    if (pbSelectorRed.ccIsMouseOver()) {
      pbLeFocus=0;
    }
    pbSelectorRed.ccCheckFocused(pbLeFocus);
    if (pbSelectorGreen.ccIsMouseOver()) {
      pbLeFocus=1;
    }
    pbSelectorGreen.ccCheckFocused(pbLeFocus);
    if (pbSelectorBlue.ccIsMouseOver()) {
      pbLeFocus=2;
    }
    pbSelectorBlue.ccCheckFocused(pbLeFocus);

    fill(0xEE);
    text("#"+hex(lpCurrentColor, 6), 210, 100);
    fill(lpCurrentColor);
    stroke(0xEE);
    {
      rect(250, 160, 300, 80);
    }
    noStroke();
  }


  void ccUpdate(int pxRoller) {
    int lpSetY=cmY;

    for (int i=0, s=cmColorModel.size(); i<s; i++) {
      fill(cmColorModel.get(i));
      rect(cmX, lpSetY, cmW, cmH);
      lpSetY+=cmH;
    }
    cmTotalH=lpSetY+cmH;
    fill(0xEE);
    text(cmLable, cmX, cmTotalH);

    if ((cmIsFocused&&(pxRoller%2==0))) {
      return;
    }
    noFill();
    stroke(0xEE);
    strokeWeight(2);
    {
      rect(cmX, cmY+cmCursor*cmH, cmW, cmH);
    }
    strokeWeight(1);
    noStroke();
  }



  void ccSetLable(String pxLable) {
    cmLable=pxLable;
  }


  void ccCheckFocused(int pxID) {
    cmIsFocused=(pxID==cmID);
  }
  int ccTellCurrentColor() {
    return cmColorModel.get(cmCursor);
  }
  int ccTellNextPointX(int pxOffset) {
    return cmX+cmW+pxOffset;
  }



  void ccShiftCursor(int pxOffset) {
    if (pxOffset==0) {
      cmCursor=0;
      return;
    }
    cmCursor+=pxOffset;
    cmCursor=constrain(cmCursor, 0, cmColorModel.size()-1);
  }


  boolean ccIsMouseOver() {
    return (mouseX>cmX)&&(mouseX<(cmX+cmW))
      &&(mouseY>cmY)&&(mouseY<(cmY+cmTotalH-cmH*2));
  } 


  void useTheColor() {
    int lpCurrentRed=(int)red(pbSelectorRed.ccTellCurrentColor());
    int lpCurrentGreen=(int)green(pbSelectorGreen.ccTellCurrentColor());
    int lpCurrentBlue=(int)blue(pbSelectorBlue.ccTellCurrentColor());
    int lpCurrentColor=color(lpCurrentRed&0xFF, lpCurrentGreen&0xFF, lpCurrentBlue&0xFF);

    if (pbSelectorRed.ccIsMouseOver()) {
      pbLeFocus=0;
    }
    pbSelectorRed.ccCheckFocused(pbLeFocus);
    if (pbSelectorGreen.ccIsMouseOver()) {
      pbLeFocus=1;
    }
    pbSelectorGreen.ccCheckFocused(pbLeFocus);
    if (pbSelectorBlue.ccIsMouseOver()) {
      pbLeFocus=2;
    }
    pbSelectorBlue.ccCheckFocused(pbLeFocus);

    fill(lpCurrentColor);
  }
}
