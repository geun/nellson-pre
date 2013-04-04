package nellson.core;
import nellson.core.abstract.IComponent;
//import nellson.ds.ObjectHash;
import nellson.ds.modify.ObjectHash;
import nellson.signals.Signal2;
/**
 * ...
 * @author Geun
 * 
 * Entity는 components를 모아둔 컬렉션임.
 * 컴포넌트는 vo로 사용
 * 
 * public class PositionComponent
 * {
 *   public var x : Number;
 *   public var y : Number;
 * }
 * 
 * 시스템은 entity들에 있는 컴포넌트들로 동작함.
 */

class Entity 
{
	
	public var name:String; // 디버깅용, 
	public var componentAdded:Signal2<Entity, Dynamic>;
	public var componentRemoved:Signal2<Entity, Dynamic>;
	
	public var prev:Entity;
	public var next:Entity;
	
	private var components:ObjectHash<Dynamic, Dynamic>;
	
	public function new() 
	{
		componentAdded  = new Signal2(Entity, Dynamic);
		componentRemoved = new Signal2(Entity, Dynamic);
		components = new ObjectHash();
	}
	
	/**
	 * Add a component to the entity.
	 * 
	 * <code>var entity : Entity = new Entity()
	 *     .add( new Position( 100, 200 )
	 *     .add( new Display( new PlayerClip() );</code>
	 *
	*/
	
	public function add(component:Dynamic, ?componentClass:Dynamic):Entity
	{
		if ( componentClass == null) 
		{
			componentClass = Type.getClass(component);
		}
		
		if (components.has(componentClass))
		{
			remove(componentClass);
		}
		components.set(componentClass, component);
		componentAdded.dispatch(this, componentClass);
		return this;
	}
	
	public function numComponent():Int
	{
		return components.size();
	}
	
	public function remove(componentClass:Dynamic):Bool
	{
		
		if (components.has(componentClass))
		{
			components.remove(componentClass);
			componentRemoved.dispatch(this, componentClass);
			return true;
		}
		return false;
	}
	
	public function has(componentClass:Dynamic):Bool
	{
		
		return components.has(componentClass);
	}
	
	
	public function get(componentsClass:Dynamic):Dynamic
	{
		return components.get(componentsClass);
	}
	public function clone():Entity
	{
		//var copy:Entity = new Entity();
		return null;
	}
	
}