package nellson.renderer;
import nellson.blit.components.BlitGraphicsData;
import nellson.blit.components.BlitSpritesheetGraphics;
import nellson.blit.components.ITilesheet;
import nellson.components.camera.Camera;
import nellson.isometirc.components.IsoSpatial;
import nellson.components.Info;
import nellson.grid.IGrid;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.nodes.QTreeItemNode;
import com.touchingsignal.secretgarden.game.model.GameState;
import com.touchingsignal.secretgarden.notice.components.PopIcon;
import nellson.ds.AABB2;
import nme.display.BitmapData;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.errors.Error;
import nme.geom.Point;

/**
 * ...
 * @author Geun
 */
typedef BatchedInfo = Array<Dynamic>;
 
class IsoNMEViewport extends NMEViewport
{
	private var point:Point;
	private var cellSize:Int;
	private var halfSize:Int;
	private var info:BatchedInfo;
	private var layerID:Int;
	
	@inject
	public var gameState:GameState;

	public function new(container:DisplayObjectContainer,camera:Camera, grid:IGrid) 
	{
		
		super(container, camera);
		
		point = new Point(0, 0);
		isDebug = false;
		//isDebug = true;
		
		this.cellSize = grid.getSellSize();
		this.halfSize = cellSize >> 1;
	}
	
	override private function init():Void 
	{
		super.init();
		
		var popuplayer:Sprite = cast container.getChildByName('popupIconLayer');
		var stagelayer:Sprite = cast container.getChildByName('stageLayer');
		
		popuplayer.addChild(noticeLayer);
		stagelayer.addChild(stageLayer);
	}
	
	override private function batch(renderNodes:QuarryResult):Void 
	{
		
		var cameraOffsetX = camera.getCameraOffsetX();
		var cameraOffsetY = camera.getCameraOffsetY();
			
		for ( node in renderNodes.data)
		{
			
			var tilesheet:ITilesheet = node.blitSpritesheet.tilesheet;
			/*var p = IsoSpatial.isoToFlat(node.aabb.minX, node.aabb.minY);
			var x = p.x - camera.viewPoint.centerX + cameraOffsetX;
			var y = p.y - camera.viewPoint.centerY + cameraOffsetY;
			
			var offsetX = Std.int(node.blitSpritesheet.getFrameRect().width) >> 1;
			var offsetY = Std.int(node.blitSpritesheet.getFrameRect().height) >> 1;
			
			
			point.x = (x - offsetX - node.blitGraphicsData.registerationPoint.x);
			point.y = (y - offsetY - node.blitGraphicsData.registerationPoint.y);*/
			
			
			
			var x = node.isoSpatial.isoToFlatX() - camera.viewPoint.centerX + cameraOffsetX;
			var y = node.isoSpatial.isoToFlatY() - camera.viewPoint.centerY + cameraOffsetY;
			
			//var offsetX = Std.int(node.blitSpritesheet.getFrameRect().width) >> 1;
			//var offsetY = Std.int(node.blitSpritesheet.getFrameRect().height) *  1;
			
			//trace(offsetY);
			
			
			//point.x = (x - offsetX - node.blitGraphicsData.registerationPoint.x);
			//point.y = (y - offsetY - node.blitGraphicsData.registerationPoint.y);
			
			//point.x = (x - offsetX);
			//point.y = (y - offsetY);
			//
			//point.x = x;
			//point.y = y;
			
			point.x = (x - node.blitGraphicsData.registerationPoint.x);
			point.y = (y - node.blitGraphicsData.registerationPoint.y);
					
			var maxX  = (camera.renderBounds.maxX  + cellSize) * camera.scaleOffset;
			var maxY  = (camera.renderBounds.maxY + cellSize) * camera.scaleOffset;
			
			if ( point.x < maxX  && point.y < maxY ) 
			{
				if (node.info.type == InfoType.Popicon)
				{
					if (gameState.isDesignMode == false)
					{
						var bmp:BitmapData = node.blitSpritesheet.getCurrentBitmapdata();
						var popIcon:PopIcon = node.entity.get(PopIcon);
						point.y += popIcon.renderPointY;
						point.x -= (bmp.rect.width / 2);
						point.x *= camera.scale; 
						point.y *= camera.scale; 
						
						info = tilesheets.get(tilesheet);
						layerID = getLayerID(node.layer);	
						
						info[0] = tilesheet;
						info[layerID].push(point.x); // position x
						info[layerID].push(point.y); // position y
						
						info[layerID].push(node.blitSpritesheet.getCurrentIdx()); // current img
					}
					//var popIcon:PopIcon = node.entity.get(PopIcon);
					//point.y += popIcon.renderPointY;
					//point.x *= camera.scale; 
					//point.y *= camera.scale; 
				}
				else
				{
					switch(node.blitGraphicsData.state)
					{
						case BlitGraphicsState.UP:
							tilesheet = node.blitSpritesheet.tilesheet;
						case BlitGraphicsState.OVER_GREEN:
							tilesheet = node.blitSpritesheet.oversheet;
						case BlitGraphicsState.OVER_RED:
							tilesheet = node.blitSpritesheet.oversheet;
						case BlitGraphicsState.OVER_NOMAL:
							tilesheet = node.blitSpritesheet.oversheet;
						case BlitGraphicsState.DOWN:
							tilesheet = node.blitSpritesheet.tilesheet;
					}
					
					info = tilesheets.get(tilesheet);
					layerID = getLayerID(node.layer);	
					
					info[0] = tilesheet;
					info[layerID].push(point.x); // position x
					info[layerID].push(point.y); // position y
					
					info[layerID].push(node.blitSpritesheet.getCurrentIdx()); // current img
					//point.x += (offsetX);
					//point.y += (offsetY >> 1);
				}
			}
			
			if (isDebug)
			{
				
				var aabb:AABB2 = node.aabb;
				var nx = point.x - aabb.minX ;
				var ny = point.y - aabb.minY;
				
				var mx = point.x - aabb.intervalX;
				var my = point.y - aabb.intervalY;
				
				//inDebugView.graphics.lineStyle(0, 0xff00ff, 1);
				inDebugView.graphics.drawRect(point.x, point.y, node.aabb.intervalX, node.aabb.intervalY);
				
				inDebugView.graphics.lineStyle(0, 0xff0000, 1);
				//inDebugView.graphics.drawRect(point.x, point.y, aabb.intervalX, aabb.intervalY);
				//inDebugView.graphics.drawRect(nx, ny, mx, my);
				
				//node.isoTile.draw(inDebugView, x, y);
			}
				
		}
		
	}
	
}