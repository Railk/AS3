/**
 * 
 * Proxy pattern data
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.pattern.mvc.proxy
{
	public class Data 
	{
		public var prev:Data;
		public var name:String;
		public var info:String;
		public var data:*;
		
		public function Data(name:String, data:*, info:String="" ) {
			this.name = name;
			this.data = data;
			this.info = info;
		}
	}
}