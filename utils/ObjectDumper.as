/**
* Object Dumper for amf object parsing
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.utils {
	public class ObjectDumper {
		public static function dump( o:Object ):String {
			return toString( o )+'\n';
		}
		
		private static function toString( o:Object ):String
		{
			var result:String = '';
			for ( var name:String in o ) 
			{
				result += '[' + name +' => ';
				result += (o[name].toString() == '[object Object]')?toString(o[name]):o[name].toString();
				result += ' ] ';
			}
			if ( !result ) result = '[ empty ]';
			return result;
		}
	}
}