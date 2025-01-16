/**
 * ActionScript implementation of the Secure Hash Algorithm, SHA-1, as defined
 * in FIPS PUB 180-1
 * Version 2.1a Copyright Paul Johnston 2000 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * Distributed under the BSD License
 * See http://pajhome.org.uk/crypt/md5 for details.
 * 
 * @author Richard Rodney
 * @version 0.1
 */

package railk.as3.crypto
{	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class HMACSHA1
	{
		private static var bits:uint=0;
		private static var hashSize:int=20;
		
		/**
		 * ACTION
		 */
		public static function base64(key:String, message:String):String { return Base64.encodeByteArray(compute(toArray(fromString(key)), toArray(fromString(message)))); }
		
		/**
		 * COMPUTE
		 */
		private static function compute(key:ByteArray, data:ByteArray):ByteArray {
			var hashKey:ByteArray;
			if (key.length>64) hashKey = hash(key);
			else {
				hashKey = new ByteArray;
				hashKey.writeBytes(key);
			}
			
			while (hashKey.length<64) hashKey[hashKey.length]=0;
			var innerKey:ByteArray = new ByteArray;
			var outerKey:ByteArray = new ByteArray;
			for (var i:uint=0;i<hashKey.length;i++) {
				innerKey[i] = hashKey[i] ^ 0x36;
				outerKey[i] = hashKey[i] ^ 0x5c;
			}
			
			innerKey.position = hashKey.length;
			innerKey.writeBytes(data);
			var innerHash:ByteArray = hash(innerKey);
			
			outerKey.position = hashKey.length;
			outerKey.writeBytes(innerHash);
			var outerHash:ByteArray = hash(outerKey);
			
			if (bits>0 && bits<8*outerHash.length) outerHash.length = bits/8;
			return outerHash;
		}
		
		/**
		 * CORE SHA1
		 */
		private static function core(x:Array, len:uint):Array {
		  /* append padding */
		  x[len >> 5] |= 0x80 << (24 - len % 32);
		  x[((len + 64 >> 9) << 4) + 15] = len;
		
		  var w:Array = [];
		  var a:uint =  0x67452301;
		  var b:uint = 0xEFCDAB89;
		  var c:uint = 0x98BADCFE;
		  var d:uint = 0x10325476;
		  var e:uint = 0xC3D2E1F0;
		
		  for(var i:uint = 0; i < x.length; i += 16) {
		    var olda:uint = a;
		    var oldb:uint = b;
		    var oldc:uint = c;
		    var oldd:uint = d;
		    var olde:uint = e;
		
		    for(var j:uint = 0; j < 80; j++) {
		      if (j < 16) w[j] = x[i + j] || 0;
		      else w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
		      
		      var t:uint = rol(a,5) + ft(j,b,c,d) + e + w[j] + kt(j);
		      e = d;
		      d = c;
		      c = rol(b, 30);
		      b = a;
		      a = t;
		    }
			
			a += olda;
			b += oldb;
			c += oldc;
			d += oldd;
			e += olde;
		  }
		  return [ a, b, c, d, e ];
		
		}
		
		/**
		 * HEX OPERATIONS
		 */
		private static function toArray(hex:String):ByteArray {
			hex = hex.replace(/\s|:/gm,'');
			var a:ByteArray = new ByteArray;
			if (hex.length&1==1) hex="0"+hex;
			for (var i:uint=0;i<hex.length;i+=2) a[i/2] = parseInt(hex.substr(i,2),16);
			return a;
		}
		
		private static function fromString(str:String, colons:Boolean=false):String {
			var a:ByteArray = new ByteArray;
			a.writeUTFBytes(str);
			return fromArray(a, colons);
		}
		
		public static function fromArray(array:ByteArray, colons:Boolean=false):String {
			var s:String = "";
			for (var i:uint=0;i<array.length;i++) {
				s+=("0"+array[i].toString(16)).substr(-2,2);
				if (colons) if (i<array.length-1) s+=":";
			}
			return s;
		}
		
		/**
		 * HASH
		 */
		private static function hash(src:ByteArray):ByteArray {
			var savedLength:uint = src.length;
			var savedEndian:String = src.endian;
			
			src.endian = Endian.BIG_ENDIAN;
			var len:uint = savedLength *8;
			while (src.length%4!=0) src[src.length]=0;
			src.position=0;
			var a:Array = [];
			for (var i:uint=0;i<src.length;i+=4) a.push(src.readUnsignedInt());
			
			var h:Array = core(a, len);
			var out:ByteArray = new ByteArray;
			var words:uint = hashSize/4;
			for (i=0;i<words;i++) out.writeUnsignedInt(h[i]);
			
			src.length = savedLength;
			src.endian = savedEndian;
			return out;
		}
		
		/*
		 * Bitwise rotate a 32-bit number to the left.
		 */
		private static function rol(num:uint, cnt:uint):uint {
		  return (num << cnt) | (num >>> (32 - cnt));
		}
		
		/*
		 * Perform the appropriate triplet combination function for the current
		 * iteration
		 */
		private static function ft(t:uint, b:uint, c:uint, d:uint):uint {
		  if(t < 20) return (b & c) | ((~b) & d);
		  if(t < 40) return b ^ c ^ d;
		  if(t < 60) return (b & c) | (b & d) | (c & d);
		  return b ^ c ^ d;
		}
		
		/*
		 * Determine the appropriate additive constant for the current iteration
		 */
		private static function kt(t:uint):uint {
		  return (t < 20) ? 0x5A827999 : (t < 40) ?  0x6ED9EBA1 :
		         (t < 60) ? 0x8F1BBCDC : 0xCA62C1D6;
		}
	}
}