package {
import com.gerantech.extensions.iab.Purchase;
import core.Assets;
import core.BillingManager;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import objects.Car;
import objects.GasGauge;

[SWF(width=720, height=1280, frameRate=60, backgroundColor=0x000000)]
public class TrivialDrive extends Sprite
{
    private var _billingManager:BillingManager;
    private var _car:Car;
    private var _title:Sprite;
    private var _gauge:GasGauge;
    private var _driveBtn:Sprite;
    private var _buyGasBtn:Sprite;
    private var _upgradeBtn:Sprite;
    private var _infiniteGasBtn:Sprite;
    private var _gasLevel:int;
    private var _waitBackground:Sprite;
    private var _waitIcon:Sprite;

    public function TrivialDrive() 
{
        stage.color = 0x303030;

        _billingManager = BillingManager.instance;
        _billingManager.addEventListener(BillingManager.ON_INITIALIZED, onInitialized);

        _title = new Sprite();
        _title.addChild(Assets.getBitmap("title"));
        _title.x = (stage.stageWidth - _title.width) * 0.5;
        _title.y = 100;
        addChild(_title);

        _car = new Car();
        _car.x = (stage.stageWidth - _car.width) * 0.5;
        _car.y = 250;
        addChild(_car);

        _gauge = new GasGauge();
        _gauge.x = (stage.stageWidth - _gauge.width) * 0.5;
        _gauge.y = 500;
        addChild(_gauge);

        _driveBtn = new Sprite();
        _driveBtn.addChild(Assets.getBitmap("drive"));
        _driveBtn.x = stage.stageWidth * 0.25 - _driveBtn.width * 0.5;
        _driveBtn.y = 700;
        addChild(_driveBtn);

        _buyGasBtn = new Sprite();
        _buyGasBtn.addChild(Assets.getBitmap("buy_gas"));
        _buyGasBtn.x = stage.stageWidth * 0.75 - _buyGasBtn.width * 0.5;
        _buyGasBtn.y = 700;
        addChild(_buyGasBtn);

        _upgradeBtn = new Sprite();
        _upgradeBtn.addChild(Assets.getBitmap("upgrade_app"));
        _upgradeBtn.x = stage.stageWidth * 0.25 - _upgradeBtn.width * 0.5;
        _upgradeBtn.y = 900;
        addChild(_upgradeBtn);

        _infiniteGasBtn = new Sprite();
        _infiniteGasBtn.addChild(Assets.getBitmap("get_infinite_gas"));
        _infiniteGasBtn.x = stage.stageWidth * 0.75 - _infiniteGasBtn.width * 0.5;
        _infiniteGasBtn.y = 900;
        addChild(_infiniteGasBtn);

        _waitBackground = new Sprite();
        _waitBackground.graphics.beginFill(0x000000, 0.75);
        _waitBackground.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
        _waitBackground.graphics.endFill();
        addChild(_waitBackground);

        _waitIcon = new Sprite();
        _waitIcon.addChild(Assets.getBitmap("wait"));
        _waitIcon.x = stage.stageWidth * 0.5 - _infiniteGasBtn.width * 0.5;
        _waitIcon.y = stage.stageHeight * 0.5 - _infiniteGasBtn.height * 0.5;
        addChild(_waitIcon);
    }

    protected function onInitialized(event:Event):void {
        _billingManager.removeEventListener(BillingManager.ON_INITIALIZED, onInitialized);

        // Add event listeners to buttons
        _buyGasBtn.addEventListener(MouseEvent.CLICK, buyGas);
        _driveBtn.addEventListener(MouseEvent.CLICK, drive);
        _upgradeBtn.addEventListener(MouseEvent.CLICK, upgrade);
        _infiniteGasBtn.addEventListener(MouseEvent.CLICK, subscribe);

        // Check if client has bought the premium car (permanent product)
        var premiumCar:Purchase = _billingManager.getPurchase("my.product.id2");
        if( premiumCar ) {
            trace("premiumCar >", premiumCar, premiumCar.itemType, premiumCar.packageName, premiumCar.sku, premiumCar.token, premiumCar.developerPayload);
            _car.setToPremium();
        }

        // Check if client has infinite gas (subscribed)
        var infiniteGas:Purchase = _billingManager.getPurchase("my.product.id3");
        if( infiniteGas ) {
            trace("infiniteGas >", infiniteGas, infiniteGas.itemType, infiniteGas.packageName, infiniteGas.sku, infiniteGas.token, infiniteGas.developerPayload);
            _gasLevel = -1;
            _gauge.setTo(_gasLevel);
        }

        // Read gas level from local storage
        var sharedObj:SharedObject = SharedObject.getLocal("saveData");
        _gasLevel = sharedObj.data.gasLevel;
        _gauge.setTo(_gasLevel);

        // Remove wait assets
        removeChild(_waitBackground);
        removeChild(_waitIcon);
    }

    protected function buyGas(event:MouseEvent):void {
        _billingManager.purchase("my.product.id1", true, "payload_for_gas");
        _billingManager.addEventListener(BillingManager.ON_PURCHASE_SUCCESS, onPurchaseSuccess);
    }

    protected function onPurchaseSuccess(event:Event):void {
        _billingManager.removeEventListener(BillingManager.ON_PURCHASE_SUCCESS, onPurchaseSuccess);
        if (_gasLevel >= 0) // _gasLevel = -1 means infinite gas (subscribed user)
            _gasLevel++;
        _gauge.setTo(_gasLevel);

        // save gas level locally
        saveGasLevel();
    }

    protected function drive(event:MouseEvent):void {
        if (_gasLevel > 0)
            _gasLevel--;
        _gauge.setTo(_gasLevel);

        // save gas level locally
        saveGasLevel();
    }

    private function saveGasLevel():void {
        var sharedObj:SharedObject = SharedObject.getLocal("saveData");
        sharedObj.data.gasLevel = _gasLevel;
        sharedObj.flush();
    }

    protected function upgrade(event:MouseEvent):void {
        _billingManager.addEventListener(BillingManager.ON_PURCHASE_SUCCESS, onUpgradeSuccess);
        _billingManager.purchase("my.product.id2", false, "payload_for_upgrade");
    }

    protected function onUpgradeSuccess(event:Event):void {
        _billingManager.removeEventListener(BillingManager.ON_PURCHASE_SUCCESS, onUpgradeSuccess);
        _car.setToPremium();
    }

    protected function subscribe(event:MouseEvent):void {
        _billingManager.addEventListener(BillingManager.ON_PURCHASE_SUCCESS, onSubscribtionSuccess);
        _billingManager.subscribe("my.product.id3");
    }

    protected function onSubscribtionSuccess(event:Event):void {
        _billingManager.removeEventListener(BillingManager.ON_PURCHASE_SUCCESS, onSubscribtionSuccess);
        _gasLevel = -1;
        _gauge.setTo(_gasLevel);
    }
}
}
