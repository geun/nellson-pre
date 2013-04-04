package nellson.core;
//import nellson.ds.ObjectHash;
import nellson.ds.modify.ObjectHash;
import nellson.signals.Signal0;
import de.polygonal.ds.IntHashTable;
import minject.Injector;
import nme.feedback.Haptic;
import nme.Lib;
import nme.Vector;

/**
 * ...
 * @author geun
 */
 
class Game 
{
	
	public var injector:Injector;
	
	private var entities:EntityList;
	private var systems:SystemList;
	//private var families:ObjectHash<Family<Dynamic>>;
	private var families:ObjectHash<Dynamic, Family<Dynamic>>;
	
	public var updateComplete:Signal0;
	public var updating:Bool;

	public function new(injector:Injector) 
	{
		entities = new EntityList();
		systems = new SystemList();
		families = new ObjectHash();
		updateComplete = new Signal0();
		
		this.injector = injector;
	}
	
	
	public function addEntitiy(entity:Entity):Void
	{
		entities.add(entity); // add to entites List
		entity.componentAdded.add(componentAdded);
		
		for (family in families)
		{
			family.addIfMatch( entity );
		}
	}
	
	public function removeEntity(entity:Entity):Void
	{
		entity.componentAdded.remove(componentAdded);
		for (family in families)
		{
			family.remove(entity);
			families.remove(entity);
		}
	}
	
	private function componentAdded(entity:Entity, componentClass:Dynamic):Void
	{
		// when new component added to entity, rematch family if math
		for ( family in families)
		{
			family.addIfMatch(entity);
		}
	}
	
		
	public function getNodeList(nodeClass:Class<Dynamic>):NodeList<Dynamic>
	{
		if (families.has(nodeClass))
		{
			return families.get(nodeClass).nodes;
		}
		
		var family = new Family(nodeClass, this);
		families.set(nodeClass, family);
		
		var entity = entities.head;
		while ( entity != null)
		{
			family.addIfMatch(entity);
			entity = entity.next;
		}
		return family.nodes;
	}
	
	public function releaseNodeList(nodeClass:Class<Dynamic>):Void
	{
		if (families.has(nodeClass))
		{
			families.get(nodeClass).cleanUp();
			families.remove(nodeClass);
		}
	}
	
	public function addSystem(system:System, priority:Int):Void
	{
		injector.injectInto(system);
		
		system.priority = priority;
		system.addToGame(this);
		systems.add(system);
	}
	
	public function removeSystem(system:System):Void
	{
		systems.remove(system);
		system.removeFromGame(this);
	}
	
	public function getSystem(type:Class<Dynamic>):System
	{
		return systems.get(type);
	}
	
	
	public function removeAllEntities():Void
	{
		
		//TODO: 테스트 안됨. 
		//var entity = entities.head;
		//var head = entities.head;
		while ( entities.head != null)
		{
			var entity = entities.head;
			entities.head = entities.head.next;
			removeEntity(entity);
		}
	}
	
	public function removeAllSystems():Void
	{
		//TODO: 테스트 안됨
		
		//var head = systems.head;
		while ( systems.head != null)
		{
			var system = systems.head;
			systems.head = systems.head.next;
			removeSystem(system);
		}
		
	}
	
	public function update(time:Float):Void
	{
		var t = Lib.getTimer();
		updating = true;
		var system = systems.head;
		while ( system != null)
		{
			system.update(time);
			system = system.next;
		}
		
		updating = false;
		updateComplete.dispatch();
		var result = Lib.getTimer() - t;
		//trace('loopTime' +result+'ms');
		
	}
	
}