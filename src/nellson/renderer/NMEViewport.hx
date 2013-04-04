package nellson.renderer;
import nellson.blit.components.ITilesheet;
import nellson.components.camera.Camera;
import nellson.components.display.GameLayer;
import nellson.core.NodeList;
import nellson.ds.ObjectHash;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.nodes.QTreeItemNode;
import de.polygonal.ds.Array2;
import de.polygonal.ds.pooling.ObjectPool;

import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.Graphics;
import nme.display.Shape;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.Lib;

using de.polygonal.ds.ArrayUtil;
/**
 * ...
 * @author Geun
 */

//typedef Layers = Array<Shape>

private typedef BatchedInfo = Array<Dynamic>;
 
class NMEViewport implements IViewport
{
	private var backgoundLayer:Shape;
	private var floorLayer:Shape;
	private var noticeLayer:Shape;
	private var stageLayer:Shape;
	private var foregroundLayer:Shape;
	private var container:DisplayObjectContainer;
	public var layers:Array<Shape>;
	
	private var count:Int;
	private var camera:Camera;
	private var tilesheets:ObjectHash<BatchedInfo>;
	private var inDebugView:Shape;
	private var isDebug:Bool;

	public function new(container:DisplayObjectContainer, camera:Camera) 
	{
		this.container = container;
		this.camera = camera;
		init();
		
	}
	
	private function init():Void
	{
		isDebug = true;
		tilesheets = new ObjectHash();
		inDebugView = new Shape();
		
		backgoundLayer = new Shape();
		floorLayer = new Shape();
		noticeLayer = new Shape();
		stageLayer = new Shape();
		foregroundLayer = new Shape();
		
		layers = [backgoundLayer, floorLayer, stageLayer, noticeLayer, foregroundLayer];
		for (layer in layers)
		{
			container.addChild(layer);
		}
		
		container.addChild(inDebugView);
	}
	
	public function dispose():Void
	{
		for (layer in layers)
		{
			container.removeChild(layer);
			layer = null;
		}
	}
	
	inline public function clearLayer():Void
	{
		for (layer in layers)
		{
			layer.graphics.clear();
		}
		if (isDebug)
		{
			inDebugView.graphics.clear();
		}
	}
	
	public function clearInfo():Void
	{
		
	}
	
	inline public function addTileSheet(tilesheet:ITilesheet):Void
	{
		
		if (!hasTileSheet(tilesheet))
		{
			tilesheets.set(tilesheet, createBatchedInfo(tilesheet));
			//trace('new tilesheet added');
			//for (info in tilesheets)
			//{
				//var s:Array<Dynamic> = info;
				//trace(s.toString());
			//}
			
		}
	}
	
	public function hasTileSheet(tilesheet:ITilesheet):Bool 
	{
		return tilesheets.has(tilesheet);
	}
	
	inline public function removeTileSheet(tilesheet:ITilesheet):Void
	{
		if (tilesheets.has(tilesheet)) tilesheets.remove(tilesheet);
	}
	
	inline private function resetBatchedInfo(info:BatchedInfo):Void
	{
		//info[0] = null;
		for ( i in 1...layers.length + 1)
		{
			info[i] = [];
		}
	}
	
	inline public function createBatchedInfo(tilesheet:ITilesheet):BatchedInfo
	{
		var info = new Array<Dynamic>();
		info[0] = tilesheet;
		for ( i in 0...layers.length)
		{
			var m = new Array<Float>();
			info.push(m);
		}
		return info;
	}
	
	
	inline private function getLayer(id:Int):Graphics
	{
		var layer:Graphics = null;
		switch(id)
		{
			case 1:
				layer = backgoundLayer.graphics;
			case 2:
				layer = floorLayer.graphics;
			case 3:
				layer = stageLayer.graphics;
			case 4:
				layer = noticeLayer.graphics;
			case 5:
				layer = foregroundLayer.graphics;
		}
		return layer;
	}
	
	
	inline private function getLayerID(target:GameLayer):Int
	{
		var idx:Int = 0;
		switch(target.type)
		{
			case GameLayers.Background: idx = 1;
			case GameLayers.Floor:	idx = 2;
			case GameLayers.Stage:	idx = 3;
			case GameLayers.Notice:	idx = 4;
			case GameLayers.Foreground:	idx = 5;
		}
		
		return idx;
	}
	
	private function batch(renderNodes:QuarryResult):Void
	{
		var t = Lib.getTimer();
		//trace(layers.length);
		for ( node in renderNodes.data)
		{
			
			var tilesheet:ITilesheet = node.blitSpritesheet.tilesheet;
			if (!tilesheets.has(tilesheet)) tilesheets.set(tilesheet, createBatchedInfo(null) );
			
			var info:BatchedInfo = tilesheets.get(tilesheet);
			var layerID:Int = getLayerID(node.layer);
			var aabb = node.aabb;
			
			var x = aabb.minX - camera.aabb.minX + camera.renderBounds.minX - camera.offset;
			var y = aabb.minY - camera.aabb.minY + camera.renderBounds.minY - camera.offset;
			info[0] = tilesheet;
			info[layerID].push(x); // position x
			info[layerID].push(y); // position y
			info[layerID].push(node.blitSpritesheet.getCurrentIdx());
			
			if (isDebug)
			{
				inDebugView.graphics.lineStyle(0, 0xff00ff, 1);
				inDebugView.graphics.drawRect(x, y, aabb.intervalX, aabb.intervalY);
			}
			
		}
		
		var result = Lib.getTimer() - t;
		//trace('batched :' + result);
	}
	inline public function draw():Void
	{
		for (infos in tilesheets)
		{
			var tilesheet:Tilesheet =  infos[0];
			if (tilesheet != null)
			{
				for (i in 1...layers.length+1)
				{	
					tilesheet.drawTiles(getLayer(i), infos[i], true);	
				}
				resetBatchedInfo(infos);
			}
			else
			{
				trace('why is it null?');
			}
			
		}
	}
	
	public function addTilesheet():Void
	{
		
	}
	
	public function checkTime(f:QuarryResult->Void):Void
	{
		
		
	}
	
	public function render(renderNodes:QuarryResult):Void
	{
		var t = Lib.getTimer();
		clearLayer();
		batch(renderNodes);
		draw();
		debugRender(renderNodes);
		var result = Lib.getTimer() - t;
		//trace('time: ' + result + 'ms');
	}
	
	public function debugRender(renderNodes:QuarryResult):Void
	{
		if (isDebug)
		{
			for ( rect in renderNodes.debug)
			{
				var x = rect.minX - camera.aabb.minX + camera.renderBounds.minX - camera.offset;
				var y = rect.minY - camera.aabb.minY + camera.renderBounds.minY - camera.offset;
				
				inDebugView.graphics.lineStyle(0, 0x000000, 2);
				inDebugView.graphics.drawRect(x,y, rect.intervalX, rect.intervalY);
			}
		}
	}
	
	/* INTERFACE nellson.renderer.IViewport */
	
	public function resize():Void 
	{
		trace('resize complete nme');
		camera.scaleDirty = false;
	}
	
	
	/* INTERFACE nellson.renderer.IViewport */
	
	
}