package objects {
	import flash.display.Sprite;
	import core.Assets;

	public class GasGauge extends Sprite {
		public function GasGauge() {
			super();
			setTo(0);
		}

		public function setTo(value:int):void {
			removeChildren();
			switch(value) {
				case 0:
					addChild(Assets.getBitmap("gas0"));
					break;
				case 1:
					addChild(Assets.getBitmap("gas1"));
					break;
				case 2:
					addChild(Assets.getBitmap("gas2"));
					break;
				case 3:
					addChild(Assets.getBitmap("gas3"));
					break;
				case 4:
					addChild(Assets.getBitmap("gas4"));
					break;
				case -1:
					addChild(Assets.getBitmap("gas_inf"));
					break;
			}
		}
	}
}
