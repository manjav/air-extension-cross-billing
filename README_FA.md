# معرفی
<br/>این افزونه برای  خرید درون برنامه ای کاربران اندروید در بازی های و اپلیکیشن هایی که با ادوبی ایر توسعه یافته اند تهیه شده است. این افزونه شما را از تهیه و نصب کتابخانه سایر مارکت ها بی نیاز کرده و فقط با تغییرات در کد و مانیفست می توانید علاوه بر استفاده برای مارکت گوگل، سایرمارکت های محلی نظیر کافه بازار، مایکت یا ... را در بازی یا نرم افزار خود فعال کنید.
[.........English Readme..........](https://github.com/manjav/air-extension-inappbilling/edit/master/README.md)

دو نوع پروژه برای تست خرید موجود است:
1. [نرم افزار فلش](https://github.com/manjav/air-extension-inappbilling/tree/master/project_templates/flash) برای طراحان فلش. قابل استفاده در نرم افزار فلش یا همان انیمیت.
2. [فقط بصورت کد](ttps://github.com/manjav/air-extension-inappbilling/tree/master/project_templates/pure_as3) برای برنامه نویسان فلش، قابل استفاده در فلش بیلدر، فلش دولوپ و سایر IDE ها.

![تصویر بازی](https://github.com/manjav/air-extension-inappbilling/blob/master/files/TrivialDrive_FA.png)

#امکانات
خرید درون برنامه نسل سه گوگل
مصرف یا بازیابی خریدهای قبلی مصرف نشده
امکان استفاده اقلام بصورت پریمیوم
امکان استفاده اقلام بصورت اشتراک مدت دار

# مستندات
Please, read docs and try ANE before asking any questions.<br/>
http://developer.android.com/google/play/billing/index.html<br />
http://help.adobe.com/en_US/air/extensions/index.html<br />


# قدم اول - وارد کردن فایل ane به پروژه:
فایل [iabilling.ane](https://github.com/manjav/air-extension-inappbilling/blob/master/package/iabilling.ane) را به پروژه خود اضافه کنید برای آشنایی با این بخش از لینک زیر کمک بگیرید..<br />
<b>آموزش:</b> [How to embed ANEs into FlashBuilder, Flash(Animate) and FlashDevelop](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)

# قدم دوم - تعریف مارکت مورد نظر به افزونه
همه اقلامی که در بازی وجود دارند را به لیست _items اضافه کنید.

هر مارکت برای هر بازی یا اپ یک کد  base64key اختصاص میده که اون رو از مارکت مورد نظر دریافت کنید و در بخش مورد نظر با عبارت '==5AMP1E8A5E64KE7==' جابجا کنید.
همچنین اگر یک مارکت جدید به افزونه اضافه می کنید  'bindeURL' و 'packageURL' اون رو هم تهیه و به خط بخش های مربوطه اضافه کنید. ما برای مثال گوگل، کافه بازار، مایکت و کندو رو آوردیم که نیازی نیست تهیه کنید.
<b>توجه داشته باشید حتما در فدم ششم باید سطح دسترسی مارکت انتخابی رو تغییر بدید</b>

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

# قدم سوم - بازیابی اقلام مصرف نشده و مصرف آن ها پس از شروع به کار نرم افزار:
کاهی اوقات فرآیند خرید به دلایل مختلف دچار مشکل شده و خرید بصورت کامل انجام نمی شود. شما میتوانید سکه یا جواهر یا هر چیزی که ما جایزه اسمشو می گذاریم، به ازای خرید به بازیکن یا کاربر اعطا می کنید را به پس از فرایند مصرف موکول کنید و اگر در این فرایند کاربران دچار مشکل شدند پس از باز و بسته کردن نرم افزار یا بازی آن را بازیابی و مصرف، جایزه مورد نظر بازیکن را به او اعطا کنید.
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

# قدم چهارم - خرید:
وقتی کاربر روی دکمه خرید میزنه باید این بخش صدا زده بشه، یادتون باشه برای اقلام مصرفی حتما باید قبل از خرید مجدد همون نوع، باید اون رو مصرف کنید که در قدم سوم و پنجم توضیح دادیم.
در کد هم مشاهده می کنید که پس از موفقیت در خرید اقدام به مصرف اقلام مصرفی میشه
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

# قدم پنجم - مصرف خرید:
توجه داشته باشید اقلام غیر مصرفی مثل پریمیوم (عدم مشاهده تبلیغات و ...) نیاز به فراخوانی این بخش نخواهند داشت.
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
# قدم هفتم - تغییرات مانیفست:
توجه داشته باشید در قدم دوم شما مارکت مورد نظر را تعیین می کردید اکنون نیز می بایست سطح دسترسی مارکت مورد نظر را در مانیفست اضافه کنید.
به فایل aplication-app.xml و بخش &lt;manifestAdditions&gt; بروید و بر اساس مارکت انتخابی تغییرات را اعمال کنید. توجه داشته باشید فقط سطح دسترسی یک مارکت را در مانیفست بصورت فعال باقی بگذارید.

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

شناسه افزونه را به انتهای مانیفست اضافه کنید.
Extension ID: com.gerantech.extensions.iabilling
```xml
<extensions>
     <extensionID>com.gerantech.extensions.iabilling</extensionID>
</extensions>
```



# آزمایش:
http://developer.android.com/google/play/billing/billing_testing.html


# سایر:
ANE is build for AIR 18.0+, in order to rebuild for another version do the following:<br />
- edit "air\extension.xml" and change 18.0 in very first line to any X.x you need;<br />
- edit "package.bat" and in the very last line change path from AIR 18.0 SDK to any AIR X.x SDK you need;<br />
- execute "package.bat" to repack the ANE.<br />

