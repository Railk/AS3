package railk.as3.effect.sticker 
{

	public class BoundaryPeeloutDetector implements IPeeloutDetector 
	{
		public function detect(sticker:StickerBase):Boolean 
		{
			return sticker.face.getBounds(sticker.faceMask).x > 0;
		}
	}
}
