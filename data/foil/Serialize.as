/**
 * Serialize
 * 
 * @author Richard Rodney
 * @version 0.1
 */


package railk.as3.data.foil
{
	import railk.as3.pattern.singleton.Singleton;
	
	public class Serialize
	{
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 GET INSTANCE
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public static function getInstance():Serialize 
		{
			return Singleton.getInstance(Serialize);
		}
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						 	SINGLETON
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function Serialize() { Singleton.assertSingle(Serialize); }
		
	}
}	