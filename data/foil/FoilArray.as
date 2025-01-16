/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	
	public class FoilArray
	{
		private var _data:Array = [];
		
		public function FoilArray( data:String )
		{
			_data = data.replace(/[\[\]]/g, "").split(',');
			for (var i:int = 0; i < _data.length; i++) 
			{
				var firstChar:String = _data[i].charAt(0);
				if ( firstChar == "'" || firstChar == "\"" ) _data[i] = _data[i].replace(/["|']/g, "");
				else if ( _data[i].search(/true|false/) != -1 ) _data[i] = Boolean(_data[i]);
				else if ( _data[i].match(/[\d]/g) != 0  ) _data[i] = Number(_data[i]);
			}
		}
		
		public function get data():Array { return _data; }
	}
	
}