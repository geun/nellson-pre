package nellson.isometirc.systems;

import nellson.blit.components.BlitSpritesheet;
import nellson.ds.AABB2;
import nellson.isometirc.components.IsoSpatial;
import nellson.isometirc.components.IsoTile;
import nellson.isometirc.nodes.IsoSpatialNode;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.tools.ListIteratingSystem;
import nme.geom.Point;
import nme.geom.Rectangle;

/**
 * ...
 * @author Geun
 */

class IsoSpatialUpdateSystem extends ListIteratingSystem<QTreeItemNode>
{
	private var offsetPoint:Point;
	private var p:Point;

	public function new() 
	{
		super(QTreeItemNode, updateNode, added);
		offsetPoint = new Point();
		p = new Point();
	}
	
	private function added(node:QTreeItemNode):Void
	{
		node.isoSpatial.isInvaildationPosition = true;
	}
	
	
	private function updateNode(node:QTreeItemNode, time:Float):Void
	{
		//trace(node.isoSpatial.isInvaildationPosition);
		if ( node.isoSpatial.isInvaildationPosition )
		{
			
			//node.aabb.setMinX(node.isoSpatial.position.x); // entity 의  aabb 영역을 업데이트함. 
			//node.aabb.setMinY(node.isoSpatial.position.x);
			//trace(node.aabb.intervalX);
			
			//var x = node.isoSpatial.position.x - (node.aabb.intervalX * .5);
			//var y = node.isoSpatial.position.y - (node.aabb.intervalY * .5);
			
			//var offsetPoint = IsoSpatial.flatToIso(node.blitGraphicsData.registerationPoint.x, node.blitGraphicsData.registerationPoint.y);
			
			//trace([offsetPoint.x, offsetPoint.y]);
			//var x = node.isoSpatial.position.x - (node.aabb.intervalX * .5) - offsetPoint.x;
			//var y = node.isoSpatial.position.y - (node.aabb.intervalY * .5) - offsetPoint.y;
			
			/*var x = node.isoSpatial.position.x - (node.aabb.intervalX * .5);
			var y = node.isoSpatial.position.y - (node.aabb.intervalY * .5);
			
			node.aabb.setMinX(x); // entity 의  aabb 영역을 업데이트함. 
			node.aabb.setMinY(y);
			*/
			
			
			
			IsoSpatial.isoToFlatToPoint(offsetPoint, node.isoSpatial.position.x, node.isoSpatial.position.y);
			offsetPoint.x -= node.blitGraphicsData.registerationPoint.x;
			offsetPoint.y -= node.blitGraphicsData.registerationPoint.y;
			
			IsoSpatial.flatToIsoToPoint(p, offsetPoint.x, offsetPoint.y);
			
			
			
			//if (node.blitGraphicsData.rotation == 1)
			//{
				//
			//}
			//else
			//{
				//
			//}
			//
			
			
			/*var rect:Rectangle = node.blitSpritesheet.getFrameRect();
			//trace([x, y, node.aabb.intervalX]);
			if (node.blitGraphicsData.rotation == 1)
			{
				
				var isotile:IsoTile = node.entity.get(IsoTile);
				var col = isotile.col;
				var row = isotile.row;
				
				var offset = (col - row / 2 * isotile.size);
				var temp:AABB2 = new AABB2(0, 0, rect.height, rect.width);
				//p.x -= (node.aabb.intervalX * .5);
				//p.y -= (node.aabb.intervalY * .5);
				//p.x += offset;
				//p.y += offset;
				p.x -= (temp.intervalX * .5);
				p.y -= (temp.intervalY * .5);
				//temp.centerX = p.x;
				//temp.centerX = p.y;
				//node.aabb.intervalX()
				//temp.setMinX(p.x); // entity 의  aabb 영역을 업데이트함. 
				//temp.setMinY(p.y);
				node.aabb.set(temp);
				node.aabb.setMinX(p.x); // entity 의  aabb 영역을 업데이트함. 
				node.aabb.setMinY(p.y);
				//node.aabb.
				
				//node.aabb.scale
			}
			else
			{
				var temp:AABB2 = new AABB2(0, 0, rect.width, rect.height);
				p.x -= (node.aabb.intervalX * .5);
				p.y -= (node.aabb.intervalY * .5);
				node.aabb.set(temp);
				node.aabb.setMinX(p.x); // entity 의  aabb 영역을 업데이트함. 
				node.aabb.setMinY(p.y);
			}*/
			
			
			
			
			/*var rect:Rectangle = node.blitSpritesheet.getFrameRect();
			var temp:AABB2 = new AABB2(0, 0, rect.width, rect.height);
			node.aabb.set(temp);
			//node.aabb.setMinX(p.x); // entity 의  aabb 영역을 업데이트함. 
			//node.aabb.setMinY(p.y);
			
			p.x -= (node.aabb.intervalX * .5);
			p.y -= (node.aabb.intervalY * .5);
			//node.aabb.set(temp);
			node.aabb.setMinX(p.x); // entity 의  aabb 영역을 업데이트함. 
			node.aabb.setMinY(p.y);
			
			if (node.blitGraphicsData.rotation == 1)
			{
				var w = node.aabb.intervalX;
				var y = node.aabb.intervalY;
				
				var o = w - y;
				node.aabb.minX += o;
				node.aabb.minY -= o;
			}*/
			
			
				
			if (node.blitGraphicsData.rotation == 1)
			{
				var isotile:IsoTile = node.entity.get(IsoTile);
				var col = isotile.col;
				var row = isotile.row;
				
				if (col != row) {
					p.x += (node.aabb.intervalX * (col*0.1)); ////TODO:  이거 완전 야매잖아 -_- ; 나중에 터치감 개선 
					p.y -= (node.aabb.intervalY * 0.5);	
				}
				else
				{
					p.x -= (node.aabb.intervalX * .5);
					p.y -= (node.aabb.intervalY * .5);
					
				}
				//p.x += (node.aabb.intervalX * .5) ;
				//p.y += (node.aabb.intervalY * .5);
			}
			else
			{
				p.x -= (node.aabb.intervalX * .5);
				p.y -= (node.aabb.intervalY * .5);	
				
			}
			node.aabb.setMinX(p.x); // entity 의  aabb 영역을 업데이트함. 
			node.aabb.setMinY(p.y);
			//
			//p.x -= (node.aabb.intervalX * .5);
			//p.y -= (node.aabb.intervalY * .5);
			//node.aabb.setMinX(p.x); // entity 의  aabb 영역을 업데이트함. 
			//node.aabb.setMinY(p.y);
			//
			
			/*p.x -= (node.aabb.intervalX * .5);
			p.y -= (node.aabb.intervalY * .5);
			node.aabb.setMinX(p.x); // entity 의  aabb 영역을 업데이트함. 
			node.aabb.setMinY(p.y);*/
			
			//trace([node.isoSpatial.position.x, node.isoSpatial.position.y,x,y]);
			
			//trace(node.aabb.toString());
			//var x = node.isoSpatial.position.x - (node.aabb.intervalX * .5);
			//var y = node.isoSpatial.position.y - (node.aabb.intervalY * .5);
			//var x = node.isoSpatial.position.x + node.blitGraphicsData.registerationPoint.x;
			//var y = node.isoSpatial.position.y + node.blitGraphicsData.registerationPoint.y;
			//node.aabb.centerX = x; // entity 의  aabb 영역을 업데이트함. 
			//node.aabb.centerY = y;
			
			
			node.isoSpatial.update(); // 업데이트 할때  isoToflat 을 실행함.
			node.isoSpatial.isInvaildationPosition = false;
		}
	}
	
}