/*
Copyright (c) 2009 Drew Cummins

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
**/

package railk.as3.data.bytearray
{
	
	import __AS3__.vec.Vector;
	
	public class BitVector
	{
		
		private var vector:Vector.<uint>;
		
		public function BitVector( source:Vector.<uint> = null, numBits:uint = 128 )
		{
			if( source != null ) vector = source;
			else vector = new Vector.<uint>( numBits >>> 5, true );
		}
		
		public function setBit( bit:uint, flag:Boolean = true ) : void
		{
			if( flag ) vector[ ( bit - 1 ) >>> 5 ] |= 1 << ( bit & 31 );
			else vector[ ( bit - 1 ) >>> 5 ] &= ~( 1 << ( bit & 31 ) );
		}
		
		public function getBit( bit:uint ) : uint
		{
			return ( vector[ ( bit - 1 ) >>> 5 ] >> ( bit & 31 ) ) & 1;
		}
		
		public function OR( bitVector:BitVector ) : BitVector
		{
			
			var result:Vector.<uint>;
			var min:Vector.<uint>;
			
			if( length < bitVector.length ) 
			{
				min = vector;
				result = bitVector.vector.slice();
			}
			else 
			{
				min = bitVector.vector;
				result = vector.slice();
			}
			
			var n:int = min.length;
			
			while( --n > -1 )
			{
				result[ n ] |= min[ n ];
			}
			
			return new BitVector( result );
			
		}
		
		public function AND( bitVector:BitVector ) : BitVector
		{
			
			var result:Vector.<uint>;
			var min:Vector.<uint>;
			
			if( length < bitVector.length ) 
			{
				min = vector;
				result = bitVector.vector.slice();
			}
			else 
			{
				min = bitVector.vector;
				result = vector.slice();
			}
			
			var n:int = min.length;
			while( --n > -1 )
			{
				result[ n ] &= min[ n ];
			}
			
			return new BitVector( result );
			
		}
		
		public function flagAllOn() : void
		{
			
			const MAX:uint = uint.MAX_VALUE;
			
			var n:int = length;
			while( --n > -1 )
			{
				vector[ n ] = MAX;
			}
			
		}
		
		public function flagAllOff() : void
		{
			
			var n:int = length;
			while( --n > -1 )
			{
				vector[ n ] = 0;
			}
			
		}
		
		public function get length() : uint
		{
			return vector.length;
		}
		
		public function get bits() : uint
		{
			return vector.length >> 5;
		}
		
		public function get bytes() : uint
		{
			return vector.length >> 3;
		}
		
		public function toString() : String
		{
			
			var output:String = "";
			
			for( var i:int = 0; i < length; i++ )
			{
				
				var bytes:uint = vector[ i ];
				
				for( var j:int = 1; j <= 32; j++ )
				{
					output += ( ( bytes >>> j ) & 1 ).toString();
				}
				
				if( i < length - 1 ) output += " | ";
				
			}
			
			return output;
			
		}

	}
}