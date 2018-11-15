package com.gerantech.extensions.iab
{
public class SkuDetails
{
public var itemType:String;
public var sku:String;
public var type:String;
public var price:String;
public var title:String;
public var description:String;
public var json:String;
public function SkuDetails(json:Object)
{
	var j:Object;
	if( json is String )
		j = JSON.parse(json+"");
	else
		j = json;
	
	itemType = j.itemType;
	sku = j.productId;
	type = j.type;
	price = j.price;
	title = j.title;
	description = j.description;
	this.json = JSON.stringify(j);
}
}
}