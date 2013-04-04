package nellson.statemachine;
//import nellson.ds.ObjectHash;
import de.polygonal.core.fmt.Sprintf;
import de.polygonal.ds.HashableItem;
import de.polygonal.ds.HashTable;
import de.polygonal.ds.Itr;
import nme.ObjectHash;



using Lambda;

/**
 * ...
 * @author Geun
 */

typedef StateData = {
	var state:IState;
	var from:Array<StateKey>;
	//var from:String;
}
 
class StateMachine 
{
	//private var states:ObjectHash<StateData>;
	public var states(default, null):HashTable<StateKey, StateData>;
	//private var states:ObjectHash<StateKey, StateData>;
	
	public var current:StateKey;
	public var prev:StateKey;
	
	private var currentStateData:StateData;
	
	//private var states:ObjectHash<String, Dynamic>;
	public function new() 
	{
		states = new HashTable(16);
		//states = new ObjectHash();
	}
	
	public function iterator():Itr<StateData>
	{
		return states.iterator();
	}
	
	public function getState(key:StateKey):StateData
	{
		//trace('get State' + key.key);
		var state = states.get(key);
		//trace(state);
		return state;
	}
	
	public function setState(key:StateKey):Bool
	{
		if (current == null)
		{
			current = key;
			
			currentStateData = states.get(current);
			//trace('current is null ' + currentStateData);
			
			currentStateData.state.enter();
			return true;
		}
		
		if (current == key)
		{
			//trace('already in the ' + key + ' state' );
		}
		
		if (currentStateData.from.has(key))
		{
			currentStateData.state.exit();
			prev = current;
			current = key;
			//trace('Set State' + current);
			currentStateData = states.get(current);
		}
		else
		{
			//trace('state ' + key + 'cannot be used while in the ' + current + ' state');
			return false;
		}
		currentStateData.state.enter();
		
		return true;
	}
	
	public function size():Int
	{
		return states.size();
	}
	
	
	public function toString():String
	{
		var size = states.size();
		var s = Sprintf.format("{machine, size: %d}", [size]);
		if (size == 0) return s;
		s += "\n|<\n";
		var i = 0;
		for (state in states)
		{
			s += Sprintf.format("  %4d -> %s -> %s\n", [i++, state.state, state.from]);
		}
		s += ">|";
		return s;
	}
	
	public function addState(key:StateKey, stateObj:IState, transable:Array<StateKey>):Void
	{
		var result = states.set(key, { state: stateObj, from: transable } );
		//trace([key.key, result,states.size()]);
	}
	
	public function update(time:Float):Void
	{
		currentStateData.state.update(time);
	}
	
	public function release():Void
	{
		currentStateData.state.exit();
	}
}