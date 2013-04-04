package nellson.components.display;

/**
 * ...
 * @author Geun
 */

enum GameLayers
{
	Background;
	Floor;
	Stage;
	Notice;
	Foreground;
}

class GameLayer
{
	public var type:GameLayers;
	public function new(type:GameLayers)
	{
		this.type = type;
		
	}
	
}