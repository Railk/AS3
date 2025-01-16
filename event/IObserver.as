/**
 * Interface Observer
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.event 
{	
	interface IObserver
	{
		function update(type:int, source:IObservable, userData:*):void;
	}
}