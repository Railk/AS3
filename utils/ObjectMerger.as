/**
* Object Merger
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils {
	public class ObjectMerger {
		public static function merge( ...os ):Object {
			var result:Object={}, i:int=0, o:Object;
			for (;i<os.length;i++) for( o in os[i]) result[o] = os[i][o];
			return result;
		}
	}
}	