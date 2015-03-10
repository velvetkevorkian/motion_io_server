//__________                        _________ .__                        
//\______   \_____    ______ ____   \_   ___ \|  | _____    ______ ______
// |    |  _/\__  \  /  ___// __ \  /    \  \/|  | \__  \  /  ___//  ___/
// |    |   \ / __ \_\___ \\  ___/  \     \___|  |__/ __ \_\___ \ \___ \ 
// |______  /(____  /____  >\___  >  \______  /____(____  /____  >____  >
//        \/      \/     \/     \/          \/          \/     \/     \/ 

class Behaviour {
  Agent parent;
  Behaviour(Agent PARENT) {
    parent = PARENT;
  }

  void apply() {
  }
}

//_________ .__                   __     ___________    .___                     
//\_   ___ \|  |__   ____   ____ |  | __ \_   _____/  __| _/ ____   ____   ______
///    \  \/|  |  \_/ __ \_/ ___\|  |/ /  |    __)_  / __ | / ___\_/ __ \ /  ___/
//\     \___|   Y  \  ___/\  \___|    <   |        \/ /_/ |/ /_/  >  ___/ \___ \ 
// \______  /___|  /\___  >\___  >__|_ \ /_______  /\____ |\___  / \___  >____  >
//        \/     \/     \/     \/     \/         \/      \/_____/      \/     \/ 

class CheckEdgesBehaviour extends Behaviour {
  CheckEdgesBehaviour(Agent PARENT) {
    super(PARENT);
  }

  void apply() {
    if (parent.position.x >= width || parent.position.x <= 0) {
      parent.speed.x *= -1;
      if (parent.position.x >= width) { 
        parent.position.x = width-1;
      }
      else if (parent.position.x <= 0) { 
        parent.position.x = 1;
      }
    }
    if (parent.position.y >= height || parent.position.y <= 0) {
      parent.speed.y *= -1;
      if (parent.position.y >= height) { 
        parent.position.y = height-1;
      }
      else if (parent.position.y <= 0) { 
        parent.position.y = 1;
      }
    }
  }
}

//   _____   __    __                        __                
//  /  _  \_/  |__/  |_____________    _____/  |_  ___________ 
// /  /_\  \   __\   __\_  __ \__  \ _/ ___\   __\/  _ \_  __ \
///    |    \  |  |  |  |  | \// __ \\  \___|  | (  <_> )  | \/
//\____|__  /__|  |__|  |__|  (____  /\___  >__|  \____/|__|   
//        \/                       \/     \/                   

class PointAttractorBehaviour extends Behaviour {
  PVector target;
  PointAttractorBehaviour(Agent PARENT, PVector TARGET) {
    super(PARENT);
    target = TARGET;
  }

  void apply() {
    float dist = parent.position.dist(target);
    if (dist < attractorDistance) {
      if (showLinks) {
        stroke(attractorColor);
        line(parent.position.x, parent.position.y, target.x, target.y);
      }
      PVector dir = PVector.sub(target, parent.position);
      dir.normalize();
      dir.mult(map(attractorDistance - dist, 0, attractorDistance, 0, 0.1));
      parent.accel.add(dir);
    }
  }
}

//__________                    .__                      
//\______   \ ____ ______  __ __|  |   _________________ 
// |       _// __ \\____ \|  |  \  |  /  ___/  _ \_  __ \
// |    |   \  ___/|  |_> >  |  /  |__\___ (  <_> )  | \/
// |____|_  /\___  >   __/|____/|____/____  >____/|__|   
//        \/     \/|__|                   \/             

class PointRepulsorBehaviour extends Behaviour {
  PVector target;
  PointRepulsorBehaviour(Agent PARENT, PVector TARGET) {
    super(PARENT);
    target = TARGET;
  }

  void apply() {
    float dist = parent.position.dist(target);
    if (dist < repulsorDistance) {
      if (showLinks) {
        stroke(repulsorColor);
        line(parent.position.x, parent.position.y, target.x, target.y);
      }
      PVector dir = PVector.sub(parent.position, target);
      dir.normalize();
      dir.mult(map(repulsorDistance - dist, 0, repulsorDistance, 0, 0.1));
      parent.accel.add(dir);
    }
  }
}

