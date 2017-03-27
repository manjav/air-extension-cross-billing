/* Copyright (c) 2013 Pozirk Games
 * http://www.pozirk.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.pozirk.payment.android 
{
	public class InAppPurchaseDetails
	{
		public static const TYPE_INAPP:String = "inapp"; //regular in-app item
		public static const TYPE_SUBS:String = "subs"; //subscription
		
		public var _type:String; //TYPE_INAPP or TYPE_SUBS
		public var _orderId:String;
		public var _packageName:String;
		public var _sku:String;
		public var _time:int;
		public var _purchaseState:String;
		public var _payload:String;
		public var _token:String;
		public var _json:String; //original json data with all the purchase details
		public var _signature:String;
		
		public function InAppPurchaseDetails() {}
	}
}