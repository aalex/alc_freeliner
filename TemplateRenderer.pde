/**
 * ##copyright##
 * See LICENSE.md
 *
 * @author    Maxime Damecour (http://nnvtn.ca)
 * @version   0.4
 * @since     2014-12-01
 */


/**
 * View part
 * The template renderer is where the rendering process begins.
 */

class TemplateRenderer implements FreelinerConfig{
  // rendering modes and repetition
  RenderMode[] renderModes;
  final int RENDERER_COUNT = 6;

  Repetition[] repeaters;
  final int REPEATER_COUNT = 4;

  Enabler[] enablers;
  final int ENABLER_COUNT = 7;

  // drawing surface
  PGraphics canvas;

  /**
   * Constructor
   */
	public TemplateRenderer(){
    // add renderModes
    renderModes = new RenderMode[RENDERER_COUNT];
    renderModes[0] = new BrushSegment();
    renderModes[1] = new LineSegment();
    renderModes[2] = new WrapLine();
    renderModes[3] = new Geometry();
    renderModes[4] = new TextLine();
    renderModes[5] = new CircularSegment();
    // add repetitionModes
    repeaters = new Repetition[REPEATER_COUNT];
    repeaters[0] = new Single();
    repeaters[1] = new EvenlySpaced();
    repeaters[2] = new EvenlySpacedWithZero();
    repeaters[3] = new TwoFull();
    // add enablers
    enablers = new Enabler[ENABLER_COUNT];
    enablers[0] = new Disabler();
    enablers[1] = new Enabler();
    enablers[2] = new Triggerable();
    enablers[3] = new Triggerable();
    enablers[4] = new SweepingEnabler();
    enablers[5] = new SwoopingEnabler();
    enablers[6] = new RandomEnabler();
	}

  public void setCanvas(PGraphics _pg){
    canvas = _pg;
  }

  /**
   * Render a arrayList of renderable templates.
   * @param ArrayList<RenderableTemplate> to render.
   */
  public void render(ArrayList<RenderableTemplate> _toRender){
    // copy arraylist
    ArrayList<RenderableTemplate> lst = new ArrayList<RenderableTemplate>(_toRender);
    // render templates
    if(lst.size() > 0)
      for(RenderableTemplate rt : lst)
        renderTemplate(rt);
  }

  /**
   * Render a renderable template.
   * @param RenderableTemplate to render.
   */
  public void renderTemplate(RenderableTemplate _rt){
    if(_rt == null) return;
    if(_rt.getSegmentGroup() == null) return;
    if(_rt.getSegmentGroup().isEmpty()) return;
    // push canvas to template
    _rt.setCanvas(canvas);
    // check the enabler, it may modify the unitInterval
    if(!enablers[_rt.getEnablerMode()%ENABLER_COUNT].enable(_rt)) return;
    // get multiple unit intervals to use
    FloatList flts = getRepeater(_rt.getRepetitionMode()).getFloats(_rt);
    int repetitionCount = 0;

    for(float flt : flts){
      // Repition object return arrayList of unit intervals.
      // negative values indicates going in reverse
      if(flt < 0){
        _rt.setLerp(flt+1);
        _rt.setDirection(true);
      }
      else {
        _rt.setLerp(abs(flt));
        _rt.setDirection(false);
      }
      // push the repetition count to template
      _rt.setRepetition(repetitionCount);
      repetitionCount++;
      // modify angle modifier
      tweakAngle(_rt);
      // pass template to renderer
      getRenderer(_rt.getRenderMode()).doRender(_rt);
    }
  }

  //needs work
  /**
   * One of the last few things to expand into
   * @param RenderableTemplate to render.
   */
  // yes a mess!
  public void tweakAngle(RenderableTemplate _rt){
    int rotMode = _rt.getRotationMode();
    float _ang = 0;
    if(rotMode == 0) _rt.setAngleMod(0);
    else {
      if(rotMode < 4){
        if(_rt.getSegmentGroup().isClockWise()) _ang = _rt.getLerp()*PI*-rotMode;
        else _ang = _rt.getLerp()*PI*rotMode;
      }
      else if(rotMode == 4) _ang = -_rt.getLerp()*PI;
      else if(rotMode == 5) _ang = _rt.getLerp()*PI;

      if(_rt.getDirection()) _ang -= PI;
      _rt.setAngleMod(_ang);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////
  ///////
  ///////     Accessors
  ///////
  ////////////////////////////////////////////////////////////////////////////////////

  public RenderMode getRenderer(int _index){
    if(_index >= RENDERER_COUNT) _index = RENDERER_COUNT - 1;
    return renderModes[_index];
  }

  public Repetition getRepeater(int _index){
    if(_index >= REPEATER_COUNT) _index = REPEATER_COUNT - 1;
    return repeaters[_index];
  }
}
