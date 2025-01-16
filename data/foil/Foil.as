/**
 * foil serializer/deserializer
 * 
 * @author Richard Rodney
 * @version 0.1
 * 
 * {
 * 		type:
 * 		name:
 * 		info:
 * 
 * 	 	object :
 * 		{
 * 			string:''
 * 			array:[]
 * 			number:12
 * 			boolean:true
 * 			customObject: new customObjectName()
 * 		}
 * }
 * 
 * TODO :SERIALIZE CLASS
 * 
 */

package railk.as3.data.foil
{
	public class Foil
	{	
		
		public  static function serialize( rawData:String ):void
		{	
			Serialize.getInstance();
		}	
		
		public  static function deserialize( rawData:String ):Object
		{	
			return Deserialize.getInstance().feed( rawData );
		}	
	}
}