package nellson.quadtree.systems;
import nellson.blit.components.BlitSpritesheet;
import nellson.components.command.InteractionCommand;
import nellson.components.controller.MouseController;
import nellson.components.Info;
import nellson.core.Entity;
import nellson.core.Game;
import nellson.core.System;
import nellson.ds.QuadTree;
import nellson.grid.IGrid;
import nellson.isometirc.components.IsoCamera;
import nellson.isometirc.components.IsoSpatial;
import nellson.quadtree.components.QuarryResult;
import nellson.quadtree.nodes.QTreeItemNode;
import nellson.scene.SceneManager;
import nellson.ui.Button;
import com.touchingsignal.secretgarden.game.model.components.DecoInfo;
import com.touchingsignal.secretgarden.game.model.components.FlowerData;
import com.touchingsignal.secretgarden.game.model.GameState;
import com.touchingsignal.secretgarden.game.model.PopupManager;
import com.touchingsignal.secretgarden.game.model.User;
import com.touchingsignal.secretgarden.game.signal.core.GameStop;
import com.touchingsignal.secretgarden.game.signal.interaction.MoveItemByCameraPoint;
import com.touchingsignal.secretgarden.game.signal.interaction.ReleaseSelectedEntity;
import com.touchingsignal.secretgarden.game.signal.interaction.ResetGridLayer;
import com.touchingsignal.secretgarden.game.signal.interaction.SetSelectedEntity;
import com.touchingsignal.secretgarden.game.signal.interaction.UseInteraction;
import com.touchingsignal.secretgarden.game.signal.popup.HidePopup;
import com.touchingsignal.secretgarden.game.signal.popup.ShowPopup;
import com.touchingsignal.secretgarden.game.view.Scenes;
import com.touchingsignal.secretgarden.notice.components.PopIcon;
import nellson.ds.AABB2;
import nme.display.BitmapData;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.display.Stage;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Matrix;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.Lib;
import nme.ui.Multitouch;
import nme.ui.MultitouchInputMode;

using Lambda;
/**
 * ...
 * @author Geun
 */

class QCommandInteractionSystem extends System
{
	@inject public var gameState:GameState;
	@inject public var resetGridLayer:ResetGridLayer;
	@inject public var setSelectedEntity:SetSelectedEntity;
	@inject public var moveItemByCameraPoint:MoveItemByCameraPoint;
	@inject public var releaseSelectedEntity:ReleaseSelectedEntity;
	@inject public var popupManager:PopupManager;
	@inject public var showPopup:ShowPopup;
	@inject public var hidePopup:HidePopup;
	@inject public var userModel:User;
	
	private var controller:MouseController;
	private var quadTree:QuadTree<QTreeItemNode>;
	private var camera:IsoCamera;
	private var stage:Stage;
	private var result:QuarryResult;
	private var requestAABB:AABB2;
	private var grid:IGrid;
	private var dummy:Entity;
	private var m:Matrix;
	private var restirc:Int;
	
	public function new(quadTree:QuadTree<QTreeItemNode>, camera:IsoCamera, controller:MouseController, grid:IGrid) 
	{
		super();
		
		this.camera = camera;
		this.quadTree = quadTree;
		this.controller = controller;
		this.grid = grid;
		
		stage = Lib.current.stage;
		
	}
	
	override public function addToGame(game:Game):Void 
	{
		super.addToGame(game);
		init();
		userModel.updateMapSize.add(updateRestric);
		restirc = 300;
	}
	
