package nellson.grid;
import de.polygonal.ds.Array2;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

typedef GridPoint = { var x:Int; var y:Int; }
interface IGrid
{
	
	public function getDebugPath(x:Int, y:Int):Bool;
	public function setDebugPath(x:Int, y:Int, value:Bool):Void;
	
	public function getData():Dynamic;
	public function getSellSize():Int;
	public function getColsNum():Int;
	public function getRowNum():Int;
	public function setDisplayGrid(value:Bool):Void;
	public function getDisplayGrid():Bool;
	public function resetWalkable(value:Bool):Void;
	public function getWalkable(x:Int, y:Int):Bool;
	public function setWalkable(x:Int, y:Int, value:Bool):Void;
	
	public function computeGridPosition(x:Float, y:Float):GridPoint;
	public function checkGridPosition(x:Int, y:Int, col:Int, row:Int, rotation:Int):Bool;
	public function checkGridRotation(x:Int, y:Int, col:Int, row:Int, rotation:Int):Bool;
	
}