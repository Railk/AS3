/**
 * UI VIEW
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.view
{	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.observer.Notification;
	import railk.as3.pattern.mvc.interfaces.IView;
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.ui.div.IDiv;
	import railk.as3.ui.Localisation;
	import railk.as3.ui.page.IPageManager;
	import railk.as3.utils.hasDefinition;
	import railk.as3.display.graphicShape.RectangleShape;
	
	public class UIView extends View implements IView
	{
		public var visible:Boolean;
		protected var _bgStyle:String;
		protected var _style:String;
		protected var _nameSpace:String;
		protected var local:Localisation = Localisation.getInstance();
		protected var UI:IPageManager;
		protected var background:RectangleShape = new RectangleShape();
		
		public function UIView( MID:String, name:String='',component:*=null, data:*=null ) {
			super(MID, name, component, data);
			local.addEventListener(Event.CHANGE, localisation, false, 0, true);
			UI = facade as IPageManager;
		}
		
		/**
		 * SHOW
		 */
		override public function show():void {
			super.show();
			visible = true;
			if (_bgStyle) {
				UI.styleSheet.applyStyle(background, _bgStyle);
				container.addChild( background );
			}
		}
		
		override public function hide():void {
			super.hide();
			visible = false;
		}
		
		/**
		 * GET CLASS
		 */
		public function classe(name:String):Class {
			name = name.charAt() + name.substring(1);
			return hasDefinition(name)?(getDefinitionByName(name) as Class):null; 
		}
		
		/**
		 * PLAY
		 */
		public function play(data:*= null):void {
			if(!facade.hasEventListener(Notification.NOTE)) facade.addEventListener(Notification.NOTE, handleNotification );
		}
		
		/**
		 * STOP
		 */
		public function stop():void {
			facade.removeEventListener(Notification.NOTE, handleNotification );
		}
		
		/**
		 * LOCALISE
		 * @param	e
		 */
		protected function localisation(e:Event):void {}
		
		
		/**
		 * GETTER/SETTER
		 */
		public function get nameSpace():String { return _nameSpace; } 
		public function set nameSpace(value:String):void { _nameSpace = value; } 
		public function get style():String { return _style; }
		public function set style(value:String):void { _style = value; }
		public function get bgStyle():String { return _bgStyle; }
		public function set bgStyle(value:String):void { _bgStyle = value; }
		public function get container():IDiv { return _component as IDiv; }
		public function set container(value:IDiv):void { _component = value; }
		public function get stage():Stage { return _component.stage as Stage }
	}
}