package nellson.tools;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;

/**
 * ...
 * @author Geun
 */

class LayoutHelper 
{
	public static function setCenter(container:DisplayObjectContainer, target:DisplayObject):Void
	{
		trace(container.width);
		trace(target.width);
		
		target.x = (container.width - target.width) * .5;
		target.y = (container.height - target.height) * .5;
	}
}