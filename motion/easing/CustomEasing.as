package railk.as3.motion.easing 
{
	public class CustomEasing 
	{
		/**
		 * http://www.mosessupposes.com/Fuse/fuse2docs/release-notes-2.1.html#customeasingtool
		 */
		public static function precalculated(t : Number,b : Number,c : Number,d : Number, ...params : Array) : Number {
			return b + c * params[Math.round(t / d * params.length)];
		}

		/**
		 * http://www.mosessupposes.com/Fuse/fuse2docs/release-notes-2.1.html#customeasingtool
		 */
		public static function curve(t : Number,b : Number,c : Number,d : Number, ...params : Array) : Number {
			var r : Number = 200 * t / d;
			var i : Number = -1;
			var e : Object;
			
			while (params[++i].Mx <= r) e = params[i];
			
			var Px : Number = e.Px;
			var Py : Number = e.Py;
			var Nx : Number = e.Nx;
			var Ny : Number = e.Ny;
			var Mx : Number = e.Mx;
			var My : Number = e.My;
			
			var s : Number = (Px == 0) ? -(Mx - r) / Nx : (-Nx + Math.sqrt(Nx * Nx - 4 * Px * (Mx - r))) / (2 * Px);
			
			return (b - c * ((My + Ny * s + Py * s * s) / 200));
		}
	}
}