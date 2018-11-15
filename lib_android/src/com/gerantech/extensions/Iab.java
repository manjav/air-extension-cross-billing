package com.gerantech.extensions;

import org.json.JSONException;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.gerantech.extensions.util.IabHelper;
import com.gerantech.extensions.util.IabResult;
import com.gerantech.extensions.util.Inventory;
import com.gerantech.extensions.util.Purchase;
import com.gerantech.extensions.util.SkuDetails;

public class Iab 
{
	static final int RC_REQUEST = 10001;
    public static final String TAG = "IAB";
    public IabExtensionContext aeContext;
    public Inventory inventory;
    
	protected static Iab _instance = null;
	private Activity purchaseActivity;
	private IabHelper mHelper;
	
	public void startSetup(String base64EncodedPublicKey, String bindURL, String packageURL, Boolean debugLogging)
	{
        // Some sanity checks to see if the developer (that's you!) really followed the
        // instructions to run this sample (don't put these checks on your app!)
        if( base64EncodedPublicKey.contains("CONSTRUCT_YOUR") )
        	dispatchResult("setupFinished", new IabResult(IabHelper.BILLING_RESPONSE_RESULT_DEVELOPER_ERROR, "Please put your app's public key in MainActivity.java. See README."));

        if( aeContext.getActivity().getPackageName().startsWith("com.example") )
        	dispatchResult("setupFinished", new IabResult(IabHelper.BILLING_RESPONSE_RESULT_DEVELOPER_ERROR, "Please change the sample's package name! See README."));

        // Create the helper, passing it our context and the public key to verify signatures with
        Log.d(TAG, "Creating IAB helper.");
        mHelper = new IabHelper(aeContext.getActivity().getApplicationContext(), base64EncodedPublicKey, bindURL, packageURL);

        // enable debug logging (for a production application, you should set this to false).
        mHelper.enableDebugLogging(debugLogging);

        // Start setup. This is asynchronous and the specified listener
        // will be called once setup completes.
        mHelper.startSetup(new IabHelper.OnIabSetupFinishedListener()
        {
            public void onIabSetupFinished(IabResult result)
            {
                dispatchResult("setupFinished", result);
            }
        });
	}
	
	public void queryInventory()
	{
        if( !isSetup("queryInventoryFinished") ) return;
        mHelper.queryInventoryAsync(mGotInventoryListener);
	}
	// Listener that's called when we finish querying the items and subscriptions we own
    IabHelper.QueryInventoryFinishedListener mGotInventoryListener = new IabHelper.QueryInventoryFinishedListener() 
    {
        public void onQueryInventoryFinished(IabResult result, Inventory inventory) 
        {
            // Have we been disposed of in the meantime? If so, quit.
            if( !isSetup("queryInventoryFinished") ) return;
			Iab.getInstance().inventory = inventory;
            dispatchResult("queryInventoryFinished", result);
        }
    };
    
