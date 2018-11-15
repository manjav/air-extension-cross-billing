# About
air-extension-inappbilling is an Adobe AIR native extension (ANE) to purchase products for multiple Android markets (locals and global).<br />

![alt text](https://www.abelandcole.co.uk/media/2529_17826_z.jpg)


It uses Google Play In-app Billing version 3 API.<br />
Supported functionality:<br />
- purchase of items;<br />
- restoration of previously purchased items;<br />
- consumption of items;<br />
- subscriptions (not tested).<br />

# Docs
Please, read docs and try ANE before asking any questions.<br />
http://developer.android.com/google/play/billing/index.html<br />
http://help.adobe.com/en_US/air/extensions/index.html<br />


# Installation
Extension ID: com.gerantech.extensions.iabilling
Add "iabilling.ane" from package folder to your Adobe AIR project.<br />
Add the following lines to your AIR Aplication-app.xml file inside &lt;manifestAdditions&gt; section:<br />


```xml
<!-- In APP Billing permissions -->
<uses-permission android:name="android.permission.INTERNET" />
<!--For Google-->	<uses-permission android:name="com.android.vending.BILLING" />
<!--For CafeBazaar-->	<!--<uses-permission android:name="com.farsitel.bazaar.permission.PAY_THROUGH_BAZAAR" />-->
<!--For Myket-->	<!--<uses-permission android:name="ir.mservices.market.BILLING" />-->
<application android:enabled="true" >
     <activity android:name="com.gerantech.extensions.IabActivity"
	  android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen"
	  android:background="#30000000"
	  android:screenOrientation="portrait"
	  android:configChanges="orientation|keyboardHidden" />
</application>

<extensions>
     <extensionID>com.gerantech.extensions.iabilling</extensionID>
</extensions>
```


# Step 1 : Initializing:
```actionscript
import com.gerantech.extensions.iab.Iab;
import com.gerantech.extensions.iab.Purchase;
import com.gerantech.extensions.iab.events.IabEvent;
...

// provide all sku items
_items = new Array("com.gerantech.inapptest.item1", "com.gerantech.inapptest.item2", "com.gerantech.inapptest.item3");
var _marketName:String = "google";
var base64Key:String, bindURL:String, packageURL:String;
switch ( _marketName ) {
	case "google":
		base64Key = "MIHNMA0GCSqGSIb3DsQEBAUAA4G7A...EAAQ==";
		bindURL = "com.android.vending.billing.InAppBillingService.BIND";
		packageURL = "com.android.vending";
		break;

	case "myket":
		base64Key = "MIHNMA0GCSqGSIb3DsQEBAUAA4G7A...EAAQ==";
		bindURL = "ir.mservices.market.InAppBillingService.BIND";
		packageURL = "ir.mservices.market";
		break;

	case "cando":
		base64Key = "MIHNMA0GCSqGSIb3DsQEBAUAA4G7A...EAAQ==";
		bindURL = "com.ada.market.service.payment.BIND";
		packageURL = "com.ada.market";
		break;

	case "cafebazaar":
		base64Key = "MIHNMA0GCSqGSIb3DsQEBAUAA4G7A...EAAQ==";
		bindURL = "ir.cafebazaar.pardakht.InAppBillingService.BIND";
		packageURL = "com.farsitel.bazaar";
		break;
	default:
		trace("BillingManager ::: market name[" + _marketName + "] is invalid");
		break;
}

Iab.instance.addEventListener(IabEvent.SETUP_FINISHED, iabSetupFinishedHandler);
Iab.instance.startSetup(base64Key, bindURL, packageURL);
...
function iabSetupFinishedHandler(event:IabEvent):void {
	trace("BillingManager ::: iabSetupFinishedHandler", event.result.message);
	Iab.instance.removeEventListener(IabEvent.SETUP_FINISHED, iabSetupFinishedHandler);
	queryInventory();
}
```

# Step 2 : Get all inconsumed purchase items and consume:
```actionscript
/**Getting purchased product details, Iab should be initialized first</br>
* if put items args getting purchased and not purchased product details
*/
public function queryInventory():void {
//restoring purchased in-app items and subscriptions
Iab.instance.addEventListener(IabEvent.QUERY_INVENTORY_FINISHED, iabQueryInventoryFinishedHandler);
Iab.instance.queryInventory();
...
function iabQueryInventoryFinishedHandler(event:IabEvent):void {
	Iab.instance.removeEventListener(IabEvent.QUERY_INVENTORY_FINISHED, iabQueryInventoryFinishedHandler);
	if ( !event.result.succeed ) {
		trace("iabQueryInventoryFinishedHandler failed to finish");
		return;
	}

	// consume all remaining items
	/*for each(var k:String in _items) {
		var purchase:Purchase = Iab.instance.getPurchase(k);
		if( purchase == null || purchase.itemType == Iab.ITEM_TYPE_SUBS )
			continue;
		consume(purchase.sku);
	}*/
}
```

# Step 3 : Making purchase:

```actionscript
// making the purchase, Iab should be initialized first
Iab.instance.addEventListener(IabEvent.PURCHASE_FINISHED, iabPurchaseFinishedHandler);
Iab.instance.purchase(sku, Iab.ITEM_TYPE_INAPP, payload);
...
function iabPurchaseFinishedHandler(event:IabEvent):void {
	trace("BillingManager ::: iabPurchaseFinishedHandler", event.result.message);
	Iab.instance.removeEventListener(IabEvent.PURCHASE_FINISHED, iabPurchaseConsumableFinishedHandler);
	if (!event.result.succeed) {
	    trace(event.result.response, event.result.message);
	    return;
	}
	var purchase:Purchase = Iab.instance.getPurchase(event.result.purchase.sku);
	if( purchase == null )
	    queryInventory();
	else // if you want immediatly consume after purchase
	    consume(purchase.sku);
}
```

```actionscript
protected function onRestoreSuccess(event:InAppPurchaseEvent):void
{
	//getting details of purchase: time, etc.
	var purchase:InAppPurchaseDetails = _iap.getPurchaseDetails("my.product.id");
}

protected function onRestoreError(event:InAppPurchaseEvent):void
{
	trace(event.data); //trace error message
}

// getting purchased and not purchased product details
_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreSuccess);
_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);

var items:Array<String> = ["my.product.id1", "my.product.id2", "my.product.id3"];
var subs:Array<String> = ["my.subs.id1", "my.subs.id2", "my.subs.id3"];
_iap.restore(items, subs); //restoring purchased + not purchased in-app items and subscriptions

...

protected function onRestoreSuccess(event:InAppPurchaseEvent):void
{
	//getting details of product: time, etc.
	var skuDetails1:InAppSkuDetails = _iap.getSkuDetails("my.product.id1");

	//getting details of product: time, etc.
	var skuDetails2:InAppSkuDetails = _iap.getSkuDetails("my.subs.id1");

	//getting details of purchase: time, etc.
	var purchase:InAppPurchaseDetails = _iap.getPurchaseDetails("my.purchased.product.id");
}

protected function onRestoreError(event:InAppPurchaseEvent):void
{
	trace(event.data); //trace error message
}

// consuming purchased item
// need to retrieve purchased items first
_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreSuccess);
_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);
_iap.restore();

...

protected function onRestoreSuccess(event:InAppPurchaseEvent):void
{
	_iap.addEventListener(InAppPurchaseEvent.CONSUME_SUCCESS, onConsumeSuccess);
	_iap.addEventListener(InAppPurchaseEvent.CONSUME_ERROR, onConsumeError);
	_iap.consume("my.product.id");
}
```

# Testing
http://developer.android.com/google/play/billing/billing_testing.html


# Misc
ANE is build for AIR 18.0+, in order to rebuild for another version do the following:<br />
- edit "air\extension.xml" and change 18.0 in very first line to any X.x you need;<br />
- edit "package.bat" and in the very last line change path from AIR 18.0 SDK to any AIR X.x SDK you need;<br />
- execute "package.bat" to repack the ANE.<br />

