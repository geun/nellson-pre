package nellson.grid;
import nellson.blit.components.BlitGraphicsData;
import nellson.blit.components.BlitSpritesheetGraphics;
import nellson.components.camera.Camera;
import nellson.components.controller.MouseController;
import nellson.components.Info;
import nellson.core.Game;
import nellson.core.NodeList;
import nellson.core.System;
import nellson.isometirc.components.IsoCamera;
import nellson.isometirc.components.IsoGrid;
import nellson.isometirc.components.IsoTile;
import nellson.pathfinding.components.AStarGrid;
import nellson.utils.helper.GridHelper;
import com.touchingsignal.secretgarden.game.model.components.DecoData;
import com.touchingsignal.secretgarden.game.model.components.FlowerData;
import com.touchingsignal.secretgarden.game.model.components.ItemData;
import com.touchingsignal.secretgarden.game.model.GameState;
import com.touchingsignal.secretgarden.game.signal.interaction.BatchedItem;
import de.polygonal.core.math.Mathematics;
import nme.display.DisplayObjectContainer;
import nme.display.Shape;
import nme.display.Sprite;
import nme.Lib;

import nellson.tools.ListIteratingSystem;

/**
 * ...
 * @author Geun
 */

using nellson.utils.helper.GridHelper;

class GridUpdateSystem extends System
{
	
	@inject 
	public var gameState:GameState;
	
	@inject
	public var container:DisplayObjectContainer;
	
	@inject
	public var batchedItem:BatchedItem;
	
	private var grid:IGrid;
	private var size:Int;
	private var halfSize:Int;
	private var nodeList:NodeList<Dynamic>;
	private var colsNum:Int;
	private var rowsNum:Int;
	private var controller:MouseController;
	private var gridView:Shape;
	private var camera:Camera;
	
	
	public function new(camera:Camera, grid:IGrid, controller:MouseController) 
	{
		super();
		this.camera = camera;
		this.grid = grid;
		this.size = grid.getSellSize();
		this.colsNum = grid.getColsNum();
		this.rowsNum = grid.getRowNum();
		this.halfSize = size >> 1;
		this.controller = controller;
		
	}
	
	
	override public function addToGame(game:Game):Void 
	{
		nodeList = game.getNodeList(GridSpatialNode);
		nodeList.nodeAdded.add(initPosition);
		nodeList.nodeRemoved.add(removePosition);
	}
	
	private function initPosition(node:GridSpatialNode):Void
	{
		setPosition(node, false);
		//trace('set position');
	}
	
	private function removePosition(node:GridSpatialNode):Void
	{
		setPosition(node, true);
	}
	
	private function setPosition(node:GridSpatialNode, isWalkable:Bool):Void 
	{
		
		var isRotated:Int = 0;
		if (node.entity.has(FlowerData))
		{
			var data:FlowerData = node.entity.get(FlowerData);
			isRotated = data.rotation;
		}
		else if (node.entity.has(DecoData))
		{
			var data:DecoData = node.entity.get(DecoData);
			isRotated = data.rotation;
		}
		
		var tile:IsoTile = node.isoTile;
		GridHelper.setPosition(tile, grid, node.gridSpatial, node.isoSpatial, isWalkable, isRotated);
		
		
		//if (isRotated == 0)
		//{
			//for (offsetX in 0...col)
			//{
				//for (offsetY in 0...row)
				//{
					//var x = node.gridSpatial.x - offsetX;
					//var y = node.gridSpatial.y - offsetY;
					//trace('test' + node.gridSpatial.x + [node.gridSpatial.y, x, y, offsetX, offsetY]);
					//grid.setWalkable(x, y, isWalkable);
					//node.isoSpatial.invalidateWalkable = false;
				//}
			//}
		//}
		//else
		//{
			//for (offsetX in 0...row)
			//{
				//for (offsetY in 0...col)
				//{
					//var x = node.gridSpatial.x - offsetX;
					//var y = node.gridSpatial.y - offsetY;
					//trace('test' + node.gridSpatial.x + [node.gridSpatial.y, x, y, offsetX, offsetY]);
					//grid.setWalkable(x, y, isWalkable);
					//node.isoSpatial.invalidateWalkable = false;
				//}
			//}
		//}
	}
	
