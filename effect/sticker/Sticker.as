package railk.as3.effect.sticker 
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * ステッカー
	 */
	public class Sticker extends AbstractSticker {
		/**
		 * コンストラクタ
		 */
		public function Sticker(faceContent:DisplayObject, backContent:DisplayObject) {
			super(faceContent, backContent);
			setStyle();
		}
		
		/**
		 * スタイルを作成
		 */
		protected function setStyle():void {
			var r:Number = 0.25;
			var o:Number = (1 - r) * 0xFF;
			var faceFilters:Array = [];
			faceFilters.push(new GlowFilter(0xFFFFFF, 1, 8, 8, 10));
			faceFilters.push(new GlowFilter(0xDDDDDD, 1, 2, 2, 10));
			var backFilters:Array = faceFilters.slice();
			backFilters.splice(1, 0, new ColorMatrixFilter([r, 0, 0, 0, o, 0, r, 0, 0, o, 0, 0, r, 0, o, 0, 0, 0, 1, 0]));
			back.filters = [new DropShadowFilter(8, 45, 0x000000, 0.3, 4, 4, 1, 3)];
			faceContent.filters = faceFilters;
			backContent.filters = backFilters;
		}
	}
}
