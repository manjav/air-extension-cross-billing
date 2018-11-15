package com.gerantech.extensions;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class IabActivity extends Activity
{
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		//> make a nice spinning circle in the center of the screen
		/*ProgressBar progress = new ProgressBar(this, null, android.R.attr.progressBarStyleLarge);
		RelativeLayout layout = new RelativeLayout(this);
		RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
		params.addRule(RelativeLayout.CENTER_IN_PARENT);
		layout.addView(progress, params);
		setContentView(layout);*/

		Bundle extras = getIntent().getExtras();
		Iab.getInstance().purchase(this, extras.getString("sku"), extras.getString("itemType"), extras.getString("payload"));
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		// Pass on the activity result to the helper for handling
		if( !Iab.getInstance().handlePurchaseResult(requestCode, resultCode, data) )
		{
			// not handled, so handle it ourselves (here's where you'd
			// perform any handling of activity results not related to in-app
			// billing...
			super.onActivityResult(requestCode, resultCode, data);
		}
	}

	@Override
	public void onDestroy() //called (so Activity is destroyed) when app reopened from app drawer, what is suxxx
	{
		Iab.getInstance().endPurchase(this); //we were in the middle of purchase, reset it
		super.onDestroy();
	}
}