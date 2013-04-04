package nellson.tick;
import nellson.signals.Signal1;
import gm2d.display.DisplayObject;
import gm2d.events.Event;

/**
 * ...
 * @author Geun
 */

class FixedTickProvider extends Signal1<Float>, implements ITickProvider
{
	
	private var displayObject:DisplayObject;
	private var frameTime:Float;
	
	public var timeAdjustment:Float = 1;

	public function new(displayObject:DisplayObject, frameTime:Float) 
	{
		super(Float)
		this.displayObject = displayObject;
		this.frameTime = frameTime;
		
	}
	
	public function start():Void
	{
		displayObject.addEventListener(Event.ENTER_FRAME, dispathTick);
	}
	public function stop():Void
	{
		displayObject.removeEventListener(Event.ENTER_FRAME, dispathTick);
	}
	
	private function dispathTick(e:Event):Void
	{
		this.dispatch(frameTime * timeAdjustment);
	}
	
}