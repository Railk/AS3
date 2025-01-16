/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.foil
{	
	public class FoilString
	{
		private var _data:String;
		
		public function FoilString( data:String )
		{
			_data = data.replace(/['|"]/g, "" );
		}
		
		public function get data():String { return _data; }
	}
	
}