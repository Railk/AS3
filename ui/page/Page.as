/**
 * Page
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.pattern.mvc.interfaces.*
	import railk.as3.pattern.mvc.observer.Notification;
	import railk.as3.ui.div.*;
	import railk.as3.ui.layout.ILayout;
	import railk.as3.ui.loader.*;
	import railk.as3.ui.view.UIView;
	
	public class Page extends View implements IPage,IView,INotifier
	{
		private var _next:IPage;
		private var _prev:IPage;
		
		private var _id:String;
		private var _title:String;
		private var _params:Object;
		private var _routes:Array;
		private var _transition:ITransition;
		private var _layout:ILayout;
		private var _enabled:Boolean;
		
		protected var align:String;
		protected var width:String;
		protected var height:String;
		protected var transitionName:String;
		protected var length:Number=0;
		
		public function Page( MID:String, id:String, title:String, layout:ILayout, align:String, width:String, height:String, transitionName:String) {
			super(MID,id);
			_id = id;
			_title = title;
			_layout = layout;
			this.align = (align)?align:'TL';
			this.width = width;
			this.height = height;
			this.transitionName = transitionName;
			data = '<h1>' + title + '</h1>\n';
		}
		
		/**
		 * NOTIFICATION HANDLER
		 * 
		 * @param	evt
		 */
		override public function handleNotification(evt:Notification):void { }
		
		/**
		 * HANDLE ROUTE
		 * @param	route
		 */
		protected function handleRoutes(routes:Array,params:Object):void {}
		
		/**
		 * SHOW/HIDE
		 */
		override public function show():void {
			super.show();
			component = new Div(id);
			(component as Div).init('none', align).state.setWidth(width).setHeight(height);
			(facade.container as PageContainer).addDiv(component);
			Plugins.getInstance().initMonitor(_id,_layout.views.concat(),enablePage);
			setupViews(layout.views);
		}
		
		override public function hide():void {
			super.hide();
			var i:int=0, views:Array = _layout.views;
			//while(component.numChildren) component.removeChildAt(0);
			for (i = 0; i < views.length; ++i) views[i].view.hide();
			try { (facade.container as PageContainer).delDiv(component); }
			catch (e:ArgumentError){ throw e; }
			component = null;
		}
		
		/**
		 * PLAY/STOP
		 */
		public function stop():void {}
		public function play():void { handleRoutes(_routes,_params); }
		
		/**
		 * DISPOSE
		 */
		public function dispose():void { _layout = null; }
		
		/**
		 * 	PAGE SETUP
		 */
		protected function setupViews(views:Array):void {
			for (var i:int = 0; i < views.length; i++) views[i].setup(_id,facade,component,data);
			if (transitionName.charAt(transitionName.length - 1) != '.') _transition = new (getDefinitionByName(transitionName))() as ITransition;
			
		}
		
		protected function enablePage():void { (facade as PageManager).enablePage(this); }
		
		/**
		 * 	GETTER/SETTER
		 */
		public function get id():String { return _id; }
		public function get title():String { return _title; }
		public function get transition():ITransition { return _transition; }
		public function get next():IPage { return _next; }
		public function set next(value:IPage):void { _next = value; }
		public function get prev():IPage { return _prev; }
		public function set prev(value:IPage):void { _prev = value; }
		public function get params():Object { return _params; }
		public function set params(value:Object):void { _params = value; }
		public function get layout():ILayout { return _layout; }
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void { _enabled = value; }
		public function get routes():Array { return _routes; }
		public function set routes(value:Array):void { _routes = value; }
		public function get UI():IPageManager { return facade as IPageManager; }
		
		/**
		 * TO STRING
		 * @return
		 */
		public function toString():String { return '[ PAGE > '+id+ ' ]'; }
	}
}