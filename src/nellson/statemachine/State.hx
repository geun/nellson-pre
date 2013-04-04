package nellson.statemachine;

/**
 * ...
 * @author Geun
 */
using Lambda;
class State 
{

	public var machine:StateMachine;
	private var isInitMachine:Bool;
	public var prevState:StateKey;
	private var loadmap:Array<StateKey>;
	
	private var prevIdx:Int;
	private var currentIdx:Int;
	
	public function new(loadmap:Array<StateKey>) 
	{
		this.loadmap = loadmap;
		this.currentState = loadmap[0];
		
		
		isInitMachine = false;
	}
	
	public function setMachine(machine:StateMachine, ?start:StateKey):Void
	{
		this.machine = machine;
		isInitMachine = true;
		if (start != null) currentState = start;
		setState(currentState);
	}
	
	public function releseMachine():Void
	{
		machine.release();
		this.machine = null;
		isInitMachine = false;
	}
	
	public function setState(state:StateKey):Void
	{
		if (isInitMachine)
		{
			//trace('Set state : ' + state.type);
			prevState = currentState;
			currentState = state;
			machine.setState(state);
		}
	}
	
	public function getNextState(loop:Bool = true):StateKey
	{
		var len:Int = loadmap.length;
		if (len > 1)
		{
			if (loop)
			{
				var idx = currentIdx;
				if (currentIdx + 1 < len) idx++;
				else if ( currentIdx + 1 >= len) idx = 0;
				
				return loadmap[idx];
			}
			else
			{
				if (currentIdx + 1 < len)
				{
					var idx = currentIdx + 1;
					return loadmap[idx];
				}
			}
		}
		
		return null;
		
	}
	
	public function nextState(isLoop:Bool = true):Void
	{
		
		var len:Int = loadmap.length;
		if (len > 1)
		{
			if (isLoop)
			{
				prevIdx = currentIdx;
				
				if (currentIdx + 1 < len) currentIdx++;
				else if ( currentIdx + 1 >= len) currentIdx = 0;
				setState(loadmap[currentIdx]);
			}
			else
			{
				if (currentIdx + 1 < len)
				{
					currentIdx++;
					setState(loadmap[currentIdx]);
				}
			}
		}
	}
	
	private var _currentState:StateKey;
	
	public var currentState(getCurretState, setCurrentState):StateKey;
	private function getCurretState():StateKey { return _currentState; }
	private function setCurrentState(value:StateKey):StateKey
	{
		
		_currentState = value;
		currentIdx = loadmap.indexOf(value);
		
		return _currentState;
	}
	
	
}