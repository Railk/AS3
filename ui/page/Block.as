/**
 * Block
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{	
	import railk.as3.pattern.mvc.core.View;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.mvc.observer.Notification;
	import railk.as3.ui.div.Div;
	import railk.as3.ui.layout.ILayout;
	
	public class Block extends View implements IBlock,IView,INotifier
	{
		protected var _prev:IBlock;
		protected var _next:IBlock;
		protected var _visible:Boolean;
		protected var _params:Object;
		protected var _id:String;
		protected var _layout:ILayout;
		
		protected var align:String;
		protected var width:String;
		protected var height:String;
		protected var onTop:Boolean;
		protected var css:String;
		
		public function Block( MID:String, id:String, layout:ILayout, align:String, width:String, height:String, onTop:Boolean, visible:Boolean ) {
			super(MID, id);
			_id = id;
			_layout = layout;
			_visible = visible;
			this.align = align;
			this.width = width;
			this.height = height;
			this.onTop = onTop;
			this.component = new Div(id)
			this.component.init('none',align);
			component.width = width;
			component.height = height;
		}
		
		/**
		 * NOTIFICATION HANDLER
		 * 
		 * @param	evt
		 */
		override public function handleNotification(evt:Notification):void {
			switch(evt.note) {
				case 'zoom': zoom(); break;
				case 'dezoom': dezoom(); break;
				case 'adapt': adapt(); break;
				default : break;
			}
		}
		
		/**
		 * 	SHOW/HIDE/UPDATE
		 */
		override public function show():void {
			(facade.container as PageContainer).addBlock(component, onTop);
			Plugins.getInstance().initMonitor(_id,_layout.views.concat(), enablePage);
			setupViews(_layout.views);
		}
		
		override public function hide():void {
			for (var i:int = 0; i < component.numChildren; i++) component.removeChildAt(i);
			(facade.container as PageContainer).delBlock(component);
			component = new Div(id);
			component.init('none', align)
			component.width = width;
			component.height = height;
		}
		
		protected function enablePage():void { 
			if (_params) castParams(_params); 
		}
		
		public function update():void { }
		
		/**
		 * ZOOM/DEZOOM
		 */
		public function zoom():void {}
		public function dezoom():void {}
		public function adapt():void {}
		public function castParams(params:Object):void {}
		
		/**
		 * 	UTILITIES
		 */		
		protected function setupViews(views:Array):void {
			for (var i:int = 0; i < views.length; i++) views[i].setup(_id,facade,component,data,true);
		}
		
		/**
		 * 	GETTER/SETTERS
		 */	
		public function get prev():IBlock { return _prev; }
		public function set prev(value:IBlock):void { _prev = value; }
		public function get next():IBlock { return _next; }
		public function set next(value:IBlock):void { _next = value; }
		public function get params():Object { return _params; }
		public function set params(value:Object):void { _params = value; }
		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void { _visible = value; }
		public function get id():String { return _id; }
		public function set id(value:String):void { _id = value; }
		public function get layout():ILayout { return _layout; }
	}
}