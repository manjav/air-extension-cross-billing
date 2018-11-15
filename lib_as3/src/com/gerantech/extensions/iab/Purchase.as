package com.gerantech.extensions.iab
{
public class Purchase
{
	public var itemType:String  // ITEM_TYPE_INAPP or ITEM_TYPE_SUBS
	public var orderId:String
	public var packageName:String
	public var sku:String
	public var purchaseTime:Number
	public var purchaseState:int
	public var developerPayload:String
	public var token:String
	public var signature:String
	public var json:String
	
public function Purchase(json:Object)
{
	var j:Object;
	if( json is String )
		j = JSON.parse(json+"");
	else
		j = json;
		
	itemType = j.itemType;
	orderId = j.orderId;
	packageName = j.packageName;
	sku = j.productId;
	purchaseTime = j.purchaseTime;
	purchaseState = j.purchaseState;
	developerPayload = j.developerPayload;
	token = j.purchaseToken;
	signature = j.signature;
	this.json = JSON.stringify(j);
}
}
}