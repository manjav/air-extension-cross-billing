# About
air-extension-inappbilling is an Adobe AIR native extension (ANE) to purchase products for multiple markets (locals and global).<br />

![alt text](https://www.abelandcole.co.uk/media/2529_17826_z.jpg)


## If you dont need multiple stores supporting, you can use [AndroidInAppPurchase](https://github.com/pozirk/AndroidInAppPurchase)


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
Extension ID: com.pozirk.AndroidInAppPurchase<br />
Add "iab-extension.ane" and "air\InAppPurchase\bin\Billing_extension_as3_lib.swc" from package folder to your AIR project.<br />
Add the following lines to your AIR Aplication-app.xml file inside &lt;manifestAdditions&gt; section:<br />
<br />
&lt;application android:enabled="true"&gt;<br />
	&lt;activity android:name="com.pozirk.payment.BillingActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" android:background="#30000000" /&gt;<br />
&lt;/application&gt;<br />

For Google Play Store <br />
&lt;uses-permission android:name="com.android.vending.BILLING" /&gt;<br />

For CafeBazaar <br />
&lt;uses-permission android:name="com.farsitel.bazaar.permission.PAY_THROUGH_BAZAAR" /&gt;<br />

For Myket <br />
&lt;uses-permission android:name="ir.mservices.market.BILLING" /&gt;<br />

For CanDo (no needs to uses-permission) <br />

# Examples
```actionscript
import com.pozirk.payment.android.InAppPurchase;
import com.pozirk.payment.android.InAppPurchaseEvent;
import com.pozirk.payment.android.InAppPurchaseDetails;

...

protected var _iap:InAppPurchase = new InAppPurchase();

...

// initialization of InAppPurchase
var base64Key:String, bindURL:String, packageURL:String;
var market:String = "google";
switch(market)
{
	case "google":
		base64Key = "YOUR_LICENSE_KEY_FOR_THE_APPLICATION";
		bindURL = "com.android.vending.billing.InAppBillingService.BIND";
		packageURL = "com.android.vending";
		break;

	case "cafebazaar":
		base64Key = "YOUR_LICENSE_KEY_FOR_THE_APPLICATION";
		bindURL = "ir.cafebazaar.pardakht.InAppBillingService.BIND";
		packageURL = "com.farsitel.bazaar";
		break;

	case "mayket":
		base64Key = "YOUR_LICENSE_KEY_FOR_THE_APPLICATION";
		bindURL = "ir.mservices.market.InAppBillingService.BIND";
		packageURL = "ir.mservices.market";
		break;

	case "cando":
		base64Key = "YOUR_LICENSE_KEY_FOR_THE_APPLICATION";
		bindURL = "com.ada.market.service.payment.BIND";
		packageURL = "com.ada.market";
		break;
}			

_iap = new InAppPurchase();
_iap.addEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInitSuccess);
_iap.addEventListener(InAppPurchaseEvent.INIT_ERROR, onInitError);
_iap.init(base64Key, bindURL, packageURL);

protected function onInitSuccess(event:InAppPurchaseEvent):void
{
	trace("Billing_extension_test.onInitSuccess(event)", event.data);
}

protected function onInitError(event:InAppPurchaseEvent):void
{
	trace("Billing_extension_test.onInitError(event)", event.data);
}

// making the purchase, _iap should be initialized first
_iap.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseSuccess);
_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ALREADY_OWNED, onPurchaseSuccess);
_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
_iap.purchase("my.product.id", InAppPurchaseDetails.TYPE_INAPP);

protected function onPurchaseSuccess(event:InAppPurchaseEvent):void
{
	trace(event.data); //product id
}

protected function onPurchaseError(event:InAppPurchaseEvent):void
{
	trace(event.data); //trace error message
}

// getting purchased product details, _iap should be initialized first
_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreSuccess);
_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);
_iap.restore(); //restoring purchased in-app items and subscriptions

...

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



## Thanks to
[pozirk](https://github.com/pozirk/AndroidInAppPurchase)
