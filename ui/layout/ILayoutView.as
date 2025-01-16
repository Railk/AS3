/**
 * Layout View
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.layout
{
	import railk.as3.pattern.mvc.interfaces.IFacade;
	import railk.as3.ui.view.UIView;
	public interface ILayoutView
	{	
		function setup(group:String,facade:IFacade, component:*, data:*,visible:Boolean=false):void;
		function populate(v:UIView):UIView;
		function dispose():void;
	}
}