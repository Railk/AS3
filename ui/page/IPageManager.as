/**
 * PageManager
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.page
{	
	import railk.as3.pattern.mvc.interfaces.IFacade;
	import railk.as3.ui.layout.ILayout;
	import railk.as3.ui.link.ILinkManager;
	import railk.as3.ui.styleSheet.ICSS;
	import railk.as3.ui.view.UIView;
	public interface IPageManager extends IFacade
	{	
		function init( titre:String, author:String, hasMenu:Boolean, multiPage:Boolean, loading:String, nameSpace:String ):void;
		function initNavigation():void;
		function addBlock(id:String, classe:String, layout:ILayout, align:String, width:String, height:String, onTop:Boolean, visible:Boolean):void;
		function addPage(id:String, title:String, classe:String, layout:ILayout, align:String, width:String, height:String, transition:String):void;
		function getPage( id:String ):IPage;
		function enablePage(page:IPage):void;
		function getUIView( name:String ):UIView;
		function forward():void;
		function back():void;
		function blanc(url:String):void;
		function getValue():String;
		function setValue(value:String,update:Boolean=false):IPageManager;
		function setData(value:Object):IPageManager;
		function set styleSheet(value:ICSS):void;
		function get styleSheet():ICSS;
		function get linkManager():ILinkManager;
		function get loadingView():IPageLoading;
	}
}