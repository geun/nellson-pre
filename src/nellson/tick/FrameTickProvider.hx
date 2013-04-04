package nellson.tick;
import nellson.signals.Signal1;
import nme.display.DisplayObject;
import nme.events.Event;
import nme.events.TimerEvent;
import nme.Lib;
import nme.utils.Timer;

/**
 * ...
 * @author Geun
 */
 
class FrameTickProvider extends Signal1<Float>, implements ITickProvider<Float->Void>
{
	private var displayObject:DisplayObject;
	private var previousTime:Float;
	private var maximumFrameTime:Float;
	
	public var isRunning:Bool;
	public var timeAdjustment:Float;
	public var currentTime(default, null):Float;
	private var _currentDate:Date;
	public var currentDate(getCurrentDate, setCurrentDate):Date;
	
	public function new(displayObject:DisplayObject, maximumFrameTime:Float = 100000) 
	{
		super(Float);
		
		previousTime = 0;
		timeAdjustment = 1;
		
		
		this.displayObject = displayObject;
		this.maximumFrameTime = maximumFrameTime;
		isRunning = false;
		
		displayObject.addEventListener(Event.ACTIVATE, displayObject_activate);
		displayObject.addEventListener(Event.DEACTIVATE, displayObject_deactivate);
	}
	
	private function displayObject_deactivate(e:Event):Void 
	{
		trace('deactivate');
	}
	
	private function displayObject_activate(e:Event):Void 
	{
		trace('activate');
	}
	
	inline public function setCurrentDate(value:Date):Date
	{
		_currentDate = value;
		currentTime = _currentDate.getTime() * .001;
		//return currentTime;
		return _currentDate;
	}
	public function getCurrentDate():Date
	{
		return Date.fromTime(currentTime * 1000);
	}
	
	public function start():Void
	{
		#if flash
		previousTime = flash.Lib.getTimer();
		//var timer = new Timer(1000);
		//timer.addEventListener(TimerEvent.TIMER, function(e) { trace(Date.now()); } );
		//timer.start();
		#else
		previousTime = nme.Lib.getTimer();
		#end
		isRunning = true;
		displayObject.addEventListener(Event.ENTER_FRAME, displayObject_enterFrame);
		
		
		
	}
	
	private function displayObject_enterFrame(e:Event):Void 
	{
		var temp:Float = previousTime;
		#if flash
		previousTime = flash.Lib.getTimer();
		#else
		previousTime = nme.Lib.getTimer();
		#end
		var frameTime:Float = (previousTime - temp) / 1000;
		if (frameTime > maximumFrameTime)
		{
			frameTime = maximumFrameTime;
		}
		
		currentTime += frameTime;
		this.dispatch(frameTime);
		
	}
	public function stop():Void
	{
		isRunning = false;
		displayObject.removeEventListener(Event.ENTER_FRAME, displayObject_enterFrame);
	}
	
}