/**
* 
* Abstract Proxy
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.proxy
{
	import railk.as3.pattern.mvc.core.*;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.observer.Notifier;
	
	public class Proxy extends Notifier implements IProxy,INotifier 
	{
		protected var _name:String = 'undefined';
		protected var datas:Data;
		
		public function Proxy(MID:String, name:String = '') {
			this.MID = MID;
			if(name) _name = name;
		}
		
		public function getAsyncData( name:String, options:*=null ):void {
			var walker:Data = datas, found:Boolean;
			while (walker) {
				if (walker.name == name) { sendData(name, walker.info, walker.data); found = true; break; }
				walker = walker.prev;
			}
			if(!found) request(name,options);
		}
		
		public function sendData(name:String,info:String,data:*):void { sendNotification(name, info, data); }
		
		/**
		 * TO OVERRIDE TO REQUEST DATA
		 * 
		 * @param	name
		 */
		protected function request( name:String,options:* ):void {}
		
		protected function addData(name:String, data:*, info:String=""):void {
			var d:Data = new Data(name, data, info);
			if (!datas) datas = d;
			else {
				d.prev = datas;
				datas = d;
			}
		}
		
		public function getData(name:String):* {
			var walker:Data = datas;
			while (walker) {
				if (walker.name == name) return walker.data;
				walker = walker.prev;
			}
			return null;
		}
		
		public function removeData( name:String ):void {
			var walker:Data = datas, previous:Data;
			while (walker ) {
				if (walker.name == name) {
					if (previous) previous.prev = walker.prev;
					else datas = walker.prev;
					walker.data = null;
				}
				previous = walker;
				walker = walker.prev;
			}
		}
		
		public function clearData():void {
			var walker:Data = datas;
			datas = null;
			while (walker) {
				walker.data = null;
				walker = walker.prev;
			}
			walker = null;
		}
		
		public function dispose():void { clearData(); }
		
		public function get name():String { return _name; }
	}
}