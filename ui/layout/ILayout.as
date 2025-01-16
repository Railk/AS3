/**
 * Layout
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import flash.utils.Dictionary;
	public interface ILayout
	{
		function getView(name:String):ILayoutView;
		function removeView(name:String):void;
		function get viewsDict():Dictionary;
		function get views():Array;
	}
}