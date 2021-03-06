
// base class for color picking
// add global color pallette to manipulate.
// then the color cycling modes can hop between pre determined colours.
class Colorizer {
	//custom colors?
	final String name = "Colorizer";

  public Colorizer(){
  }

  public color get(RenderableTemplate _event, int _alpha){
  	return alphaMod(color(255), _alpha);
  }

	// need to multiplex alpha value for fill & stroke, just fill, or just stroke.
  public color alphaMod(color  _c, int _alpha){
  	return color(red(_c), green(_c), blue(_c), _alpha);
  }

  public color HSBtoRGB(float _h, float _s, float _b){
  	return java.awt.Color.HSBtoRGB(_h, _s, _b);
  }

	public color getFromPallette(int _c){
		if(_c >= 0 || _c < PALLETTE_COUNT) return userPallet[_c];
		else return color(255);
	}

  public String getName(){
  	return name;
  }
}

////////////////////////////////////////////////////////////////////////////////////
///////
///////     Subclasses
///////
////////////////////////////////////////////////////////////////////////////////////

/**
 * Basic Color
 */
class SimpleColor extends Colorizer{
	color col;
	public SimpleColor(color _c){
		col = _c;
	}
	public color get(RenderableTemplate _event, int _alpha){
		return alphaMod(col , _alpha);
	}
}

/**
 * Colors from the user's pallette
 */
class PalletteColor extends Colorizer {
	int colorIndex;

	public PalletteColor(int _i){
		colorIndex = _i;
	}

	public color get(RenderableTemplate _event, int _alpha){
		return alphaMod(getFromPallette(colorIndex) , _alpha);
	}
}

/**
 * Working with primary colors
 */
class PrimaryColor extends Colorizer {
	public PrimaryColor(){

	}

	public color get(RenderableTemplate _event, int _alpha){
		return alphaMod(getPrimary(1), _alpha);
	}

	public color getPrimary(int _c){
		switch(_c){
			case 0:
				return #ff0000;
			case 1:
				return #00ff00;
			default:
				return #0000ff;
		}
	}
}

/**
 * Random primary color
 */
class RandomPrimaryColor extends PrimaryColor {
	public RandomPrimaryColor(){

	}

	public color get(RenderableTemplate _event, int _alpha){
		return alphaMod(getPrimary(_event.getRandomValue()%3), _alpha);
	}
}

/**
 * Changes primary color on the beat regardless of divider
 */
class PrimaryBeatColor extends PrimaryColor {
	public PrimaryBeatColor(){
	}

	public color get(RenderableTemplate _event, int _alpha){
		return alphaMod(getPrimary(_event.getRawBeatCount() % 3), _alpha);
	}
}

/**
 * Constantly changing random primary color
 */
class FlashyPrimaryColor extends PrimaryColor {
	public FlashyPrimaryColor(){

	}

	public color get(RenderableTemplate _event, int _alpha){
		return alphaMod(getPrimary((int)random(3)), _alpha);
	}
}

/**
 * Per Repetition
 */
class JahColor extends Colorizer {

	color[] jah = {#CE000E,#E9FF00,#268E01};
	final int JAH_COUNT = 3;
	public JahColor(){

	}

	public color get(RenderableTemplate _event, int _alpha){
		int index = (_event.getBeatCount()-_event.getRepetition()+_event.getSegmentIndex()) % JAH_COUNT;
		index %= JAH_COUNT;
		if(index < 0) index = 0;
		color c = jah[index];
		return alphaMod(c , _alpha);
	}
}

/**
 * JahColor
 */
class RepetitionColor extends Colorizer {

	public RepetitionColor(){

	}

	public color get(RenderableTemplate _event, int _alpha){
		int index = (_event.getBeatCount()-_event.getRepetition()+_event.getSegmentIndex()) % PALLETTE_COUNT;
		index %= PALLETTE_COUNT;
		if(index < 0) index = 0;
		color c = userPallet[index];
		return alphaMod(c , _alpha);
	}
}

/**
 * Constantly changing random value gray
 */
class FlashyGray extends Colorizer {
	public FlashyGray(){

	}

	public color get(RenderableTemplate _event, int _alpha){
		color c = color(random(255));
		return alphaMod(c , _alpha);
	}
}


/**
 * Constantly changing random color
 */
class FlashyRandom extends Colorizer {
	public FlashyRandom(){

	}

	public color get(RenderableTemplate _event, int _alpha){
		color c = color(random(255),random(255),random(255));
		return alphaMod(c , _alpha);
	}
}

/**
 * Constantly changing random color
 */
class Strobe extends Colorizer {
	public Strobe(){
	}

	public color get(RenderableTemplate _event, int _alpha){
		if(maybe(20)) return color(255);
		else return color(255,0);
	}
}

/**
 * flash once! then black?
 */
class Flash extends Colorizer {
	public Flash(){
	}

	public color get(RenderableTemplate _event, int _alpha){
		if(_event.getUnitInterval()<0.01) return color(255, 255);
		else if(_event.getUnitInterval()>0.1) return color(0,0);
		else return color(0, 255);
	}
}



/**
 * Fade through the HUE
 */
class MillisFade extends Colorizer {
	public MillisFade(){
	}
	public color get(RenderableTemplate _event, int _alpha){

		color c = HSBtoRGB(float(millis()%10000)/10000.0, 1.0, 1.0);
		return alphaMod(c , _alpha);
	}
}

/**
 * Fade through the HUE
 */
class HSBLerp extends Colorizer {
	public HSBLerp(){
	}
	public color get(RenderableTemplate _event, int _alpha){
		color c = HSBtoRGB(_event.getLerp(), 1.0, 1.0);
		return alphaMod(c , _alpha);
	}
}

/**
 * HSB Lerp
 */
class HSBFade extends Colorizer {
	public HSBFade(){
	}
	public color get(RenderableTemplate _event, int _alpha){
		float hue = _event.getHue();
		color c = HSBtoRGB(hue, 1.0, 1.0);
		hue+=0.001;
		hue = fltMod(hue);
		_event.setHue(hue);
		return alphaMod(c , _alpha);
	}
}

/**
 * Get template's custom color
 */
class CustomColor extends Colorizer {
	public CustomColor(){
	}
	public color get(RenderableTemplate _event, int _alpha){
		return alphaMod(_event.getCustomColor(), _alpha);
	}
}
