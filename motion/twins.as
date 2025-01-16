/**
 * Twins entry point
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.motion
{
	import railk.as3.motion.tweens.Timeline;
	public function twins(name:String):Timeline { return Timeline.get(name); }
}
