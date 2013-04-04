package nellson.isometirc.components;
import nellson.pathfinding.components.AStarGrid;
import nme.display.DisplayObjectContainer;
import nme.display.Graphics;
import nme.display.Shape;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */

class IsoTile 
{
	private var offsetX:Int;
	private var offsetY:Int;
	public var drawColor:Int;
	public var isDrawing:Bool;
	public var size:Int;
	public var col:Int;
	public var row:Int;
	public var half:Int;
	
	public var updateDrawColor:Bool;
	
	public function new(size:Int, col:Int = 1, row:Int = 1) 
	{
		this.size = size;
		this.col = col;
		this.row = row;
		
		isDrawing = false;
		drawColor = 0xff0000;
		
		offsetX = size >> 2;
		offsetY = size >> 3;
		
	}
	 
	public function computeOffsetX():Int
	{
		return col * size;
	}
	
	public function computeOffsetY():Int
	{
		return row * size;
	}
	
	public function getCenter(p:Point):Void
	{
		//col 이 넓어지면 offsetx 가 증가 
		//var px = ( -(col - 1) * offsetX) + ((row -1) * offsetX);
		//var py = ((col - 1) * offsetY) + ((row -1) * offsetY);
		
		var px = ((row - col) * offsetX);
		var py = (((col - 1) + (row -1 ))  * offsetY) - offsetX;
		
		p.x = -px * .85;
		p.y = py * .85;
	}
	
	public function draw(container:Shape, x:Float, y:Float, fillColor:Bool = false, color:Int = 0xff0000, centerDraw:Bool = true, rotation:Bool = false):Void
	{
		if (col == 1 && row == 1) centerDraw = false;
		
		
		var _col:Int = col;
		var _row:Int = row;
		
		if (rotation)
		{
			_col = row;
			_row = col;
		}
		
		var width = _col * (size >> 1);
		var height = _row * (size >> 2);
		//var width = size >> 1;
		//var height = size >> 2;
		
		//var width = size;
		//var height = size >> 1;
		
		//container.graphics.lineStyle(0, 0x3d3d3d, 1);
		
		//var cd = size >> 1 * 
		
	/*	var startPoint = new Point(x, y - height);
		var w = size >> 1;
		var h = size >> 2;
		
		var p1 = new Point(col / 2 * w * -startPoint.x, col / 2 * w * -startPoint.y);
		var p2 = new Point(col / 2 * h * startPoint.x, col / 2 * w * -startPoint.y);
		var p3 = new Point(col / 2 * w * startPoint.x, col / 2 * w * startPoint.y);
		var p4 = new Point(col / 2 * h * -startPoint.x, col / 2 * w * startPoint.y);
		
		if (fillColor) container.graphics.beginFill(drawColor, 0.7);
		container.graphics.moveTo(startPoint.x, startPoint.y);
		container.graphics.lineTo(p1.x, p1.y);
		container.graphics.lineTo(p2.x, p2.y);
		container.graphics.lineTo(p3.x, p3.y);
		container.graphics.lineTo(p4.x, p4.y);
		if (fillColor) container.graphics.endFill();
		*/
		
		
		
		//trace(startPoint);
		//trace(p1);
		//trace(p2);
		//trace(p3);
		//trace(p4);
		
		
		//if (fillColor) container.graphics.beginFill(drawColor, 0.7);
		//container.graphics.lineStyle(1);
		//if (fillColor) container.graphics.beginFill(drawColor, 0.7);
		//if (fillColor) container.graphics.endFill();
		
		if (fillColor) container.graphics.beginFill(drawColor, 0.7);
		if (centerDraw)
		{
			/*container.graphics.moveTo(x, y - height);
			container.graphics.lineTo(x + width, y);
			container.graphics.lineTo(x , y + height);
			container.graphics.lineTo(x  - width, y);
			container.graphics.lineTo(x, y - height);*/
			var w = size;
			var h = size >> 1;

			var startPoint = new Point(x, y + (size >> 1));
			var p1 = new Point(-(_col / 2 * w) + startPoint.x, -(_col / 2 * h) + startPoint.y);
			var p2 = new Point(_row / 2 * w + p1.x, -(_row / 2 * h) + p1.y);
			var p3 = new Point(_col / 2 * w + p2.x, _col / 2 * h + p2.y);
			var p4 = new Point( -(_row / 2 * w) + p3.x, _row / 2 * h + p3.y);
			container.graphics.moveTo(startPoint.x, startPoint.y);
			container.graphics.lineTo(p1.x, p1.y);
			container.graphics.lineTo(p2.x, p2.y);
			container.graphics.lineTo(p3.x, p3.y);
			container.graphics.lineTo(p4.x, p4.y);
		}
		else
		{
			container.graphics.moveTo(x, y);
			container.graphics.lineTo(x + width, y + height);
			container.graphics.lineTo(x, y + height * 2);
			container.graphics.lineTo(x - width, y + height);
			container.graphics.lineTo(x, y);
			
		}		
		if (fillColor) container.graphics.endFill();
		
		//trace('draw complete ' +  x + ' / ' + y);
	}
	
}