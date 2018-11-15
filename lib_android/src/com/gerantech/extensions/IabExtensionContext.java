package com.gerantech.extensions;

import java.util.HashMap;
import java.util.Map;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class IabExtensionContext extends FREContext //implements ActivityResultCallback, StateChangeCallback {
{
	
//	private AndroidActivityWrapper aaw;

//	public AndroidExtensionContext() {
//		aaw = AndroidActivityWrapper.GetAndroidActivityWrapper();
//		aaw.addActivityResultListener(this);
//		aaw.addActivityStateChangeListner(this);
//	}
//
//	@Override
//	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
//	}
//
//	@Override
//	public void onActivityStateChanged(ActivityState state) {
//		switch (state) {
//		case STARTED:
//		case RESTARTED:
//		case RESUMED:
//		case PAUSED:
//		case STOPPED:
//		case DESTROYED:
//		}
//		Log.w("A.N.E", "State :  " + state.toString());
//	}
//
//	@Override
//	public void onConfigurationChanged(Configuration paramConfiguration) {
//	}

	@Override
	public void dispose() {
	}

	@Override
	public Map<String, FREFunction> getFunctions() {

		Log.w("A.N.E", "Map function called");

		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("iab", new IabFunction());
		return functionMap;
	}
}