/**
 * ##copyright##
 * See LICENSE.md
 *
 * @author    Maxime Damecour (http://nnvtn.ca)
 * @version   0.4
 * @since     2014-12-01
 */


/**
 * A segment consist of two vertices with special other data as a offset line.
 */
class Segment {
  // these are the main coordinates of the start and end of a segment
  PVector pointA;
  PVector pointB;
  // angles of offset
  float offsetAngleA;
  float offsetAngleB;
  float offsetSize = 0;
  PVector offsetA;
  PVector offsetB;

  // center position of the segment
  PVector center;

  // angle of the segment.
  float angle;
  boolean centered;
  boolean clockWise;

  // previous and or next segments, needed to create offset line
  Segment neighbA;
  Segment neighbB;

  // these are alternative positions for pointA and pointB
  PVector ranA;
  PVector ranB;

  // a segment specific random value...
  float ranFloat;

  // text for the segment
  String segmentText;

  public Segment(PVector pA, PVector pB) {
    pointA = pA.get();
    pointB = pB.get();
    offsetA = pA.get();
    offsetB = pB.get();
    offsetAngleA = 0;
    offsetAngleB = 0;

    center = new PVector(0, 0, 0);
    newRan();
    centered = false;
    updateAngle();
    segmentText = "freeliner!";
  }


  ////////////////////////////////////////////////////////////////////////////////////
  ///////
  ///////     Geometry stuff
  ///////
  ////////////////////////////////////////////////////////////////////////////////////

  public void updateAngle(){
    angle = atan2(pointA.y-pointB.y, pointA.x-pointB.x);
    //anglePI = angle + PI;
    if(pointA.x > pointB.x){
      if(pointA.y > pointB.y) clockWise = false;
      else clockWise = true;
    }
    else if(pointA.y > pointB.y) clockWise = true;
    else clockWise = false;
    updateOffsetAngles();
  }

  // only gets called on angle update
  private void updateOffsetAngles(){
    if(neighbA == null || neighbB == null) return;
    offsetAngleA = calcOffsetAngle(pointA, neighbA.getPointA(), pointB, center, neighbA.getPointB());
    offsetAngleB = calcOffsetAngle(pointB, pointA, neighbB.getPointB(), center, neighbB.getPointA());
  }

  /**
   * This is to generate new vertices in relation to brush size.
   * @param PVector vertex to offset
   * @param PVector previous neighboring vertex
   * @param PVector following neighboring vertex
   * @param PVector center of shape
   * @param PVector an other to point to check if the offset should be perpendicular
   * @return PVector offseted vertex
   */
  float calcOffsetAngle(PVector p, PVector pA, PVector pB, PVector c, PVector ot) {
    float d = 20.0;
    float angleA = (atan2(p.y-pA.y, p.x-pA.x));
    float angleB = (atan2(p.y-pB.y, p.x-pB.x));
    float A = radianAbs(angleA);
    float B = radianAbs(angleB);
    float ang = abs(A-B)/2; //the shortest angle
    d = (d/2);
    if(p.dist(ot) > 3.0) ang = HALF_PI + angle;
    else {
      d = d/sin(ang);
      if (A<B) ang = (ang+angleA);
      else ang = (ang+angleB);
    }
    PVector outA = new PVector(cos(ang)*d, sin(ang)*d, 0);
    PVector outB = new PVector(cos(ang+PI)*d, sin(ang+PI)*d, 0);
    outA.add(p);
    outB.add(p);

    if (c.dist(outA) < c.dist(outB)) return ang;
    else  return ang+PI;
  }

  float radianAbs(float a) {
    while (a<0) {
      a+=TWO_PI;
    }
    while (a>TWO_PI) {
      a-=TWO_PI;
    }
    return a;
  }

  // set the offsetsize
  private void setOffsetSize(float _f){
    if(offsetSize != _f){
      offsetSize = _f;
      if(centered) findOffset();
    }
  }

  // set the offset coords
  private void findOffset() {
    offsetA.set( cos(offsetAngleA) * offsetSize, sin(offsetAngleA) * offsetSize, 0);
    offsetA.add(pointA);
    offsetB.set( cos(offsetAngleB) * offsetSize, sin(offsetAngleB) * offsetSize, 0);
    offsetB.add(pointB);
  }

