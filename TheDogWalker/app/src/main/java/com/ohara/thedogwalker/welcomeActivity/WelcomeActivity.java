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

    FirebaseAuth mAuth;
    DatabaseReference mReference;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome);

        //instance of firebase auth
        mAuth = FirebaseAuth.getInstance();
        //instance of database
        mReference = FirebaseDatabase.getInstance().getReference().child("users");

        WelcomeFragment welcomeFragment = WelcomeFragment.newInstance();
        getFragmentManager().beginTransaction().replace(R.id.welcomeContainer, welcomeFragment, WelcomeFragment.WELCOME_TAG).commit();

        //listener to save user data, gets hit after create user method finishes
        mAuth.addAuthStateListener(new FirebaseAuth.AuthStateListener() {
            @Override
            public void onAuthStateChanged(@NonNull FirebaseAuth firebaseAuth) {

                //get current user
                FirebaseUser user = firebaseAuth.getCurrentUser();

                //check user is not null
                if (user != null) {
                    //dev
                    Log.i(TAG, "onAuthStateChanged: ONBOARDING" + user.getUid());

                    //holder for users uid
                    String uid = user.getUid();

                    Log.i(TAG, "onAuthStateChanged:  ONBOARDING" + uid);

                }
            }
        });
    }



}
