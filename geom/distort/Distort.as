/**
 * Tesselates an area into several triangles to allow free transform distortion on BitmapData objects.
 * 
 * @author        Thomas Pfeiffer (aka kiroukou)
 *                 kiroukou@gmail.com
 *                 www.flashsandy.org
 * @author        Ruben Swieringa
 *                 ruben.swieringa@gmail.com
 *                 www.rubenswieringa.com
 *                 www.rubenswieringa.com/blog
 * @version        1.1.0
 * 
 * 
 * edit 2
 * 
 * The original Actionscript2.0 version of the class was written by Thomas Pfeiffer (aka kiroukou),
 *   inspired by Andre Michelle (andre-michelle.com).
 *   Ruben Swieringa rewrote Thomas Pfeiffer's class in Actionscript3.0, making some minor changes/additions.
 * 
 * 
 * Copyright (c) 2005 Thomas PFEIFFER. All rights reserved.
 * 
 * Licensed under the CREATIVE COMMONS Attribution-NonCommercial-ShareAlike 2.0 you may not use this
 *   file except in compliance with the License. You may obtain a copy of the License at:
 *   http://creativecommons.org/licenses/by-nc-sa/2.0/fr/deed.en_GB
 * 
 */

package railk.as3.geom.distort
{    
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    public class Distort 
	{    
        protected var sMat:Matrix; 
		protected var tMat:Matrix;
        protected var xMin:Number; 
		protected var xMax:Number;
		protected var yMin:Number; 
		protected var yMax:Number;
        protected var hsLen:Number;
		protected var vsLen:Number;
		protected var p:Array;
        protected var tri:Array;
		
		protected var hseg:int;
		protected var vseg:int;
		protected var w:Number;
		protected var h:Number;
		
        public var smoothing:Boolean = true;
        
        /**
         * CONSTRUCTEUR
         * 
         * @param    w        Width of the image to be processed
         * @param    h        Height of image to be processed
         * @param    hseg    Horizontal precision
         * @param    vseg    Vertical precision
         * 
         */
        public function Distort(w:Number, h:Number, hseg:int=2, vseg:int=2):void {
            this.w = w;
            this.h = h;
            this.vseg = vseg;
            this.hseg = hseg;
            init();
        }
        
        protected function init():void {
            var ix: Number, iy: Number;
            var w2: Number = w*.5;
            var h2: Number = h*.5;
			var x: Number, y: Number;
            xMin = yMin = 0;
            xMax = w; 
			yMax = h;
            hsLen = w/(hseg+1);
            vsLen = h/(vseg+1);
			p = [];
            tri = [];
            
            // create points:
            for ( ix = 0 ; ix <vseg + 2 ; ix++ ){
                for ( iy = 0 ; iy <hseg + 2 ; iy++ ){
                    x = ix * hsLen;
                    y = iy * vsLen;
                    p.push( { x: x, y: y, sx: x, sy: y } );
                }
            }
            // create triangles:
            for ( ix = 0 ; ix <vseg + 1 ; ix++ ){
                for ( iy = 0 ; iy <hseg + 1 ; iy++ ){
                    tri.push([ p[ iy + ix * ( hseg + 2 ) ] , p[ iy + ix * ( hseg + 2 ) + 1 ] , p[ iy + ( ix + 1 ) * ( hseg + 2 ) ] ] );
                    tri.push([ p[ iy + ( ix + 1 ) * ( hseg + 2 ) + 1 ] , p[ iy + ( ix + 1 ) * ( hseg + 2 ) ] , p[ iy + ix * ( hseg + 2 ) + 1 ] ] );
                }
            }
        }
        
        
        /**
         * Distorts the provided BitmapData according to the provided Point instances and draws it onto the provided Graphics.
         * 
         * @param    graphics    Graphics on which to draw the distorted BitmapData
         * @param    bmd            The undistorted BitmapData
         * @param    tl            Point specifying the coordinates of the top-left corner of the distortion
         * @param    tr            Point specifying the coordinates of the top-right corner of the distortion
         * @param    br            Point specifying the coordinates of the bottom-right corner of the distortion
         * @param    bl            Point specifying the coordinates of the bottom-left corner of the distortion
         * 
         */
        public function setTransform(graphics:Graphics, bmd:BitmapData, tl:Point, tr:Point, br:Point, bl:Point):void {
            var dx30:Number = bl.x - tl.x;
            var dy30:Number = bl.y - tl.y;
            var dx21:Number = br.x - tr.x;
            var dy21:Number = br.y - tr.y;
            var l:Number = p.length;
            while( --l> -1 ){
                var point:Object = p[ l ];
                var gx:Number = ( point.x - xMin ) / w;
                var gy:Number = ( point.y - yMin ) / h;
                var bx:Number = tl.x + gy * ( dx30 );
                var by:Number = tl.y + gy * ( dy30 );
                point.sx = bx + gx * ( ( tr.x + gy * ( dx21 ) ) - bx );
                point.sy = by + gx * ( ( tr.y + gy * ( dy21 ) ) - by );
            }
            render(graphics, bmd);
        }
        
        
        /**
         * Distorts the provided BitmapData and draws it onto the provided Graphics.
         * 
         * @param    graphics    Graphics
         * @param    bmd            BitmapData
         * 
         * @private
         */
        protected function render(graphics:Graphics, bmd:BitmapData):void {
            var t: Number;
            var vertices: Array;
            var p0:Object, p1:Object, p2:Object;
            var a:Array;
            sMat = new Matrix();
            tMat = new Matrix();
            var l:Number = tri.length;
            while( --l> -1 ){
                a = tri[ l ];
                p0 = a[0];
                p1 = a[1];
                p2 = a[2];
                var x0: Number = p0.sx;
                var y0: Number = p0.sy;
                var x1: Number = p1.sx;
                var y1: Number = p1.sy;
                var x2: Number = p2.sx;
                var y2: Number = p2.sy;
                var u0: Number = p0.x;
                var v0: Number = p0.y;
                var u1: Number = p1.x;
                var v1: Number = p1.y;
                var u2: Number = p2.x;
                var v2: Number = p2.y;
                tMat.tx = u0;
                tMat.ty = v0;
                tMat.a = ( u1 - u0 ) / w;
                tMat.b = ( v1 - v0 ) / w;
                tMat.c = ( u2 - u0 ) / h;
                tMat.d = ( v2 - v0 ) / h;
                sMat.a = ( x1 - x0 ) / w;
                sMat.b = ( y1 - y0 ) / w;
                sMat.c = ( x2 - x0 ) / h;
                sMat.d = ( y2 - y0 ) / h;
                sMat.tx = x0;
                sMat.ty = y0;
                tMat.invert();
                tMat.concat( sMat );
                // draw:
                graphics.beginBitmapFill( bmd, tMat, false, smoothing );
                graphics.moveTo( x0, y0 );
                graphics.lineTo( x1, y1 );
                graphics.lineTo( x2, y2 );
                graphics.endFill();
            }
        }
        
		/**
		 * GETTERS/SETTERS
		 */
        public function get width():Number { return w; }
        public function set width(value:Number):void { w=value; init(); }
		
        public function get height():Number { return h; }
        public function set height(value:Number):void { h=value; init(); }
		
        public function get hPrecision():int { return hseg; }
        public function set hPrecision(value:int):void { hseg=value; init(); }
		
        public function get vPrecision():int { return vseg; }
        public function set vPrecision(value:int):void { vseg=value; init(); }
    }
}