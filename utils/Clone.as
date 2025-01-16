/**
 * duplicate any displayobject
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils {
	
	import flash.utils.describeType;
 
	public class Clone  {
		
		public static function deep(target:* ):* 
		{
			return duplicateChild( target );
		}
	
		private static function duplicateChild( target:* ):*
		{
			var i:int;
			var acceptChild:Boolean = false;
			var childs:Array = new Array();
			var classInfo:XML = describeType( target );
			var targetClass:Class = Object(target).constructor;
			
			
			var duplicate:*;
			if ( String(targetClass) == '[class GraphicShape]' && target.copy )
			{
				duplicate = new targetClass(true);
				duplicate.graphicsCopy.copy(target.graphicsCopy);
			}
			else duplicate = new targetClass();
			
			
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			
			var propertyName:String;
			var propertyValue:*;
			for  each ( var v:XML in classInfo..variable )
            {
                propertyName = v.@name;
                propertyValue = target[propertyName];
            }
			
			for  each ( var a:XML in classInfo..accessor )
            {
				propertyName = a.@name;
                propertyValue = target[propertyName];
                if ( a.@access == 'readwrite' )
				{
					duplicate[propertyName] = propertyValue;
				}
				else 
				{
					if (propertyName == 'numChildren') acceptChild = true;	
				}
            }
			
			
			if ( acceptChild)
			{
				if ( target.numChildren != 0 )
				{
					for ( i=0; i < target.numChildren; i++) 
					{
						 childs.push( duplicateChild( target.getChildAt(i) ) );
					}
				}
			}
			
			for ( i=0; i < childs.length ; i++) 
			{
				duplicate.addChild( childs[i] );
			}
			
			return duplicate;
		}
	}	
}