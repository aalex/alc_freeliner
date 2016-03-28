/**
 * ##copyright##
 * See LICENSE.md
 *
 * @author    Maxime Damecour (http://nnvtn.ca)
 * @version   0.4
 * @since     2014-12-01
 */

/**
 * Abstract class for brushes.
 * Brushes are PShapes drawn along segments
 */
abstract class Brush implements FreelinerConfig{
	String name =  "basic";//brush
  // Size to generate brushes
	final int BASE_SIZE = 20;
  final int HALF_SIZE = BASE_SIZE/2;
  // The brush
  PShape brushShape;
  PShape scaledBrush;
  float scaledBrushSize;

  /**
   * Constructor, generates the shape
   */
  Brush(){
    brushShape = generateBrush();
    scaledBrush = brushShape;
    scaledBrushSize = BASE_SIZE;
  }

  /**
   * Needs to implement the making of the brush
   * The PShape has a center of 0,0 and points upwards.
   * @return PShape of the brush
   */
  abstract public PShape generateBrush();

  /**
   * Brush accessor
   * Makes a copy of the brush scaled by scalar.
   * @param RenderableTemplate for brush size scaling
   * @return PShape of the brush
   */
  public PShape getShape(RenderableTemplate _rt){
    // only clone if the size changed
		// #p3 bug fix...
  	if(abs(_rt.getScaledBrushSize() - scaledBrushSize) > 0.5){
      scaledBrushSize = _rt.getScaledBrushSize();
      scaledBrush = cloneShape(brushShape, scaledBrushSize/BASE_SIZE, new PVector(0,0));
    }
  	return scaledBrush;
  }
	public String getName(){
		return name;
	}
}

////////////////////////////////////////////////////////////////////////////////////
///////
///////     Subclasses, kept in the same file because too many files.
///////
////////////////////////////////////////////////////////////////////////////////////

/**
 * A brush that is just a point.
 */
class PointBrush extends Brush {

	String name =  "point";//brush

  public PointBrush(){
  }

	public PShape generateBrush(){
		PShape shp = createShape();
		shp.strokeJoin(STROKE_JOIN);
		shp.strokeCap(STROKE_CAP);
		shp.beginShape(POINTS);
    shp.vertex(0,0);
		shp.endShape();
		return shp;
	}
}

/**
 * A brush that is a perpendicular line.
 */
class LineBrush extends Brush {

	String name =  "line";//brush

  public LineBrush(){

  }
	public PShape generateBrush(){
		PShape shp = createShape();
    shp.beginShape(LINES);
    shp.vertex(-HALF_SIZE, 0);
    shp.vertex(HALF_SIZE, 0);
    shp.endShape();
    return shp;
	}
}

/**
 * Chevron brush >>>>
 */
class ChevronBrush extends Brush {

	String name =  "chevron";//brush

  public ChevronBrush(){

  }
	public PShape generateBrush(){
		PShape shp = createShape();
    shp.beginShape();
    shp.vertex(-HALF_SIZE, 0);
    shp.vertex(0, HALF_SIZE);
    shp.vertex(HALF_SIZE, 0);
    shp.endShape();
    return shp;
	}
}

/**
 * Square shaped brush
 */
class SquareBrush extends Brush {

	String name =  "square";//brush

  public SquareBrush(){

  }
	public PShape generateBrush(){
		PShape shp = createShape();
    shp.beginShape();
    shp.vertex(-HALF_SIZE, 0);
    shp.vertex(0, HALF_SIZE);
    shp.vertex(HALF_SIZE, 0);
    shp.vertex(0, -HALF_SIZE);
    shp.vertex(-HALF_SIZE, 0);
    shp.endShape(CLOSE);
    return shp;
	}
}

/**
 * Custom brush, a brush that is the segments of group.
 */
class CustomBrush extends Brush {

	String name =  "custom";//brush

  /**
   * Constructor will generate a null shape.
   */
  public CustomBrush(){
  }

  /**
   * Takes the sourceShape and makes the brush
   */
  public PShape generateBrush(){
    scaledBrushSize = 1;
    return null;
  }

  public PShape getShape(RenderableTemplate _rt){

    if(abs(_rt.getScaledBrushSize() - this.scaledBrushSize) > 0.5 || scaledBrush == null){
      //println(_rt.getScaledBrushSize() - scaledBrushSize);
      scaledBrushSize = _rt.getScaledBrushSize();
      scaledBrush = cloneShape( _rt.getCustomShape(), scaledBrushSize/BASE_SIZE, new PVector(0,0));
    }
    if(scaledBrush == null){
      PShape empty = createShape();
      empty.beginShape();
      empty.endShape(CLOSE);
      return empty;
    }
    return scaledBrush;
  }
}


/**
 * Circle shaped brush
 */
class CircleBrush extends Brush {