	private function init() 
	{
		result = new QuarryResult();
		requestAABB = new AABB2();
		dummy = new Entity();
		m = new Matrix();
		var view:DisplayObjectContainer = controller.container;
		#if mobile 
		view.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown);
		view.addEventListener(TouchEvent.TOUCH_END, onTouchUp);
		view.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
		#else 
		view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		view.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		//view.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		#end
	}
	
	private function updateRestric(value:Int):Void
	{
		var offset = gameState.cellSize >> 3;
		if (value > 22)  offset << 1;
		restirc = value  * offset;
	}
		
	private function onTouchMove(e:TouchEvent):Void 
	{
		if (controller.mouseEnable)
		{
			if (camera.scale < 1.0)
			{
				var f = camera.scaleOffset;
				controller.currentMousePoint.x = stage.mouseX * f;
				controller.currentMousePoint.y = stage.mouseY * f;
			}
			else
			{
				controller.currentMousePoint.x = stage.mouseX;
				controller.currentMousePoint.y = stage.mouseY;
			}
			
			controller.mouseAABB.centerX = controller.currentMousePoint.x;
			controller.mouseAABB.centerY = controller.currentMousePoint.y;
			if (gameState.isDesignMode)
			{
				
				if ( controller.currentSelected != null)
				{
					moveItemByCameraPoint.dispatch(controller.currentSelected);
				}
				else
				{
					//선택 되지 않을때
					camera.moveCamera(controller.previousPoint.x - controller.currentMousePoint.x, controller.previousPoint.y - controller.currentMousePoint.y);
					controller.previousPoint.x = controller.currentMousePoint.x;
					controller.previousPoint.y = controller.currentMousePoint.y;
				}
			}
			else
			{
				camera.moveCamera(controller.previousPoint.x - controller.currentMousePoint.x, controller.previousPoint.y - controller.currentMousePoint.y);
				controller.previousPoint.x = controller.currentMousePoint.x;
				controller.previousPoint.y = controller.currentMousePoint.y;
			}
		}
	}
	
	private function onTouchUp(e:TouchEvent):Void 
	{
		#if flash
		if (controller.mouseEnable && e.target.name == 'mainview')
		#else
		if (controller.mouseEnable && (e.target.name == 'stageLayer' ||  e.target.name == 'Stage 1' ||e.target.name == 'popupIconLayer'))
		#end
		{
			if (!controller.isDraggingMode)
			{
				
				if (gameState.isDesignMode)
				{
					if (controller.currentSelected != null)
					{
						releaseSelectedEntity.dispatch(controller.currentSelected);
					}
					else
					{
						var pickup:QTreeItemNode = detectObject();
						if (pickup != null)
						{
							switch(pickup.info.type)
							{
								case InfoType.DropItems:
								case InfoType.EventDecos:
								case InfoType.Effects:
								case InfoType.Building:
								case InfoType.Flowers:
									setSelectedEntity.dispatch(pickup.entity);
								case InfoType.Deco:
									setSelectedEntity.dispatch(pickup.entity);
								case InfoType.Charactor:
								case InfoType.Popicon:
							}
						}
						else
						{
							controller.currentSelected = null;
						}
					}
				}
				else
				{
					if (gameState.hasPopup)
					{
						//trace(' gameState.hasPopup : ' + gameState.hasPopup);
						var current = popupManager.currentKey;
						if ( current != null)
						{
							switch(current)
							{
								case Scenes.INVENTORY:
								{
									hidePopup.dispatch(popupManager.currentKey);
								}
								case Scenes.FLOWER_INFO:
								{
									hidePopup.dispatch(popupManager.currentKey);
								}
								case Scenes.QUEST_LIST:
								{
									hidePopup.dispatch(popupManager.currentKey);
								}
							}
						}
					}
					else
					{
						var pickup:QTreeItemNode = detectObject();
						if (pickup != null)
						{
							switch(pickup.info.type)
							{
								case InfoType.DropItems:
								case InfoType.EventDecos:
								case InfoType.Effects:
								case InfoType.Flowers:
									setSelectedEntity.dispatch(pickup.entity);
									var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
									interactionCommand.mouseCommand.mouseClicked(pickup.entity);
								case InfoType.Deco:
									setSelectedEntity.dispatch(pickup.entity);
									var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
									interactionCommand.mouseCommand.mouseClicked(pickup.entity);
								case InfoType.Building:
									setSelectedEntity.dispatch(pickup.entity);
									var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
									interactionCommand.mouseCommand.mouseClicked(pickup.entity);
								case InfoType.Charactor:
								case InfoType.Popicon:
									setSelectedEntity.dispatch(pickup.entity);
									var popIcon:PopIcon = pickup.entity.get(PopIcon);
									var interactionCommand:InteractionCommand = popIcon.linkedEntity.get(InteractionCommand);
									interactionCommand.mouseCommand.mouseClicked(popIcon.linkedEntity);
							}
						}
						else
						{
							controller.currentSelected = null;
						}
					}
					
				}
			}
			controller.isDraggingMode = false;
			controller.isMouseDown = false;
		}
	}
	
	private function onTouchDown(e:TouchEvent):Void 
	{
		if (controller.mouseEnable)
		{
			if (camera.scale < 1.0)
			{
				var f = camera.scaleOffset;
				controller.currentMousePoint.x = stage.mouseX * f;
				controller.currentMousePoint.y = stage.mouseY * f;
			}
			else
			{
				controller.currentMousePoint.x = stage.mouseX;
				controller.currentMousePoint.y = stage.mouseY;
			}
			controller.isMouseDown = true;
			controller.previousPoint.x = controller.currentMousePoint.x;
			controller.previousPoint.y = controller.currentMousePoint.y;
		}
	}
	
	private function onWheel(e:MouseEvent):Void 
	{
		if (e.delta >= 1)
		{
			trace('zoom in : camera scale ', camera.scale);
			if(camera.scale < 1)
			camera.scale += 0.05;
		}
		else
		{
			trace('zoom out : camera scale ', camera.scale);
			if(camera.scale > 0.5)
			camera.scale -= 0.05;
		}
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		
		
		//trace('target : ' + e.target.name);
		//trace('currenttarget : ' + e.target.name);
		
		//trace('mouse move');
		//if (e.target.name == 'mainview')
		#if flash
		if (controller.mouseEnable && (e.target.name == 'mainview' || e.target.name == 'dropItemLayer') )
		//if (controller.mouseEnable)
		#else
		if (controller.mouseEnable && (e.target.name == 'stageLayer' ||  e.target.name == 'Stage 1' ||e.target.name == 'popupIconLayer'))
		#end
		{
			if (camera.scale < 1.0)
			{
				var f = camera.scaleOffset;
				controller.currentMousePoint.x = stage.mouseX * f;
				controller.currentMousePoint.y = stage.mouseY * f;
			}
			else
			{
				controller.currentMousePoint.x = stage.mouseX;
				controller.currentMousePoint.y = stage.mouseY;
			}
			
			
			controller.mouseAABB.centerX = controller.currentMousePoint.x;
			controller.mouseAABB.centerY = controller.currentMousePoint.y;
			
			
			
			if (controller.isMouseDown) controller.isDraggingMode = true;
			if (controller.isDraggingMode)
			{
				
				//trace([controller.currentMousePoint.x, controller.currentMousePoint.y]);
				
				
				//if (controller.currentMousePoint.x > 500) controller.currentMousePoint.x = 499;
				//if (controller.currentMousePoint.x < -200) controller.currentMousePoint.x = -199;
				//if ( controller.currentMousePoint.y > 400) controller.currentMousePoint.y = 400;
				//if (controller.currentMousePoint.y < -100) controller.currentMousePoint.y = -99;
				
				//if(gameState.
				camera.moveCamera(controller.previousPoint.x - controller.currentMousePoint.x, controller.previousPoint.y - controller.currentMousePoint.y, restirc);
				controller.previousPoint.x = controller.currentMousePoint.x;
				controller.previousPoint.y = controller.currentMousePoint.y;
			}
			else
			{
				if (gameState.isDesignMode)
				{
					
					if (gameState.isBatchMode)
					{
						if ( controller.currentSelected != null)
						{
								moveItemByCameraPoint.dispatch(controller.currentSelected);
						}
					}
					else
					{

							//선택 되지 않을때
						#if flash
						if (controller.prevOvered != null)
						{
							var prev = controller.prevOvered;
							var interactionCommand:InteractionCommand = prev.get(InteractionCommand);
							interactionCommand.mouseCommand.mouseRollOut(prev);
							prev = null;
						}
						var pickup:QTreeItemNode = detectObject();
						if (pickup != null)
						{
							switch(pickup.info.type)
							{
								case InfoType.DropItems:
								case InfoType.EventDecos:
								case InfoType.Effects:
								case InfoType.Building:
								case InfoType.Charactor:
								case InfoType.Flowers:
									var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
									interactionCommand.mouseCommand.mouseRollOver(pickup.entity);
									controller.currentOvered = pickup.entity;
								case InfoType.Deco:
									var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
									interactionCommand.mouseCommand.mouseRollOver(pickup.entity);
									controller.currentOvered = pickup.entity;
								case InfoType.Popicon:
							}
						}
						#end
					}
				}
				else
				{
					#if flash
					if (controller.prevSelected != null)
					{
						var prev = controller.prevSelected;
						if (prev.has(InteractionCommand))
						{
							var interactionCommand:InteractionCommand = prev.get(InteractionCommand);
							interactionCommand.mouseCommand.mouseRollOut(prev);
						}
						prev = null;
					}
					var pickup:QTreeItemNode = detectObject();
					if (pickup != null)
					{
						switch(pickup.info.type)
						{
							case InfoType.DropItems:
								//var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
								//interactionCommand.mouseCommand.mouseRollOver(pickup.entity);
							case InfoType.EventDecos:
							case InfoType.Effects:
							case InfoType.Building:
							case InfoType.Charactor:
							case InfoType.Flowers:
								setSelectedEntity.dispatch(pickup.entity);
								var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
								interactionCommand.mouseCommand.mouseRollOver(pickup.entity);
							case InfoType.Deco:
								setSelectedEntity.dispatch(pickup.entity);
								var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
								interactionCommand.mouseCommand.mouseRollOver(pickup.entity);
							case InfoType.Popicon:
								//var likedPick:PopIcon = pickup.entity.get(PopIcon);
								//var entity = likedPick.linkedEntity;
								//var interactionCommand:InteractionCommand = entity.get(InteractionCommand);
								//interactionCommand.mouseCommand.mouseRollOver(entity);
								//controller.prevSelected = entity;
						}
					}
					else
					{
						controller.currentSelected = null;
					}
					#end
				}
				
			}
		}
		else
		{
			#if flash
			
			//currentSelected
			if (controller.prevOvered != null)
			{
				var prev = controller.prevOvered;
				var interactionCommand:InteractionCommand = prev.get(InteractionCommand);
				interactionCommand.mouseCommand.mouseRollOut(prev);
				prev = null;
			}
			
			if (controller.currentSelected != null)
			{
				var currentSelected = controller.currentSelected;
				var interactionCommand:InteractionCommand = currentSelected.get(InteractionCommand);
				interactionCommand.mouseCommand.mouseRollOut(currentSelected);
				currentSelected = null;
			}
						
			//controller.currentSelected = null;
			#end
		}
	}
	
	private function onMouseUp(e:MouseEvent):Void 
	{
		//trace('target : ' + e.target.name);
		//trace('currenttarget : ' + e.target.name);
			
		
		#if flash
		if (controller.mouseEnable && (e.target.name == 'mainview' || e.target.name == 'dropItemLayer') )
		//if (controller.mouseEnable)
		#else
		if (controller.mouseEnable && (e.target.name == 'stageLayer' ||  e.target.name == 'Stage 1' ||e.target.name == 'popupIconLayer'))
		#end
		{
			if (!controller.isDraggingMode)
			{
				if (gameState.isDesignMode)
				{
					if (gameState.isBatchMode)
					{
						if (controller.currentSelected != null)
						{
							//gameState.isBatchMode = false;
							releaseSelectedEntity.dispatch(controller.currentSelected);
						}
						//else
						//{
							//gameState.isBatchMode = false;
							//controller.currentSelected = null;
						//}
					}
					else
					{
						var pickup:QTreeItemNode = detectObject();
						if (pickup != null)
						{
							switch(pickup.info.type)
							{
								case InfoType.DropItems:
								case InfoType.EventDecos:
								case InfoType.Effects:
								case InfoType.Building:
								case InfoType.Flowers:
									setSelectedEntity.dispatch(pickup.entity);
									//gameState.isBatchMode = true;
								case InfoType.Deco:
									setSelectedEntity.dispatch(pickup.entity);
									//gameState.isBatchMode = true;
								case InfoType.Charactor:
								case InfoType.Popicon:
							}
						}
						//else
						//{
							//controller.currentSelected = null;
							//releaseSelectedEntity.dispatch(controller.currentSelected);
						//}
						
					}
				}
				else
				{
					var pickup:QTreeItemNode = detectObject();
					if (pickup != null)
					{
						switch(pickup.info.type)
						{
							case InfoType.DropItems:
							case InfoType.EventDecos:
							case InfoType.Effects:
							case InfoType.Flowers:
								setSelectedEntity.dispatch(pickup.entity);
								var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
								interactionCommand.mouseCommand.mouseClicked(pickup.entity);
							case InfoType.Deco:
								setSelectedEntity.dispatch(pickup.entity);
								var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
								interactionCommand.mouseCommand.mouseClicked(pickup.entity);
							case InfoType.Building:
								setSelectedEntity.dispatch(pickup.entity);
								var interactionCommand:InteractionCommand = pickup.entity.get(InteractionCommand);
								interactionCommand.mouseCommand.mouseClicked(pickup.entity);
							case InfoType.Charactor:
							case InfoType.Popicon:
								//setSelectedEntity.dispatch(pickup.entity);
								//var popIcon:PopIcon = pickup.entity.get(PopIcon);
								//var interactionCommand:InteractionCommand = popIcon.linkedEntity.get(InteractionCommand);
								//interactionCommand.mouseCommand.mouseClicked(popIcon.linkedEntity);
						}
					}
					else
					{
						controller.currentSelected = null;
					}
				}
			}
		}
		//gameState.isBatchMode = false;
		controller.isDraggingMode = false;
		controller.isMouseDown = false;
		
	}
	
	private function onMouseDown(e:MouseEvent):Void 
	{
		//#if flash
		//if (controller.mouseEnable && e.target.name == 'mainview')
		//#else 
		//if (controller.mouseEnable && (e.target.name == 'stageLayer' ||  e.target.name == 'Stage 1' ||e.target.name == 'popupIconLayer'))
		//#end
		
		#if flash
		if (controller.mouseEnable && (e.target.name == 'mainview' || e.target.name == 'dropItemLayer') )
		//if (controller.mouseEnable)
		#else
		if (controller.mouseEnable && (e.target.name == 'stageLayer' ||  e.target.name == 'Stage 1' ||e.target.name == 'popupIconLayer'))
		#end
		{
			if (camera.scale < 1.0)
			{
				var f = camera.scaleOffset;
				controller.currentMousePoint.x = stage.mouseX * f;
				controller.currentMousePoint.y = stage.mouseY * f;
			}
			else
			{
				controller.currentMousePoint.x = stage.mouseX;
				controller.currentMousePoint.y = stage.mouseY;
			}
			controller.isMouseDown = true;
			controller.previousPoint.x = controller.currentMousePoint.x;
			controller.previousPoint.y = controller.currentMousePoint.y;
			if (gameState.isDesignMode)
			{
				
				if (!gameState.isBatchMode)
				{
					if ( controller.currentSelected != null)
					{
						releaseSelectedEntity.dispatch(dummy);
						controller.currentSelected = null;
					}
				}
				
			}
			
		}
		
	}
	
	
	private function detectObject():QTreeItemNode
	{
		var current:Point= camera.getIsoPoint(controller.currentMousePoint.x, controller.currentMousePoint.y);
		requestAABB.set(controller.mouseAABB);
		requestAABB.centerX = current.x;
		requestAABB.centerY = current.y;
		
		var pickup:QTreeItemNode = null;
		if ( camera.aabb.contains(requestAABB)) 
		{
			result.reset();
			var num = quadTree.queryAABB(requestAABB, result.data, 100, result.debug );
			//trace(['detect : ', num]);
			
			if (result.data.length > 0)
			{
				result.sort(false);
				
				#if !flash
				var popicons:Array<QTreeItemNode> = result.data.filter(function (node:QTreeItemNode) {
					//trace(node.info.type);
					return node.info.type == InfoType.Popicon;
				}).array();
				#else
				var popicons:Array<QTreeItemNode> = new Array();
				#end
				
				//trace(popicons.length);
				if (popicons.length > 0)
				{
					var node = popicons[0];
					return node;
					
					//trace(popicons[0].info.type);
					//trace('찾았다');
					
					//return popicons[0];
				}
				else
				{
					//trace('result num : ' + result.data.length);
					for (node in result.data)
					{
						if (node.entity.has(InteractionCommand))
						{
							//return node;
							//var mPoint:Point = camera.getIsoPoint(controller.currentMousePoint.x - node.blitGraphicsData.registerationPoint.x, controller.currentMousePoint.y - node.blitGraphicsData.registerationPoint.y);
							//var mPoint = current.subtract(node.isoSpatial.position);
							//var p = camera.getFlatPoint(mPoint.x, m
							
							//node.isoSpatial.isoToFlatX();
							
							var cPoint = camera.getFlatPoint(node.isoSpatial.position.x, node.isoSpatial.position.y);
							//var offsetCurrnet = camera.getIsoPoint(controller.currentMousePoint.x + node.blitGraphicsData.registerationPoint.x, controller.currentMousePoint.y + node.blitGraphicsData.registerationPoint.y);
							//var offsetCurrnet = camera.getIsoPoint(controller.currentMousePoint.x + node.blitGraphicsData.registerationPoint.x, controller.currentMousePoint.y + node.blitGraphicsData.registerationPoint.y);
							var offsetCurrnet = camera.getIsoPoint(controller.currentMousePoint.x, controller.currentMousePoint.y);
							var gPoint = camera.getFlatPoint(offsetCurrnet.x, offsetCurrnet.y);
							
							//var nPoint = camera.getFlatPoint(current.x, current.y);
							cPoint.x -= node.blitGraphicsData.registerationPoint.x;
							cPoint.y -= node.blitGraphicsData.registerationPoint.y;
							var mPoint = gPoint.subtract(cPoint);
							
							//trace([cPoint, gPoint, mPoint]);
							//mPoint.x -= node.blitGraphicsData.registerationPoint.x;
							//mPoint.y -= node.blitGraphicsData.registerationPoint.y;
							
							
						
							//point.x = (x - (Std.int(node.blitSpritesheet.getFrameRect().width) >> 1) - node.blitGraphicsData.registerationPoint.x);
							//point.y = (y - (Std.int(node.blitSpritesheet.getFrameRect().height) >> 1) - node.blitGraphicsData.registerationPoint.y);
							
							//var s:BlitSpritesheet
							//#if flash
							var currentOverBitmapdata:BitmapData = node.blitSpritesheet.getCurrentBitmapdata(true);
							var checkBitmapdata:BitmapData = new BitmapData(currentOverBitmapdata.width, currentOverBitmapdata.height);
							if (node.blitGraphicsData.rotation == 1)
							{
								m.identity();
								m.a = -1;
								m.tx = node.blitSpritesheet.getFrameRect().width;
								checkBitmapdata.draw(currentOverBitmapdata, m);
							}
							else
							{
								checkBitmapdata = currentOverBitmapdata;
							}
							
							
							var offsetX:Float = (checkBitmapdata.rect.width-24) / 2;
							var offsetY:Float = (checkBitmapdata.rect.height-24) / 2;
							
							//var box:Rectangle = node.blitSpritesheet.getFrameRect();
							//var offsetX:Float = (box.width) * .5;
							//var offsetY:Float = (box.height) * .5;
							
							
							//var aabb 
							
							//var aabb:AABB2 = new AABB2( -offsetX, -offsetY, offsetX, offsetY);
							
							var x = mPoint.x + offsetX; // 픽셀검사용
							var y = mPoint.y + offsetY; // 픽셀검사용.
							
							//var x = mPoint.x;
							//var y = mPoint.y;
							
							//var x = mPoint.x + offsetX;
							//var y = mPoint.y + offsetY;
							
							//trace([node.isoSpatial.position, mPoint, offsetX, offsetY,node.blitGraphicsData.registerationPoint.x,node.blitGraphicsData.registerationPoint.y, currentOverBitmapdata.rect.width, currentOverBitmapdata.rect.height, x,y]);
							//if(box.width
							//return node;
							if (mPoint.x < offsetX  && 
							    mPoint.x > -offsetX &&
								mPoint.y < offsetY &&
								mPoint.y > -offsetY)
							{
								//return node;
								//trace(node.info.id);
								//return node;
								//trace('continue');
								//continue;
								var alpha:Int = (checkBitmapdata.getPixel32(Std.int(x), Std.int(y)) >> 24 & 0xFF);
								//trace([node.isoSpatial.position, mPoint, offsetX, offsetY, node.blitGraphicsData.registerationPoint.x, node.blitGraphicsData.registerationPoint.y,  currentOverBitmapdata.rect.width, currentOverBitmapdata.rect.height, x,y, alpha]);
								//trace(alpha);
								if (node.blitGraphicsData.rotation == 1) checkBitmapdata.dispose();
								if (alpha > 30 ) return node;
								else continue;
								
								//else return node;
							}
							//#end
						}
						//else
						//{
							//trace('이건 뭐징');
						//}
					}
				}
				
				
			}
			else
			{
				//trace('아무것도 안선택됨');
				
			}
		}
		else
		{
			//trace('영역 바깥임');
		}
		
		return null;
	}
	
}