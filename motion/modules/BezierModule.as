/**
 * Numeric tweening along a Bezier curve
 * @author Philippe / http://philippe.elsass.me
 */

package railk.as3.motion.modules 
{
	import railk.as3.motion.utils.*;
	public class BezierModule
	{	
		static public function update(target:Object, props:Prop, ratio:Number ):Prop
		{
			var segment:Seg, segments:Array = props.start, last:int = length - 1;
			if (ratio >= 1) target[props.prop] = segments[last].p + segments[last].d2;
			else if (segments.length == 1) target[props.prop] = segments[0].calc(ratio);
			else{
				var index:int = (ratio*segments.length)>>0;
				if (index < 0) index = 0;
				else if (index > last) index = last;
				segment = segments[index];
				ratio = length * (ratio - index / length);
				target[props.prop] = segment.calc(ratio);
			}
			return props;
		}
		
		static public function init(b:Number, e:Array):Array {
			var through:Boolean = false, segments:Array=[];
			if (e[0] is Array) { through = true; e = e[0]; }
			e.unshift(b);
			
			var p:Number, p1:Number, p2:Number = e[0], last:int = e.length-1, i:int = 1, auto:Number = NaN;
			while (i<last) {
				p = p2;
				p1 = e[i];
				p2 = e[++i];
				if (through) {
					if (!segments.length) { auto = (p2-p)/4; segments[segments.length] = new Seg(p,p1-auto,p1);}
					segments[segments.length] = new Seg(p1,p1+auto,p2);
					auto = p2-(p1+auto);
				} else {
					if (i!=last) p2=(p1+p2)/2;
					segments[segments.length] = new Seg(p,p1,p2);
				}
			}
			return segments;
		}
	}
}