class AttractAndRepelBehaviour extends Behaviour {
  PVector target;
  AttractAndRepelBehaviour(Agent PARENT, PVector TARGET) {
    super(PARENT);
    target = TARGET;
  }

  void apply() {
    float dist = parent.position.dist(target);
    //repel
    if (dist < repulsorDistance) {
      if (showLinks) {
        stroke(repulsorColor);
        line(parent.position.x, parent.position.y, target.x, target.y);
      }
      PVector dir = PVector.sub(parent.position, target);
      dir.normalize();
      dir.mult(map(repulsorDistance - dist, 0, repulsorDistance, 0, repulsorStrength));
      parent.accel.add(dir);
    }

    //attract
    if (dist < attractorDistance && dist > repulsorDistance) {
      if (showLinks) {
        stroke(attractorColor);
        line(parent.position.x, parent.position.y, target.x, target.y);
      }
      PVector dir = PVector.sub(target, parent.position);
      dir.normalize();
      dir.mult(map(attractorDistance - dist, 0, attractorDistance, 0, attractorStrength));
      parent.accel.add(dir);
    }
  }
}

// ____ ___                    
//|    |   \______ ___________ 
//|    |   /  ___// __ \_  __ \
//|    |  /\___ \\  ___/|  | \/
//|______//____  >\___  >__|   
//             \/     \/       

class UserControlledBehaviour extends Behaviour {

  UserControlledBehaviour(Agent PARENT) {
    super(PARENT);
  }

  void apply() {   
    float tilt = parent.tiltFB + tiltOffset;
    if (reverseTilt) {
      tilt*=-1;
    }
    float mag = parent.speed.mag(); 
    mag = lerp(mag, mag+(tilt/20), lerpFactor); //tilt * curve?
    //mag = lerp(mag, mag + sin(1.5*tilt*tilt), lerpFactor);
    if (mag<=0) {
      mag = 0.1;
    }
    parent.speed.setMag(mag);
    float rot = parent.tiltLR/5;
    rot = constrain(rot, -userTurnRate, userTurnRate);
    parent.speed.rotate(radians(rot));
    
  }
  
  
}

//________                        .__  .__        __            
//\______ \____________ __  _  __ |  | |__| ____ |  | __  ______
// |    |  \_  __ \__  \\ \/ \/ / |  | |  |/    \|  |/ / /  ___/
// |    `   \  | \// __ \\     /  |  |_|  |   |  \    <  \___ \ 
///_______  /__|  (____  /\/\_/   |____/__|___|  /__|_ \/____  >
//        \/           \/                      \/     \/     \/ 

class DrawLinksBehaviour extends Behaviour {
  ArrayList<DumbAgent> others;

  DrawLinksBehaviour(Agent PARENT, ArrayList<DumbAgent> OTHERS) {
    super(PARENT);
    others = OTHERS;
  }

  void apply() {
    float desiredSeparation = 50;
    for (DumbAgent other: others) {
      float d = PVector.dist(parent.position, other.position);
      if (d > 0 && d < desiredSeparation) {
        strokeWeight(1);
        stroke(200, 75-d);
        line(parent.position.x, parent.position.y, other.position.x, other.position.y);
      }
    }
  }
}

//   _____             .__    .___         __  .__                         
//  /  _  \___  ______ |__| __| _/   _____/  |_|  |__   ___________  ______
// /  /_\  \  \/ /  _ \|  |/ __ |   /  _ \   __\  |  \_/ __ \_  __ \/  ___/
///    |    \   (  <_> )  / /_/ |  (  <_> )  | |   Y  \  ___/|  | \/\___ \ 
//\____|__  /\_/ \____/|__\____ |   \____/|__| |___|  /\___  >__|  /____  >
//        \/                   \/                   \/     \/           \/ 

class AvoidOthersBehaviour extends Behaviour {
  ArrayList<DumbAgent> others;

  AvoidOthersBehaviour(Agent PARENT, ArrayList<DumbAgent> OTHERS) {
    super(PARENT);
    others = OTHERS;
  }

