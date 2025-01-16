/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	
	public class FoilObject extends Object
	{
		private var _data:Object={};
		
		public function FoilObject( data:String )
		{
			_data = { };
		}
		
		public function get data():Object { return _data; }
	}
	
}