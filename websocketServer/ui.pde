void setupUI() {

  int lineHeight = fontsize;
  int pos = 25;
 // ip = getIP();
  CColor c = new CColor(color(150, 100), //foreground,
  color(100, 100), //background,
  color(225, 100), //active,
  color(200), //caption colour
  color(200)); //value colour

  cp5.setColor(c);
  cp5.addFrameRate();

  pos+= 10;
  cp5.addToggle("showLinks")
    .setPosition(5, pos)
      .setWidth(lineHeight)
        .setHeight(lineHeight)
          .setLabel("show relationships")
            .getCaptionLabel()
              .toUpperCase(false)
                .getStyle()
                  .setMarginTop(int(lineHeight*-1.5))
                    .setMarginLeft(int(lineHeight*1.5))
                      ;

  pos+=lineHeight; 
  pos+=5;

  cp5.addToggle("debugText")
    .setPosition(5, pos)
      .setWidth(lineHeight)
        .setHeight(lineHeight)
          .setLabel("show debug text")
            .getCaptionLabel()
              .toUpperCase(false)
                .getStyle()
                  .setMarginTop(int(lineHeight*-1.5))
                    .setMarginLeft(int(lineHeight*1.5))
                      ;

  pos+=lineHeight;

  pos+=5;
  cp5.addToggle("reverseTilt")
    .setPosition(5, pos)
      .setWidth(lineHeight)
        .setHeight(lineHeight)
          .setLabel("reverse tilt")
            .getCaptionLabel()
              .toUpperCase(false)
                .getStyle()
                  .setMarginTop(int(lineHeight*-1.5))
                    .setMarginLeft(int(lineHeight*1.5))
                      ;

  pos+=lineHeight;

  pos+=5;
  cp5.addToggle("isPaused")
    .setPosition(5, pos)
      .setWidth(lineHeight)
        .setHeight(lineHeight)
          .setLabel("pause")
            .getCaptionLabel()
              .toUpperCase(false)
                .getStyle()
                  .setMarginTop(int(lineHeight*-1.5))
                    .setMarginLeft(int(lineHeight*1.5))
                      ;

  pos+=lineHeight;

  pos+=5;
  cp5.addToggle("showColorSwatches")
    .setPosition(5, pos)
      .setWidth(lineHeight)
        .setHeight(lineHeight)
          .setLabel("show colour swatches")
            .getCaptionLabel()
              .toUpperCase(false)
                .getStyle()
                  .setMarginTop(int(lineHeight*-1.5))
                    .setMarginLeft(int(lineHeight*1.5))
                      ;

  pos+=lineHeight;
  
  pos+=5;
  cp5.addToggle("kickAfterTimeout")
    .setPosition(5, pos)
      .setWidth(lineHeight)
        .setHeight(lineHeight)
          .setLabel("kick after timeout")
            .getCaptionLabel()
              .toUpperCase(false)
                .getStyle()
                  .setMarginTop(int(lineHeight*-1.5))
                    .setMarginLeft(int(lineHeight*1.5))
                      ;

  pos+=lineHeight;
  
  
  
  pos+=lineHeight;
  cp5.addSlider("minSpeed")
    .setLabel("minimum speed")
      .setRange(0, 5)
        .setPosition(5, pos)
          .setHeight(lineHeight)
            .getCaptionLabel()
              .toUpperCase(false)
                ;

  pos+=lineHeight*1.5;

  cp5.addSlider("maxSpeed")
    .setLabel("maximum speed")
      .setRange(1, 10)
        .setPosition(5, pos)
          .setHeight(lineHeight)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("attractorDistance")
    .setLabel("attractor distance")
      .setRange(0, width)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("repulsorDistance")
    .setLabel("repulsor distance")
      .setRange(0, 200)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;

  pos+=lineHeight*1.5;

  cp5.addSlider("historyLength")
    .setLabel("history Length")
      .setRange(0, 100)
      .setValue(historyLength)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("numAgents")
    .setLabel("dumb agents")
      .setRange(0, 1000)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("collisionThreshold")
    .setLabel("collision threshold")
      .setRange(0, 150)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("collisionDistance")
    .setLabel("collision distance")
      .setRange(0, 150)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("tiltOffset")
    .setLabel("tiltOffset")
      .setRange(-90, 90)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("maxUserSpeed")
    .setLabel("maxUserSpeed")
      .setRange(0, 20)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("userTurnRate")
    .setLabel("user turn rate")
      .setRange(0, 10)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("maxVolume")
    .setLabel("max cc volume")
      .setRange(0, 127)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

//  cp5.addSlider("lerpFactor")
//    .setLabel("lerp factor")
//      .setRange(0, 1)
//        .setHeight(lineHeight)
//          .setPosition(5, pos)
//            .getCaptionLabel()
//              .toUpperCase(false)
//                ;
//  pos+=lineHeight*1.5;

  cp5.addSlider("attractorTimer")
    .setLabel("attractor timer")
      .setRange(0, 1000)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("attractorStrength")
    .setLabel("attractor strength")
      .setRange(0, 5)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("repulsorStrength")
    .setLabel("repulsor strength")
      .setRange(0, 5)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("desiredSeparation")
    .setLabel("desired separation")
      .setRange(0, 200)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("steeringRadius")
    .setLabel("steering radius")
      .setRange(0, 500)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addSlider("maxLinkTrans")
    .setLabel("link transparency")
      .setRange(0, 255)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;
  
  cp5.addSlider("speedDiv")
    .setLabel("speed divison")
      .setRange(5, 25)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;
  
  cp5.addSlider("inactiveTimeout")
    .setLabel("inactive timeout")
      .setRange(500, 2500)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;
  
  
  cp5.addSlider("textWidth")
    .setLabel("text box width")
      .setRange(100, width)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;
  
  
  cp5.addSlider("textHeight")
    .setLabel("text box height")
      .setRange(100, height)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;
  
  cp5.addSlider("textXOffset")
    .setLabel("text x offset")
      .setRange(0, width)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;
  
  cp5.addSlider("textYOffset")
    .setLabel("text y offset")
      .setRange(0, height)
        .setHeight(lineHeight)
          .setPosition(5, pos)
            .getCaptionLabel()
              .toUpperCase(false)
                ;
  pos+=lineHeight*1.5;

  cp5.addButton("screenshot")
    .setPosition(5, pos)
      .setWidth(125)
        .setLabel("take screenshot")
          .getCaptionLabel()
            .toUpperCase(false)
              ;

  pos += lineHeight; 
  pos += 10;

  cp5.addButton("saveSettings")
    .setPosition(5, pos)
      .setWidth(125)
        .setLabel("save settings")
          .getCaptionLabel()
            .toUpperCase(false)
              ;

  pos+=lineHeight;
  pos+=10;

  cp5.addButton("loadSettings")
    .setPosition(5, pos)
      .setWidth(125)
        .setLabel("load settings")
          .getCaptionLabel()
            .toUpperCase(false)
              ;

  pos+=lineHeight;
  pos+=10;

  cp5.addButton("clearConsole")
    .setPosition(5, pos)
      .setWidth(125)
        .setLabel("clear console")
          .getCaptionLabel()
            .toUpperCase(false)
              ;

  pos+=lineHeight;
  pos+=10;

  cp5.addButton("quit")
    .setPosition(5, pos)
      .getCaptionLabel()
        .toUpperCase(false)
          ;

  pos+=lineHeight;
  pos+=10;

  console = cp5.addTextarea("console")
    .setPosition(5, pos)
      .setSize(300, lineHeight*16)
        .setLineHeight(lineHeight)
          .setColor(color(200))
            .setColorBackground(color(150, 100))
              .setColorForeground(color(150, 100))
                ;
  cp5.addConsole(console);

  loadSettings();
}