  void apply() {
    float desiredSeparation = 50;
    PVector sum = new PVector();
    int count = 0;
    for (DumbAgent other: others) {
      float d = PVector.dist(parent.position, other.position);
      if (d > 0 && d < desiredSeparation) {
        if (showLinks) {
          stroke(repulsorColor);
          line(parent.position.x, parent.position.y, other.position.x, other.position.y);
        }
        PVector diff = PVector.sub(parent.position, other.position);
        diff.normalize();
        float scale = map(d, 0, desiredSeparation, 0.5, 0.05); 
        sum.add(diff);
        count ++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.setMag(0.25);
      parent.accel.add(sum);
    }
  }
}

//  _________ __                                .__  __  .__              __  .__                         
// /   _____//  |_  ____   ___________  __  _  _|__|/  |_|  |__     _____/  |_|  |__   ___________  ______
// \_____  \\   __\/ __ \_/ __ \_  __ \ \ \/ \/ /  \   __\  |  \   /  _ \   __\  |  \_/ __ \_  __ \/  ___/
// /        \|  | \  ___/\  ___/|  | \/  \     /|  ||  | |   Y  \ (  <_> )  | |   Y  \  ___/|  | \/\___ \ 
///_______  /|__|  \___  >\___  >__|      \/\_/ |__||__| |___|  /  \____/|__| |___|  /\___  >__|  /____  >
//        \/           \/     \/                              \/                   \/     \/           \/ 

//class SteerWithOthersBehaviour extends Behaviour {
//  ArrayList<DumbAgent> others;
//
//  SteerWithOthersBehaviour(Agent PARENT, ArrayList<DumbAgent> OTHERS) {
//    super(PARENT);
//    others = OTHERS;
//  }
//
//  void apply() {
//    float radius = 250;
//    PVector sum = new PVector();
//    int count = 0;
//    for (DumbAgent other: others) {
//      float d = PVector.dist(parent.position, other.position);
//      if (d > 0 && d < radius) {
//        if (showLinks) {
//          stroke(attractorColor);
//          line(parent.position.x, parent.position.y, other.position.x, other.position.y);
//        }
//        PVector diff = PVector.sub(other.position, parent.position);
//        diff.normalize();
//        float scale = map(d, 0, radius, 0.5, 0.05); 
//        sum.add(diff);
//        count ++;
//      }
//    }
//    if (count > 0) {
//      sum.div(count);
//      sum.setMag(0.25);
//      parent.accel.add(sum);
//    }
//  }
//}

class SteeringBehaviour extends Behaviour {

  ArrayList<DumbAgent> others;

  SteeringBehaviour(Agent PARENT, ArrayList<DumbAgent> OTHERS) {
    super(PARENT);
    others = OTHERS;
  }

  void apply() {

    PVector sum1 = new PVector();
    PVector sum2 = new PVector();
    int count1 = 0;
    int count2 = 0;
    //PVector diff;

    for (DumbAgent other: others) {
      float d = PVector.dist(parent.position, other.position);

      if (d > 0 && d < desiredSeparation) {
        //draw links
        stroke(200, maxLinkTrans-d);
        line(parent.position.x, parent.position.y, other.position.x, other.position.y);

        //avoid
        if (showLinks) {
          stroke(repulsorColor);
          line(parent.position.x, parent.position.y, other.position.x, other.position.y);
        }
        PVector diff = PVector.sub(parent.position, other.position);
        diff.normalize();
        //float scale = map(d, 0, desiredSeparation, 0.5, 0.05); 
        sum1.add(diff);
        count1 ++;
      }

      //steer
      if (d > 0 && d < steeringRadius) {
        if (showLinks) {
          stroke(attractorColor);
          line(parent.position.x, parent.position.y, other.position.x, other.position.y);
        }
        PVector diff = PVector.sub(other.position, parent.position);
        diff.normalize();
        //float scale = map(d, 0, steeringRadius, 0.5, 0.05); 
        //diff.mult(scale);
        sum2.add(diff);
        count2 ++;
      }
    }

    if (count1 > 0) {
      sum1.div(count1);
      sum1.setMag(0.25);
      parent.accel.add(sum1);
    }
    
    if (count2 > 0) {
      sum2.div(count2);
      sum2.setMag(0.25);
      parent.accel.add(sum2);
    }
  }
}


//   _____             .__    .___                                   
//  /  _  \___  ______ |__| __| _/  __ __  ______ ___________  ______
// /  /_\  \  \/ /  _ \|  |/ __ |  |  |  \/  ___// __ \_  __ \/  ___/
///    |    \   (  <_> )  / /_/ |  |  |  /\___ \\  ___/|  | \/\___ \ 
//\____|__  /\_/ \____/|__\____ |  |____//____  >\___  >__|  /____  >
//        \/                   \/             \/     \/           \/ 

class AvoidUsersBehaviour extends Behaviour {
  ArrayList<UserAgent> others;
  float sep;
  float strength;

