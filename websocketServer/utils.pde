void keyPressed() {
  switch(key) {  

  case 'h': //toggle ui
    if (cp5.isVisible()) {
      cp5.hide();
    } 
    else {
      cp5.show();
    } 
    break;  

  case 'p': //pause  
    isPaused = !isPaused;
    break;

  case 's': //take screenshot
    screenshot();
    break;

  case 'q': //exit program gracefully
    exit();
    break;
  }
}

int randomInt(float low, float high) {
  return int(random(low, high));
}

color randomColor() {
  return color(random(255), random(255), random(255));
}


void stop() {

  try {
    server.stop();
  } 
  catch(Exception e) {
  }
  super.stop();
}

void addAgent(WebSocket id) {
  agents.add(new UserAgent(id));
  println("midi channels: ");
  printArray(channels);
}

void addProtoAgent(WebSocket id) {
  protoAgents.add(new ProtoAgent(id));
}


class ProtoAgent { 
  WebSocket id;
  color col;
  ProtoAgent(WebSocket ID) {
    id = ID;
  }
}


void quit() {
  //  for(Collision c: collisions) {
  //    c.n.end();
  //  }
  exit();
}

void loadSettings() {
  cp5.loadProperties("prefs");
}

void saveSettings() {
  clearConsole();
  cp5.saveProperties("prefs");
}

String timestamp() {
  return year() + "_" + month() + "_" + day()  + "_" + hour()  + "_" + minute()  + "_" + second();
}

void screenshot() {
  println("saving screenshot...");
  saveFrame(timestamp() + ".png");
  //saveFrame("/Users/Kyle/Desktop/output/" + timestamp() + ".png");
  println("done.");
}

class MidiNote {
  int channel, note, velocity;
  MidiNote(int CHANNEL, int NOTE, int VELOCITY) {
    channel = CHANNEL;
    note = NOTE;
    velocity = VELOCITY;
  }

  void begin() {
    midi.sendNoteOn(channel, note, velocity);
  }

  void end() {
    midi.sendNoteOff(channel, note, velocity);
  }
}

void clearConsole() {
  console.clear();
}

void numAgents(int newAmount) {
  int currentAmount = dumbAgents.size();
  if (currentAmount < newAmount) {
    //addmore 
    int diff = newAmount - currentAmount;
    for (int i = 0; i < diff; i++) {
      dumbAgents.add(new DumbAgent(
      new PVector(random(-5, 5), random(-5, 5)), //speed
      new PVector(random(width), random(height)) //position
      ));
    }
  }
  else if (currentAmount > newAmount) {
    int diff = currentAmount - newAmount; 
    try {
      for (int i = 0; i < diff; i++) {
        dumbAgents.remove(i);
      }
    } 
    catch(Exception e) {
      println("Something might have gone wrong: " + timestamp());
    }
  }
}

void historyLength(int newVal) {
  historyLength = newVal;
  println("history length: " + historyLength);
  for (DumbAgent a: dumbAgents) {
      a.points = new PVector[newVal];
      a.tail = createShape();
      a.tail.beginShape();
      a.tail.noFill();
      for (int i = 0; i < newVal; i++) {
        float s = map(i, 0, newVal, 50, 1);
        a.tail.stroke(200, s);
        a.tail.vertex(a.position.x, a.position.y);
      }
      a.tail.endShape();
  }
}

