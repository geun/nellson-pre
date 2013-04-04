package nellson.isometirc.systems;


import nellson.components.camera.Camera;
import nellson.core.System;
import nellson.grid.IGrid;
import nellson.isometirc.components.IsoGrid;
import nellson.isometirc.components.IsoSpatial;
import nellson.isometirc.components.IsoTile;
import nellson.isometirc.nodes.IsoSpatialNode;
import nellson.tools.ListIteratingSystem;
import de.polygonal.ds.Array2;
import nme.display.DisplayObjectContainer;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Point;

using de.polygonal.ds.ArrayUtil;
using Lambda;

/**
 * ...
 * @author Geun
 */

class IsoGridDebugRenderSystem extends System
{

	private var grid:IGrid;
	private var container:DisplayObjectContainer;
	private var gridView:Shape;
	private var stateView:Shape;
	
	private var tiles:Array2<IsoTile>;
	private var halfSize:Int;
	private var camera:Camera;
	private var inDrawing:Bool;
	
	private var gridColsNum:Int;
	private var gridRowsNum:Int;
	private var debugView:Shape;
	private var size:Int;
	
	public function new(container:DisplayObjectContainer, camera:Camera, grid:IGrid) 
	{
		super();
		this.grid  = grid;
		this.container = container;
		this.halfSize = grid.getSellSize() >> 1;
		gridColsNum = grid.getColsNum();
		gridRowsNum = grid.getRowNum();
		
		this.camera = camera;
		init();
	}
	
	private function init():Void
	{
		inDrawing = true;
		gridView = new Shape();
		stateView = new Shape();
		debugView = new Shape();
		
		size = grid.getSellSize();
		
		var root:Sprite = cast container.getChildByName('gridLayer');
		root.addChild(gridView);
		root.addChild(stateView);
		root.addChild(debugView);
		tiles = new Array2<IsoTile>(gridColsNum, gridRowsNum);
		for ( y in 0...grid.getRowNum())
			for (x in 0...grid.getColsNum())
				tiles.set(x, y, new IsoTile(size, x, y));
		
		drawAll();
	}
	
	
	override public function update(time:Float):Void 
	{
		if (grid.getDisplayGrid())
		{
			gridView.visible = true;
			gridView.x = -camera.viewPoint.centerX;
			gridView.y = -camera.viewPoint.centerY;
			drawCell();
		}
		else
		{
			gridView.visible = false;
		}
	}
	
	private function drawCell():Void
	{
		debugView.graphics.clear();
		stateView.graphics.clear();
		for ( row in 0...gridColsNum)
		{
			for ( col in 0...gridRowsNum)
			{
				var walkable = grid.getWalkable(col, row);
				if (!walkable)
				{
					var node = tiles.get(col, row);
					drawTile(node, 0xff0000);
				}
				var debug = grid.getDebugPath(col, row);
				if (debug)
				{
					var node = tiles.get(col, row);
					drawTile(node, 0xff0ff);
				}
			}
		}
		
	}
	
	private function drawAll():Void
	{
		gridView.graphics.clear();
		for ( node in tiles)
		{
			drawTile(node);
		}
		inDrawing = false;
	}
	
	private function drawTile(node:IsoTile, ?fillColor:Int, ?isState:Bool):Void
	{
		var x = node.col * halfSize;
		var y = node.row * halfSize;
		
		var cameraOffsetX = camera.getCameraOffsetX();
		var cameraOffsetY = camera.getCameraOffsetY();
		
		var renderX = isoToFlatX(x,y)- camera.viewPoint.centerX + cameraOffsetX;
		var renderY = isoToFlatY(x,y) - camera.viewPoint.centerY + cameraOffsetY;
		
		if (fillColor == null) draw(gridView, renderX, renderY);
		else draw(stateView, renderX, renderY, true, fillColor);
		
		//debugDraw(x, y, halfSize, halfSize);
	}
	
	private function debugDraw(x:Float, y:Float, w:Float, h:Float):Void
	{
		var offset = new Point(1000, 300);
		debugView.graphics.lineStyle(0, 0xff0000, 1);
		debugView.graphics.drawRect(x + offset.x, y+ offset.y, w, h);
	}
		
	inline private function isoToFlatX(x:Float, y:Float):Float
	{
		return (x - y);
	}
	inline private function isoToFlatY(x:Float, y:Float):Float
	{
		return cast ( x + y) >> 1;
	}
	
	public function draw(container:Shape, x:Float, y:Float, fillColor:Bool = false, color:Int = 0xff0000):Void
	{
		//var width = col * (size >> 1);
		//var height = row * (size >> 2);
		var width = size >> 1;
		var height = size >> 2;
		
		//var width = size;
		//var height = size >> 1;
		
		container.graphics.lineStyle(0, 0x3d3d3d, 1);
		
		var centerDraw = false;
		if (fillColor)	container.graphics.beginFill(color, 0.5);
		if (centerDraw)
		{
			container.graphics.moveTo( x, y - height);
			container.graphics.lineTo(x + width, y);
			container.graphics.lineTo(x , y + height);
			container.graphics.lineTo(x  - width, y);
			container.graphics.lineTo(x, y - height);
			
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