package com.ohara.thedogwalker.walkerHome;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.ohara.thedogwalker.R;

public class WalkerHomeActivity extends AppCompatActivity {

    //TAG
    private static final String TAG = "WalkerHomeActivity";
    //result code
    private static final int REQUEST_DETAILS = 0x01001;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_walker_home);
    }
}
