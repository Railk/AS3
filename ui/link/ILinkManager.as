/**
 * PageManager
 * 
 * @author Richard Rodney
 */

package railk.as3.ui.link
{	
	public interface ILinkManager
	{	
		function addGroup(name:String, navigation:Boolean = false):ILinkManager;
		function delGroup(name:String):void;
		function add( name:String, target:Object = null, action:Function = null,  group:String = '', colors:Object = null, type:String = 'mouse', data:*= null):ILink;
		function remove( name:String ):ILinkManager;
		function getLink( name:String, group:String = '' ):ILink;
		function getLinks(group:String = ''):Array;
		function navigationChange(name:String):Boolean;	
	}
}