/**
 * PageLoading
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.page
{	
	import com.asual.swfaddress.SWFAddressEvent;
	import railk.as3.ui.layout.ILayout;
	import railk.as3.pattern.mvc.observer.Notification;
	public interface IPage
	{	
		function handleNotification(evt:Notification):void;
		function show():void;
		function hide():void;
		function play():void;
		function stop():void;
		function dispose():void;
		function get id():String;
		function get title():String;
		function get transition():ITransition;
		function get next():IPage;
		function set next(value:IPage):void;
		function get prev():IPage;
		function set prev(value:IPage):void;
		function get params():Object;
		function set params(value:Object):void;
		function get routes():Array;
		function set routes(value:Array):void;
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		function get layout():ILayout;
		function get UI():IPageManager;
		function toString():String;
	}
}