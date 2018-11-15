package com.gerantech.extensions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class IabFunction implements FREFunction 
{
	@Override
	public FREObject call(FREContext context, FREObject[] args) 
	{
		if( context != null )
			Iab.getInstance().aeContext = (IabExtensionContext) context;
try {
		String command = args[0].getAsString();
		Log.i(Iab.TAG, "IabFunction called ... " + command);
		if ( command.equalsIgnoreCase("startSetup") )
		{
			String base64EncodedPublicKey = args[1].getAsString();
			String bindURL = args[2].getAsString();
			String packageURL = args[3].getAsString();
			boolean debugLogging = args[4].getAsBool();
			Iab.getInstance().startSetup(base64EncodedPublicKey, bindURL, packageURL, debugLogging);
			return null;
		}
		
		if ( command.equalsIgnoreCase("queryInventory") )
		{
			Iab.getInstance().queryInventory();
			return null;
		}
		
		if ( command.equalsIgnoreCase("purchase") )
		{
			Iab.getInstance().launchPurchaseFlow(args[1].getAsString(), args[2].getAsString(), args[3].getAsString());
			return null;
		}
		
		if ( command.equalsIgnoreCase("consume") )
		{
			Iab.getInstance().consume(args[1].getAsString());
			return null;
		}
		
		if ( command.equalsIgnoreCase("getPurchase") )
		{
			if( Iab.getInstance().inventory == null || !Iab.getInstance().inventory.hasPurchase(args[1].getAsString()) )
				return null;
			return FREObject.newObject(Iab.getInstance().inventory.getPurchase(args[1].getAsString()).getOriginalJson());
		}
		
		if ( command.equalsIgnoreCase("getSkuDetails") )
		{
			if( Iab.getInstance().inventory == null || !Iab.getInstance().inventory.hasDetails(args[1].getAsString()) )
				return null;
			return FREObject.newObject(Iab.getInstance().inventory.getSkuDetails(args[1].getAsString()).getOriginalJson());
		}

} catch (Exception e1) { e1.printStackTrace(); }
	return null;
	}
}