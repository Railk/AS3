/**
 * Page Manager
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.page
{
	import com.asual.swfaddress.*;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import railk.as3.pattern.mvc.core.*;
	import railk.as3.pattern.mvc.interfaces.*;
	import railk.as3.pattern.multiton.Multiton;
	import railk.as3.ui.div.Div;
	import railk.as3.ui.layout.ILayout;
	import railk.as3.ui.loader.*;
	import railk.as3.ui.link.*;
	import railk.as3.ui.RightClickMenu;
	import railk.as3.ui.styleSheet.ICSS;
	import railk.as3.ui.view.UIView;
	import railk.as3.utils.hasDefinition;
	import railk.as3.utils.Logger;
	
	public class PageManager extends Facade implements IPageManager
	{
		public var index:IPage;
		public var last:IPage;
		public var blocks:IBlock;
		public var current:String = '';
		public var params:Dictionary = new Dictionary(true);
		public var menu:RightClickMenu;
		public var hasMenu:Boolean;
		public var multiPage:Boolean;
		public var nameSpace:String;
		public var titre:String;
		
		private var multiPageOn:Boolean;
		private var multiPageId:String;
		private var multiPageParams:Object;
		private var multiPageRoutes:Array;
		
		private var _styleSheet:ICSS;
		private var _linkManager:ILinkManager = LinkManager.getInstance();
		private var _loadingView:IPageLoading;
		
		public static function getInstance():PageManager {
			return Multiton.getInstance('S',PageManager);
		}
		
		public function PageManager(id:String) {
			super(id);
			MID = Multiton.assertSingle(id,PageManager); 
		}
		
		public function init( titre:String, author:String, hasMenu:Boolean, multiPage:Boolean, loading:String, nameSpace:String ):void {
			this.titre = titre;
			this.hasMenu = hasMenu;
			this.multiPage = multiPage;
			this.nameSpace = nameSpace;
			menu = new RightClickMenu();
			menu.add(author, author);
			registerModel(Model);
			registerController(Controller);
			registerContainer( new PageContainer() );
			if (loading) _loadingView = new (getDefinitionByName(loading))() as IPageLoading;
		}
		
		public function initNavigation():void {
			SWFAddress.addEventListener( SWFAddressEvent.EXTERNAL_CHANGE, dispatchRoute, false, 0, true );
			SWFAddress.addEventListener( SWFAddressEvent.INTERNAL_CHANGE, dispatchRoute, false, 0, true );
			SWFAddress.addEventListener( SWFAddressEvent.UPDATE, dispatchRoute, false, 0, true );
			SWFAddress.setTitle( titre );
			_linkManager.addGroup(_MID, true);
		}
		
		private function dispatchRoute(evt:SWFAddressEvent):void {
			var value:String = evt.value.substring(1), id:String, routes:Array = [];
			if (value == '') id = 'home';
			else {
				routes = value.substring(0,value.length-1).split('/');
				id = routes.shift();
			}
			
			_linkManager.getLink(id).active = true;
			if ( !multiPageOn && multiPage ) showAll(id,routes,evt.parameters);
			else (multiPage)?goToPage(id,routes,evt.parameters):setPage(id,routes,evt.parameters);
		}
		
		public function addBlock(id:String, classe:String, layout:ILayout, align:String, width:String, height:String, onTop:Boolean, visible:Boolean):void {
			var b:Block = !hasDefinition(classe)?new Block(MID, id, layout, align,width,height, onTop, visible):new (getDefinitionByName(classe))(MID, id, layout, align,width,height, onTop, visible);
			if (!blocks) blocks = b;
			else {
				blocks.next = b;
				b.prev = blocks;
				blocks = b;
			}
			if (visible) { registerView(b); b.show(); }
			else registerView(b);
		}
		
		public function addPage(id:String, title:String, classe:String, layout:ILayout, align:String, width:String, height:String, transition:String):void {
			id = (id == 'index')?'home':id;
			if( !index) registerView( index = last = !hasDefinition(classe)?new Page(MID,id,title,layout,align,width,height,transition):new (getDefinitionByName(classe))(MID,id,title,layout,align,width,height,transition) );
			else {
				var page:IPage;
				registerView( page = !hasDefinition(classe)?new Page(MID,id,title,layout,align,width,height,transition):new (getDefinitionByName(classe))(MID,id,title,layout,align,width,height,transition));
				last.next = page; page.prev = last; last = page;
			}
			
			var action:Function = function(type:String,data:LinkData):void {
				switch(type) {
					case 'do': setValue('/'+id+'/',true); break;
					default : break;
				}
			}
			menu.add(id, '-> '+title, setValue, ['/'+id+'/',true], ((id == 'home')?true:false) );
			_linkManager.add(id, null, action, _MID);
		}
		
		/**
		 * MULTIPAGE NAV
		 */
		private function showAll(id:String,routes:Array=null,params:Object=null):void {
			multiPageOn = true;
			multiPageId = id;
			multiPageParams = params;
			multiPageRoutes= routes;
			index.show();
		}
		
		private function showNext(page:IPage):void {
			if (page.next != null) page.next.show();
			else goToPage(multiPageId,multiPageRoutes,multiPageParams);
		}
		
		private function goToPage(id:String,routes:Array=null,params:Object=null):void {
			var change:String  = changePage(id,params);
			if (!change) return; 
			if (current) getPage(current).stop();
			var page:IPage = getPage(id);
			page.params = params;
			page.routes = routes;
			if (change == 'id') (container as PageContainer).goTo(id, page.transition.easeInOut, page.play );
			else page.play();
			current = id;
			params[current] = params;
			if (blocks) updateBlocks();
		}
		
		/**
		 * SINGLE PAGE NAV
		 */
		public function getPage(id:String):IPage { return getView(id) as IPage; }
		
		private function setPage(id:String,routes:Array=null,params:Object=null ):void {
			var change:String  = changePage(id, params);
			if (current) unsetPage(current);
			current = id;
			var page:IPage = getPage(id);
			page.params = params;
			page.routes = routes;
			page.show();
			if (page.transition && change == 'id') page.transition.easeIn((page as IView).component );
			params[current] = params;
			if (blocks) updateBlocks();
		}
		
		private function unsetPage( id:String ):void {
			var page:IPage = getPage(id);
			page.stop();
			if (!page.enabled) return;
			if (page.transition) page.transition.easeOut((page as IView).component, page.hide );
			else page.hide();
		}
		
		/**
		 * UI VIEWS
		 */
		public function getUIView(name:String):UIView { return getView(name) as UIView; }
		
		/**
		 * NAV UTILITIES
		 */
		private function changePage(id:String, params:Object=null):String {
			if (current != id) return 'id';
			if (current == id && params[current] != params) return 'params';
			return '';
		}
		
		public function enablePage(page:IPage):void {
			if (page.id != current) return;
			page.enabled = true;
			if (multiPage) showNext(page);
			else page.play();
		}
		
		private function updateBlocks():void {
			var s:IBlock = blocks;
			while (s) { 
				if (s.visible) s.update();
				s = s.prev;
			}
		}
		
		/**
		 * SWFADRESS UTILITIES
		 */
		public function forward():void { SWFAddress.forward(); } 
		public function back():void { SWFAddress.back(); }
		public function blanc(url:String):void { SWFAddress.href(url, '_blanc'); }
		public function getValue():String { return SWFAddress.getValue(); }
		public function setValue(value:String, update:Boolean = false):IPageManager { SWFAddress.setValue(value, update); return this; }
		public function setData(value:Object):IPageManager { SWFAddress.setData(value); return this; }
		private function replace(str:String, find:String, replace:String):String { return str.split(find).join(replace); }	
		private function toTitleCase(str:String):String { return str.substr(0,1).toUpperCase() + str.substr(1); }
		private function formatTitle(title:String):String { return titre+' '+ (title != '/' ? ' / ' + toTitleCase(replace(title.substr(1, title.length - 2), '/', ' / ')) : ''); }
		private function updateTitle(title:String):void {
			if (title.charAt(title.length - 1) != '/') title += '/';
			SWFAddress.setTitle(formatTitle(title));
		}
		
		/**
		 * GETTER/SETTER
		 */
		public function set styleSheet(value:ICSS):void { _styleSheet = value; }
		public function get styleSheet():ICSS { return _styleSheet; }
		public function get linkManager():ILinkManager { return _linkManager; }
		public function get loadingView():IPageLoading { return _loadingView; }
	}
}