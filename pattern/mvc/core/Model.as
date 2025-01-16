/**
* 
* MVC  Model
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import flash.utils.Dictionary;
	import railk.as3.pattern.mvc.interfaces.IModel;
	import railk.as3.pattern.mvc.interfaces.IProxy;
	import railk.as3.pattern.multiton.Multiton;
		
	public class Model implements IModel
	{
		protected var MID:String;
		protected var proxys:Dictionary = new Dictionary(true);
		
		public static function getInstance(id:String):Model {
			return Multiton.getInstance(id,Model);
		}
		
		public function Model(id:String) { 
			MID = Multiton.assertSingle(id,Model);
		}
		
		public function registerProxy( proxyClass:Class, name:String='' ):void {
			proxys[name] = new proxyClass(MID,name);
		}

		public function removeProxy( name:String ):void {
			delete proxys[name];
		}
		
		public function getProxy( name:String ):IProxy {
			return (proxys[name]!=undefined)?proxys[name]:null;
		}
		
		public function hasProxy( name:String ):Boolean {
			return (proxys[name]!=undefined)?true:false;
		}
	}
}