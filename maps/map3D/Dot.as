/**
* 
* Dot
* 
* @author Richard Rodney
* @version 0.1
*/


package railk.as3.maps.map3D {
	

	// ________________________________________________________________________________________ IMPORT FLASH
	import flash.display.Sprite;
	import flash.events.Event;
	
	// ________________________________________________________________________________________ IMPORT RAILK
	import railk.as3.stage.StageManager;
	import railk.as3.display.GraphicShape;
	import railk.as3.display.DSprite;
	
	// __________________________________________________________________________________ IMPORT PAPERVISION
	import org.papervision3d.core.geom.renderables.Particle;
	
	// _______________________________________________________________________________________ IMPORT TWEENER
	import caurina.transitions.Tweener;
	

    public class Dot extends Sprite
    {
        private var yPos:Number;
        private var particle:Particle;
        private var zPos:Number;
        private var xPos:Number;

        public function Dot(param1:Number, param2:Number, param3:Number)
        {
            xPos = param1;
            yPos = param2;
            zPos = param3;
            particle = new Particle( StageManager.GlobalVars.material1, 1, xPos, yPos, zPos );//Math.random() * 5000 - 2000, Math.random() * 5000 - 2000, Math.random() * 5000 - 2500
            addEventListener(Event.ENTER_FRAME, updateParticle);
            return;
        }

        public function getParticle() : Particle
        {
            return particle;
        }

        private function spreadParticle() : void
        {
            Tweener.addTween(particle, {z:Math.random() * 5000 - 2000, y:Math.random() * 5000 - 2000, x:Math.random() * 5000 - 2000, time:4, transition:"easeInOutCubic"});
            return;
        }

        private function updateParticle( evt:Event ) : void
        {
            if (particle.renderScale < 2.9)
            {
                particle.material = StageManager.GlobalVars.material2;
            }
            else
            {
                particle.material = StageManager.GlobalVars.material1;
            }
            return;
        }

        private function placeParticle() : void
        {
            var _loc_2:Array;
            _loc_2 = new Array();
            _loc_2.push({z:zPos, y:yPos, x:xPos});
            Tweener.addTween(particle, {z:zPos, y:yPos, x:xPos, time:4, _bezier:_loc_2, transition:"easeInOutCubic"});
            return;
        }
		
		
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		// 																			  DESTROY MAP AND MARKERS
		// ——————————————————————————————————————————————————————————————————————————————————————————————————
		public function destroy():void {
			
		}
		
	}
	
}