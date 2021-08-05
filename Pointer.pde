float pX, pY;
float prePX, prePY;
PointManager pointManager;
LineManager lineManager;
//boolean doublePushedFlag;
boolean resetFlag;

void paintGyroPre() {
  pX = width/3;
  pY = height/4;

 // pointManager = new PointManager();
  lineManager = new LineManager();
  // doublePushedFlag = false;
}

void paintGyro() {
  prePX = pX;
  prePY = pY;

  if (abs(gz) > 5.0f && abs(gz) < 200.0f) {
    //pX += ((gz - reggz)*cos(dy*PI/180) + (gx - reggx)*sin(dy*PI/180))*dt*10;
    pX += gz*dt*10;
  }
  if (abs(gx) > 5.0f && abs(gx) < 200.0f) {
    //pY -= (-(gz - reggz)*sin(dy*PI/180) + (gx - reggx)*cos(dy*PI/180))*dt*10;
    pY += gx*dt*10;
  }

  if (buttonPushed /*&& !doublePushedFlag*/) {
  //  pointManager.makePoint(pX, pY);
    lineManager.makeLine(prePX, prePY, pX, pY);
  }

  //  pointManager.rend();
  lineManager.rend();

  if (resetPushed && resetFlag) {
    resetFlag = false;
    savePNG();
    pX = width/3;
    pY = height/4;
    dy = 0;
   // pointManager.reset();
    lineManager.reset();
    //doublePushedFlag = true;
  }
  if (!resetPushed) {
    resetFlag = true;
  }

  strokeWeight(1);
  fill(255);
  ellipse(pX, pY, 20, 20);

  /*if (!buttonPushed) {
   doublePushedFlag = false;
   }*/
}
