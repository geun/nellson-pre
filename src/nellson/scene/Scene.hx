package nellson.scene;
import com.eclecticdesignstudio.motion.Actuate;
import nellson.statemachine.IState;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Sprite;

/**
 * ...
 * @author Geun
 */

class Scene extends Sprite, implements IState
{
	private var backgroud:Bitmap;
	public var isAnimating:Bool;
	public var isInited:Bool;
	
	public function new(name:String) 
	{
		super();
		this.name = name;
		isAnimating = false;
		isInited = false;
	}
	
	/* INTERFACE nellson.statemachine.IState */
	
	public function addBackground(url:String):Void
	{
		var backgroudData:BitmapData = Assets.getBitmapData(url);
		backgroud = new Bitmap(backgroudData);
		addChildAt(backgroud,0);	
	}
	
	public function getBackground():DisplayObject
	{
		return backgroud;
	}
	
	public function release():Void 
	{
		
	}
	
	public function enter():Void 
	{
		
		if (isAnimating) Actuate.stop(this); 
		isAnimating = true;
		this.alpha = 0;
		Actuate.tween(this, 1, { alpha: 1  }, true).onComplete(transitionIn);
	}
	
	public function update(?time:Float):Void 
	{
		
	}
	
	public function exit():Void 
	{
		if (isAnimating) Actuate.stop(this); 
		isAnimating = true;
		Actuate.tween(this, 1, { alpha: 0  }, true).onComplete(transitionOut);
	}
	
	public function show():Void
	{
		this.visible = true;
		this.alpha = 100;
	}
	
	public function hide():Void
	{
		this.visible = false;
	}
	
	public function transitionIn():Void
	{
		isAnimating = false;
	}
	
	public function transitionOut():Void
	{
		isAnimating = false;
	}
	
	
	public function resize(scale:Float, scaleOffset:Float):Void
	{
		
	}
	
}