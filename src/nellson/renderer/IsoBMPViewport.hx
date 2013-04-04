package nellson.renderer;
import nellson.blit.components.BlitSpritesheet;
import nellson.blit.components.BlitSpritesheetGraphics;
import nellson.components.camera.Camera;
import nellson.components.Info;
import nellson.grid.IGrid;
import nellson.isometirc.components.IsoSpatial;
import nellson.isometirc.components.IsoTile;
import nellson.pathfinding.astar.AstarNode;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.tools.TestUtil;
import com.touchingsignal.secretgarden.animation.components.Effect;
import com.touchingsignal.secretgarden.game.model.components.DropItem;
import com.touchingsignal.secretgarden.game.model.components.ItemData;
import com.touchingsignal.secretgarden.game.model.GameState;
import com.touchingsignal.secretgarden.notice.components.PopIcon;
import nellson.ds.AABB2;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.BlendMode;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.filters.GlowFilter;
import nme.geom.ColorTransform;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * ...
 * @author Geun
 */

class IsoBMPViewport extends BMPViewport
{
	@inject
	public var gameState:GameState;
	
	
	private var cellSize:Int;
	private var halfSize:Int;
	private var isCopyFixcel:Bool;
	private var m:Matrix;
	private var offset:Point;
	private var getCenterPoint:Point;
	private var alphaTransfrom:ColorTransform;
	
	public function new(container:DisplayObjectContainer,camera:Camera, grid:IGrid) 
	{
		super(container, camera);
		//isDebug = true;
		//isDebug = true;
		//
		//isCopyFixcel = false;
		isCopyFixcel = true;
		
		this.cellSize = grid.getSellSize();
		this.halfSize = cellSize >> 1;
		offset = new Point();
		getCenterPoint = new Point();
		m = new Matrix();
		
		alphaTransfrom = new ColorTransform();
		alphaTransfrom.alphaOffset = 255;
		alphaTransfrom.redOffset = 25;
		alphaTransfrom.blueOffset = 25;
		alphaTransfrom.greenOffset = 25;
								
								
	}
	
	override private function init():Void 
	{
		super.init();
		
		var popuplayer:Sprite = cast container.getChildByName('popupIconLayer');
		var stagelayer:Sprite = cast container.getChildByName('stageLayer');
		var dropItemlayer:Sprite = cast container.getChildByName('dropItemLayer'); 
		
		if (dropItemlayer != null)
		{
			//trace('add noticeLayer');
			dropItemlayer.addChild(foregroundLayer);
		}
		if (popuplayer != null) 
		{
			//trace('add popupLayer');
			popuplayer.addChild(noticeLayer);
		}
		if (stagelayer != null)
		{
			//trace('add stageLayer');
			stagelayer.addChild(stageLayer);
		}
	}
	
	private function skew(matrix:Matrix, deg:Float):Void
	{
		 deg = deg * (Math.PI / 180);
		 matrix.c = Math.tan(deg);
	}
	
