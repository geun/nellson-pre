package nellson.isometirc.components;
import nellson.grid.IGrid;
import de.polygonal.core.math.Mathematics;
import de.polygonal.ds.Array2;

/**
 * ...
 * @author Geun
 */

class IsoGrid implements IGrid	
{
	private var data:Array2<Bool>;
	private var sellSize:Int;
	private var halfSize:Int;
	
	private var showGrid:Bool;
	
	private var colsNum:Int;	
	private var rowsNum:Int;
	
	public function new(cols:Int, rows:Int, size:Int) 
	{
		sellSize = size;
		halfSize = sellSize >> 1;
		colsNum = cols;
		rowsNum = rows;
		
		data = new Array2<Bool>(cols, rows);
		resetWalkable(true);
		
		showGrid = false;
	}
	
		
	public function getSellSize():Int
	{
		return sellSize;
	}
	public function getColsNum():Int
	{
		return colsNum;
	}
	public function getRowNum():Int
	{
		return rowsNum;
	}
	public function setDisplayGrid(value:Bool):Void
	{
		showGrid = value;
	}
	
	public function getDisplayGrid():Bool
	{
		return showGrid;
	}
	
	public function resetWalkable(value:Bool):Void
	{
		data.fill(value);
	}
	public function getWalkable(x:Int, y:Int):Bool
	{
		return data.get(x, y);
	}
	public function setWalkable(x:Int, y:Int, value:Bool):Void
	{
		data.set(x, y, value);
	}
	
	public function getData():Dynamic
	{
		return data;
	}
	
	public function getDebugPath(x:Int, y:Int):Bool
	{
		return false;
	}
	
	public function setDebugPath(x:Int, y:Int, value:Bool):Void
	{
		
	}
	
	public function computeGridPosition(x:Float, y:Float):GridPoint
	{
		var col = Mathematics.floor(x / halfSize);
		var row = Mathematics.floor(y / halfSize);
		
		return { x:col, y:row} ; 
	}
	
	/* INTERFACE nellson.grid.IGrid */
	
	public function checkGridPosition(x:Int, y:Int, col:Int, row:Int, rotation:Int):Bool 
	{
		return false;
	}
	
	public function checkGridRotation(x:Int, y:Int, col:Int, row:Int, rotation:Int):Bool 
	{
		return false;
	}
	
}