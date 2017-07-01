package com.ohara.thedogwalker;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class WelcomeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);

        WelcomeFragment welcomeFragment = WelcomeFragment.newInstance();
        getFragmentManager().beginTransaction().replace(R.id.welcomeContainer, welcomeFragment, WelcomeFragment.WELCOME_TAG).commit();
    }
}
