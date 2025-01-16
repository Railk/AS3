/**
 * Typed Array
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.data.array
{
	public dynamic class TypedArray extends Array
	{
		private const dataType:Class;
		public function TypedArray(typeParam:Class, ...args) {
			dataType = typeParam;
			var n:uint = args.length
			if (n == 1 && (args[0] is Number))
			{
				var dlen:Number = args[0];
				var ulen:uint = dlen
				if (ulen != dlen) throw new RangeError("Array index is not a 32-bit unsigned integer ("+dlen+")")
				length = ulen;
			} else {
				var i:int=0
				for (i;i<n;i++) this.push(args[i])
				length = this.length;
			}
		}

		AS3 override function push(...args):uint {
			for (var i:* in args) if (!(args[i] is dataType)) args.splice(i,1);
			return (super.push.apply(this, args));
		}

		AS3 override function concat(...args):Array {
			var passArgs:TypedArray = new TypedArray(dataType);
			for (var i:* in args) passArgs.push(args[i]);
			return (super.concat.apply(this, passArgs));
		}

		 AS3 override function splice(...args):* {
			if (args.length > 2) for (var i:int=2; i< args.length; i++) if (!(args[i] is dataType)) args.splice(i,1);
			return (super.splice.apply(this, args));
		}

		AS3 override function unshift(...args):uint {
			for (var i:* in args) if (!(args[i] is dataType)) args.splice(i,1);
			return (super.unshift.apply(this, args));
		}
	}
}