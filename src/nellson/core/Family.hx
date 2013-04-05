package nellson.core;
import nellson.core.abstract.IComponent;
import nellson.core.abstract.Component;
import nellson.core.Entity;
//import nellson.ds.ObjectHash;
import nellson.ds.modify.ObjectHash;
import de.polygonal.ds.HashableItem;
import de.polygonal.ds.HashKey;
import haxe.rtti.Meta;
import nme.Lib;
import haxe.rtti.CType;

/**
 * ...
 * @author Geun
 */
typedef ComponentData = {
	var name:String;
	var componentClass:Class<Dynamic>;
}
	
 
class Family<T:Node>
{
	//public var key:Int;
	//public var prev:IFamily;
	//public var next:IFamily;
	
	public var nodes:NodeList<T>;
	//private var entities:ObjectHash<T>;
	
	private var entities:ObjectHash<Dynamic, T>;
	//private var nodeClass:Class<T>; // debug only
	private var nodeClass:Class<Dynamic>; // debug only
	
	//private var components:ObjectHash<ComponentData>;
	private var components:ObjectHash<Dynamic, ComponentData>;
	
	private var nodePool:NodePool<T>;
	private var game:Game;
	static private inline var TEST_NUM:Int = 1000;
	
	public function new(nodeClass:Class<Dynamic>, ?game:Game)
	{
		this.nodeClass = nodeClass;
		if( game != null) this.game = game;
		
		init();
	}
	
	private function init():Void
	{
		nodePool = new NodePool(nodeClass);
		nodes = new NodeList(nodeClass);
		
		entities = new ObjectHash();
		components = new ObjectHash();
		//nodePool.dispose(nodePool.get()); // create dummy instance to ensure describeType worked;
		
		var typeMeta =  Meta.getType(nodeClass);
		
		//TODO: 형 자체를 담을수는 없는가? -> resolve 과정을 한번 뺌
		var types:Array<String> = cast typeMeta.type;
		var names:Array<String> = cast typeMeta.name;
		var len:Int = Std.parseInt(typeMeta.type.length);
		
		
		for ( i in 0...len)
		{
			var componentClass:Class<Dynamic> = Type.resolveClass(types[i]);
			//components.set(componentClass, {name : names[i], type: componentClass});
			components.set(componentClass, {name: names[i], componentClass : componentClass});
			//trace(names[i] + types[i]);
		}
	}
	
	public function addIfMatch(entity:Entity):Void
	{
		if ( !entities.has(entity))
		{
			for ( data in components)
			{
				if ( !entity.has(data.componentClass))
				{
					//trace(' not found');
					return;
				}
			}
			
			var node:T = nodePool.get();
			node.entity = entity;
			for ( data in components)
			{
				var fieldName:String = data.name;
				Reflect.setField(node, fieldName, entity.get( data.componentClass ));
			}
			
			entities.set(entity, node); 
			//trace('entities : ' + entities.size());
			entity.componentRemoved.add(componentRemoved);
			nodes.add(node); // list추가 
		}
	}
	
	public function remove(entity:Entity):Void
	{
		if (entities.has(entity))
		{
			var node = entities.get(entity);
			entity.componentRemoved.remove(componentRemoved);
			entities.remove(entity);
			
			nodes.remove(node);
			if (game.updating)
			{
				nodePool.cache(node);
				game.updateComplete.add(releaseNodePoolCache);
			}
			else
			{
				nodePool.dispose(node);
			}
		}
		//trace('entities : ' + entities.size());
		//trace('이거 안되낭');
		
	}
	
	private function releaseNodePoolCache():Void
	{
		game.updateComplete.remove(releaseNodePoolCache);
		nodePool.releaseCache();
		
	}
	
	public function cleanUp():Void
	{
		var node:Node = nodes.head;
		while (node != null)
		{
			node.entity.componentRemoved.remove(componentRemoved);
			entities.remove(node.entity);
			node = node.next;
		}
		nodes.removeAll();
	}
	
	private function componentRemoved(entity:Entity, componentClass:Dynamic):Void
	{
		if ( components.has(componentClass))
		{
			remove(entity);
		}
	}
	
	
}