	String name =  "circle";//brush

  public CircleBrush(){

  }
  public PShape generateBrush(){
    PShape shp =  createShape(ELLIPSE, 0, 0, BASE_SIZE, BASE_SIZE);
    return shp;
  }
	// overRide for scaling
	public PShape getShape(RenderableTemplate _rt){
		// update if the size changed
		if(abs(_rt.getScaledBrushSize() - scaledBrushSize) > 0.5){
			scaledBrushSize = _rt.getScaledBrushSize();
			scaledBrush = createShape(ELLIPSE, 0, 0, scaledBrushSize, scaledBrushSize);
		}
		return scaledBrush;
	}
}

/**
 * Triangle shaped brush
 */
class TriangleBrush extends Brush {

	String name =  "triangle";//brush

  public TriangleBrush(){

  }
  public PShape generateBrush(){
    float hght = sqrt(sq(BASE_SIZE)+pow(HALF_SIZE,2));
    PShape shp = createShape(TRIANGLE, -HALF_SIZE, 0,
                                       HALF_SIZE, 0,
                                       0, BASE_SIZE*pow(3, 1/3.0)/2);
    return shp;
  }
}


/**
 * X shaped brush
 */
class XBrush extends Brush {

	String name =  "X";//brush

  public XBrush(){

  }
  public PShape generateBrush(){
    PShape shp = createShape();
    shp.beginShape(LINES);
    shp.vertex(-HALF_SIZE, -HALF_SIZE);
    shp.vertex(HALF_SIZE, HALF_SIZE);
    shp.vertex(-HALF_SIZE, HALF_SIZE);
    shp.vertex(HALF_SIZE, -HALF_SIZE);
    shp.endShape();
    return shp;
  }
}

/**
 * Leaf shaped brush
 */
class LeafBrush extends Brush {

	String name =  "leaf";//brush

  public LeafBrush(){

  }
  public PShape generateBrush(){
    PShape shp = createShape();
    shp.beginShape();
		shp.vertex(-0.6728153, 7.683716);
		shp.vertex(-0.4056158, 2.7851562);
		shp.vertex(-2.8896399, 4.5375977);
		shp.vertex(-4.957216, 5.289551);
		shp.vertex(-3.3653917, 3.6522217);
		shp.vertex(-0.48373985, 2.5578613);
		shp.vertex(-4.891837, 2.8632812);
		shp.vertex(-8.405435, 0.9388428);
		shp.vertex(-4.4208436, 1.0469971);
		shp.vertex(-0.46278572, 2.366455);
		shp.vertex(-4.9180675, -0.93652344);
		shp.vertex(-7.5094423, -5.944824);
		shp.vertex(-3.296897, -2.949585);
		shp.vertex(-0.4129467, 2.2398682);
		shp.vertex(-1.4464064, -2.9370117);
		shp.vertex(0.1256113, -10.602173);
		shp.vertex(1.3657084, -3.0498047);
		shp.vertex(0.0832119, 2.2938232);
		shp.vertex(3.0037231, -2.4002686);
		shp.vertex(8.227526, -6.843628);
		shp.vertex(5.1290474, -0.6890869);
		shp.vertex(0.1441145, 2.5178223);
		shp.vertex(4.1453266, 1.0227051);
		shp.vertex(8.281681, 0.76416016);
		shp.vertex(4.5554295, 2.894287);
		shp.vertex(0.081624985, 2.7386475);
		shp.vertex(2.7639713, 3.6608887);
		shp.vertex(4.9208336, 5.5914307);
		shp.vertex(1.978899, 4.6070557);
		shp.vertex(-0.193079, 2.8511963);
		shp.vertex(-0.35807228, 7.8149414);
    shp.endShape();
    return shp;
  }
}


/**
 * Sprinkles
 */
class SprinkleBrush extends Brush {

	String name =  "sprinkle";//brush

  public SprinkleBrush(){}
  // dosent apply here...
  public PShape generateBrush(){
    PShape shp = createShape();
    shp.beginShape(LINES);
    shp.vertex(-HALF_SIZE, -HALF_SIZE);
    shp.vertex(HALF_SIZE, HALF_SIZE);
    shp.endShape();
    return shp;
  }

  private PShape generateSprinkles(float _sz){
    PShape shp = createShape();
    shp.beginShape(POINTS);
    PVector pnt;
    PVector cent = new PVector(0,0);
    float half = _sz/2.0;
    for(int i = 0; i < _sz*3; i++){
      pnt = new PVector(random(_sz) - (half), random(_sz) - (half));
      if(cent.dist(pnt) < half) shp.vertex(pnt.x, pnt.y);
    }
    shp.endShape();
    return shp;
  }

  public PShape getShape(RenderableTemplate _rt){
    return generateSprinkles(_rt.getScaledBrushSize());
  }
}
