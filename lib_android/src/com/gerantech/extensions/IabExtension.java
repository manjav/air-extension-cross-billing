package com.gerantech.extensions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;




public class IabExtension implements FREExtension
{
    /** Called when the activity is first created. */
	@Override
	public FREContext createContext(String arg0)
	{
		// TODO Auto-generated method stub
		Log.w("A.N.E", "Inside Create Context");
		return new IabExtensionContext();
	}

	@Override
	public void dispose() 
	{
		// TODO Auto-generated method stub
	}

	@Override
	public void initialize()
	{
		// TODO Auto-generated method stub
	}
}