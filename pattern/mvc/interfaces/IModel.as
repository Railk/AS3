/**
* 
* MVC Imodel
* 
* @author Richard Rodney
* @version 0.1
*/

package railk.as3.pattern.mvc.interfaces
{
	public interface IModel
	{
		function registerProxy( proxyClass:Class, name:String='' ):void;
		function removeProxy( name:String ):void;
		function getProxy( name:String ):IProxy;
		function hasProxy( name:String ):Boolean;
	}
}