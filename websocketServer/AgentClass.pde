class Agent {
  PVector speed, position, accel;
  boolean remove = false;
  boolean collided = false;
  int timeSinceLastCollision = 10;

  float tiltLR = 0;
  float tiltFB = 0;  
  float  dir = 0;

  color col;
  int channel;

  
  ArrayList<Behaviour> behaviours = new ArrayList<Behaviour>();

  Agent(PVector SPEED, PVector POSITION) {
    speed = SPEED;
    position = POSITION;
    behaviours.add(new CheckEdgesBehaviour(this)); 
    accel = new PVector(random(-5, 5), random(-5, 5));
  }

  
  void applyBehaviours() {
    for (Iterator<Behaviour> i = behaviours.iterator(); i.hasNext();) {
      Behaviour b = i.next();
      b.apply();
    }
  }
}


class DumbAgent extends Agent {
  PShape tail;
  PVector[] points = new PVector[historyLength]; 

  DumbAgent(PVector SPEED, PVector POSITION) {
    super(SPEED, POSITION);
    col = color(0, 255, 0);
    behaviours.add(new AttractAndRepelBehaviour(this, attractor));
    behaviours.add(new AvoidUsersBehaviour(this, agents, 50, 5));
    behaviours.add(new SteeringBehaviour(this, dumbAgents));
    tail = createShape();
    tail.beginShape();
    tail.noFill();
    for(int i = 0; i < historyLength; i++){
      float s = map(i, 0, historyLength, 50, 1);
      tail.stroke(200, s);
      tail.vertex(position.x, position.y);
    }
    tail.endShape();
  }
  
  void retainedTail(){
    shape(tail);
  }
  
  void update() { 
    accel.mult(0);   
    applyBehaviours();
    speed.add(accel); 
    speed.limit(maxSpeed); 
    if (speed.mag() < minSpeed) {
      speed.setMag(minSpeed);
    }

    position.add(speed);
    
    for(int i = 0; i < tail.getVertexCount(); i++){
      points[i] = tail.getVertex(i);
    }
    tail.setVertex(0, position.x, position.y);
    for(int i = 1; i < tail.getVertexCount(); i++){
      tail.setVertex(i, points[i-1].x, points[i-1].y);
    }
  }


  void displayParticle() {
    tint(100, 100);
    float size = noise(position.x, position.y)*20;
    //float size = 15;
    image(particleTexture, position.x, position.y, size, size);
  }
}


class UserAgent extends Agent {
  ArrayList<PVector> history = new ArrayList<PVector>();
  WebSocket id;
  int age = 0;
  color col;
  int colIndex = -1;
  int channel;
  int outputVal = 0;
  String label;
  int timeSinceLastUpdate = 0;

  UserAgent(WebSocket ID) {
    super(new PVector(random(-5, 5), random(-5, 5)), new PVector(random(width), random(height)));
    id = ID;
    channel = pickChannel(); 
    behaviours.add(new CheckEdgesBehaviour(this)); 
    behaviours.add(new UserControlledBehaviour(this));
    behaviours.add(new PointAttractorBehaviour(this, attractor));
    //behaviours.add(new BetweenUsersBehaviour(this, channel));  
    behaviours.add(new AvoidUsersBehaviour(this, agents, 25, 0.5));   
    behaviours.add(new CollisionsBehaviour(this, agents));
    pickColor();
    id.send(hex(col, 6));
    unmuteChannel();
  }

  void updateInput(JSONObject data) {
    tiltLR = parseData(data, "tiltLR");
    tiltFB = parseData(data, "tiltFB");
    dir = parseData(data, "dir");
    timeSinceLastUpdate = 0;
    //println(data);
  }

  float parseData(JSONObject data, String id) {
    try {
      return data.getFloat(id);
    }
    catch(RuntimeException e) {
      return 0;
    }
  }

  void updateAge() {
    age++;
  }

