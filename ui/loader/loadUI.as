/**
 * UIloader
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.ui.loader
{	
	/**
	 * 
	 * @param	url 	either a STRING or ARRAY
	 * @param	noCache
	 * @return
	 */
	public function loadUI(url:*, noCache:Boolean=false):UILoader { return new UILoader(url, noCache); }
}