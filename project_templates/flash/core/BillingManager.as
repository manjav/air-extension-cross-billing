package core 
{
import com.gerantech.extensions.iab.Iab;
import com.gerantech.extensions.iab.Purchase;
import com.gerantech.extensions.iab.events.IabEvent;
import flash.events.Event;
import flash.events.EventDispatcher;

public class BillingManager extends EventDispatcher 
{
    public static var ON_INITIALIZED:String = "ON_INITIALIZED";
    public static var ON_PURCHASE_SUCCESS:String = "ON_PURCHASE_SUCCESS";

    private static var _INSTANCE:BillingManager;

    private var _items:Array;
    private var _marketName:String = "cafebazaar";

    public static function get instance():BillingManager{
        if( _INSTANCE == null )
            _INSTANCE = new BillingManager();
        return _INSTANCE
    }

    public function BillingManager() {
        startSetup();
    }

    public function startSetup():void {
        trace("BillingManager ::: start setup", _marketName);
        // provide all sku items
        _items = new Array("my.product.id1", "my.product.id2", "my.product.id3");

        var base64Key:String, bindURL:String, packageURL:String;
        switch (_marketName) {
            case "google":
                base64Key = "";
                bindURL = "com.android.vending.billing.InAppBillingService.BIND";
                packageURL = "com.android.vending";
                break;

            case "myket":
                base64Key = "";
                bindURL = "ir.mservices.market.InAppBillingService.BIND";
                packageURL = "ir.mservices.market";
                break;

            case "cando":
                base64Key = "";
                bindURL = "com.ada.market.service.payment.BIND";
                packageURL = "com.ada.market";
                break;

            case "cafebazaar":
                base64Key = "MIHNMA0GCSqGSIb3DsQEBAUAA4G7ADCBtwKBrwDHPjyPimF77D8Ex2KfPeHT4apjv3pTQ6MAFcSnn9Eup4xK5Z1B6bunS7zxvARW5u9UEr9nM5mVBvAVQlntdq3fGIuA7/O7tK6K4CgIBSpXMru9R+p8b3tYjJ0luCnfTtF1WaRxZMWXC7mJQ9xQ/5cF4SJpdGcQNhgEZWCFvmUq0W909ea98gTZQS5YNXgJhHD8CKQFyFXRPyiHS9YY2X2yTcTI/YiHs7ISOsDTv8sCAwEAAQ==";
                bindURL = "ir.cafebazaar.pardakht.InAppBillingService.BIND";
                packageURL = "com.farsitel.bazaar";
                break;
            default:
                trace("BillingManager ::: market name[" + _marketName + "] is invalid");
                break;

        }

        Iab.instance.addEventListener(IabEvent.SETUP_FINISHED, iabSetupFinishedHandler);
        Iab.instance.startSetup(base64Key, bindURL, packageURL);
    }

    protected function iabSetupFinishedHandler(event:IabEvent):void {
        trace("BillingManager ::: iabSetupFinishedHandler", event.result.message);
        Iab.instance.removeEventListener(IabEvent.SETUP_FINISHED, iabSetupFinishedHandler);
        queryInventory();
    }

// -_-_-_-_-_-_-_-_-_-_-_-_-_-_- QUERY INVENTORY -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
    /**Getting purchased product details, _iap should be initialized first</br>
     * if put items args getting purchased and not purchased product details
     */
    public function queryInventory():void {
        Iab.instance.addEventListener(IabEvent.QUERY_INVENTORY_FINISHED, iabQueryInventoryFinishedHandler);
        //restoring purchased in-app items and subscriptions
        Iab.instance.queryInventory();
    }

    protected function iabQueryInventoryFinishedHandler(event:IabEvent):void {
        if (!event.result.succeed) {
            trace("iabQueryInventoryFinishedHandler failed to finish");
            return;
        }
        Iab.instance.removeEventListener(IabEvent.QUERY_INVENTORY_FINISHED, iabQueryInventoryFinishedHandler);

        // verify and consume all remaining items
        /*for each(var k:String in _items) {
            var purchase:Purchase = Iab.instance.getPurchase(k);
            if(purchase == null || purchase.itemType == Iab.ITEM_TYPE_SUBS)
                continue;
            consume(purchase.sku);
        }*/
        dispatchEvent(new Event(ON_INITIALIZED));
    }

// -_-_-_-_-_-_-_-_-_-_-_-_-_-_- GET PURCHASE -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
    public function getPurchase(sku:String):Purchase {
        var purchase:Purchase = Iab.instance.getPurchase(sku);
        return purchase;
    }

// -_-_-_-_-_-_-_-_-_-_-_-_-_-_- SUBSCRIBE -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
    public function subscribe(sku:String):void {
        Iab.instance.addEventListener(IabEvent.PURCHASE_FINISHED, iabSubscribeFinishedHandler);
        Iab.instance.purchase(sku, Iab.ITEM_TYPE_SUBS);
    }

    protected function iabSubscribeFinishedHandler(event:IabEvent):void {
        Iab.instance.removeEventListener(IabEvent.PURCHASE_FINISHED, iabSubscribeFinishedHandler);
        if( !event.result.succeed )
		{
            trace(event.result.response == Iab.IABHELPER_NOT_SUPPORTED ? "popup_purchase_not_initialized" : "popup_purchase_error");
            return;
        }
        dispatchEvent(new Event(ON_PURCHASE_SUCCESS));
    }

// -_-_-_-_-_-_-_-_-_-_-_-_-_-_- PURCHASE -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
    public function purchase(sku:String, consumable:Boolean, payload:String):void {
        if (consumable)
            Iab.instance.addEventListener(IabEvent.PURCHASE_FINISHED, iabPurchaseConsumableFinishedHandler);
        else
            Iab.instance.addEventListener(IabEvent.PURCHASE_FINISHED, iabPurchasePermanentFinishedHandler);
        Iab.instance.purchase(sku, Iab.ITEM_TYPE_INAPP, payload);
    }

    protected function iabPurchaseConsumableFinishedHandler(event:IabEvent):void {
        trace("BillingManager ::: iabPurchaseConsumableFinishedHandler", event.result.message);
        Iab.instance.removeEventListener(IabEvent.PURCHASE_FINISHED, iabPurchaseConsumableFinishedHandler);
        if (!event.result.succeed) {
            trace(event.result.response == Iab.IABHELPER_NOT_SUPPORTED ? "popup_purchase_not_initialized" : "popup_purchase_error");
            return;
        }
        var purchase:Purchase = Iab.instance.getPurchase(event.result.purchase.sku);
        if (purchase != null)
            consume(purchase.sku);
        else
            queryInventory();

        var e:Event = new Event(ON_PURCHASE_SUCCESS);
        dispatchEvent(e);
    }

    protected function iabPurchasePermanentFinishedHandler(event:IabEvent):void {
        trace("BillingManager ::: iabPurchasePermanentFinishedHandler", event.result.message);
        Iab.instance.removeEventListener(IabEvent.PURCHASE_FINISHED, iabPurchasePermanentFinishedHandler);
        if (!event.result.succeed) {
            trace(event.result.response == Iab.IABHELPER_NOT_SUPPORTED ? "popup_purchase_not_initialized" : "popup_purchase_error");
            return;
        }

        var e:Event = new Event(ON_PURCHASE_SUCCESS);
        dispatchEvent(e);
    }

// -_-_-_-_-_-_-_-_-_-_-_-_-_-_- CONSUMING PURCHASED ITEM -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
    public function consume(sku:String):void {
        trace("BillingManager ::: consume", sku);
        Iab.instance.addEventListener(IabEvent.CONSUME_FINISHED, iabConsumeFinishedHandler);
        Iab.instance.consume(sku);
    }

    protected function iabConsumeFinishedHandler(event:IabEvent):void {
        trace("BillingManager ::: iabConsumeFinishedHandler", event.result.message);
        Iab.instance.removeEventListener(IabEvent.CONSUME_FINISHED, iabConsumeFinishedHandler);
        if (!event.result.succeed) {
            trace("iabConsumeFinishedHandler failed to consume.", event.result.succeed);
            return;
        }
    }
}
}
