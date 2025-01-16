/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{
	
	public class FoilNumber
	{
		private var _data:Number;
		
		public function FoilNumber( data:String )
		{
			_data = Number(data);
		}
		
		public function get data():Number { return _data; }
	}
	
}