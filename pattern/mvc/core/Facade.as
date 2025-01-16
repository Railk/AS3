/**
* 
* MVC  Facade
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.core
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.command.*;
	import railk.as3.pattern.mvc.observer.*;
	import railk.as3.pattern.multiton.Multiton;
	
	public class Facade extends EventDispatcher implements IFacade
	{
		protected var _MID:String;
		protected var _container:*;
		protected var model:IModel;
		protected var controller:IController;
		protected var views:Dictionary=new Dictionary(true);
		
		public static function getInstance(id:String):Facade {
			return Multiton.getInstance(id,Facade);
		}
		
		public function Facade(id:String) { MID = Multiton.assertSingle(id,Facade); }
		
		
		public function registerContainer(container:*):void {
			_container = container;
		}
		
		public function addChild(child:*):* { return container.addChild(child); }
		public function addChildAt(child:*,index:int):* { return container.addChildAt(child,index); }
		public function removeChild(child:*):* { return container.removeChild(child); }
		public function removeChildAt(index:int):* { return container.removeChildAt(index); }
		
		public function registerModel( modelClass:Class ):void {
			model = modelClass.getInstance.apply(null,[MID]);
		}
		
		public function registerController( controllerClass:Class ):void {
			controller = controllerClass.getInstance.apply(null,[MID]);
		}
		
		public function registerView( view:*, name:String = '', component:*= null, data:*=null ):IView {
			if (view is Class) return views[name] = new view(MID, name, component, data);
			return views[view.name] = view;
		}
		
		public function removeView( name:String ):void {
			delete views[name];
		}
		
		public function getView( name:String ):IView {
			return (views[name]!=undefined)?views[name]:null;
		}
		
		public function registerCommand(commandClass:Class, name:String=''):void { 
			controller.registerCommand(commandClass, name);
		}
		
		public function executeCommand(name:String, action:String, ...args ):void { 
			controller.executeCommand(name, action, args); 
		}
		
		public function removeCommand(name:String):void { 
			controller.removeCommand(name); 
		}
		
		public function registerProxy(proxyClass:Class,name:String=''):void { 
			model.registerProxy(proxyClass, name);
		}
		
		public function getProxy(name:String):IProxy { 
			return model.getProxy(name); 
		}
		
		public function removeProxy(name:String):void { 
			model.removeProxy(name); 
		}
		
		public function sendNotification(note:String, info:String='', data:Object=null):void {
			dispatchEvent( new Notification( note, info, data ) );
		}
		
		public function get container():* { return _container; }
		public function get MID():String { return _MID; }
		public function set MID(value:String):void { _MID = value; }
	}
}