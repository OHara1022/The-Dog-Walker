package com.ohara.thedogwalker.login;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.google.firebase.auth.FirebaseAuth;
import com.ohara.thedogwalker.register.FormActivity;
import com.ohara.thedogwalker.R;

public class LoginActivity extends AppCompatActivity implements View.OnClickListener{

    //tag
    private static final String TAG = "LoginActivity";

    //stored properties
    Button registerBtn;
    Button loginBtn;
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


        //set onClickListener
        registerBtn.setOnClickListener(this);
        loginBtn.setOnClickListener(this);
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