	override public function render(renderNodes:QuarryResult):Void 
	{
		getCenterPoint.x = 0;
		getCenterPoint.y = 0;
		
		if (camera.inValidationSize)
		{
			resize();
			camera.inValidationSize = false;
		}
		
		lockLayer();
		var num = renderNodes.data.length;
		
		var cameraOffsetX = camera.getCameraOffsetX();
		var cameraOffsetY = camera.getCameraOffsetY();
		
		//trace('Render' + renderNodes.data.length);
		
		for (i in 0...num)
		{
			var node:QTreeItemNode = renderNodes.data[i];
			var debugRect = renderNodes.debug[i];
			
			var x = node.isoSpatial.isoToFlatX() - camera.viewPoint.centerX + cameraOffsetX;
			var y = node.isoSpatial.isoToFlatY() - camera.viewPoint.centerY + cameraOffsetY;
			
			var drawLayer:BitmapData = getLayer(node.layer);
			
			//point.x = (x - getCenterPoint.x - (Std.int(node.blitSpritesheet.getFrameRect().width) >> 1) - node.blitGraphicsData.registerationPoint.x);
			//point.y = (y - getCenterPoint.y - (Std.int(node.blitSpritesheet.getFrameRect().height) >> 1) - node.blitGraphicsData.registerationPoint.y);
			point.x = (x -node.blitSpritesheet.getFrameRect().width * .5 - node.blitGraphicsData.registerationPoint.x);
			point.y = (y -node.blitSpritesheet.getFrameRect().height *.5 - node.blitGraphicsData.registerationPoint.y);
			
			//point.x = (x - node.blitGraphicsData.registerationPoint.x);
			//point.y = (y - node.blitGraphicsData.registerationPoint.y);
			var maxX  = (camera.renderBounds.maxX  + cellSize) * camera.scaleOffset;
			var maxY  = (camera.renderBounds.maxY + cellSize) * camera.scaleOffset;

			
			//offsceen culling
			if ( x < maxX  && y < maxY ) 
			{
				if (node.info.type == InfoType.Popicon)
				{
					//trace(node.info.type);
					if (!gameState.isDesignMode )
					{
						var bmp:BitmapData = node.blitSpritesheet.getCurrentBitmapdata();
						var popIcon:PopIcon = node.entity.get(PopIcon);
						if (popIcon.linkedEntity == null) continue;
						//if (!popIcon.isPopuped) continue;
						var sheet = popIcon.linkedEntity.get(BlitSpritesheet);
						var h = sheet.getFrameRect().height + 7;
						point.y += (popIcon.renderPointY -  h);
						//point.x -= (bmp.rect.width / 2);
						//point.x *= camera.scale; 
						//point.y *= camera.scale; 
						
						if (isCopyFixcel)
						{
							var rect = bmp.rect;
							drawLayer.copyPixels(bmp, rect, point, true);
						}
					}
				}
				else if (node.info.type == InfoType.Effects)
				{
					var bmp:BitmapData = node.blitSpritesheet.getCurrentBitmapdata();
					//var popIcon:PopIcon = node.entity.get(PopIcon);
					//var sheet = popIcon.linkedEntity.get(BlitSpritesheet);
					//var h = sheet.getFrameRect().height;
					//point.y += (popIcon.renderPointY -  h);
					//point.x -= (bmp.rect.width / 2);
					//point.x *= camera.scale; 
					//point.y *= camera.scale; 
					var effect:Effect = node.entity.get(Effect);
					if (effect.linkedEntity == null) continue;
					var sheet = effect.linkedEntity.get(BlitSpritesheet);
					var h = sheet.getFrameRect().height;
					point.y -= h;

					if (isCopyFixcel)
					{
						var rect = bmp.rect;
						drawLayer.copyPixels(bmp, rect, point, true);
					}
				}
				
				/*else if (node.info.type == InfoType.DropItems)
				{
					var dropitem:DropItem = node.entity.get(DropItem);
					
					if (!dropitem.isCollected && !dropitem.isAnimating)
					{
						var bmp:BitmapData = node.blitSpritesheet.getCurrentBitmapdata();
						
						m.identity();
						m.scale(camera.scale * .8, camera.scale *.8  );
						m.translate(point.x, point.y);
						drawLayer.draw(bmp, m, null, null, null, true);
					}
				}*/
				else
				{
					var isotile:IsoTile = node.entity.get(IsoTile);
					if (isotile != null)
					{
						isotile.getCenter(getCenterPoint);
						//point.x -= getCenterPoint.x;
						//point.y -= getCenterPoint.y;
					}
					
					var offsetX = node.blitSpritesheet.getFrameRect().width * .5;
					var offsetY = node.blitSpritesheet.getFrameRect().height * .5;
					switch(node.blitGraphicsData.state)
					{
						case BlitGraphicsState.UP:
						{
							//var itemData:ItemData = node.entity.get(ItemData);
							var bmp:BitmapData = node.blitSpritesheet.getCurrentBitmapdata();
							
							if (node.blitGraphicsData.rotation == 1)
							{
								m.identity();
								m.a = -1;
								if (isotile.col == isotile.row)	m.tx = node.blitSpritesheet.getFrameRect().width;
								else m.tx = node.blitSpritesheet.getFrameRect().width + ((isotile.col-1) * halfSize);
								//m.translate( -offsetX, -offsetY); //중심점 
								//m.scale(camera.scale + 0.1, camera.scale+ 0.1);
								//m.translate( offsetX, offsetY);
								m.translate(x, y);
								m.translate( -offsetX, -offsetY); //중심점 	
								m.translate( -getCenterPoint.x, -getCenterPoint.y);
								m.translate(-node.blitGraphicsData.registerationPoint.x, -node.blitGraphicsData.registerationPoint.y);
								//node.blitGraphicsData.registerationPoint.y
								//skew(m, 20);
								//m.translate(-offsetX *2, -offsetY*2);
								drawLayer.draw(bmp, m, null, null, null, false);
							}
							else
							{
								if (isCopyFixcel)
								{
									var rect = bmp.rect;
									point.x -= getCenterPoint.x;
									point.y -= getCenterPoint.y;
									drawLayer.copyPixels(bmp, rect, point, true);
								}
								else
								{
									m.identity();
									m.translate( -offsetX, -offsetY); //중심점 	
									m.scale(camera.scale, camera.scale);
									m.translate( offsetX, offsetY); //중심점 	
									
									m.translate(x, y);
									m.translate( -offsetX, -offsetY); //중심점 	
									m.translate( -getCenterPoint.x, -getCenterPoint.y);
									m.translate(-node.blitGraphicsData.registerationPoint.x, -node.blitGraphicsData.registerationPoint.y);
									//m.translate(point.x, point.y);
									//m.translate( -getCenterPoint.x, -getCenterPoint.y);
									//m.scale(camera.scale, camera.scale);
									drawLayer.draw(bmp, m, null, null, null, false);
								}
							}
						}
							
							
						case BlitGraphicsState.OVER_GREEN:
						
							var over:BitmapData = node.blitSpritesheet.getCurrentBitmapdata(true);
							if (node.blitGraphicsData.rotation == 1)
							{
								m.identity();
								m.a = -1;
								if (isotile.col == isotile.row)	m.tx = node.blitSpritesheet.getFrameRect().width;
								else m.tx = node.blitSpritesheet.getFrameRect().width + ((isotile.col-1) * halfSize);
								//m.translate( -offsetX, -offsetY); //중심점 	
								//m.scale(camera.scale + .025, camera.scale + .025);
								//m.translate( offsetX, offsetY); //중심점 	
								m.translate(x, y);
								m.translate( -offsetX, -offsetY); //중심점 	
								m.translate( -getCenterPoint.x, -getCenterPoint.y);
								m.translate(-node.blitGraphicsData.registerationPoint.x, -node.blitGraphicsData.registerationPoint.y);
								//node.blitGraphicsData.registerationPoint.y
								//skew(m, 20);
								//m.translate(-offsetX *2, -offsetY*2);
								drawLayer.draw(over, m, null, null, null, false);
							}
							else
							{
								m.identity();
								//m.translate( -offsetX, -offsetY); //중심점 	
								//m.scale(camera.scale + .025, camera.scale + .025);
								//m.translate( offsetX, offsetY); //중심점 	
								m.translate(x, y);
								m.translate( -offsetX, -offsetY); //중심점 	
								m.translate( -getCenterPoint.x, -getCenterPoint.y);
								m.translate(-node.blitGraphicsData.registerationPoint.x, -node.blitGraphicsData.registerationPoint.y);
								//node.blitGraphicsData.registerationPoint.y
								//skew(m, 20);
								//m.translate(-offsetX *2, -offsetY*2);
								drawLayer.draw(over, m, null, null, null, false);
								
							}
							//var rect = over.rect;
							//drawLayer.copyPixels(over, rect, point, true);
						case BlitGraphicsState.OVER_RED:
							
							var over:BitmapData = node.blitSpritesheet.getCurrentBitmapdata(true);
							var c:ColorTransform = new ColorTransform();
							c.redOffset = 250;
							c.blueOffset = -70;
							c.greenOffset = -70;
							c.alphaOffset = 255;
							
							if (node.blitGraphicsData.rotation == 1)
							{
								m.identity();
								m.a = -1;
								if (isotile.col == isotile.row)	m.tx = node.blitSpritesheet.getFrameRect().width;
								else m.tx = node.blitSpritesheet.getFrameRect().width + ((isotile.col-1) * halfSize);
								m.translate( -offsetX, -offsetY); //중심점 	
								m.scale(camera.scale + .025, camera.scale + .025);
								m.translate( offsetX, offsetY); //중심점 	
								m.translate(x, y);
								m.translate( -offsetX, -offsetY); //중심점 	
								m.translate( -getCenterPoint.x, -getCenterPoint.y);
								m.translate(-node.blitGraphicsData.registerationPoint.x, -node.blitGraphicsData.registerationPoint.y);
								//node.blitGraphicsData.registerationPoint.y
								//skew(m, 20);
								//m.translate(-offsetX *2, -offsetY*2);
								drawLayer.draw(over, m, c, null, null, false);
							}
							else
							{
								m.identity();
								m.translate( -offsetX, -offsetY); //중심점 	
								m.scale(camera.scale + .025, camera.scale + .025);
								m.translate( offsetX, offsetY); //중심점 	
								m.translate(x, y);
								m.translate( -offsetX, -offsetY); //중심점 	
								m.translate( -getCenterPoint.x, -getCenterPoint.y);
								m.translate(-node.blitGraphicsData.registerationPoint.x, -node.blitGraphicsData.registerationPoint.y);
								//node.blitGraphicsData.registerationPoint.y
								//skew(m, 20);
								//m.translate(-offsetX *2, -offsetY*2);
								drawLayer.draw(over, m, c, null, null, false);
								
							}
							//bitmapData.copyPixels(node.blitGraphicsData.overBitmapData, node.spriteSheet.getFrameRect(), point);
						case BlitGraphicsState.OVER_NOMAL:
						case BlitGraphicsState.DOWN:
						
					}
				}
				
				if (isDebug)
				{
					
					point.x -= getCenterPoint.x;
					point.y -= getCenterPoint.y;
									
					//var aabb:AABB2 = node.blitGraphicsData.aabb;
					//var rect:Rectangle = node.blitSpritesheet.getFrameRect();
					inDebugView.graphics.lineStyle(0, 0xff00ff, 1);
					if (node.blitGraphicsData.rotation == 1)
					{
						//point.x -= (node.aabb.intervalX * .5);
						//point.y -= (node.aabb.intervalY * .5);
						
					}
					
					//inDebugView.graphics.drawRect(point.x, point.y, node.aabb.intervalX, node.aabb.intervalY);
					inDebugView.graphics.drawRect(point.x, point.y, node.aabb.intervalX, node.aabb.intervalY);
					
					//inDebugView.graphics.drawRect(point.x, point.y, node.aabb.intervalX, node.aabb.intervalY);
					
					TestUtil.drawAABB(inDebugView, node.aabb, false, 0xff55cc, 1000, 300);
					//node.isoTile.draw(inDebugView, x, y);
					TestUtil.drawISOAABB(inDebugView, debugRect, false, 0xff0000, 1000, 300);
					TestUtil.drawAABB(inDebugView, debugRect, false, 0xcc55cc, 1000, 300);
				}
			}
			
		}
		unlockLayer();
	/*	inDebugView.graphics.lineStyle(0, 0x00ffff, 2);
		inDebugView.graphics.drawRect(camera.aabb.minX, camera.aabb.minY, camera.aabb.intervalX, camera.aabb.intervalY);*/
		
		if(isDebug)
		{
			//TestUtil.drawISOAABB(inDebugView, camera.worldBounds, false, 0xeeeeee, 1000, 300);
			TestUtil.drawISOAABB(inDebugView, camera.aabb, false, 0xff00ff, 1000, 300);
			TestUtil.drawISOAABB(inDebugView, camera.centerAABB, false, 0x00cc33, 1000, 300);
			//TestUtil.drawAABB(inDebugView, camera.renderBounds, false, 0xFF0000);
			
			//TestUtil.drawISOPoint(inDebugView, new Point(camera.aabb.centerX, camera.aabb.centerY), 0xff00ff, 1000, 300);
			TestUtil.drawISOAABB(inDebugView, camera.viewPoint, false, 0xff0000, - camera.viewPoint.centerX + cameraOffsetX, - camera.viewPoint.centerY + cameraOffsetY);
			//TestUtil.drawISOPoint(inDebugView, camera.viewPoint, 0xff0000, - camera.viewPoint.x + cameraOffsetX, - camera.viewPoint.y + cameraOffsetY);
			TestUtil.drawISOAABB(inDebugView, camera.viewPoint, false, 0xff0000, 1000, 300);
			//TestUtil.drawISOPoint(inDebugView, camera.viewPoint, 0xff0000, 1000, 300);
			
			//trace([aabb.minX + (aabb.intervalX * .5)]);
			
			TestUtil.drawAABB(inDebugView, camera.aabb, false, 0x0000FF, 1000,300);
			
			//trace(IsoSpatial.isoToFlat(camera.viewPoint.x, camera.viewPoint.y));
		}
		
		
		
	}
	
}