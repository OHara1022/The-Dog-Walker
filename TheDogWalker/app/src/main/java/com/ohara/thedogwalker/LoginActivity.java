package com.ohara.thedogwalker;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

public class LoginActivity extends AppCompatActivity implements View.OnClickListener{

    //tag
    private static final String TAG = "LoginActivity";

    //stored properties
    Button registerBtn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        registerBtn = (Button) findViewById(R.id.registerButton);


        //set onClickListener
        registerBtn.setOnClickListener(this);
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