  void update() { 
    accel.mult(0);   
    applyBehaviours();
    speed.add(accel); 
    speed.limit(maxUserSpeed); 
    if (speed.mag() < minSpeed) {
      speed.setMag(minSpeed);
    }

    position.add(speed);
    int controlLR;
    //int controlLR = int(map(tiltLR, -90, 90, -127, 127));
    if(tiltLR >= 0) controlLR = int(map(tiltLR, 0, 90, 40, 125));
    else  controlLR = int(map(tiltLR, 0, -90, 40, 125));
    //if(controlLR < 0) controlLR*=-1;
    int controlFB = int(map(speed.mag(), 0, maxUserSpeed, 0, 127));
    //println("controlFB: " + controlFB);
    //println("controlLR: " + controlLR);
    
    midi.sendControllerChange(channel, 9, controlFB);
    midi.sendControllerChange(channel, 14, controlLR);

    updateHistory();
    timeSinceLastUpdate ++;
    if(timeSinceLastUpdate > inactiveTimeout && kickAfterTimeout) remove = true;
    timeSinceLastCollision ++;
    if (collided) {
      collided = false;
    }
  }
  
  void updateHistory() {
    history.add(position.get());
    if (history.size() > historyLength) {
      history.remove(0);
    }
  }

  int pickChannel() {
    int chan = -1;
    for (int i = 0; i < channels.length; i++) {
      if (channels[i] == false) {
        chan = i; 
        channels[i] = true; 
        break;
      }
    }
    return chan;
  }

  void pickColor() {
    if (agents.size() < colors.length) {
      for (int i = 0; i< colorsAvailable.length; i++) {
        if (colorsAvailable[i] == true) {
          colorsAvailable[i] = false;
          colIndex = i;
          //return colors[i];
          col = colors[i];
          println(colorsAvailable);
          break;
        }
      }
    }
    else {
      col =  randomColor();
    }
  }

  void muteChannel() {
    midi.sendControllerChange(channel, 3, 0);
  }

  void unmuteChannel() {
    midi.sendControllerChange(channel, 3, maxVolume);
  }

  void display() {
    tint(col, 100);
    image(particleTexture, position.x, position.y, 50, 50);
    drawParticleTail();
    //drawVertexTail();
    drawPolyTail();
    if (debugText) {
      fill(col);
      text("speed: " + speed + "\naccel: " + accel +"\nAge: " + age + "\nchannel: " + (channel+1) + "\nlast collision: " + timeSinceLastCollision + "\ncollided: " + collided + "\ntilt-fb: " + tiltFB, position.x+20, position.y-10);
    }

  }

  void drawPolyTail() {
    int count = 0;
    for (Iterator<PVector> i = history.iterator(); i.hasNext(); count++) {
      PVector p = i.next();
      float size = map(count, 0, history.size(), maxSpeed*2, maxSpeed*4);
      float rot = map(count, 0, history.size(), 0, TWO_PI);
      stroke(200, 50);
      //noFill();
      fill(200, 15);
      pushMatrix();
      translate(p.x, p.y);
      rotate(rot);
      rotate(speed.heading()-TWO_PI*0.25);
      beginShape(TRIANGLES);
      for (int j = 0; j<3; j++) {
        float r = (TWO_PI/3)*j;
        float xpos = sin(r)*size*0.75;
        float ypos = cos(r)*size*0.75;
        vertex(xpos, ypos);
      }
      endShape();
      popMatrix();
    }
  }

  void drawParticleTail() {
    int count = 0;
    for (Iterator<PVector> i = history.iterator(); i.hasNext(); count++) {
      float str = map(count, 0, history.size(), 50, 150);
      float size = map(count, 0, history.size(), maxSpeed*2, maxSpeed*4);
      PVector p = i.next();
      tint(100, str);
      image(particleTexture, p.x, p.y, size, size);
      tint(col, str);
      image(particleTexture, p.x, p.y, size*0.75, size*0.75);
    }
  }
}

