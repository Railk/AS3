/**
 * ...
 * 
 * @author Richard Rodney
 * @version 0.1
 */
 
package railk.as3.geom.distort
{
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
 
	public class SDistort extends Sprite
	{
		public var TL:Point;
		public var TR:Point;
		public var BL:Point;
		public var BR:Point;
		
		public var brightness:Number = 0;
		private var bmd:BitmapData;
		private var matrix:Matrix = new Matrix();
		
		private var tri1:STri;
		private var tri2:STri;
		private var v1:SVertex;
		private var v2:SVertex;
		private var v3:SVertex;
		private var v4:SVertex;
 
		public function SDistort(bmd:BitmapData,TLX:Number,TLY:Number,TRX:Number,TRY:Number,BLX:Number,BLY:Number,BRX:Number,BRY:Number) {
			this.bmd = bmd;
			TL = new Point(TLX, TLY);
			TR = new Point(TRX, TRY);
			BL = new Point(BLX, BLY);
			BR = new Point(BRX, BRY);
			v1 = new SVertex(TL,new Point(0,0));
			v2 = new SVertex(TR,new Point(bmd.width,0));
			v3 = new SVertex(BL,new Point(0,bmd.height));
			v4 = new SVertex(BR, new Point(bmd.width, bmd.height));
			tri1 = new STri(v1, v2, v3);
			tri2 = new STri(v2, v4, v3);
		}
		
		public function updateFrame():void {
			this.graphics.clear();
			drawTriangle (tri1);
			drawTriangle (tri2);	
		}
		
		public function drawTriangle(tri:STri):void {
			var points:Array = calcUVs(tri);
			var p0:Point = points[0];
			var p1:Point = points[1];
			var p2:Point = points[2];
			var bmdCopy:BitmapData = bmd.clone();
            bmdCopy.colorTransform(new Rectangle(0, 0, bmdCopy.width, bmdCopy.height),new ColorTransform(1, 1, 1, 1, brightness * 255, brightness * 255, brightness * 255, 0));
			this.graphics.beginBitmapFill(bmdCopy, matrix);
			this.graphics.moveTo(p0.x, p0.y);
			this.graphics.lineTo(p1.x, p1.y);
			this.graphics.lineTo(p2.x, p2.y);
			this.graphics.endFill();
		}
 
		public function calcUVs(tri:STri):Array {
			var p0:Point = tri.v0.p;
			var uv0:Point = tri.v0.uv;
			var p1:Point = tri.v1.p;
			var uv1:Point = tri.v1.uv;
			var p2:Point = tri.v2.p;
			var uv2:Point = tri.v2.uv,
			var du1:Number = uv1.x - uv0.x;
			var dv1:Number = uv1.y - uv0.y;
			var du2:Number = uv2.x - uv0.x;
			var dv2:Number = uv2.y - uv0.y;
			var dx1:Number = p1.x - p0.x;
			var dy1:Number = p1.y - p0.y;
			var dx2:Number = p2.x - p0.x;
			var dy2:Number = p2.y - p0.y;
			var det:Number = 1.0 / ((du1 * dv2) - (du2 * dv1));
			matrix.a = (( dv2 * dx1) + (-dv1 * dx2)) * det;
			matrix.b = (( dv2 * dy1) + (-dv1 * dy2)) * det;
			matrix.c = ((-du2 * dx1) + ( du1 * dx2)) * det;
			matrix.d = ((-du2 * dy1) + ( du1 * dy2)) * det;
			matrix.tx = p0.x - ( (uv0.x * matrix.a) + (uv0.y * matrix.c) );
			matrix.ty = p0.y - ( (uv0.x * matrix.b) + (uv0.y * matrix.d) );
			return(new Array( p0, p1, p2 ) );
		}
	}
}

import flash.geom.Point;
internal class SVertex
{
	public var p:Point;
	public var uv:Point;
	public function SVertex(p:Point, uv:Point) {
		this.p = p;
		this.uv = uv;
	}
}

internal class STri
{
	public var v0:SVertex;
	public var v1:SVertex;
	public var v2:SVertex;
	public function STri(v0:SVertex, v2:SVertex, v2:SVertex) {
		this.v0 = v0;
		this.v1 = v1;
		this.v2 = v2;
	}
}