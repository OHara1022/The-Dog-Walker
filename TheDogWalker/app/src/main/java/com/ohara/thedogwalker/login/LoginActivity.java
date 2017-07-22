package com.ohara.thedogwalker.login;

import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.ohara.thedogwalker.register.FormActivity;
import com.ohara.thedogwalker.R;

public class LoginActivity extends AppCompatActivity implements View.OnClickListener{

    //tag
    private static final String TAG = "LoginActivity";

    //stored properties
    Button registerBtn;
    Button loginBtn;
    Button forgotPassword;
    EditText mEmailEditText;
    EditText mPasswordEditText;
    private FirebaseAuth mAuth;
    private FirebaseAuth.AuthStateListener mAuthListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        //init email & password fields
        mEmailEditText = (EditText) findViewById(R.id.emailEditText);
        mPasswordEditText = (EditText) findViewById(R.id.passwordEditText);

        //init buttons
        registerBtn = (Button) findViewById(R.id.registerButton);
        loginBtn = (Button) findViewById(R.id.loginButton);
        forgotPassword = (Button) findViewById(R.id.forgetButton);

        //set onClickListener
        registerBtn.setOnClickListener(this);
        loginBtn.setOnClickListener(this);
        forgotPassword.setOnClickListener(this);

        //init auth state listener
        mAuthListener = new FirebaseAuth.AuthStateListener() {

            @Override
            public void onAuthStateChanged(@NonNull FirebaseAuth firebaseAuth) {
                //get current user
                FirebaseUser user = firebaseAuth.getCurrentUser();

                //check is user has a value
                if (user != null) {
                    //dev
                    Log.d(TAG, "onAuthStateChanged: SIGNED IN " + user.getUid());

                } else {
                    //dev
                    Log.d(TAG, "onAuthStateChanged: SIGNED OUT");

                    //clean text fields on return to home screen
                    mEmailEditText.setText("");
                    mPasswordEditText.setText("");
                }
            }
        };
    }


    @Override
    public void onClick(View v) {

        switch (v.getId()){

            case R.id.registerButton:

                //dev
                Log.i(TAG, "onClick: REGISTER");


                Intent formIntent = new Intent(LoginActivity.this, FormActivity.class);
                startActivity(formIntent);
        }
return;
    }
}
