/*
MIDI SETTINGS
 channel volume: cc 3
 param 1: cc 9 
 param 2: cc 14
 
 */

//main
import controlP5.*;
import java.util.Iterator;
import themidibus.*;

PImage particleTexture;

//UI
ControlP5 cp5;
Textarea console;
//String ip; 

PFont font;
int fontsize = 12;

int  textWidth = 400;
int textHeight = 100;
int textXOffset = 10;
int textYOffset = 10;


MidiBus midi;
int collisionChannel = 16;
boolean[] channels;
int numChannels = 4;


int[] notes = {
  61+12, 59+12, 56+12, 53+12
};


color[] colors = {
  color(27, 75, 122),
  color(146, 194, 81),
  color(218, 111, 70),
  color(245, 153, 10),
  color(72, 232, 206),
  color(188, 82, 201),
  color(147, 27, 40),
  color(255, 251, 52)  
};
boolean[] colorsAvailable;
float numColors;


//server and agents
Server server;

int numAgents = 200;
ArrayList<UserAgent> agents;
ArrayList<ProtoAgent> protoAgents;
ArrayList<DumbAgent> dumbAgents;
ArrayList<Collision> collisions;

PVector attractor; 

//appearance
color backgroundColor = color(20);
boolean showLinks = true;
boolean debugText = false;
boolean dumbAgentPolytails = true;
boolean reverseTilt = true;
boolean isPaused = false;
boolean showColorSwatches = true;
color repulsorColor = color(255, 0, 0, 100);
color attractorColor = color(0, 255, 0, 5);
color voronoiColor = color(220, 20);

float minSpeed = 0.1;
float maxSpeed = 5;
float attractorDistance;
float repulsorDistance;
float collisionDistance = 50;
int attractorTimer = 10;
int attractorCount = 0;

int maxVolume = 100;

float tiltOffset = -60;
float maxUserSpeed = 8;
float userTurnRate = 8;
int numSteps = 10;
float fuzziness = 10;
int historyLength = 15;
int collisionThreshold = 25;

//float pulseDistance = 0;
//float pulseSpeed = 10;
float lerpFactor = 0.1;

float repulsorStrength = 1;
float attractorStrength = 0.1;
float desiredSeparation = 50;
float steeringRadius = 250;
float maxLinkTrans = 70;
float speedDiv = 20;
int inactiveTimeout = 1300;
boolean kickAfterTimeout = false;

void setup() {
//  size(1920, 1080, P3D);
  size(1280, 720, P3D);
  hint(DISABLE_DEPTH_TEST);
  cp5 = new ControlP5(this);
  font = createFont("Exo 2.0 Light", fontsize*2);
  textFont(font);
  
  cp5.setAutoDraw(false);
  
  
  numColors = colors.length;
  colorsAvailable = new boolean[int(numColors)];
  for(int i = 0; i< numColors; i++){
    colorsAvailable[i] = true;
  }

  channels = new boolean[numChannels];
  for (int i = 0; i<numChannels; i++) {
    channels[i] = false;
  }

  midi = new MidiBus(this, "loopMIDI Port", "loopMIDI Port"); 

  particleTexture = loadImage("particleUpdate2.png");

  imageMode(CENTER);
  blendMode(ADD);

  attractorDistance = height/3;
  repulsorDistance = 50;
  collisionDistance = 5;

  background(backgroundColor);

  attractor= new PVector(width/2, height/2);

  agents = new ArrayList<UserAgent>();
  protoAgents = new ArrayList<ProtoAgent>();
  dumbAgents= new ArrayList<DumbAgent>(); 
  for (int i = 0; i< numAgents; i++) {
    dumbAgents.add(new DumbAgent(
    new PVector(random(-5, 5), random(-5, 5)), //speed
    new PVector(random(width), random(height)) //position
    ));
  }
  collisions = new ArrayList<Collision>();


  try {
    WebSocketImpl.DEBUG = false;
    server = new Server(8887);
    server.start();
  }
  catch(Exception e) {
    println("couldn't start server: " + e);
  }
  setupUI();  
  
}

void draw() {
  if (!isPaused) {
    background(backgroundColor);
    
    textAlign(RIGHT);
    fill(200, 200);
    textSize(24);
    text("1. Connect to wi-fi network motionIO \n2. Go to motion.io \n 3. Press Connect", width - textWidth - textXOffset, textYOffset, textWidth, textHeight);
    for (Iterator<DumbAgent> i = dumbAgents.iterator(); i.hasNext();) {
      DumbAgent a = i.next();
      a.displayParticle();
      a.retainedTail();
      a.update();
      if (a.remove) {
        i.remove();
      } 
    }

    for (Iterator<UserAgent> i = agents.iterator(); i.hasNext();) {
      UserAgent a = i.next();
      a.display();
      a.update();
      a.updateAge();

      if (a.remove) {
        if (a.channel >= 0 && a.channel <channels.length) {
          channels[a.channel] = false;
          a.muteChannel();
          if (a.colIndex != -1) {
            colorsAvailable[a.colIndex] = true;
          }
        }
        i.remove();
        println("midi channels: ");
        printArray(channels);
      } 
    }


    if (protoAgents.size() > 0) {
      for (ProtoAgent pa: protoAgents) {
        addAgent(pa.id);
      }
      protoAgents.clear();
    }


    for (Iterator<Collision> i = collisions.iterator(); i.hasNext();) {
      Collision c = i.next();
      c.display();
      c.update();
      if (c.remove) {
        i.remove();
      }
    }
  }
  cp5.draw();

  attractorCount ++;
  if (attractorCount > attractorTimer) {
    moveAttractor();
    attractorCount = 0;
  }
  
  stroke(220, 100);
  fill(220, 100);
  ellipse(attractor.x, attractor.y, 20, 20);

  if (showColorSwatches) {
    noStroke();
    for (int i = 0; i < colors.length; i++) {
      float trans;
      if (!colorsAvailable[i]) trans = 255; 
      else trans = 100;
      fill(colors[i], trans);
      rect(i*30, height-30, 30, 30);
    }
  }
}


void moveAttractor() {
  if(agents.size() >= 1){
    float totalX = 0;
    float totalY = 0;
    for(UserAgent a: agents){
      totalX += a.position.x;
      totalY += a.position.y;
    }
    float avgX = totalX/agents.size();
    float avgY = totalY/agents.size();
    attractor.x = avgX;
    attractor.y = avgY;
  }
  else{
    attractor.x = random(width);
    attractor.y = random(height);
  }
}



class Collision {
  float age = 0;
  float initSize = 50;
  float size = initSize;
  PVector position;
  boolean remove = false;
  MidiNote n; 

  Collision(PVector POSITION) {
    position = POSITION;
    n = new MidiNote(collisionChannel, notes[randomInt(0, notes.length)], 100);
    n.begin();
  }

  void display() {
    color c = color(randomColor(), 200);
    stroke(c);
    fill(c);
    //noFill();
    ellipse(position.x, position.y, size, size);
  }

  void update() {
    age ++;
    size --;
    if (size <=0 ) {
      n.end();
      remove = true;
    }
  }
}

