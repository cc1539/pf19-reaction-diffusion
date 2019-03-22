
public class ReactionDiffusionGrid {
  
  // contains the actual chemical data
  private PGraphics grid;
  
  // visual representation of the chemicals
  private PGraphics canvas;
  
  private PShader rd_shader; // reaction-diffusion calculation
  private PShader paint_shader; // manually change the chemicals on the grid
  private PShader draw_shader; // render to the canvas
  
  // reaction diffusion settings
  private float Da;
  private float Db;
  private float f;
  private float k;
  
  // preset ids
  public static final int CORAL = 0;
  public static final int MITOSIS = 1;
  public static final int USKATE = 2;
  
  public ReactionDiffusionGrid(int width, int height) {
    grid = createGraphics(width,height,P2D);
    canvas = createGraphics(width,height,P2D);
    
    // we want to start out with nothing on our grid
    grid.beginDraw();
    grid.clear();
    grid.endDraw();
    
    // load our shaders
    rd_shader = loadShader("reaction_diffusion.glsl");
    rd_shader.set("grid",grid);
    
    paint_shader = loadShader("paint.glsl");
    
    draw_shader = loadShader("draw.glsl");
    draw_shader.set("canvas",grid);
    
  }
  
  public void setDiffuseA(float Da) {
    rd_shader.set("Da",this.Da=Da);
  }
  
  public void setDiffuseB(float Db) {
    rd_shader.set("Db",this.Db=Db);
  }
  
  public void setKill(float k) {
    rd_shader.set("k",this.k=k);
  }
  
  public void setFeed(float f) {
    rd_shader.set("f",this.f=f);
  }
  
  public void usePreset(int preset_id) {
    switch(preset_id) {
      case CORAL:
        setFeed(0.0545);
        setKill(0.0620);
      break;
      case MITOSIS:
        setFeed(0.0367);
        setKill(0.0649);
      break;
      case USKATE:
        setFeed(0.0620);
        setKill(0.0609);
      break;
    }
  }
  
  public void timeStep() {
    grid.beginDraw();
    grid.filter(rd_shader);
    grid.endDraw();
  }
  
  public void paint(float x, float y, float radius, color chemical) {
    grid.beginDraw();
    
    // upload our values to the paint shader
    paint_shader.set("canvas",grid);
    paint_shader.set("brush_radius",radius);
    paint_shader.set("brush_center",x,grid.height-y);
    paint_shader.set("brush_color",
      red(chemical)/255,
      green(chemical)/255,
      blue(chemical)/255,
      alpha(chemical)/255
    );
    grid.filter(paint_shader);
    grid.endDraw();
  }
  
  public PImage get() {
    canvas.beginDraw();
    canvas.filter(draw_shader);
    canvas.endDraw();
    return canvas;
  }
  
}