  AvoidUsersBehaviour(Agent PARENT, ArrayList<UserAgent> OTHERS, float SEP, float STRENGTH) {
    super(PARENT);
    others = OTHERS;
    sep = SEP;
    strength = STRENGTH;
  }

  void apply() {
    float desiredSeparation = sep; //50
    PVector sum = new PVector();
    int count = 0;
    for (UserAgent other: others) {
      if (other != parent) {
        ArrayList<PVector> vecs = new ArrayList<PVector>();
        vecs.add(other.position);
        for (int i = 0; i < other.history.size(); i++) {
          vecs.add(other.history.get(i));
        }
        for (PVector p: vecs) {
          float d = PVector.dist(parent.position, p);
          if (d > 0 && d < desiredSeparation) {
            PVector diff = PVector.sub(parent.position, p);
            diff.normalize(); 
            sum.add(diff);
            count ++;
          }
        }
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.setMag(strength); //5
      parent.accel.add(sum);
    }
  }
}

//_________        .__  .__  .__       .__                      
//\_   ___ \  ____ |  | |  | |__| _____|__| ____   ____   ______
///    \  \/ /  _ \|  | |  | |  |/  ___/  |/  _ \ /    \ /  ___/
//\     \___(  <_> )  |_|  |_|  |\___ \|  (  <_> )   |  \\___ \ 
// \______  /\____/|____/____/__/____  >__|\____/|___|  /____  >
//        \/                         \/               \/     \/ 

class CollisionsBehaviour extends Behaviour {
  ArrayList<UserAgent> others; 
  CollisionsBehaviour(Agent PARENT, ArrayList<UserAgent> OTHERS) {
    super(PARENT);  
    others = OTHERS;
  }

  void apply() {

    for (UserAgent other: others) {
      if (other != this.parent) {
        float d = PVector.dist(parent.position, other.position);
        if (d <= collisionDistance && !parent.collided && !other.collided && parent.timeSinceLastCollision > collisionThreshold && other.timeSinceLastCollision > collisionThreshold) {
          parent.collided = true;
          parent.timeSinceLastCollision = 0;
          other.collided = true;
          other.timeSinceLastCollision = 0;
          collisions.add(new Collision(parent.position.get()));
        }
      }
    }
  }
}

//__________        __                                  ____ ___                           
//\______   \ _____/  |___  _  __ ____   ____   ____   |    |   \______ ___________  ______
// |    |  _// __ \   __\ \/ \/ // __ \_/ __ \ /    \  |    |   /  ___// __ \_  __ \/  ___/
// |    |   \  ___/|  |  \     /\  ___/\  ___/|   |  \ |    |  /\___ \\  ___/|  | \/\___ \ 
// |______  /\___  >__|   \/\_/  \___  >\___  >___|  / |______//____  >\___  >__|  /____  >
//        \/     \/                  \/     \/     \/               \/     \/           \/ 

class BetweenUsersBehaviour extends Behaviour {
  int channel;
  BetweenUsersBehaviour(Agent PARENT, int CHANNEL) {
    super(PARENT);
    channel = CHANNEL;
  }

  void apply() {
    float numOthers = agents.size()-1;
    float maxPossible = 127;
    float  maxPerAgent = maxPossible/numOthers;
    float total = 0;
    //    for (Agent ua: agents) { 
    //      if (ua != parent) {
    //        float distance = ua.position.dist(parent.position);
    //        float amount = map(distance, 0, width, maxPerAgent, 0);
    //        total += amount;
    //
    //        float trans = map(distance, 0, width, 100, 0);
    //        stroke(parent.col, trans);
    //        fuzzyLine(parent.position, ua.position, numSteps, fuzziness);
    //      }
    //    }
    int ccMessage = int(total);
    midi.sendControllerChange(this.channel, 9, ccMessage);
    //println("sending cc value " + ccMessage + " on channel " + this.channel);
  }
}

