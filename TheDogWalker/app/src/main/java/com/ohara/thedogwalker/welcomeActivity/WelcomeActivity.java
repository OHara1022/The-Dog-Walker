package com.ohara.thedogwalker.welcomeActivity;

import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.ohara.thedogwalker.R;

public class WelcomeActivity extends AppCompatActivity {

    private static final String TAG = "WelcomeActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);

        WelcomeFragment welcomeFragment = WelcomeFragment.newInstance();
        getFragmentManager().beginTransaction().replace(R.id.welcomeContainer, welcomeFragment, WelcomeFragment.WELCOME_TAG).commit();

    }



}
