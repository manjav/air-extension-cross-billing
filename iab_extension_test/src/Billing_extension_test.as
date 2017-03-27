package
{
	import com.pozirk.payment.android.InAppPurchase;
	import com.pozirk.payment.android.InAppPurchaseDetails;
	import com.pozirk.payment.android.InAppPurchaseEvent;
	import com.pozirk.payment.android.InAppSkuDetails;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Billing_extension_test extends Sprite
	{
		private var _iap:InAppPurchase;

		private var textField:TextField;
		
		public function Billing_extension_test()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
						
			var initButton:Sprite = addButton(0x000000,10);
			initButton.addEventListener(MouseEvent.CLICK, init_clickHandler);
			
			var purchaseButton:Sprite = addButton(0xFF00000,160);
			purchaseButton.addEventListener(MouseEvent.CLICK, purchase_clickHandler);
			
			var restoreButton:Sprite = addButton(0x00FF00,360);
			restoreButton.addEventListener(MouseEvent.CLICK, restore_clickHandler);
			
			var consumeButton:Sprite = addButton(0x0000FF,560);
			consumeButton.addEventListener(MouseEvent.CLICK, consume_clickHandler);		
		}
		
		private function addButton(param0:int, param2:int):Sprite
		{
			var ret:Sprite = new Sprite();
			ret.graphics.beginFill(param0);
			ret.graphics.drawRect(10,param2,300,140);
			addChild(ret);
			return ret;
		}		
		
		
		
		protected function init_clickHandler(event:MouseEvent):void
		{
			var base64Key:String, bindURL:String, packageURL:String;
			var market:String = "cafebazaar";
			switch(market)
			{
				case "google":
					base64Key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkoD4iDkNchN1PCNUwUH53C5V8YETzwcLsFoZ1kV55H1jquH4XG99FD7dw21DbhNGjJyxfbiSxrLputdni9mLc/rGjNmtgcMZLuf7Nnrva7orbS9+2AVulAsQWp6I0gEaUungeijBwKVp4YjlrQn9woRxZg/wAjPp1SsJ8H229j1u/dHcOufm1sMAb/JRpOaG3XicC91MUG1fbP8P9mPBIEP8AD8ryYI/W3P4cJtpJOwdZKgCsnez3GCHnliSYezd/4Td5hFDh67vnhNRZFgtyNhuMiVAZgK8FMXy48kVV6GwS2Rd58pr5nLERcrR5s/sYDJlDKqYcNffT8QIYy+GmwIDAQAB";
					bindURL = "com.android.vending.billing.InAppBillingService.BIND";
					packageURL = "com.android.vending";
					break;
				
				case "cafebazaar":
					base64Key = "MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwC84yMBRhSKAekQuBctTKxXiEiLKVrAw5PgeR+olHVy+jlYuCDahmQkSS6Cjf/eIHZUbI822F09jMZv4Niskxeei89w/zeGURqkn1IX+BRKO0fuZjfYIy3fcJX7UG/NIVkkvSZFvwT0fAwXHQaCEGjijzRqKReaIy2N9Yoon+nzuV80Yu6XG5CrV2qyQ+ck9rZe13osDd8afzfSoS5xorK4/PiFgJ34Qq0vE08WWAMCAwEAAQ==";
					bindURL = "ir.cafebazaar.pardakht.InAppBillingService.BIND";
					packageURL = "com.farsitel.bazaar";
					break;
				
				case "market":
					base64Key = "MIGeMA0GCSqGSIb3DQEBAQUAA4GMADCBiAKBgJMpfaXOx6tVOeg4RE63Z8GVqOiT8MigKw42dcTfwKuzo9n8vjjBtLX5XSatS0bsnkfBuNIq/w+FsXYFrHpU5TA/C0OMKBAr8BxCURX4LlYosQrXCBGzdKpGm242h+Oyco0Z9phXNs3jxBSe1qj9SKzofWObgPAUlUOjGL3gpfUZAgMBAAE=";
					bindURL = "ir.mservices.market.InAppBillingService.BIND";
					packageURL = "ir.mservices.market";
					break;
				
				case "cando":
					base64Key = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCC3hfXAyBj1bnrlNilrtdW4U1qkI8FP27usDKinH9w/XQddtbyn/yY+Qpgi9rZqGEiy8g7jqZr6YZAM3hJCB4V6dvZPwdHmF2AgtbQJQGYbk4lfhfzQl+UGUtsRJtiaPoJZ7ZTYFlqlAz0tRR83w5y0NdkHyqnaJYyOBvI9jgmXwIDAQAB";
					bindURL = "com.ada.market.service.payment.BIND";
					packageURL = "com.ada.market";
					break;
			}			
			
			_iap = new InAppPurchase();
			_iap.addEventListener(InAppPurchaseEvent.INIT_SUCCESS, onInitSuccess);
			_iap.addEventListener(InAppPurchaseEvent.INIT_ERROR, onInitError);
			_iap.init(base64Key, bindURL, packageURL);
		}
		
		protected function onInitSuccess(event:InAppPurchaseEvent):void
		{
			trace("Billing_extension_test.onInitSuccess(event)", event.data);
		}
		
		protected function onInitError(event:InAppPurchaseEvent):void
		{
			trace("Billing_extension_test.onInitError(event)", event.data);
		}
		
		
		//> making the purchase, _iap should be initialized first ---------------------------------------------------------------------
		protected function purchase_clickHandler(event:MouseEvent):void
		{
			_iap.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESS, onPurchaseSuccess);
			_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ALREADY_OWNED, onPurchaseSuccess);
			_iap.addEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
			_iap.purchase("air.com.gerantech.trivialdrivesample.gas", InAppPurchaseDetails.TYPE_INAPP);
		}
		
		protected function onPurchaseSuccess(event:InAppPurchaseEvent):void
		{
			trace("onPurchaseSuccess", event.data); //product id
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreSuccess);
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);
			_iap.restore([event.data]);
			/*var purchase:InAppPurchaseDetails = _iap.getPurchaseDetails("air.com.gerantech.trivialdrivesample.gas");
			if(purchase)
			{
				//AndroidExtension.instance.showToast("Purchase: "+ purchase._json, 1);
				trace(purchase._json)
			}*/
		}
		
		protected function onPurchaseError(event:InAppPurchaseEvent):void
		{
			trace("onPurchaseError", event.data); //trace error message
		}
		
		
		//> getting purchased product details, _iap should be initialized first --------------------------------------------------
		protected function restore_clickHandler(event:MouseEvent):void
		{
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreSuccess);
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);
			_iap.restore(); //restoring purchased in-app items and subscriptions
		}
		
		protected function onRestoreSuccess(event:InAppPurchaseEvent):void
		{
			//getting details of purchase: time, etc.
			var purchase:InAppPurchaseDetails = _iap.getPurchaseDetails("air.com.gerantech.trivialdrivesample.gas");
			if(purchase)
			{
				//AndroidExtension.instance.showToast("Purchase: "+ purchase._json, 1);
				trace(purchase._json)
			}
			trace("onRestoreSuccess", event.data); //product id
		}
		
		protected function onRestoreError(event:InAppPurchaseEvent):void
		{
			trace("onRestoreError", event.data); //trace error message
		}
		
		//> getting purchased and not purchased product details ----------------------------------------------------------------------
		protected function restoreAll_clickHandler(event:MouseEvent):void
		{
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_SUCCESS, onRestoreAllSuccess);
			_iap.addEventListener(InAppPurchaseEvent.RESTORE_ERROR, onRestoreError);
			
			var items:Array = ["my.product.id1", "my.product.id2", "my.product.id3"];
			
			var subs:Array = ["my.subs.id1", "my.subs.id2", "my.subs.id3"];
			_iap.restore(items, subs); //restoring purchased + not purchased in-app items and subscriptions
		}
		
		
		protected function onRestoreAllSuccess(event:InAppPurchaseEvent):void
		{
			//getting details of product: time, etc.
			var skuDetails1:InAppSkuDetails = _iap.getSkuDetails("my.product.id1");
			
			//getting details of product: time, etc.
			var skuDetails2:InAppSkuDetails = _iap.getSkuDetails("my.subs.id1");
			
			//getting details of purchase: time, etc.
			var purchase:InAppPurchaseDetails = _iap.getPurchaseDetails("my.purchased.product.id");
		}
		
		
		
		//> consuming purchased item ------------------------------------------------------------------------------------------
		protected function consume_clickHandler(event:MouseEvent):void
		{
			_iap.addEventListener(InAppPurchaseEvent.CONSUME_SUCCESS, onConsumeSuccess);
			_iap.addEventListener(InAppPurchaseEvent.CONSUME_ERROR, onConsumeError);
			_iap.consume("air.com.gerantech.trivialdrivesample.gas");
		}
		
		protected function onConsumeSuccess(event:InAppPurchaseEvent):void
		{
			trace("onConsumeSuccess", event.data); //trace error message				
		}
		
		protected function onConsumeError(event:InAppPurchaseEvent):void
		{
			trace("onConsumeError", event.data); //trace error message				
		}
	}
}