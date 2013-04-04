package nellson.components.command;

/**
 * ...
 * @author Geun
 */

class InteractionCommand
{
	public var mouseCommand:IMouseCommand;
	public var gestureCommand:IGestureCommand;
	
	public function new(mouseCommand:IMouseCommand, gestureCommand:IGestureCommand) 
	{
		this.mouseCommand = mouseCommand;
		this.gestureCommand = gestureCommand;
	}
	
}