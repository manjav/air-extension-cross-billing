package com.gerantech.extensions.iab
{
public class IabResult
{
public var response:int = -1;
public var message:String;
public var purchase:Purchase;

public function IabResult(response:int, message:String="", data:String=null)
{
	this.response = response;
	this.message = message;
	if( data != null )
		this.purchase = new Purchase(data);
}

public function setJson(json:String):void
{
	var j:Object = JSON.parse(json);
	response = j.response;
	message = j.message;
	if( j.data != null )
		this.purchase = new Purchase(j.data);
}
public function get succeed():Boolean
{
	return response == Iab.BILLING_RESPONSE_RESULT_OK;
}


}
}