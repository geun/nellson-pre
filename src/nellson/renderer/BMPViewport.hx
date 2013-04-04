package nellson.renderer;
import nellson.blit.components.ITilesheet;
import nellson.components.camera.Camera;
import nellson.components.display.GameLayer;
import nellson.ds.ObjectHash;
import nellson.isometirc.components.IsoSpatial;
import nellson.quadtree.components.QuarryResult;
import de.polygonal.ds.pooling.ObjectPool;
import nellson.ds.AABB2;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObjectContainer;
import nme.display.PixelSnapping;
import nme.display.Shape;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.text.TextField;

/**
 * ...
 * @author Geun
 */

class BMPViewport implements IViewport
{
	
	private var backgoundLayer:Bitmap;
	private var floorLayer:Bitmap;
	private var noticeLayer:Bitmap;
	private var stageLayer:Bitmap;
	private var foregroundLayer:Bitmap;
	private var container:DisplayObjectContainer;
	public var layers:Array<Bitmap>;
	
	private var count:Int;
	private var camera:Camera;
	private var renderRect:Rectangle;
	private var pointPool:ObjectPool<Point>;
	private var point:Point;
	private var inDebugView:Shape;
	private var isDebug:Bool;
	private var empty:BitmapData;
	private var grid:Sprite;
	
	public function new(container:DisplayObjectContainer,camera:Camera) 
	{
		this.container = container;
		this.camera = camera;
		
		init();
		//tilesheets = new ObjectHash();
	}
	
	private function createBitmapData():BitmapData
	{
		renderRect = new Rectangle(camera.renderBounds.minX, camera.renderBounds.minY, camera.renderBounds.intervalX * camera.scaleOffset, camera.renderBounds.intervalY * camera.scaleOffset);
		return new BitmapData(Std.int(renderRect.width), Std.int(renderRect.height), true, 0);
	}
	
	private function init():Void
	{
		isDebug = false;
		
		point = new Point();
		pointPool = new ObjectPool(1 << 12);
		
		empty = createBitmapData();
		backgoundLayer = new Bitmap(createBitmapData());
		//floorLayer = new Bitmap(createBitmapData());
		noticeLayer = new Bitmap(createBitmapData());
		stageLayer = new Bitmap(createBitmapData(), PixelSnapping.AUTO, true);
		foregroundLayer = new Bitmap(createBitmapData());
		
		inDebugView = new Shape();
		
		layers = [backgoundLayer, stageLayer, noticeLayer, foregroundLayer];
		//layers = [backgoundLayer, stageLayer, noticeLayer];
		//layers = [backgoundLayer, floorLayer, stageLayer, noticeLayer, foregroundLayer];
		//layers = [stageLayer];
		for (layer in layers) container.addChild(layer);
		
		
		container.addChild(inDebugView);
		
		grid = new Sprite();
		grid.mouseChildren = false;
		grid.mouseEnabled = false;
		//container.addChild(grid);
	}

	
	inline private function getLayer(target:GameLayer):BitmapData
	{
		var layer:BitmapData = null;
		switch(target.type)
		{
			case GameLayers.Background: layer = backgoundLayer.bitmapData;
			case GameLayers.Floor:		layer = floorLayer.bitmapData;
			case GameLayers.Stage:		layer = stageLayer.bitmapData;
			case GameLayers.Notice:		layer = noticeLayer.bitmapData;
			case GameLayers.Foreground:	layer = foregroundLayer.bitmapData;
		}
		return layer;
	}
	
	
	inline private function lockLayer():Void
	{
		for (layer in layers)
		{
			layer.bitmapData.lock();
			layer.bitmapData.fillRect(renderRect, 0);
		}
		
		if (isDebug)
		{
			inDebugView.graphics.clear();
		}
	}
	inline private function unlockLayer():Void
	{
		for (layer in layers)
		{
			layer.bitmapData.unlock();
		}
	
	}
	
	public function render(renderNodes:QuarryResult):Void
	{
		
		/*lockLayer();
		for ( node in renderNodes.data)
		{
			var aabb = node.aabb;
			var x = aabb.minX - camera.aabb.minX + camera.renderBounds.minX - camera.offset;
			var y = aabb.minY - camera.aabb.minY + camera.renderBounds.minY - camera.offset;
			var bitmapData = getLayer(node.layer);
			point.x = x;
			point.y = y;
			bitmapData.copyPixels(node.graphicsData.upBitmapData, node.spriteSheet.getFrameRect(), point);
			if (isDebug)
			{
				inDebugView.graphics.lineStyle(0, 0xff00ff, 1);
				inDebugView.graphics.drawRect(x, y, aabb.intervalX, aabb.intervalY);
				
				node.isoTile.draw(inDebugView, x,y);
			}
			
		}
		unlockLayer();
		if (isDebug)
		{
			for ( rect in renderNodes.debug)
			{
				var x = rect.minX - camera.aabb.minX + camera.renderBounds.minX - camera.offset;
				var y = rect.minY - camera.aabb.minY + camera.renderBounds.minY - camera.offset;
				
				inDebugView.graphics.lineStyle(0, 0x000000, 2);
				inDebugView.graphics.drawRect(x,y, rect.intervalX, rect.intervalY);
			}
			
			//drawAABB(inDebugView, camera.aabb, 0x0000ff, 2);
			//drawAABB(inDebugView, camera.renderBounds, 0x00ff00, 5);
			//drawAABB(inDebugView, camera.worldBounds, 0x00ffff, 2);
		}
		
		//grid.x = grid.x - camera.aabb.minX + camera.renderBounds.minX - camera.offset;
		//grid.y = grid.y - camera.aabb.minY + camera.renderBounds.minY - camera.offset;
		
		*/
		
	}
	
	
	public function resize():Void
	{
		empty = createBitmapData();
		backgoundLayer.bitmapData = createBitmapData();
		//floorLayer.bitmapData = createBitmapData();
		noticeLayer.bitmapData = createBitmapData();
		stageLayer.bitmapData = createBitmapData();
		//foregroundLayer.bitmapData = createBitmapData();
		//inDebugView = new Shape();
		//stageLayer.smoothing = true;
		camera.scaleDirty = false;
	}
	
	/* INTERFACE nellson.renderer.IViewport */
	
	public function addTileSheet(tilesheet:ITilesheet):Void 
	{
		
	}
	
	public function removeTileSheet(tilesheet:ITilesheet):Void 
	{
		
	}
	
	/* INTERFACE nellson.renderer.IViewport */
	
	public function hasTileSheet(tilesheet:ITilesheet):Bool 
	{
		return false;
	}
	
}