  ////////////////////////////////////////////////////////////////////////////////////
  ///////
  ///////     Modifiers
  ///////
  ////////////////////////////////////////////////////////////////////////////////////

  public void newRan(){
    ranA = new PVector(pointA.x+random(-100, 100), pointA.y+random(-100, 100), 0);
    ranB = new PVector(pointB.x+random(-100, 100), pointB.y+random(-100, 100), 0);
    ranFloat = 1+random(50)/100.0;
  }

  public void setNeighbors(Segment a, Segment b){
    neighbA = a;
    neighbB = b;
    updateOffsetAngles();
  }

  public void setPointA(PVector p){
    pointA = p.get();
    updateAngle();
  }

  public void setPointB(PVector p){
    pointB = p.get();
    updateAngle();
  }

  public void setCenter(PVector c) {
    centered = true;
    center = c.get();
    updateOffsetAngles();
  }

  public void unCenter(){
    centered = false;
  }

  public void setText(String w){
    segmentText = w;
  }

  ////////////////////////////////////////////////////////////////////////////////////
  ///////
  ///////     Accessors
  ///////
  ////////////////////////////////////////////////////////////////////////////////////

  /**
   * POINT POSITIONS
   */

  /**
   * Get the first vertex
   * @return PVector pointA
   */
  public final PVector getPointA(){
    return pointA;
  }

  /**
   * Get the second vertex
   * @return PVector pointB
   */
  public final PVector getPointB(){
    return pointB;
  }

  /**
   * Get pointA's strokeWidth offset
   * @return PVector offset of stroke width
   */
  public final PVector getOffsetA(){
    if(!centered) return pointA;
    return offsetA;
  }

  /**
   * Get pointB's strokeWidth offset
   * @return PVector offset of stroke width
   */
  public final PVector getOffsetB(){
    if(!centered) return pointB;
    return offsetB;
  }

  public final float getOffsetSize(){
    return offsetSize;
  }

  /**
   * Get pointA's brushSize offset
   * @return PVector offset of brushSize
   */
  // public final PVector getBrushOffsetA(){
  //   if(!centered) return pointA;
  //   return brushOffsetA;
  // }

  /**
   * Get pointB's brushSize offset
   * @return PVector offset of brushSize
   */
  // public final PVector getBrushOffsetB(){
  //   if(!centered) return pointB;
  //   return brushOffsetB;
  // }

  /**
   * INTERPOLATED POSTIONS
   */

  /**
   * Interpolate between pointA and pointB, offset by brush if centered
   * @param float unit interval (lerp)
   * @return PVector interpolated position
   */
  public final PVector getOffsetPos(float _l) {
    if (centered) return vecLerp(offsetA, offsetB, _l);
    else return vecLerp(pointA, pointB, _l);
  }

  public final PVector getPos(float _l) {
    return vecLerp(pointA, pointB, _l);
  }

  /**
   * Interpolate between pointA and pointB, offset by strokeWidth if centered
   * @param float unit interval (lerp)
   * @return PVector interpolated position
   */
  // public final PVector getStrokePos(float _l) {
  //   if (centered) return vecLerp(strokeOffsetA, strokeOffsetB, _l);
  //   else return vecLerp(pointA, pointB, _l);
  // }

  //random pos
  public final PVector getRanA() {
    return ranA;
  }

  public final PVector getRanB() {
    return ranB;
  }

  // other stuff
  public final boolean isCentered(){
    return centered;
  }

  public final boolean isClockWise(){
    return clockWise;
  }

  public final float getAngle(boolean inv) {
    if(inv) return angle+PI;
    return angle;
  }

  public final float getRanFloat(){
    return ranFloat;
  }

  public final float getLength() {
    return dist(pointA.x, pointA.y, pointB.x, pointB.y);
  }

  public final PVector getCenter() {
    return center;
  }

  public final PVector getMidPoint() {
    return vecLerp(pointA, pointB, 0.5);
  }

  public final String getText(){
    return segmentText;
  }

  public final Segment getNext(){
    return neighbB;
  }

  public final Segment getPrev(){
    return neighbA;
  }
}
