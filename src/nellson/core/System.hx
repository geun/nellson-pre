package nellson.core;
import mmvc.impl.Actor;
import mmvc.impl.Command;

/**
 * ...
 * @author Geun
 */

class System
{
	public var prev:System;
	public var next:System;
	public var priority:Int;
	
	public function new() 
	{
		priority = 0;
	}
	
	public function addToGame(game:Game):Void
	{
		
	}
	
	public function removeFromGame(game:Game):Void
	{
		
	}
	
	public function update(time:Float):Void
	{
		
	}
	
}