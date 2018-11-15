package {
	import com.gerantech.extensions.iab.Purchase;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import core.BillingManager;

	import flash.display.MovieClip;

	[SWF(width = 720, height = 1280, frameRate = 60, backgroundColor = 0x000000)]

	public class TrivialDrive extends Sprite {
		private var _billingManager: BillingManager;
		private var _car: MovieClip;
		private var _gauge: MovieClip;
		private var _driveBtn: MovieClip;
		private var _buyGasBtn: MovieClip;
		private var _upgradeBtn: MovieClip;
		private var _infiniteGasBtn: MovieClip;
		private var _gasLevel: int;
		private var _waitScreen: MovieClip;

		public function TrivialDrive() {
			stage.color = 0x303030;

			_billingManager = BillingManager.instance;
			_billingManager.addEventListener(BillingManager.ON_INITIALIZED, onInitialized);

			_car = getChildByName("car_mc") as MovieClip;
			_car.gotoAndStop(1);

			_gauge = getChildByName("gauge_mc") as MovieClip;
			_gauge.gotoAndStop(1);

			_driveBtn = getChildByName("drive_mc") as MovieClip;
			_driveBtn.gotoAndStop(1);

			_buyGasBtn = getChildByName("buy_mc") as MovieClip;
			_buyGasBtn.gotoAndStop(1);

			_upgradeBtn = getChildByName("upgrade_mc") as MovieClip;
			_upgradeBtn.gotoAndStop(1);

			_infiniteGasBtn = getChildByName("infinite_mc") as MovieClip;
			_infiniteGasBtn.gotoAndStop(1);
			
			_waitScreen = getChildByName("wait_mc") as MovieClip;
			_waitScreen.gotoAndStop(1);
		}

		protected function onInitialized(event: Event): void {
			_billingManager.removeEventListener(BillingManager.ON_INITIALIZED, onInitialized);

			// Add event listeners to buttons
			_buyGasBtn.addEventListener(MouseEvent.CLICK, buyGas);
			_driveBtn.addEventListener(MouseEvent.CLICK, drive);
			_upgradeBtn.addEventListener(MouseEvent.CLICK, upgrade);
			_infiniteGasBtn.addEventListener(MouseEvent.CLICK, subscribe);

			// Check if client has bought the premium car (inconsumable)
			var premiumCar: Purchase = _billingManager.getPurchase("my.product.id2");
			if (premiumCar) {
				trace("premiumCar >", premiumCar, premiumCar.itemType, premiumCar.packageName, premiumCar.sku, premiumCar.token, premiumCar.developerPayload);
				_car.gotoAndStop("premium");
			}

			// Check if client has infinite gas (subscribed)
			var infiniteGas: Purchase = _billingManager.getPurchase("my.product.id3");
			if (infiniteGas) {
				trace("infiniteGas >", infiniteGas, infiniteGas.itemType, infiniteGas.packageName, infiniteGas.sku, infiniteGas.token, infiniteGas.developerPayload);
				_gasLevel = -1;
				_gauge.gotoAndStop("infinite");
			}

			// Remove wait assets
			removeChild(_waitScreen);
		}

		protected function buyGas(event: MouseEvent): void {
			_billingManager.purchase("my.product.id1", true, "payload_for_gas");
			_billingManager.addEventListener(BillingManager.ON_PURCHASE_SUCCESS, onPurchaseSuccess);
		}

		protected function onPurchaseSuccess(event: Event): void {
			_billingManager.removeEventListener(BillingManager.ON_PURCHASE_SUCCESS, onPurchaseSuccess);
			if (_gasLevel >= 0)
				_gasLevel++;
			_gauge.gotoAndStop("level" + String(_gasLevel));
		}

		protected function drive(event: MouseEvent): void {
			if (_gasLevel > 0)
				_gasLevel--;
			_gauge.gotoAndStop("level" + String(_gasLevel));
		}

		protected function upgrade(event: MouseEvent): void {
			_billingManager.addEventListener(BillingManager.ON_PURCHASE_SUCCESS, onUpgradeSuccess);
			_billingManager.purchase("my.product.id2", false, "payload_for_upgrade");
		}

		protected function onUpgradeSuccess(event: Event): void {
			_billingManager.removeEventListener(BillingManager.ON_PURCHASE_SUCCESS, onUpgradeSuccess);
			_car.gotoAndStop("premium");
		}

		protected function subscribe(event: MouseEvent): void {
			_billingManager.addEventListener(BillingManager.ON_PURCHASE_SUCCESS, onSubscribtionSuccess);
			_billingManager.subscribe("my.product.id3");
		}

		protected function onSubscribtionSuccess(event: Event): void {
			_billingManager.removeEventListener(BillingManager.ON_PURCHASE_SUCCESS, onSubscribtionSuccess);
			_gasLevel = -1;
			_gauge.gotoAndStop("infinite");
		}
	}
}