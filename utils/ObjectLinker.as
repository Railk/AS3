/**
 * Link Objects to a master one
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	public class ObjectLinker extends Proxy {
		public var master:*;
		private var linked:Array;
		
		public function ObjectLinker( master:*, ...args ) {
			this.master = master;
			linked = args;
		}
		
		flash_proxy override function callProperty(methodName:*, ...args:Array):* { 
			master[methodName].apply(null, args);
			for (var i:int = 0; i < linked.length; ++i) linked[i][methodName].apply(null, args);
		}
		
		flash_proxy override function getProperty(prop:*):* {
			return master[prop];
		}
		
		flash_proxy override function setProperty(prop:*,value:*):void {
			master[prop] = value;
			for (var i:int = 0; i < linked.length; ++i) linked[i][prop] = value;
		}		
	}
}