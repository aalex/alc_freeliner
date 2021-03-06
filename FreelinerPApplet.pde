/**
 * ##copyright##
 * See LICENSE.md
 *
 * @author    Maxime Damecour (http://nnvtn.ca)
 * @version   0.5
 * @since     2016-02-21
 */




import processing.core.PApplet;
import processing.core.PSurface;

 /**
  * ExternalGUI is a seperate PApplet launched by freeliner
  */
public class FreelinerPApplet extends PApplet {


  /**
   * HELLO THERE! WELCOME to FREELINER
   * Here are some settings. There are more settings in the Config.pde file.
   */
  void settings(){
    // set the resolution, or fullscreen and display
    size(1024, 768, P2D);
    //size(1024, 683, P2D);
    //fullScreen(P2D, 2);
    //fullScreen(P2D, SPAN);
    // needed for syphon!
    PJOGL.profile=1;
    smooth(0);
  }



  ////////////////////////////////////////////////////////////////////////////////////
  ///////
  ///////     Not Options
  ///////
  ////////////////////////////////////////////////////////////////////////////////////

  FreeLiner freeliner;
  // fonts
  PFont font;
  PFont introFont;

  final String VERSION = "0.4";
  boolean doSplash = true;
  boolean OSX = false;

  OscP5 oscP5;
  // where to send a sync message
  NetAddress toPDpatch;
  OscMessage tickmsg = new OscMessage("/freeliner/tick");

  ExternalGUI externalGUI = null; // set specific key to init gui
  boolean runGui = false;


  ////////////////////////////////////////////////////////////////////////////////////
  ///////
  ///////     Setup
  ///////
  ////////////////////////////////////////////////////////////////////////////////////

  public FreelinerPApplet() {

    // pick your flavour of freeliner
    freeliner = new FreeLiner(this);
    //freeliner = new FreelinerSyphon(this); <- FOR SYPHON
    //freeliner = new FreelinerLED(this,"tunnel_map.xml");

    surface.setResizable(false);
    surface.setTitle("a!Lc Freeliner");
    noCursor();
    hint(ENABLE_KEY_REPEAT); // usefull for performance

    // load fonts
    introFont = loadFont("MiniKaliberSTTBRK-48.vlw");
    font = loadFont("Arial-BoldMT-48.vlw");

    //osc
    oscP5 = new OscP5(this, FreelinerConfig.OSC_IN_PORT);
    toPDpatch = new NetAddress(FreelinerConfig.OSC_OUT_IP, FreelinerConfig.OSC_OUT_PORT);
    oscP5.addListener(freeliner.osc);
    // detect OSX
    if(System.getProperty("os.name").charAt(0) == 'M') OSX = true;
    else OSX = false;
    // perhaps use -> PApplet.platform == MACOSX
    splash();
    if(runGui) launchGUI();
  }

  // splash screen!
  void splash(){
    background(0);
    stroke(100);
    fill(150);
    //setText(CENTER);
    textFont(introFont);
    text("a!Lc freeLiner", 10, height/2);
    textSize(24);
    fill(255);
    text("V"+VERSION+" - made with PROCESSING", 10, (height/2)+20);
  }
  ////////////////////////////////////////////////////////////////////////////////////
  ///////
  ///////     Draw
  ///////
  ////////////////////////////////////////////////////////////////////////////////////

  // do the things
  void draw() {
    background(0);
    if(doSplash) splash();
    freeliner.update();
  }

  // sync message to other software
  void oscTick(){
   oscP5.send(tickmsg, toPDpatch);
  }
  ////////////////////////////////////////////////////////////////////////////////////
  ///////
  ///////    Input
  ///////
  ////////////////////////////////////////////////////////////////////////////////////

  // relay the inputs to the mapper
  void keyPressed() {
    freeliner.getKeyboard().processKey(key, keyCode);
    if(key == '~') launchGUI();
    if (key == 27) key = 0;       // dont let escape key, we need it :)
  }

  void keyReleased() {
    freeliner.getKeyboard().processRelease(key, keyCode);
  }

  void mousePressed(MouseEvent event) {
    doSplash = false;
    freeliner.getMouse().press(mouseButton);
  }

  void mouseDragged() {
    freeliner.getMouse().drag(mouseButton, mouseX, mouseY);
  }

  void mouseMoved() {
    freeliner.getMouse().move(mouseX, mouseY);
  }

  void mouseWheel(MouseEvent event) {
    freeliner.getMouse().wheeled(event.getCount());
  }
}
