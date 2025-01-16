/**
 * Layout View
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.pattern.mvc.interfaces.IFacade;
	import railk.as3.ui.div.*;
	import railk.as3.ui.page.Plugins;
	import railk.as3.ui.view.UIView;
	
	public final class LayoutView implements ILayoutView
	{	
		public var div:IDiv;
		public var master:LayoutView;
		public var container:LayoutView;
		public var viewClass:Class;
		public var view:UIView;
		
		public var id:String;
		public var viewName:String;
		public var style:String;
		public var bgStyle:String;
		public var data:XML;
		public var visible:Boolean;
		
		/**
		 * CONSTRUCTEUR
		 */
		public function LayoutView( container:LayoutView, master:LayoutView, viewName:String, id:String, float:String, align:String, state:DivState, position:String, x:Number, y:Number, style:String, bgStyle:String, data:XML, constraint:String, visible:Boolean ) {
			this.container = container;
			this.master = master;
			this.viewName = viewName;
			this.data = data;
			this.id = id;
			this.style = style;
			this.bgStyle = bgStyle;
			this.visible = visible;
			div = new Div(id);
			div.init(float, align, position, constraint);
			div.state = (!state)?new DivState():state;
			div.x = x;
			div.y = y;
		}
		
		public function setup(group:String, facade:IFacade, component:*, data:*, visible:Boolean=false):void {
			Plugins.getInstance().getClass(group,viewName,run,facade,component,data,visible);	
		}
		
		private function run(facade:IFacade, component:*, data:*,visible:Boolean=false, c:Class = null):void {
			viewClass = (c)?c:UIView;
			if (!container) component.addDiv( div );
			else container.div.addDiv( div  );
			view = populate(facade.registerView(viewClass, id, div, data) as UIView);
			this.visible = (!visible)?this.visible:visible;
			view.visible = this.visible;
			if (this.visible) view.show();
		}
		
		public function populate(v:UIView):UIView { v.bgStyle = bgStyle; v.style = style; v.nameSpace = viewName.split('::')[0]; return v; }
		
		public function dispose():void { div=null; }
	}
}