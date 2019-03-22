
public ReactionDiffusionGrid rdg;
public float scale = .5;
public float cursor_radius = 5;

public void setup() {
  
  size(640,640,P2D);
  
  rdg = new ReactionDiffusionGrid((int)(width*scale),(int)(height*scale));
  rdg.setDiffuseA(1.0);
  rdg.setDiffuseB(0.5);
  rdg.usePreset(ReactionDiffusionGrid.CORAL);
  
}

public void mouseWheel(MouseEvent e) {
  cursor_radius = max(0,cursor_radius-e.getCount()*5);
}

public void draw() {
  
  if(mousePressed) {
    color chemical = mouseButton==LEFT?
      color(255,255,0,0):
      color(0,0,255,255);
    rdg.paint(mouseX*scale,mouseY*scale,cursor_radius*scale,chemical);
  }
  
  image(rdg.get(),0,0,width,height);
  
  if(!mousePressed) {
    stroke(255);
    noFill();
    float diameter = cursor_radius*2;
    ellipse(mouseX,mouseY,diameter,diameter);
  }
  
  for(int i=0;i<100;i++) {
    rdg.timeStep();
  }
  
  surface.setTitle("FPS: "+frameRate);
}