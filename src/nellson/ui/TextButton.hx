package nellson.ui;
import nme.display.BitmapData;
import nme.text.TextField;

/**
 * ...
 * @author Geun
 */

class TextButton extends Button
{
	public var label:TextField;
	
	public function new(?img:BitmapData) 
	{
		super(img);
		
		label = new TextField();
		addChild(label);
	}
}