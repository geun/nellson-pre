package nellson.ui;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import com.eclecticdesignstudio.motion.easing.Sine;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Shape;
import nme.display.Sprite;
import nme.events.MouseEvent;

/**
 * ...
 * @author Geun
 */

class Button extends Sprite
{
	public var bitmap:Bitmap;
	private var img:BitmapData;
	public var text:Shape;

	public function new(?img:BitmapData) 
	{
		super();
		
		this.img = img;
		init();
	}
	
	inline private function init():Void
	{
		bitmap = new Bitmap(img);
		//bitmap.cacheAsBitmap = true;
		this.mouseChildren = false;
		addChild(bitmap);
		text = new Shape();
		addChild(text);
		
		//this.addEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
		//this.addEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
	}
	
	public function setZoomEffect(value:Bool):Void
	{
		if (value)
		{
			
			if(!this.hasEventListener(MouseEvent.MOUSE_OVER)) this.addEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
			if(!this.hasEventListener(MouseEvent.MOUSE_OUT)) this.addEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
		}
		else
		{
			if(this.hasEventListener(MouseEvent.MOUSE_OVER)) this.removeEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
			if(this.hasEventListener(MouseEvent.MOUSE_OUT)) this.removeEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
		}
	}
	private function this_mouseOver(e:MouseEvent):Void 
	{
		Actuate.tween(this, 0.1, { scaleX:0.55, scaleY:0.55 }, false ).onComplete(update);
		//scaleX = scaleY = 0.6;
		//bitmap.smoothing = true;
		//this.cacheAsBitmap = true;
	}
	
	private function this_mouseOut(e:MouseEvent):Void 
	{
		Actuate.tween(this, 0.1, { scaleX:0.5, scaleY:0.5 }, false ).onComplete(update);
		//scaleX = scaleY = 0.5;
		//bitmap.smoothing = true;
		//this.cacheAsBitmap = true;
	}
	
	public function setCenterImg():Void
	{
		bitmap.x = -bitmap.width * .5;
		bitmap.y = -bitmap.height * .5;
		
		bitmap.smoothing = true;
		//this.cacheAsBitmap = true;
		setZoomEffect(true);
		var _hitArea = new Sprite();
		_hitArea.graphics.beginFill(0x0,0);
		_hitArea.graphics.drawRect(bitmap.x, bitmap.y, this.width, this.height);
		this.addChild(_hitArea);
		this.hitArea = _hitArea;
		
		scaleX = scaleY = 0.5;
	}
	
	private function update():Void
	{
		this.cacheAsBitmap = true;
		bitmap.smoothing = true;
	}
	
	public function move(dx:Float, dy:Float):Void
	{
		this.x = dx;
		this.y = dy;
	}
	
}