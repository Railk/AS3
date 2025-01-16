/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	import flash.utils.getDefinitionByName;
	import flash.utils.describeType;
	import railk.as3.utils.getObjectInfo;
	
	public class FoilCustom
	{
		private var _data:*
		private var className:String;
		private var args:Array;
		private var classe:Class;
		
		public function FoilCustom( data:String )
		{	
			var dataExplode:Array;
			dataExplode = data.replace(/[ ]{0,}new[ ]{0,}/g, "").split('(');
			className = dataExplode[0];
			args = dataExplode[1].replace(/[\)]/g, "").split(',');
			
			classe = getDefinitionByName(className) as Class;
			_data = new classe();
			getObjectInfo.from( _data );
			
			for (var i:int = 0; i < args.length ; i++) 
			{
				var argName:String = args[i].split('=')[0];
				var argValue:String = args[i].split('=')[1];
				if ( getObjectInfo.hasAccessor(argName) || getObjectInfo.hasVariable(argName)  )
				{
					if( getObjectInfo.getAccessor( argName ) || getObjectInfo.getVariable( argName ) ) _data[argName] = argValue;
				}
			}
		}
		
		public function get data():* { return _data; }
	}
	
}