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

package com.pozirk.payment;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class InitFunction implements FREFunction
{	
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		ExtensionContext ctx = (ExtensionContext)arg0;
		
		try
		{
			String base64EncodedPublicKey = arg1[0].getAsString();
			String bindURL = arg1[1].getAsString();
			String packageURL = arg1[2].getAsString();
		
			Billing billing = Billing.getInstance();
			billing.init(arg0.getActivity(), ctx, base64EncodedPublicKey, bindURL, packageURL);
		}
		catch (Exception e)
		{ 
			e.printStackTrace();
		} 
		
		return null;
	}
}