	public void launchPurchaseFlow(String sku, String itemType, String payload) 
	{
        if( !isSetup("purchaseFinished") ) return;
        if( inventory == null )
        {
        	dispatchResult("purchaseFinished", new IabResult(IabHelper.IABHELPER_NOT_INITIALIZED, "inventory not found. please run 'queryInventory' method."));
        	return;
        }
		Intent intent = new Intent(Iab.getInstance().aeContext.getActivity(), IabActivity.class);
		Bundle mBundle = new Bundle();
		mBundle.putString("sku", sku);
		mBundle.putString("itemType", itemType);
		mBundle.putString("payload", payload);
		intent.putExtras(mBundle);
		Iab.getInstance().aeContext.getActivity().startActivity(intent);
    }
	public boolean handlePurchaseResult(int requestCode, int resultCode, Intent data)
	{
		return mHelper.handleActivityResult(requestCode, resultCode, data);
	}    
	public void purchase(Activity activity, String sku, String itemType, String payload)
	{
		purchaseActivity = activity;
		//if(mHelper.isAsyncInProgress() == false) //to prevent starting another async operation
		//{
		//	_act = act;
		mHelper.launchPurchaseFlow(activity, sku, itemType, RC_REQUEST, mPurchaseFinishedListener, payload);
		//}
	}
    // Callback for when a purchase is finished
    IabHelper.OnIabPurchaseFinishedListener mPurchaseFinishedListener = new IabHelper.OnIabPurchaseFinishedListener() {
        public void onIabPurchaseFinished(IabResult result, Purchase purchase) {
            Log.d(TAG, "Purchase finished: " + result + ", purchase: " + purchase);

            // if we were disposed of in the meantime, quit.
            if( !isSetup("purchaseFinished") ) return;
            
            if( result.isSuccess() )
            {
            	result.setData( purchase.getOriginalJson() );
            	Iab.getInstance().inventory.addPurchase(purchase);
                if( !Iab.getInstance().inventory.hasDetails(purchase.getSku()) )
                {
	            	String jsonSkuDetails = "{\"productId\":\"" + purchase.getSku() + "\", \"type\":\"" + purchase.getItemType() + "\"";
	            	jsonSkuDetails += ", \"title\":\"no title\"";
	            	jsonSkuDetails += ", \"description\":\"no description\"";
	            	jsonSkuDetails += ", \"price\":0}";
	                Log.i(TAG, result.isSuccess() + " jsonSkuDetails: " + jsonSkuDetails);
		           	try {
		           		Iab.getInstance().inventory.addSkuDetails(new SkuDetails(purchase.getItemType(), jsonSkuDetails));
					} catch (JSONException e) { e.printStackTrace(); }
                }
            }
            
            if( Iab.getInstance().purchaseActivity != null )
            	Iab.getInstance().purchaseActivity.finish();
            dispatchResult("purchaseFinished", result);
        }
    };	
	public void endPurchase(Activity act)
	{
//		if(act == _act) //I guess :), that Activities are created and destroyed asynchronously, so don't let to null wrong Activity
//		{
//			_act = null;
//			mHelper.flagEndAsync();
//		}
	}

	
	
    public void consume (String sku)
    {
        if( !isSetup("consumeFinished") ) return;
        if( inventory == null )
        {
        	dispatchResult("consumeFinished", new IabResult(IabHelper.IABHELPER_INVALID_CONSUMPTION, "inventory not found. please run 'queryInventory' method."));
        	return;
        }
        Purchase purchase = inventory.getPurchase(sku);
        if( purchase == null )
        {
        	dispatchResult("consumeFinished", new IabResult(IabHelper.IABHELPER_INVALID_CONSUMPTION, "purchase not found."));
        	return;
        }
        mHelper.consumeAsync(purchase, mConsumeFinishedListener);
    }
    IabHelper.OnConsumeFinishedListener mConsumeFinishedListener = new IabHelper.OnConsumeFinishedListener() {
        public void onConsumeFinished(Purchase purchase, IabResult result) {
            Log.d(TAG, "Consumption finished. Purchase: " + purchase + ", result: " + result);
            // if we were disposed of in the meantime, quit.
            if( !isSetup("consumeFinished") ) return;
            result.setData( purchase.getOriginalJson() );
            dispatchResult("consumeFinished", result);
        }
    };  
    
    private void dispatchResult(String type, IabResult result)
    {
        Log.d(TAG, type + "=> result: " + result);
    	Iab.getInstance().aeContext.dispatchStatusEventAsync(type, result.toJsonString());
    }
	private boolean isSetup(String status)
	{
		if( mHelper == null )
		{
			Iab.getInstance().aeContext.dispatchStatusEventAsync(status, new IabResult(IabHelper.IABHELPER_NOT_INITIALIZED, "in-app billing is not setup yet.").toJsonString());
			return false;
		}
		return true;
	}
	public static Iab getInstance()
	{
		if( _instance == null )
			_instance = new Iab();
		return _instance;
	}
}