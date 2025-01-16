/**
* 
* Matrix transformation utility
* 
* @author Richard Rodney
* @version 0.2
*/

package railk.as3.transform.matrix
{
	// _________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

    public class TransformMatrix
	{
		// ________________________________________________________________________________________ VARIABLES
		private var target:*;
		private var bounds:Rectangle;
		private var t:Transform;
		private var oX:Number;
		private var oY:Number;
		private var tWidth:Number;
		private var tHeight:Number;
		
		private var o:Matrix;
		private var w:Matrix;
		
		private var wX:Number;
		private var wY:Number;
		private var clone:Matrix;
		private var angle:Number = 0;
		private var A:Point;
		private var B:Point;
		
		private var states:States = new States();
		private var transformations:OriginTransformations = new OriginTransformations();
		private var matrices:Matrices = new Matrices();
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																								  INIT
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function TransformMatrix(target:*)
		{
			this.target = target;
			t = new Transform(target);
			o = target.transform.matrix;
			w =  new Matrix();
			
			wX = wY = 0; 
			oX = target.x;
			oY = target.y;
			tWidth = target.width;
			tHeight = target.height;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																						   TRANSFORMER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		/*
		 * scaleX 
		 */
		public function scaleX( dist:Number, x:Number, y:Number, constraint:String, corner:Boolean=false ):void
		{
			matrices.finale.scaleX.identity();
			if ( constraint == 'L')
			{
				matrices.working.scaleX.a = states.last.matrix.a + (dist/tWidth);
				transformations.scaleX.define( function(dist) {  return x }, function(dist){ return y} );
			}
			else {
				matrices.working.scaleX.a = states.last.matrix.a - (dist / tWidth);
				transformations.scaleX.define( function(dist) { return (corner)?wX:oX }, function(dist) {  return (corner)?wY:oY } );
			}
			Distances.scaleX += dist;
			transformations.current = (corner)? 'scaleXY':'scaleX';
			transform();
		}
		
		/*
		 * scaleY 
		 */
		public function scaleY( dist:Number, x:Number, y:Number, constraint:String, corner:Boolean=false ):void
		{
			matrices.finale.scaleY.identity();
			if ( constraint == 'T')
			{
				matrices.working.scaleY.d = states.last.matrix.d + (dist/tHeight);
				transformations.scaleY.define(  function(dist) { return x }, function(dist) { return y } );
			}
			else {
				matrices.working.scaleY.d = states.last.matrix.d -(dist / tHeight);
				transformations.scaleY.define( function(dist) { return (corner)?wX:oX }, function(dist) { return (corner)?wY:oY } );
			}
			Distances.scaleY += dist;
			transformations.current = (corner)? 'scaleXY':'scaleY';
			transform();
		}
		
		/*
		 * scaleXY 
		 */
		public function scaleXY( dx:Number, dy:Number, x:Number, y:Number, constraint:String ):void
		{
			switch( constraint )
			{
				case 'TL':
					scaleX( dx, x, y, 'L', false);
					scaleY( dy, x, y, 'T', false);
					break;
				
				case 'BL':
					scaleX( dx, x, y, 'L', true);
					scaleY( dy, x, y, 'B', true);
					break;
				
				case 'TR':
					scaleX( dx, x, y, 'R', true);
					scaleY( dy, x, y, 'T', true);
					break;
					
				case 'BR':
					scaleX( dx, x, y, 'R', true);
					scaleY( dy, x, y, 'B', true);
					break;
					
				default : break;
			}
		}
		
		/*
		 * skewX 
		 */
		public function skewX( dx:Number, dy:Number, constraint:String ):void
		{
			matrices.finale.skewX.identity();
			var dist:Number = 0;
			if ( constraint == 'SKEW_UP' )
			{
				matrices.working.skewX.c = states.last.matrix.c - (dist / tHeight);
				matrices.working.skewY.b = states.last.matrix.b;
				transformations.skewX.define( function(dist) { return wX + Math.cos(angle) * dist; }, function(dist) { return wY + Math.sin(angle) * dist; } );
			}
			else
			{
				matrices.working.skewX.c = states.last.matrix.c + (dist / tHeight);
				matrices.working.skewY.b = states.last.matrix.b;
				transformations.skewX.define( function(dist){ return oX }, function(dist){ return oY } );
			}
			Distances.skewX += dist;
			transformations.current = 'skewX';
			transformations.skewX.dist = dist;
			transform();
		}
		
		/*
		 * skewY 
		 */
		public function skewY( dx:Number, dy:Number, constraint:String ):void
		{
			matrices.finale.skewY.identity();
			var dist:Number = 0;
			if ( constraint == 'SKEW_LEFT' )
			{
				matrices.working.skewY.b = states.last.matrix.b - (dist / tWidth);
				matrices.working.skewX.c = states.last.matrix.c;
				transformations.skewY.define( function(dist){ return wX - Math.sin(angle) * dist }, function(dist){ return wY + Math.cos(angle) * dist } );
			}
			else
			{
				matrices.working.skewY.b = states.last.matrix.b + (dist / tWidth);
				matrices.working.skewX.c = states.last.matrix.c;
				transformations.skewY.define( function(dist){ return oX }, function(dist){ return oY } );
			}
			Distances.skewY += dist;
			transformations.current = 'skewY';
			transformations.skewY.dist = dist;
			transform();
		}
		
		/*
		 * rotate 
		 */
		public function rotate( x:Number, y:Number, angle:Number ):void
		{
			matrices.finale.rotate.identity();
			oX = o.tx;
			oY = o.ty;
			
			this.angle = angle*0.0174532925;
			A = new Point(x, y);
			matrices.working.rotate.rotate(this.angle);
			B = matrices.working.rotate.transformPoint(A);
			
			transformations.rotate.define( function() { return (B.x -A.x); }, function() { return (B.y -A.y); } );
			transformations.current = 'rotate';
			transform();
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			CONCAT THE MATRIX IN ORDER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		private function transform():void
		{  
			w = matrices.transform( w );
			
			wX = oX;
			wY = oY;
			if ( transformations.current == 'rotate')
			{
				if ( transformations.scaleX.activated ) wX = (transformations.scaleX.x as Function).apply(null, [Distances.scaleX]);
				if ( transformations.scaleX.activated ) wY = (transformations.scaleX.y as Function).apply(null, [Distances.scaleX]);
				if ( transformations.scaleY.activated ) wX = (transformations.scaleY.x as Function).apply(null, [Distances.scaleY]);
				if ( transformations.scaleY.activated ) wY = (transformations.scaleY.y as Function).apply(null, [Distances.scaleY]);
				if ( transformations.skewX.activated ) wX = (transformations.skewX.x as Function).apply(null, [Distances.skewX]);
				if ( transformations.skewX.activated ) wY = (transformations.skewX.y as Function).apply(null, [Distances.skewX]);
				if ( transformations.skewY.activated ) wX = (transformations.skewY.x as Function).apply(null, [Distances.skewY]);
				if ( transformations.skewY.activated ) wY = (transformations.skewY.y as Function).apply(null, [Distances.skewY]);
			}
			else
			{
				if ( transformations.scaleX.activated && ( transformations.current == 'scaleX' || transformations.current == 'scaleXY' ) ) wX = (transformations.scaleX.x as Function).apply(null, [transformations.scaleX.dist]);
				if ( transformations.scaleX.activated && ( transformations.current == 'scaleX' || transformations.current == 'scaleXY' ) ) wY = (transformations.scaleX.y as Function).apply(null, [transformations.scaleX.dist]);
				if ( transformations.scaleY.activated && ( transformations.current == 'scaleY' || transformations.current == 'scaleXY' ) ) wX = (transformations.scaleY.x as Function).apply(null, [transformations.scaleY.dist]);
				if ( transformations.scaleY.activated && ( transformations.current == 'scaleY' || transformations.current == 'scaleXY' ) ) wY = (transformations.scaleY.y as Function).apply(null, [transformations.scaleY.dist]);
				//if ( transformations.skewX.activated && transformations.current == 'skewX') wX = (transformations.skewX.x as Function).apply(null, [transformations.skewX.dist]);
				//if ( transformations.skewX.activated && transformations.current == 'skewX' ) wY = (transformations.skewX.y as Function).apply(null, [transformations.skewX.dist]);
				//if ( transformations.skewY.activated && transformations.current == 'skewY' ) wX = (transformations.skewY.x as Function).apply(null, [transformations.skewY.dist]);
				//if ( transformations.skewY.activated && transformations.current == 'skewY' ) wY = (transformations.skewY.y as Function).apply(null, [transformations.skewY.dist]);
			}
				
			w.tx = wX - ((transformations.rotate.activated)?transformations.rotate.x.apply():0);
			w.ty = wY - ((transformations.rotate.activated)?transformations.rotate.y.apply():0);
			t.matrix = w.clone();			
			states.current.matrix = w.clone();
			
			w.identity();
			matrices.working.identity();
		}
		
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			APPLY MATRIX MODIFICATIONS
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function apply():void
		{
			if (states.current.matrix != o )
			{
				states.last.matrix.a = matrices.finale.scaleX.a;
				states.last.matrix.b = matrices.finale.skewY.b;
				states.last.matrix.c = matrices.finale.skewX.c;
				states.last.matrix.d = matrices.finale.scaleY.d;
				o.a = states.current.matrix.a;
				o.b = states.current.matrix.b;
				o.c = states.current.matrix.c;
				o.d = states.current.matrix.d;
				oX = wX;
				oY = wY;
			}
			w.identity();
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   UPDATE POISTION
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function update():void
		{
			oX = target.x;
			oY = target.y;
		}
		
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		// 																					   	 GETTER/SETTER
		// ———————————————————————————————————————————————————————————————————————————————————————————————————
		public function get matrix():Matrix { return target.transform.matrix; }
		
		public function get rotation():Number { return Math.atan2(w.b, w.a) * 57.2957795; }
		
		public function get skewStateX():Number {return Math.atan2(-w.c, w.d) * 57.2957795; } 
		
		public function get skewStateY():Number { return Math.atan2(w.b, w.a) * 57.2957795; }
		
		public function get scaleStateX():Number { return Math.sqrt(w.a*w.a + w.b*w.b); }
		
		public function get scaleStateY():Number { return Math.sqrt(w.c*w.c + w.d*w.d); }
		
		public function get height():Number { return target.height; }
		
		public function get width():Number { return target.width; }
    }
}

import flash.geom.Matrix;

class Matrices {
	
	public var finale:Matrice;
	public var working:Matrice;
	private var clone:Matrix;
	private var concatened:Matrix;
	
	public function Matrices()
	{
		finale = new Matrice();
		working = new Matrice();
	}
	
	public function transform(matrix:Matrix):Matrix
	{
		concatened = matrix;
		finale.rotate.concat( working.rotate );
		finale.scaleX.concat( working.scaleX );
		finale.scaleY.concat( working.scaleY );
		finale.skewX.concat( working.skewX );
		finale.skewY.concat( working.skewY );
		
		concat( finale.rotate );
		concat( finale.scaleX );
		concat( finale.scaleY );
		concat( finale.skewX );
		concat( finale.skewY );
		return concatened;
	}
	
	private function concat(matrix:Matrix):void
	{
		clone = matrix.clone();
		clone.concat( concatened );
		concatened = clone.clone();
	}
}

class Matrice {
	
	public var rotate:Matrix;
	public var scaleX:Matrix;
	public var scaleY:Matrix;
	public var skewX:Matrix
	public var skewY:Matrix
	
	public function Matrice()
	{
		rotate = new Matrix();
		scaleX = new Matrix();
		scaleY = new Matrix();
		skewX = new Matrix();
		skewY = new Matrix();
	}
	
	public function identity()
	{
		rotate.identity();
		scaleX.identity();
		scaleY.identity();
		skewX.identity();
		skewY.identity();
	}
}

class States {
		
	public var current:State;
	public var last:State;
	
	public function States()
	{
		current = new State();
		last = new State();
	}
}
	
class State {
		
	public var matrix:Matrix;
	
	public function State( matrix:Matrix=null )
	{
		this.matrix = (matrix != null)? matrix : new Matrix();
	}
}

class OriginTransformations {
		
	public var scaleX:OriginTransformation;
	public var scaleY:OriginTransformation;
	public var skewX:OriginTransformation;
	public var skewY:OriginTransformation;
	public var rotate:OriginTransformation;
	public var current:String = '';
	
	public function OriginTransformations()
	{
		scaleX = new OriginTransformation();
		scaleY = new OriginTransformation();
		skewX = new OriginTransformation();
		skewY = new OriginTransformation();
		rotate = new OriginTransformation();
	}
	
}

class OriginTransformation {
		
	public var x:Function=null;
	public var y:Function=null;
	public var dist:Number;
	public var activated:Boolean = false;
	
	public function OriginTransformation(x:Function=null,y:Function=null)
	{
		this.x = x;
		this.y = y;
		activated = ( x != null && y != null )?true:false;
	}
	
	public function define( x:Function, y:Function ):void
	{
		this.x = x;
		this.y = y;
		activated = true;
	}
}

class Distances {
	
	public static var scaleX:Number=0;
	public static var scaleY:Number=0;
	public static var skewX:Number=0;
	public static var skewY:Number=0;
}
