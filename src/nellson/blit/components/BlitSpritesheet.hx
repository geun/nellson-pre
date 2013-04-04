package nellson.blit.components;
import nellson.blit.components.ITilesheet;
import de.polygonal.ds.ArrayUtil;
//import nme.ObjectHash;
import nellson.ds.ObjectHash;
import nme.display.BitmapData;
import nme.errors.Error;
import nme.geom.Rectangle;


//using Lambda;

using de.polygonal.ds.ArrayUtil;
using Lambda;
/**
 * ...
 * @author Geun
 */

class BlitSpritesheet
{
	public var tilesheet:ITilesheet;
	public var oversheet:ITilesheet;
	public var frames:Array<Int>;
	public var name:String;
	//private var cycles:ObjectHash<String, BlitSpritesheetCycle>;
	
	#if flash
	private var cycles:ObjectHash<BlitSpritesheetCycle>;
	#else
	private var cyclesNames:Array<String>;
	private var cyclesDatas:Array<BlitSpritesheetCycle>;
	#end
	
	private var _currentIdx:Int;
	private var currentCycle:BlitSpritesheetCycle;
	private var animated:Bool;
	private var fps:Int;
	private var time:Float;
	private var prevFrame:Int;
	private var idx:Int;
	
	//static private inline var DURATION:Float = 10.0;
	public var loop:Bool;
	
	public var onComplete:Void->Void;
	
	public function new(tilesheet:ITilesheet, oversheet:ITilesheet, name:String, fps:Int = 18) 
	{
		this.tilesheet = tilesheet;
		this.oversheet = oversheet;
		this.name = name;
		this.fps = fps;
		animated = true;
		loop = true;
		time = 0;
		prevFrame = -1;
		init();
	}
	
	private function init():Void
	{
		_currentIdx = 0;
		
		
		#if flash
		cycles = new ObjectHash();
		#else
		cyclesNames = new Array();
		cyclesDatas = new Array();
		#end
		
		frames = tilesheet.getTextures(name);
		
		//fps = frames.length;
		if (frames.length == 0) throw new Error('there is no frames');
	}
		
	
	public function addCycle(cycle:BlitSpritesheetCycle):BlitSpritesheet
	{
		var id:String = cycle.id;
		#if flash
		cycles.set(id, cycle);
		#else
		cyclesNames.push(id);
		cyclesDatas.push(cycle);
		#end
		if (currentCycle == null) updateCycle(id);
		
		return this;
	}
	
	#if !flash
	inline private function findCycle(id:String):Int
	{
		var idx:Int = -1;
		for ( i in 0...cyclesNames.length)
		{
			if (cyclesNames[i] == id) idx = i;
		}
		return idx;
		
	}
	#end
	
	inline public function updateCycle(id:String):Void
	{
		//trace('update cycle ' + id);
		#if flash
		if (cycles.has(id))
		{
			currentCycle = cycles.get(id);
			_currentIdx = frames[currentCycle.startFrame-1];
			
			//trace('set cycle : ' + id + ' / frameNum : ' +currentCycle.numFrames);
		}
		#else
		var ids:Int = findCycle(id);
		if (ids != -1)
		{
			// trace(ids);
			currentCycle = cyclesDatas[ids];
			_currentIdx = frames[0];
			
			//trace('set cycle : ' + id + ' / frameNum : ' +currentCycle.numFrames);
		}
		#end
		else
		{
			throw new Error('there is no cycle');
		}
		fps = currentCycle.numFrames;
	}
	
	public function removeCycle():Bool
	{
		//TODO: 나중에 하자 
		return false;
	}
	
	public function setFrameByName(name:String):Void
	{
		var idx = tilesheet.getIndexByName(name);
		var goFrame = frames.indexOf(idx);
		trace(goFrame);
		_currentIdx = frames[goFrame];
	}
	
	//#if flash
	inline public function getCurrentBitmapdata(over:Bool = false):BitmapData
	{
		//trace(_currentIdx);
		if (over)
		{
			return oversheet.getBitmap(_currentIdx);
		}
		else
		{
			return tilesheet.getBitmap(_currentIdx);
		}
		
	}
	//#end
	
	inline public function getCurrentIdx():Int
	{
		return _currentIdx;
	}
	
	inline public function getFrameRect():Rectangle
	{
		return tilesheet.getFrametoRectangle(_currentIdx);
	}
	
	public var currentFrame(get_currentFrame, set_currentFrame):Int;

	
	function step(elapsed:Float)
	{
		if (animated)
		{
			time += elapsed;
			var newFrame = currentFrame;
			if (newFrame == prevFrame) return;
			var looping = newFrame < prevFrame;
			prevFrame = newFrame;
			if (looping)
			{
				if (!loop) 
				{
					animated = false;
					currentFrame = totalFrames - 1;
				}
				else
				{
					//trace('reset loop' + newFrame + ' / ' +  _currentIdx + ' / ' + frames[newFrame] + ' / ' + frames[currentCycle.startFrame]);
					_currentIdx = frames[newFrame];
					//prevFrame = -1;
					time = 0;
				}
				if (onComplete != null) onComplete();
			}
			else 
			{
				_currentIdx = frames[newFrame];
			}
		}
	}

	public function play() 
	{ 
		if (!animated) 
		{
			animated = true;
			if (currentFrame == totalFrames - 1)
			{
				currentFrame = 0;
				prevFrame = -1;
			}
		}
	}
	
	public function stop() { animated = false; }
	
	function get_currentFrame():Int 
	{
		var frame:Int = Math.floor(time / currentCycle.duration * fps);
		//var frame:Int = Math.floor(time / currentCycle.duration * fps);
		
		var offset = frame % currentCycle.numFrames;
		//trace([time, frame, offset]);
		return currentCycle.startFrame + offset - 1;
	}
	function set_currentFrame(value:Int):Int 
	{
		if (value >= totalFrames) value = totalFrames - 1;
		time = Math.floor((currentCycle.duration) * value / fps);
		_currentIdx = frames[value];
		return value;
	}

	public var totalFrames(get_totalFrames, null):Int;

	inline function get_totalFrames():Int
	{
		//return frames.length;
		return currentCycle.numFrames;
	}
	
	public function update(time:Float):Void
	{
		step(time);
	}
}

class BlitSpritesheetCycle
{
	public var id(default, null):String;
	public var type(default, null):String;
	
	public var startFrame(default, null):Int;
	public var endFrame(default, null):Int;
	public var duration(default, null):Float;
	public var numFrames(default, null):Int;
	public var frameDuration(default, null):Float;
	public var mustComplete(default, null):Bool;
	
	public function new(id:String, type:String, startFrame:Int, endFrame:Int, duration:Float, mustComplete:Bool = false)
	{
		this.id = id;
		this.type = type;
		this.startFrame = startFrame;
		this.endFrame = endFrame;
		this.duration = duration;
		this.numFrames = endFrame - startFrame + 1;
		this.frameDuration = duration / numFrames;
		this.mustComplete = mustComplete;
	}
}
