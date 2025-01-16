/**
 * Has definition by name
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.utils
{	
	import flash.system.ApplicationDomain;
	public function hasDefinition(name:String):Boolean { return ApplicationDomain.currentDomain.hasDefinition(name); }
}