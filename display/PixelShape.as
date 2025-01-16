/**
* 
* Pixel Shapes
* 
* @author Richard Rodney
*/

package railk.as3.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class PixelShape extends UISprite
	{
		/**
		 * CONSTRUCTEUR
		 */
		public function PixelShape() {
			super();
		}
		
		/**
		* PIXEL SURFACE
		* 
		* @param	color
		* @param	W
		* @param	H
		* @param	espaceW  minimum = 1
		* @param	espaceH  minimum = 1
		* @param	pair
		*/
		public function pixel( color:uint, W:int, H:int, espaceW:int, espaceH:int, pair:Boolean = false ):void {
			super();
			var flagPair:int=0;
			var X:int = 0;
			var Y:int = 0;
			var bmp:Bitmap = new Bitmap( new BitmapData( W, H, true, 0x00FFFFFF ) );
			bmp.name = 'bmp';
			
			if (flagPair == 0){ X=0; if(!pair){ flagPair = 1; } }
			else if (flagPair == 1) { X=1; flagPair = 0; }

			//calcul du nombre de pixel par ligne et du nombre de ligne
			var nbCol:int = Math.ceil( W/espaceW );
			var nbLigne:int = Math.ceil( H/espaceH );
			
			bmp.bitmapData.lock();
			var m:Boolean = true;
			var xLoop:int = 0;
			var yLoop:int = 0;
			while (true) {
				m ? xLoop++ : --xLoop;
				
				bmp.bitmapData.setPixel32(X, Y, color);
				X = X+espaceW;
				
				if (xLoop == nbCol || xLoop == 0) {
					if (yLoop++ == nbLigne) break;
					m = !m;
					
					if (flagPair == 0){ X=0; if(!pair){ flagPair = 1; } }
					else if (flagPair == 1) { X=1; flagPair = 0; }
					Y = Y+espaceH;
				}
			}
			bmp.bitmapData.unlock();
			this.addChild( bmp );
		}
		
		public function erasePixel():void { 
			this.removeChild( this.getChildByName( 'bmp' ) );
		}
		
		/**
		* PIXEL PATTERN
		* 
		* @param	W 	largeur de la surface sur laquelle appliquer le pattern
		* @param	H 	hauteur de la surface sur laquelle appliquer le pattern
		* @param	color 	Object du type { flat:0xFF000000,trans:0x060000000 }
		* @param	pattern 	object de type {11:1, ....nn:n} ou n ---> 0=noColor, 1=flatColor, 2=transparentColor
		* @param	patternH	taille du pattern en hauteur
		* @param	patternW	taille du pattern en largeur
		* @return
		*/
		public function pattern( W:int, H:int, color:Object, pattern:Object, patternH:int, patternW:int ):void 
		{
			var X:int = 0;
			var Y:int = 0;
			var bmp:Bitmap = new Bitmap( new BitmapData( W, H, true, 0x00FFFFFF ) );
			
			//nombre de lignes/col de pattern
			var nbLigne = Math.ceil( H/patternH );
			var nbCol = Math.ceil( W/patternW );
			
			bmp.bitmapData.lock();
			var m:Boolean = true;
			var xLoop:int = 0;
			var yLoop:int = 0;
			var nx:int;
			while (true) {
				nx = m ? xLoop++ : --xLoop;
				
				for( var i:int=1;i<=patternH;i++ ){
					for( var j:int=1;j<=patternW;j++ ){
						if( pattern[String(i)+String(j)] == 1) {
							bmp.bitmapData.setPixel32(X, Y, color.flat);
						}
						else if( pattern[String(i)+String(j)] == 2) {
							bmp.bitmapData.setPixel32(X, Y, color.trans);
						}
						X += 1;
					}
					Y+=1;
					X-=patternW;
				}
				
				X = patternW * nx;
				Y-=patternH;
				
				if (xLoop == nbCol+1 || xLoop == 0) {
					if (yLoop++ == nbLigne) break;
					m = !m;
					Y = patternH * yLoop;
					X = 0;
				}
			}
			bmp.bitmapData.unlock();
			this.addChild( bmp );
		}
		
		/**
		* PERLIN NOISE
		* 
		* @param	bmp            bitmapdata ou ecrire le perlinnoise
		* @param	grayscale      true or false
		* @return
		*/
		public function pnoise( bmp:BitmapData, grayscale:Boolean=true ):BitmapData {
			var seed:Number = Math.floor(Math.random() * 30);
			bmp.perlinNoise(2, 1, 1, seed, true, false, 7, grayscale, null);
			
			return bmp;
		}
	}
}