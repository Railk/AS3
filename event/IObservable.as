/**
 * Interface Observable
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.event 
{	
	interface IObservable
	{
		function attach(o:IObserver, mask:int = 0):void;
		function detach(o:IObserver, mask:int = 0):void;
		function notify(type:int, userData:* = null):void;
	}
}