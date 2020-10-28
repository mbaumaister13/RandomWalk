import controlP5.*;

class RandomWalker { //Random Walk Class
  int x;
  int y;
  float col;
  float finalCol;
  int step;
  int it;
  
  
  RandomWalker() { //Constructor
    x = width/2;
    y = height/2;
    finalCol = 0;
    col = 0;
    step = 0;
    it = 0;
  }

  void display(float iterations, boolean clr) { //Draws out the random walk
   if (it < iterations) { //Draws the random walk until iterations it reached
     stroke(finalCol);
     point(x,y);
     if (clr) { //Checks if color is turned on
       finalCol = map(col, 0, iterations, 0, 255); //Maps color values (0-255) to iteration values (0-iterations value based on slider)
       col++;
     }
   } else { //Doesn't allow draw to continue updating once iterations is reached
     draw = false;
     reset = false;
     strt = false;
   }
   it++;
 }
  
  void stepper() {
    int rand = int(random(4));
    switch(rand) { //Random walk "coin flipper"
      case 0:
        y++;
        break;
      case 1:
        y--;
        break;
      case 2:
        x++;
        break;
      case 3:
        x--;
        break;
    }
    x = constrain(x, 0, width-1); //Doesn't allow the random walk to go out of bounds
    y = constrain(y, 0, height-1);
  }
}

void reset() { //Resets values everytime start is pressed
  background(135, 206, 250);
  walk.it = 0;
  walk.finalCol = 0;
  walk.col = 0;
  walk.x = width/2;
  walk.y = height/2;
  reset = true;
  strt = true;
}

RandomWalker walk;
ControlP5 controlP5;
controlP5.Button start;
controlP5.CheckBox check;
controlP5.Slider iteration;
controlP5.Slider steps;
boolean draw = false;
boolean reset = false;
boolean strt = false;

void setup() { //Creates the window and the button
  size(800, 800); //Size of window
  background(135, 206, 250); //Sets background color
  controlP5 = new ControlP5(this);
  walk = new RandomWalker(); 
  
  start = controlP5.addButton("Start", 0, 10, 30, 120, 50); //Sets start button label, position and size
  controlP5.getController("Start").getCaptionLabel().setSize(20); //Changes the text size of label
  
  check = controlP5.addCheckBox("Check").setPosition(140, 25).setSize(30, 30).addItem("Color", 0).addItem("Gradual", 1); //Sets Color/Gradual checkbox label, position and size
  controlP5.getController("Color").getCaptionLabel().setSize(12); //Changes the text size of label
  controlP5.getController("Gradual").getCaptionLabel().setSize(12); //Changes the text size of label
  
  iteration = controlP5.addSlider("Iterations").setRange(1000, 500000).setPosition(225, 25).setSize(500, 30); //Sets iteration slider label, position and size
  steps = controlP5.addSlider("Steps").setRange(1, 1000).setPosition(225, 60).setSize(500, 30); //Sets step slider label, position and size
  controlP5.getController("Iterations").getCaptionLabel().setSize(12); //Changes the text size of label
  controlP5.getController("Steps").getCaptionLabel().setSize(12); //Changes the text size of label
}


void draw() {
  if (!check.getState(1)) { //checks to see if gradual is not active
    if(draw && strt) { //If gradual is deactivated while iterations hasn't been reached, finish the walk instantaneously
      for(int i = 0; i < iteration.getValue() - walk.it; i++){ //Iterates through remainder of iterations needed and displays them all at once
        walk.stepper();
        walk.display(iteration.getValue(), check.getState(0)); //Passes in iteration slider value and color checkbox state to determine iteration count and whether to change the color or not
      }
    }
    if(start.isPressed()) { //Checks if start is activated
      reset(); //Resets variables
    }
    if(strt && !start.isPressed()) { //Only runs after start has been pressed and released
      for(int i = 0; i < iteration.getValue(); i++) { //Iterates through all of the iterations and displays them all at once
        walk.stepper();
        walk.display(iteration.getValue(), check.getState(0)); //Passes in iteration slider value and color checkbox state to determine iteration count and whether to change the color or not
      }
    }
  } else {
    if(start.isPressed()) { //Checks if start is activated
      reset(); //Resets variables //<>//
      draw = true; //Allows the random walk to be displayed gradually, and also allows the remainder of iterations to be displayed if gradual is deactivated after starting //<>//
    }
    if(draw && reset && strt && !start.isPressed()) { //Only runs after start has been pressed and released, and the reset function has been called //<>//
      for(int i = 0; i < steps.getValue(); i++) { //Iterates through all of the iterations and displays them based on how many steps determined by the slider //<>//
        walk.stepper();
        walk.display(iteration.getValue(), check.getState(0)); //Passes in iteration slider value and color checkbox state to determine iteration count and whether to change the color or not
      }
    }
  }
}
