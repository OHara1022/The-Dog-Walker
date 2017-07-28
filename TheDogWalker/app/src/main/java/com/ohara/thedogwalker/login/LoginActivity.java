package com.ohara.thedogwalker.login;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.support.annotation.NonNull;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.ohara.thedogwalker.register.FormActivity;
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.walkerHome.WalkerHomeActivity;

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

        mAuth = FirebaseAuth.getInstance();

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

//                    Intent walkerHome = new Intent(LoginActivity.this, WalkerHomeActivity.class);
//                    startActivity(walkerHome);

                } else {
                    //dev
                    Log.d(TAG, "onAuthStateChanged: SIGNED OUT");

                    //clean text fields on return to home screen
                    mEmailEditText.setText("");
                    mPasswordEditText.setText("");
                }
            }
        };

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
    }


    @Override
    public void onClick(View v) {

        switch (v.getId()){

            case R.id.loginButton:

                //dev
                Log.i(TAG, "onClick: LOGIN");

                mAuth.signInWithEmailAndPassword(mEmailEditText.getText().toString().toLowerCase().trim(),
                        mPasswordEditText.getText().toString().trim()).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (!task.isSuccessful()) {
                            //notify user of wrong credentials
                            Toast.makeText(LoginActivity.this, "Wrong Credentials !", Toast.LENGTH_SHORT).show();
                            return;
                        }
                        mAuth.addAuthStateListener(new FirebaseAuth.AuthStateListener() {
                            @Override
                            public void onAuthStateChanged(@NonNull FirebaseAuth firebaseAuth) {
                                //get current user
                                FirebaseUser user = firebaseAuth.getCurrentUser();
                                //user conditional
                                if (user != null) {
                                    //dev
                                    Log.i(TAG, "onAuthStateChanged: " + "User: " + user.getEmail() + " / Signed In");
                                    //re-direct user to home activity
                                    Intent homeActivityIntent = new Intent(LoginActivity.this, WalkerHomeActivity.class);
                                    startActivity(homeActivityIntent);
                                    //kill login activity
                                    LoginActivity.this.finish();
                                }
                            }

                        });
                    }
                });

            return;

            case R.id.registerButton:

                //dev
                Log.i(TAG, "onClick: REGISTER");


                Intent formIntent = new Intent(LoginActivity.this, FormActivity.class);
                startActivity(formIntent);
        }

    }

    @Override
    protected void onStart() {
        super.onStart();
        //add listener for firebase auth
        mAuth.addAuthStateListener(mAuthListener);
    }

    @Override
    protected void onStop() {
        super.onStop();
        //check listener
        if (mAuthListener != null) {
            //remove listener on stop
            mAuth.removeAuthStateListener(mAuthListener);
        }
    }
}
