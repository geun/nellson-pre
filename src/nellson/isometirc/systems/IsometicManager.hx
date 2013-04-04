package nellson.isometirc.systems;
import nellson.isometirc.components.IsoGrid;

/**
 * ...
 * @author Geun
 */

class IsometicManager 
{

	private var grid:IsoGrid;
	
	public function new(grid:IsoGrid) 
	{
		this.grid = grid;
	}
	
	public function setPosition(x:Int, y:Int):Void
	{
		grid.sellSize / x;
		grid.sellSize / y;
	}
	
}