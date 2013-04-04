package nellson.statemachine;

/**
 * ...
 * @author Geun
 */

interface IState 
{
	function release():Void;
	function enter():Void;
	function update(?time:Float):Void;
	function exit():Void;
}