	override public function update(time:Float):Void 
	{
		checkIsospatial(time);
	}

	private function checkIsospatial(time:Float):Void
	{
		//grid.resetWalkable(true);
		var node:GridSpatialNode = nodeList.head;
		while ( node != null)
		{
			if (node.isoSpatial.invalidateWalkable)
			{
				//trace([node.gridSpatial.x, node.gridSpatial.y]);
				setPosition(node, true);
				var x = Math.floor(node.isoSpatial.position.x);
				var y = Math.floor(node.isoSpatial.position.y);
				var px = Std.int(x / halfSize);
				var py = Std.int(y / halfSize);
				
				//limited 
				var limitX = px - node.isoTile.col;
				var limitY = py - node.isoTile.row;
				if ( px >= colsNum) px = colsNum - 1;
				if ( py >= rowsNum) py = rowsNum - 1;
				if ( limitX < 0) px = node.isoTile.col - 1;
				if ( limitY < 0) py = node.isoTile.row - 1;
				
				node.isoSpatial.position.x = px * halfSize;
				node.isoSpatial.position.y = py * halfSize;
				
				if ( gameState.isDesignMode == true)
				{
					if (grid.checkGridPosition(px, py, node.isoTile.col, node.isoTile.row, node.graphicsData.rotation))
					{
						node.gridSpatial.x = px;
						node.gridSpatial.y = py;
						setPosition(node, false);
						
						node.isoTile.drawColor = 0x50da04;
						//node.isoSpatial.invalidateWalkable = true;
						node.isoSpatial.setAble = true;
						#if flash
						node.isoSpatial.invalidateWalkable = false;
						node.graphicsData.state = BlitGraphicsState.OVER_GREEN;
						#elseif (android || iphone)
						node.isoSpatial.invalidateWalkable = true;
						#else
						node.isoSpatial.invalidateWalkable = false;
						#end
						//gridView.graphics.clear();
						//drawTile(node, 0x50da04);
						
					}
					else
					{
						node.isoTile.drawColor = 0xff0000;
						node.isoSpatial.invalidateWalkable = true;
						#if flash
						node.graphicsData.state = BlitGraphicsState.OVER_RED;
						#end
						//gridView.graphics.clear();
						//drawTile(node, 0xff0000);
						node.isoSpatial.setAble = false;
						
					}
				}
				else
				{
					node.gridSpatial.x = px;
					node.gridSpatial.y = py;
					setPosition(node, false);
				}
				
			}
			node = node.next;
		}
		
	}
	
	inline private function drawTile(node:GridSpatialNode, ?fillColor:Int, ?isState:Bool):Void
	{
		//var x = node.col * halfSize;
		//var y = node.row * halfSize;
		
		var cameraOffsetX = camera.getCameraOffsetX();
		var cameraOffsetY = camera.getCameraOffsetY();
		
		var renderX = node.isoSpatial.isoToFlatX()- camera.viewPoint.centerX + cameraOffsetX;
		var renderY = node.isoSpatial.isoToFlatY() - camera.viewPoint.centerY + cameraOffsetY;
		
		//trace('draw tile');
		node.isoTile.draw(gridView, renderX, renderY, true, fillColor);
		
		//debugDraw(x, y, halfSize, halfSize);
	}
	
	inline private function isoToFlatX(x:Float, y:Float):Float
	{
		return (x - y);
	}
	inline private function isoToFlatY(x:Float, y:Float):Float
	{
		return cast ( x + y) >> 1;
	}
	
}
