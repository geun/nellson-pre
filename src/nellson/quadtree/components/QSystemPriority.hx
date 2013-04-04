package nellson.quadtree.components;

/**
 * ...
 * @author Geun
 */

class QSystemPriority 
{
	inline static public var GetEntityFromCamera:Int = 0;
	
	inline static public var MotionAllEntity:Int = 1;
	
	
	inline static public var MouseInteraction:Int = 3;
	inline static public var KeyboardInteraction:Int = 3;
	
	
	inline static public var Move:Int = 6;
	inline static public var GridUpdate:Int = 4;
	inline static public var Astar:Int = 5;
	
	inline static public var UpdateIsoSpatial:Int = 5;
	inline static public var Zsorting:Int = 7;
	inline static public var QuadTreeUpdate:Int = 1;
	inline static public var UpdateSheetSrpite:Int = 9;
	
	
	inline static public var Animation:Int = 9;
	inline static public var Render:Int = 10;
	
	
	
	
	
	public function new()
	{
		
	}
	
	
}
