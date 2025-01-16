/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	
	public class FoilBoolean
	{
		private var _data:Boolean;
		
		public function FoilBoolean( data:String )
		{
			_data = data as Boolean;
		}
		
		public function get data():Boolean { return _data; }
	}
	
}