/**
 * ##copyright##
 * See LICENSE.md
 *
 * @author    Maxime Damecour (http://nnvtn.ca)
 * @version   0.4
 * @since     2015-07-22
 */

// Syphon!!
// if you are like me and dont have a MAC, keep this commented.

/* DELETE THIS LINE

import codeanticode.syphon.*;

class FreelinerSyphon extends FreeLiner{
	SyphonServer syphonServer;

	public FreelinerSyphon(PApplet _pa){
		super(_pa);
  	syphonServer = new SyphonServer(_pa, "alcFreeliner");
	}

	void update(){
		super.update();
		syphonServer.sendImage(canvasManager.getFXCanvas());
	}
}

*/ //DELETE THIS LINE



import spout.*;

class FreelinerSpout extends FreeLiner{
	Spout spout;

	public FreelinerSpout(PApplet _pa){
		super(_pa);
    spout = new Spout(_pa);
		spout.createSender("alc_freeliner", width, height);
	}

	void update(){
		super.update();
		spout.sendTexture(canvasManager.getFXCanvas());
	}
}
