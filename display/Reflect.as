/////////////////////////////////////////////////////////////////
//*************************************************************//
//*            Package de création des menus                  *//
//*************************************************************//
/////////////////////////////////////////////////////////////////

package railk.as3.display {
    
    import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
    import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.geom.Point;


    public class Reflect extends Sprite {
        
        private var _disTarget:DisplayObject;
        private var _numStartFade:Number;
        private var _numMidLoc:Number;
        private var _numEndFade:Number;
        private var _numSkewX:Number;
        private var _numScale:Number;        
        private var _bmpReflect:Bitmap;
        
        // Constructor
        public function Reflect(set_disTarget:DisplayObject, set_numStartFade:Number=.3, set_numMidLoc:Number=.5, set_numEndFade:Number=0, set_numSkewX:Number=0, set_numScale:Number=1) {
            super();
            _disTarget = set_disTarget;
            _numStartFade = set_numStartFade;
            _numMidLoc = set_numMidLoc;
            _numEndFade = set_numEndFade;
            _numSkewX = set_numSkewX;
            _numScale = set_numScale;
            
            _bmpReflect = new Bitmap(new BitmapData(1, 1, true, 0));
            this.addChild(_bmpReflect);
            createReflection();
        }
		
        
        // Create reflection
        private function createReflection():void {
            
            // Reflection
            var bmpDraw:BitmapData = new BitmapData(_disTarget.width, _disTarget.height, true, 0);
            var matSkew:Matrix = new Matrix(1, 0, _numSkewX, -1 * _numScale, 0, _disTarget.height);
            var recDraw:Rectangle = new Rectangle(0, 0, _disTarget.width, _disTarget.height * (2 - _numScale));
            var potSkew:Point = matSkew.transformPoint(new Point(0, _disTarget.height));
            matSkew.tx = potSkew.x * -1;
            matSkew.ty = (potSkew.y - _disTarget.height) * -1;
            bmpDraw.draw(_disTarget, matSkew, null, null, recDraw, true);
            
            // Fade
            var shpDraw:Shape = new Shape();
            var matGrad:Matrix = new Matrix();
            var arrAlpha:Array = new Array(_numStartFade, (_numStartFade - _numEndFade) / 2.5, _numEndFade);
            var arrMatrix:Array = new Array(0, 0xFF * _numMidLoc, 0xFF);
            matGrad.createGradientBox(_disTarget.width, _disTarget.height/2.5, 0.5 * Math.PI);
            shpDraw.graphics.beginGradientFill("linear", new Array(0,0,0), arrAlpha, arrMatrix, matGrad)
            shpDraw.graphics.drawRect(0, 0, _disTarget.width, _disTarget.height);
            shpDraw.graphics.endFill();
            bmpDraw.draw(shpDraw, null, null, BlendMode.ALPHA);
            
            _bmpReflect.bitmapData.dispose();
            _bmpReflect.bitmapData = bmpDraw;
            
            _bmpReflect.filters = _disTarget.filters;
            
            this.x = _disTarget.x;
            this.y = (_disTarget.y + _disTarget.height) - 1;          
        }
    }
}	