/**
 * reflect any as3 object
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils {
	
	import flash.utils.describeType;
 
	public class getObjectInfo  {
	
		private static var object:*;
		private static var constructor:Class;
		private static var xmlInfos:XML;
		private static var variables:Array;
		private static var methods:Array;
		private static var accessors:Array;
		private static var extendClasses:Array;
		private static var implementInterfaces:Array;
		public static var classArgs:Array;
		
		public static function from( target:* ):void
		{
			object = target;
			xmlInfos = describeType( object );
			constructor = Object(object).constructor;
			getClassArgs( xmlInfos );
			getVariables( xmlInfos );
			getMethods( xmlInfos );
			getAccessors( xmlInfos );
			getExtends( xmlInfos );
		}
		
		public static function hasAccessor( accessor:String ):Boolean
		{
			return has(accessor, accessors);
		}
		
		public static function hasMethod( method:String ):Boolean
		{
			return has(method, methods);
		}
		
		public static function hasVariable( variable:String ):Boolean
		{
			return has(variable, variables);
		}
				
		private static function has(name:String, data:Array):Boolean
		{
			var result:Boolean = false;
			loop:for (var i:int = 0; i < data.length; i++) 
			{
				if ( data[i].name == name ) {
					result = true;
					break loop;
				}
			}
			return result;
		}
		
		public static function getAccessor( name:String ):Object
		{
			return getObject(name,accessors);
		}
		
		public static function getMethod( name:String ):Object
		{
			return getObject(name,methods);
		}
		
		public static function getVariable( name:String ):Object
		{
			return getObject(name,variables);
		}
		
		private static function getObject( name:String, data:Array ):Object
		{
			var result:Object;
			loop:for (var i:int = 0; i < accessors.length; i++) 
			{
				if ( data[i].name == name ) {
					result = data[i]
					break loop;
				}
			}
			return result;
		}
		
		
		public static function dumpVariables():String 
		{
			var result:String = '[ VARIABLES FOR ' + object.name.toUpperCase() + '\n';
			result += dump( variables );
			result += ' END VARIABLES ]';
			return result;
		}
		
		public static function dumpMethods():String 
		{
			var result:String = '[ METHODS FOR ' + object.name.toUpperCase() + '\n';
			result += dump( methods );
			result += ' END METHODS ]';
			return result;
		}
		
		public static function dumpAccessors():String 
		{
			var result:String = '[ ACCESSORS FOR ' + object.name.toUpperCase() + '\n';
			result += dump( accessors );
			result += ' END ACCESSORS ]';
			return result;
		}
		
		private static function dump( data:Array ):String
		{
			var result:String='';
			for (var i:int = 0; i < data.length; i++) 
			{
				result += '( OBJECT ';
				for ( var prop:String in data[i] )
				{
					result += ' ,' + prop + ':' + data[i][prop]+'';
				}
				result += ' )\n';
			}
			return result;
		}
		
		private static function getAccessors( child:XML ):void
		{
			accessors = new Array();
			var propertyName:String;
			var propertyValue:*;
			for each ( var a:XML in child..accessor )
            {
				propertyName = a.@name;
                propertyValue = object[propertyName];
				accessors[accessors.length] = { name:propertyName, value:propertyValue, type:a.@access };
            }
		}
		
		private static function getMethods( child:XML ):void
		{
			methods = new Array();
			var params:Object = {};
			for each ( var m:XML in child..method)
            {
				var nbParams:Number = 0;
				for each ( var p:XML in m..parameter )
				{
					params[String(nbParams)] = p.@type;
					nbParams += 1;
				}
				methods[methods.length] = { name:m.@name, nbParams:nbParams, params:params, returnType:m.@returnType };
            }
		}
		
		private static function getVariables( child:XML ):void
		{
			variables = new Array();
			var propertyName:String;
			var propertyValue:*;
			for each ( var v:XML in child..variable )
            {
                propertyName = v.@name;
                propertyValue = object[propertyName];
				variables[variables.length] = { name:propertyName, value:propertyValue };
            }
		}
		
		private static function getClassArgs( child:XML ):void
		{
			classArgs = new Array();
			var index:int;
			var type:String;
			var optional:Boolean;
			for each ( var a:XML in child..constructor )
            {
                index = a.@index;
                type = a.@type;
                optional = a.@optional;
				classArgs[classArgs.length] = { index:index, type:type, optional:optional };
            }
		}
		
		private static function getExtends( child:XML ):void
		{
			extendClasses = new Array();
			implementInterfaces = new Array();
			for each ( var e:XML in child..extendsClass )
            {
				extendClasses[extendClasses.length] = { type:e.@type };
            }
			
			for each ( var i:XML in child..implementsInterface )
            {
				implementInterfaces[implementInterfaces.length] = { type:i.@type };
            }
		}
	}
}	