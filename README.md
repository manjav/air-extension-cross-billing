# About
air-extension-inappbilling is an Adobe AIR native extension (ANE) to purchase products for multiple Android markets (locals and global).<br />
[...........راهنمــــــای فـــــــارسی..........](https://github.com/manjav/air-extension-inappbilling/edit/master/README_FA.md)

We prepared 2 type projects template:
1. [Flash Professional(Animate) template](https://github.com/manjav/air-extension-inappbilling/tree/master/project_templates/flash) for Flash Designers.
2. [Pure Action Script template](https://github.com/manjav/air-extension-inappbilling/tree/master/project_templates/pure_as3) for Flash Developers to use Flash Builder, Flash Develop or Intellij Idea.

![Test Project](https://github.com/manjav/air-extension-inappbilling/blob/master/files/TrivialDrive_EN.png)

It uses Google Play In-app Billing version 3 API.<br />
Supported functionality:<br />
- purchase of items;<br />
- restoration of previously purchased items;<br />
- consumption of items;<br />
- subscriptions (not tested).<br />

# Docs
Please, read docs and try ANE before asking any questions.<br/>
http://developer.android.com/google/play/billing/index.html<br />
http://help.adobe.com/en_US/air/extensions/index.html<br />


# Step 1 : Insert ANE file into your Adobe AIR Project
Add [iabilling.ane](https://github.com/manjav/air-extension-inappbilling/blob/master/package/iabilling.ane) file from package folder to your Adobe AIR project.<br />
<b>Tutorial:</b> [How to embed ANEs into FlashBuilder, Flash(Animate) and FlashDevelop](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)

# Step 2 : Initializing based on selected market:
Insert All uses items into '_items' array.

Get base64key from market console and replace with '==5AMP1E8A5E64KE7=='.<br />
Also if you want add new market, you had to added new case with 'bindeURL' and 'packageURL'.
```actionscript
import com.gerantech.extensions.iab.Iab;
import com.gerantech.extensions.iab.Purchase;
import com.gerantech.extensions.iab.events.IabEvent;
...

// provide all sku items
_items = new Array("my.product.id1", "my.product.id2", "my.product.id3");
var _marketName:String = "google";
var base64Key:String, bindURL:String, packageURL:String;
switch ( _marketName ) {
	case "google":
		base64Key = "==5AMP1E8A5E64KE7==";
		bindURL = "com.android.vending.billing.InAppBillingService.BIND";
		packageURL = "com.android.vending";
		break;

	case "cafebazaar":
		base64Key = "==5AMP1E8A5E64KE7==";
		bindURL = "ir.cafebazaar.pardakht.InAppBillingService.BIND";
		packageURL = "com.farsitel.bazaar";
		break;

	case "myket":
		base64Key = "==5AMP1E8A5E64KE7==";
		bindURL = "ir.mservices.market.InAppBillingService.BIND";
		packageURL = "ir.mservices.market";
		break;

	case "cando":
		base64Key = "==5AMP1E8A5E64KE7==";
		bindURL = "com.ada.market.service.payment.BIND";
		packageURL = "com.ada.market";
		break;
	default:
		trace("BillingManager ::: market name[" + _marketName + "] is invalid.");
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

# Step 3 : Get all inconsumed purchase items and consume:
Sometimes users can not complete purchase flow cause network problems or other fatal errors. you can restore items after initializing to better user experience.   
```actionscript
/**Getting purchased product details, Iab should be initialized first</br>
* if put items args getting purchased and not purchased product details
*/
function queryInventory():void {
	//restoring purchased in-app items and subscriptions
	Iab.instance.addEventListener(IabEvent.QUERY_INVENTORY_FINISHED, iabQueryInventoryFinishedHandler);
	Iab.instance.queryInventory();
}
...
function iabQueryInventoryFinishedHandler(event:IabEvent):void {
	Iab.instance.removeEventListener(IabEvent.QUERY_INVENTORY_FINISHED, iabQueryInventoryFinishedHandler);
	if ( !event.result.succeed ) {
		trace("iabQueryInventoryFinishedHandler failed to finish.");
		return;
	}

	// consume all consumable items
	/*for each(var k:String in _items) {
		var purchase:Purchase = Iab.instance.getPurchase(k);
		if( purchase == null || purchase.itemType == Iab.ITEM_TYPE_SUBS )
			continue;
		consume(purchase.sku);
	}*/
}
```

# Step 4 : Making purchase:
When user tapped or clicked on 'BUY' button call purchase method. dont forget in order to purchase that item must be consumed.<br/>
For consumable items you should consume items immediatly after purchase finished in listener method.
```actionscript
// making the purchase, Iab should be initialized first
Iab.instance.addEventListener(IabEvent.PURCHASE_FINISHED, iabPurchaseFinishedHandler);
Iab.instance.purchase(sku, Iab.ITEM_TYPE_INAPP, payload);
...
function iabPurchaseFinishedHandler(event:IabEvent):void {
	trace("BillingManager ::: iabPurchaseFinishedHandler", event.result.message);
	Iab.instance.removeEventListener(IabEvent.PURCHASE_FINISHED, iabPurchaseFinishedHandler);
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

# Step 5 : Consume purchase items:
For non-consumable item not needs to using this method.
```actionscript
function consume(sku:String):void {
	trace("BillingManager ::: consume", sku);
	Iab.instance.addEventListener(IabEvent.CONSUME_FINISHED, iabConsumeFinishedHandler);
	Iab.instance.consume(sku);
}

function iabConsumeFinishedHandler(event:IabEvent):void {
	trace("BillingManager ::: iabConsumeFinishedHandler", event.result.message);
	Iab.instance.removeEventListener(IabEvent.CONSUME_FINISHED, iabConsumeFinishedHandler);
	if (!event.result.succeed) {
	    trace("iabConsumeFinishedHandler failed to consume:", event.result.message);
	    return;
	}
}
```
# Step 6 : Manifest Edition :
Add Billing permissions based on selected market
Add the following lines to your AIR Aplication-app.xml file inside &lt;manifestAdditions&gt;

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
```

Add extension id
Extension ID: com.gerantech.extensions.iabilling
```xml
<extensions>
     <extensionID>com.gerantech.extensions.iabilling</extensionID>
</extensions>
```



# Testing
http://developer.android.com/google/play/billing/billing_testing.html


# Misc
ANE is build for AIR 18.0+, in order to rebuild for another version do the following:<br />
- edit "air\extension.xml" and change 18.0 in very first line to any X.x you need;<br />
- edit "package.bat" and in the very last line change path from AIR 18.0 SDK to any AIR X.x SDK you need;<br />
- execute "package.bat" to repack the ANE.<br />

