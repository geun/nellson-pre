package ;

import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.Lib;

/**
 * ...
 * @author geun
 */

class Main 
{
	
	static public function main() 
	{
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		// entry point
	}
	
}