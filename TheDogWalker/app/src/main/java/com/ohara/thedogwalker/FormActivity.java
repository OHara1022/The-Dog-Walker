package com.ohara.thedogwalker;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class FormActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_form);

        //get instance of form fragment
        FormFragment formFragment = FormFragment.newInstance();
        //display fragment
        getFragmentManager().beginTransaction().replace(R.id.formContainer, formFragment,
                FormFragment.FORM_TAG).commit();
    }
}
