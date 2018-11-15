package objects {
	import flash.display.Sprite;
	import core.Assets;

	public class Car extends Sprite {
		public function Car() {
			super();
			setToFree();
		}

		public function setToPremium():void {
			removeChildren();
			addChild(Assets.getBitmap("premium"));
		}

		public function setToFree():void {
			removeChildren();
			addChild(Assets.getBitmap("free"));
		}
	}
}
