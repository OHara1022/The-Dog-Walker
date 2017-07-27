package com.ohara.thedogwalker.welcomeActivity;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import com.ohara.thedogwalker.R;

public class WelcomeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);

        //get instance of walker fragment
        WelcomeFragment welcomeFragment = WelcomeFragment.newInstance();
        getFragmentManager().beginTransaction().replace(R.id.welcomeContainer, welcomeFragment, WelcomeFragment.WELCOME_TAG).commit();
    }


}
