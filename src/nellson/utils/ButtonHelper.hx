package nellson.utils;
import nellson.ui.Button;
import flash.display.Sprite;
import nme.display.Bitmap;
import nme.events.MouseEvent;

import com.eclecticdesignstudio.motion.actuators.GenericActuator;
/**
 * ...
 * @author Geun
 */

class ButtonHelper 
{
	
	public static function zoomEffect(sprite:Sprite):Void
	{
		sprite.addEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
		sprite.addEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
	}
	
	public static function this_mouseOver(e:MouseEvent):Void 
	{
		Actuate.tween(this, 0.1, { scaleX:0.6, scaleY:0.6 }, false ).onComplete(update).ease(Quad.easeIn);
		//scaleX = scaleY = 0.6;
		bitmap.smoothing = true;
	}
	
	public static function this_mouseOut(e:MouseEvent):Void 
	{
		Actuate.tween(this, 0.1, { scaleX:0.5, scaleY:0.5 },false ).onComplete(update).ease(Quad.easeOut);
		//scaleX = scaleY = 0.5;
		//bitmap.smoothing = true;
	}
	
	public static function setCenterBitmap(sprite:Sprite, bitmap:Bitmap):Void
	{
		bitmap.x = -bitmap.width * .5;
		bitmap.y = -bitmap.height * .5;
		sprite.scaleX = sprite.scaleY = 0.5;
		//bitmap.smoothing = true;
	}
	
	
	public static function disable (sprite:Sprite):Void {
		
		sprite.mouseEnabled = false;
		sprite.mouseChildren = false;
		
	}
	
	
	public static function enable (sprite:Sprite, mouseChildren:Bool = true):Void {
		
		sprite.mouseEnabled = true;
		
		if (mouseChildren) {
			
			sprite.mouseChildren = true;
			
		}
		
	}
	
	
	public static function hide (sprite:Sprite, time:Float = 1):IGenericActuator {
		
		disable (sprite);
		return DisplayObjectHelper.fade (sprite, 0, time);
		
	}
	
	
	public static function show (sprite:Sprite, time:Float = 1):IGenericActuator {
		
		enable (sprite);
		return DisplayObjectHelper.fade (sprite, 1, time);
		
	}
	
	
}

	
	
}