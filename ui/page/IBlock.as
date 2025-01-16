/**
 * PageLoading
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.page
{	
	import railk.as3.ui.layout.ILayout;
	import railk.as3.pattern.mvc.observer.Notification;
	public interface IBlock
	{	
		function handleNotification(evt:Notification):void;
		function show():void;
		function hide():void;
		function update():void;
		function castParams(params:Object):void;
		function get prev():IBlock;
		function set prev(value:IBlock):void;
		function get next():IBlock;
		function set next(value:IBlock):void;
		function get params():Object;
		function set params(value:Object):void;
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		function get id():String;
		function set id(value:String):void;
		function get layout():ILayout;
	}
}