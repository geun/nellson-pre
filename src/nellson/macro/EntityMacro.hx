package nellson.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
#end


/**
 * ...
 * @author Geun
 */

class EntityMacro 
{
	
	@:macro public static function getData():Expr
	{
		
		var date = Date.now().toString();
		var pos = Context.currentPos();
		return { expr : EConst(CString(date)), pos : pos };
	}
	@:macro public static function rtti():Array<Field>
	{
		var pos = Context.currentPos();
		var fields = Context.getBuildFields();
		trace(Context.getLocalClass().get());
		//var tarray = TPath({pack })
		var tint = TPath( { pack : [], name: "Int", params : [], sub : null } );
		fields.push( { name:"hello", doc:null, meta : [], access : [APublic], kind: FVar(tint, null), pos:pos } );
		return fields;
	}
	
	
	
		/*trace(haxe.macro.Context.getLocalClass().get().superClass.params);

        var params = switch(haxe.macro.Context.getLocalClass().get().superClass.params[0])
        {
          case haxe.macro.Type.TAnonymous(a):
            var converted = [];

            for (field in a.get().fields)
            {
              trace(field.type);
              converted.push({ pos : pos, expr : EVars([
                { expr : null, name : field.name, type :
                  switch(field.type) {
                    case TInst(t, params):
                      TPath({ pack : t.get().pack, name : t.get().name, params : null, sub : null });

                    default:
                      null;
                  }
                }])
              });
            }

            converted;

          default: null;
        }

        trace(params);

        return { expr : EBlock(params), pos : pos };*/
	
	#if macro
	
	/**
	 * 
	 * 
	 * 
	 * init count : 1000;
	 * 
	 * 	       parsing   /  metadata
	 * flash     237ms   /    0ms
	 * cpp        33ms   /    0ms
	 * 
	 * init count : 10000;
	 * 	       parsing   /  metadata
	 * flash   2295 ms   /    1ms
	 * cpp      321 ms   /    2ms 
 	 * 
	 */
	public static function generate()
	{
		
		//Context.registerModuleDependency(
		Context.onGenerate(function(types){
			for (type in types)
			{
				//trace(type);
				switch (type)
				{
					case TInst(t, params):
					processInst(t, params);
					default:
				}
			}
		});
	}
	
	static function processField(ref:ClassType, field:ClassField)
	{
		
		switch (field.type)
		{
			// might need to recurse into typedefs here, incase people are silly - dp
			case TInst(t, params):
				var node = t.get();
				
				//var c = Context.getType(node); //Context.getType(node.name); 
				//processProperty(ref, field, node, params);
				trace('not in' + ref.meta.get());
				ref.meta.add("type", [Context.parse('"' + node.name + '"', ref.pos)], ref.pos);
				trace('in' + ref.meta.get());
				//trace(c);
			default:
		}

	}
	
	static function processProperty(ref:ClassType, field:ClassField, type:ClassType, params)
	{
		/*var pack = type.pack;
		pack.push(type.name);
		
		
		field.meta.add("type", [Context.parse('"' + pack.join(".") + '"', ref.pos)], ref.pos);
		field.meta.add("name", [Context.parse('"' + field.name + '"', ref.pos)], ref.pos);*/
		
		
		
		field.meta.add("type", [ ], ref.pos);
		trace(ref.pos + ' / ' + field.name + ' / ' + type.name + ':' + type.params + ':' + type.meta.get());
	}
	
	static function processInst(t:Ref<ClassType>, params:Array<Type>)
	{
		var ref = t.get();
		//trace(ref);
		if (ref.superClass != null)
		{
			if (ref.superClass.t.get().name == 'Node') // 상위 클래스가 node 인놈만 추려
			{
				trace('find it ' + ref.name);
				trace(ref.module);
				trace(ref.pos);
				
				
				//var s = Context.getModule(ref.name);
				//trace(ss.toString());
				//Context.registerModuleReuseCall(
				//trace('ref meta : ' + ref.meta.get());
				//var s = new Array<Int>();
				//var fields = ref.fields.get();
				var fields = ref.fields.get();
				//trace(ref.fields.get().toString());
				/*
				typedef ClassField = {
						var name : String;
						var type : Type;
						var isPublic : Bool;
						var params : Array<{ name : String, t : Type }>;
						var meta : Metadata;
						//var kind : FieldKind;
					}
				*/
					
				
					
				
				/*var pos = ref.pos;
				
				var tint = TPath({ pack : [], name : "Int", params : [], sub : null });
				fields.push({ name : "hello", doc : null, meta : [], access : [APublic], kind : FVar(tint,null), pos : pos });*/
				
				var types:Array<Expr> = [];
				var names:Array<Expr> = [];
				
				//var tstring = TPath( { pack : [], name : "String", params : [], sub : null } );
				//EVars(vars : Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr> }>)
				for (field in fields)
				{
					
					switch (field.type)
					{
						// might need to recurse into typedefs here, incase people are silly - dp
						case TInst(t, params):
							var node = t.get();
							//ref.meta.add("type", [Context.parse('"' + node.name + '"', ref.pos)], ref.pos);
							
							//field.meta.add("type", [Context.parse('"' + pack.join(".") + '"', ref.pos)], ref.pos);
							//trace(node.pack);
							//types.push({expr : EConst(CString(node.pack)), pos: ref.pos});
							
							
							var pack = node.pack;
							pack.push(node.name);
							
							names.push(Context.parse('"' + field.name + '"', ref.pos));
							types.push(Context.parse('"' + pack.join(".") + '"', ref.pos));
							
							//Context.registerModuleDependency(ref.module , pack);
							trace('name ' + field.name);
							trace('class ' + pack);
							
							//Context.parse('"' + pack.join(".") + '"', ref.pos)
							
							/*types.push( { expr : EVars([{ name : field.name, type : tstring,
							expr : { expr : EConst(CString(node.name)), pos: ref.pos}}]), pos : ref.pos } );*/
							
							//EVars(vars : Array<{ type : Null<ComplexType>, name : String, expr : Null<Expr> }>)
							//type.push({ type : Null<ComplexType>, name : , expr : Null<Expr> })
							//types.push({expr : EConst(CString(node.name)), pos: ref.pos});
							//trace('in' + ref.meta.get());
							//trace(c);
						default:
					}
					//processField(ref, field);
					//EBlock(exprs : Array<Expr>)
				}
				
				ref.meta.add("type", types, ref.pos);
				ref.meta.add("name", names, ref.pos); 
				//ref.meta.add("name", types, ref.pos);
				trace(ref.meta.get());
				var num:Int = types.length;
				var numString:String = Std.string(num);
				
				//ref.meta.add("num", [{expr : EConst(CInt(numString)), pos : ref.pos}], ref.pos);
			}
			//if (ref.superClass.t == BaseType( { name: 'Node' } ))
			//if(ref.superClass.t.toString() == 'nellson.core.Node')
			//trace(ref.superClass.t.toString());
			//trace(ref.superClass.t.get());
		}
		
		/*if (ref.superClass.params[0] == "Node")
		{
			trace(ref);
		}*/
		
		/*
		if (ref.isInterface)
		{
			ref.meta.add("interface", [], ref.pos);
		}

		if (ref.constructor != null)
		{
			processField(ref, ref.constructor.get());
		}

		var fields = ref.fields.get();

		for (field in fields)
		{
			processField(ref, field);
		}*/
	}
	#end
}