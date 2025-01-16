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
	public class MD5 
	{
		public static var hexcase:uint = 0;
		
		public static function encrypt (string:String):String {
			return hex_md5 (string);
		}
		
		/*
		 * These are the functions you'll usually want to call
		 * They take string arguments and return either hex or base-64 encoded strings
		 */
		public static function hex_md5 (string:String):String {
			return rstr2hex (rstr_md5 (str2rstr_utf8 (string)));
		}
		
		/*
		 * Calculate the MD5 of a raw string
		 */
		public static function rstr_md5 (string:String):String {
		  return binl2rstr (binl_md5 (rstr2binl (string), string.length * 8));
		}
		
		
		/*
		 * Convert a raw string to a hex string
		 */
		public static function rstr2hex (input:String):String {
		  var hex_tab:String = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
		  var output:String = "";
		  var x:Number;
		  for(var i:Number = 0; i < input.length; i++) {
		  	x = input.charCodeAt(i);
		    output += hex_tab.charAt((x >>> 4) & 0x0F)
		           +  hex_tab.charAt( x        & 0x0F);
		  }
		  return output;
		}
		
		/*
		 * Encode a string as utf-8.
		 * For efficiency, this assumes the input is valid utf-16.
		 */
		public static function str2rstr_utf8 (input:String):String {
		  var output:String = "";
		  var i:Number = -1;
		  var x:Number, y:Number;
		
		  while(++i < input.length) {
		    /* Decode utf-16 surrogate pairs */
		    x = input.charCodeAt(i);
		    y = i + 1 < input.length ? input.charCodeAt(i + 1) : 0;
		    if(0xD800 <= x && x <= 0xDBFF && 0xDC00 <= y && y <= 0xDFFF) {
		      x = 0x10000 + ((x & 0x03FF) << 10) + (y & 0x03FF);
		      i++;
		    }
		
		    /* Encode output as utf-8 */
		    if(x <= 0x7F)
		      output += String.fromCharCode(x);
		    else if(x <= 0x7FF)
		      output += String.fromCharCode(0xC0 | ((x >>> 6 ) & 0x1F),
		                                    0x80 | ( x         & 0x3F));
		    else if(x <= 0xFFFF)
		      output += String.fromCharCode(0xE0 | ((x >>> 12) & 0x0F),
		                                    0x80 | ((x >>> 6 ) & 0x3F),
		                                    0x80 | ( x         & 0x3F));
		    else if(x <= 0x1FFFFF)
		      output += String.fromCharCode(0xF0 | ((x >>> 18) & 0x07),
		                                    0x80 | ((x >>> 12) & 0x3F),
		                                    0x80 | ((x >>> 6 ) & 0x3F),
		                                    0x80 | ( x         & 0x3F));
		  }
		  return output;
		}
		
		
		/*
		 * Convert a raw string to an array of little-endian words
		 * Characters >255 have their high-byte silently ignored.
		 */
		public static function rstr2binl (input:String):Array {
		  var output:Array = Array(input.length >> 2);
		  for(var i:Number = 0; i < output.length; i++)
		    output[i] = 0;
		  for(var i:Number = 0; i < input.length * 8; i += 8)
		    output[i>>5] |= (input.charCodeAt(i / 8) & 0xFF) << (i%32);
		  return output;
		}
		
		/*
		 * Convert an array of little-endian words to a string
		 */
		public static function binl2rstr (input:Array):String {
		  var output:String = "";
		  for(var i:Number = 0; i < input.length * 32; i += 8)
		    output += String.fromCharCode((input[i>>5] >>> (i % 32)) & 0xFF);
		  return output;
		}
		
		/*
		 * Calculate the MD5 of an array of little-endian words, and a bit length.
		 */
		public static function binl_md5 (x:Array, len:Number):Array {
		    /* append padding */
			x[len >> 5] |= 0x80 << ((len) % 32);
			x[(((len + 64) >>> 9) << 4) + 14] = len;

			var a:uint = 0x67452301; // 1732584193;
			var b:uint = 0xEFCDAB89; //-271733879;
			var c:uint = 0x98BADCFE; //-1732584194;
			var d:uint = 0x10325476; // 271733878;

			for(var i:uint = 0; i < x.length; i += 16)
			{
			x[i]||=0;    x[i+1]||=0;  x[i+2]||=0;  x[i+3]||=0;
			x[i+4]||=0;  x[i+5]||=0;  x[i+6]||=0;  x[i+7]||=0;
			x[i+8]||=0;  x[i+9]||=0;  x[i+10]||=0; x[i+11]||=0;
			x[i+12]||=0; x[i+13]||=0; x[i+14]||=0; x[i+15]||=0;

			var olda:uint = a;
			var oldb:uint = b;
			var oldc:uint = c;
			var oldd:uint = d;

			a = ff(a, b, c, d, x[i+ 0], 7 , 0xD76AA478);
			d = ff(d, a, b, c, x[i+ 1], 12, 0xE8C7B756);
			c = ff(c, d, a, b, x[i+ 2], 17, 0x242070DB);
			b = ff(b, c, d, a, x[i+ 3], 22, 0xC1BDCEEE);
			a = ff(a, b, c, d, x[i+ 4], 7 , 0xF57C0FAF);
			d = ff(d, a, b, c, x[i+ 5], 12, 0x4787C62A);
			c = ff(c, d, a, b, x[i+ 6], 17, 0xA8304613);
			b = ff(b, c, d, a, x[i+ 7], 22, 0xFD469501);
			a = ff(a, b, c, d, x[i+ 8], 7 , 0x698098D8);
			d = ff(d, a, b, c, x[i+ 9], 12, 0x8B44F7AF);
			c = ff(c, d, a, b, x[i+10], 17, 0xFFFF5BB1);
			b = ff(b, c, d, a, x[i+11], 22, 0x895CD7BE);
			a = ff(a, b, c, d, x[i+12], 7 , 0x6B901122);
			d = ff(d, a, b, c, x[i+13], 12, 0xFD987193);
			c = ff(c, d, a, b, x[i+14], 17, 0xA679438E);
			b = ff(b, c, d, a, x[i+15], 22, 0x49B40821);

			a = gg(a, b, c, d, x[i+ 1], 5 , 0xf61e2562);
			d = gg(d, a, b, c, x[i+ 6], 9 , 0xc040b340);
			c = gg(c, d, a, b, x[i+11], 14, 0x265e5a51);
			b = gg(b, c, d, a, x[i+ 0], 20, 0xe9b6c7aa);
			a = gg(a, b, c, d, x[i+ 5], 5 , 0xd62f105d);
			d = gg(d, a, b, c, x[i+10], 9 ,  0x2441453);
			c = gg(c, d, a, b, x[i+15], 14, 0xd8a1e681);
			b = gg(b, c, d, a, x[i+ 4], 20, 0xe7d3fbc8);
			a = gg(a, b, c, d, x[i+ 9], 5 , 0x21e1cde6);
			d = gg(d, a, b, c, x[i+14], 9 , 0xc33707d6);
			c = gg(c, d, a, b, x[i+ 3], 14, 0xf4d50d87);
			b = gg(b, c, d, a, x[i+ 8], 20, 0x455a14ed);
			a = gg(a, b, c, d, x[i+13], 5 , 0xa9e3e905);
			d = gg(d, a, b, c, x[i+ 2], 9 , 0xfcefa3f8);
			c = gg(c, d, a, b, x[i+ 7], 14, 0x676f02d9);
			b = gg(b, c, d, a, x[i+12], 20, 0x8d2a4c8a);

			a = hh(a, b, c, d, x[i+ 5], 4 , 0xfffa3942);
			d = hh(d, a, b, c, x[i+ 8], 11, 0x8771f681);
			c = hh(c, d, a, b, x[i+11], 16, 0x6d9d6122);
			b = hh(b, c, d, a, x[i+14], 23, 0xfde5380c);
			a = hh(a, b, c, d, x[i+ 1], 4 , 0xa4beea44);
			d = hh(d, a, b, c, x[i+ 4], 11, 0x4bdecfa9);
			c = hh(c, d, a, b, x[i+ 7], 16, 0xf6bb4b60);
			b = hh(b, c, d, a, x[i+10], 23, 0xbebfbc70);
			a = hh(a, b, c, d, x[i+13], 4 , 0x289b7ec6);
			d = hh(d, a, b, c, x[i+ 0], 11, 0xeaa127fa);
			c = hh(c, d, a, b, x[i+ 3], 16, 0xd4ef3085);
			b = hh(b, c, d, a, x[i+ 6], 23,  0x4881d05);
			a = hh(a, b, c, d, x[i+ 9], 4 , 0xd9d4d039);
			d = hh(d, a, b, c, x[i+12], 11, 0xe6db99e5);
			c = hh(c, d, a, b, x[i+15], 16, 0x1fa27cf8);
			b = hh(b, c, d, a, x[i+ 2], 23, 0xc4ac5665);

			a = ii(a, b, c, d, x[i+ 0], 6 , 0xf4292244);
			d = ii(d, a, b, c, x[i+ 7], 10, 0x432aff97);
			c = ii(c, d, a, b, x[i+14], 15, 0xab9423a7);
			b = ii(b, c, d, a, x[i+ 5], 21, 0xfc93a039);
			a = ii(a, b, c, d, x[i+12], 6 , 0x655b59c3);
			d = ii(d, a, b, c, x[i+ 3], 10, 0x8f0ccc92);
			c = ii(c, d, a, b, x[i+10], 15, 0xffeff47d);
			b = ii(b, c, d, a, x[i+ 1], 21, 0x85845dd1);
			a = ii(a, b, c, d, x[i+ 8], 6 , 0x6fa87e4f);
			d = ii(d, a, b, c, x[i+15], 10, 0xfe2ce6e0);
			c = ii(c, d, a, b, x[i+ 6], 15, 0xa3014314);
			b = ii(b, c, d, a, x[i+13], 21, 0x4e0811a1);
			a = ii(a, b, c, d, x[i+ 4], 6 , 0xf7537e82);
			d = ii(d, a, b, c, x[i+11], 10, 0xbd3af235);
			c = ii(c, d, a, b, x[i+ 2], 15, 0x2ad7d2bb);
			b = ii(b, c, d, a, x[i+ 9], 21, 0xeb86d391);

			a += olda;
			b += oldb;
			c += oldc;
			d += oldd;

			}
			return [ a, b, c, d ];
		}
		
		/*
		 * Bitwise rotate a 32-bit number to the left.
		 */
		private function rol(num:uint, cnt:uint):uint {
		  return (num << cnt) | (num >>> (32 - cnt));
		}

		/*
		 * These functions implement the four basic operations the algorithm uses.
		 */
		private function cmn(q:uint, a:uint, b:uint, x:uint, s:uint, t:uint):uint {
			return rol(a + q + x + t, s) + b;
		}
		private function ff(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, t:uint):uint {
			return cmn((b & c) | ((~b) & d), a, b, x, s, t);
		}
		private function gg(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, t:uint):uint {
			return cmn((b & d) | (c & (~d)), a, b, x, s, t);
		}
		private function hh(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, t:uint):uint {
			return cmn(b ^ c ^ d, a, b, x, s, t);
		}
		private function ii(a:uint, b:uint, c:uint, d:uint, x:uint, s:uint, t:uint):uint {
			return cmn(c ^ (b | (~d)), a, b, x, s, t);
		}
	}
}