package com.ohara.thedogwalker.register;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.UserData;
import com.ohara.thedogwalker.welcomeActivity.WelcomeActivity;


public class FormFragment extends Fragment {

    //TAG
    private static final String TAG = "FormFragment";
    public static final String FORM_TAG = "FORM_TAG";

    //edit text fields
    EditText mFirstNameET;
    EditText mLastNameET;
    EditText mEmailET;
    EditText mPasswordET;
    EditText mPhoneNumberET;
    EditText mAddressET;
    EditText mCityET;
    EditText mStateET;
    EditText mZipCodeET;
    EditText mAptNumberET;
    EditText mCompanyCodeET;
    EditText mCompanyNameET;

    //interface listener
    GetUserData mListener;

    //new instance of form frag
    public static FormFragment newInstance() {
        //instance of form frag
        FormFragment formFragment = new FormFragment();
        //bundle info
        Bundle args = new Bundle();
        //set arguments
        formFragment.setArguments(args);
        //return frag w/ info
        return formFragment;
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        if (context instanceof  GetUserData){

            mListener = (GetUserData) context;

        }else{
            throw new IllegalArgumentException("Please add get user data interface");
        }

    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setHasOptionsMenu(true);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        super.onCreateOptionsMenu(menu, inflater);

        inflater.inflate(R.menu.form_menu, menu);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {

        View formView = inflater.inflate(R.layout.form_fragment, container, false);

        mFirstNameET = (EditText) formView.findViewById(R.id.firstNameEditText);
        mLastNameET = (EditText) formView.findViewById(R.id.lastNameEditText);
        mEmailET = (EditText) formView.findViewById(R.id.emailEditText);
        mPasswordET = (EditText) formView.findViewById(R.id.passwordEditText);
        mPhoneNumberET = (EditText) formView.findViewById(R.id.numberEditText);
        mAddressET = (EditText) formView.findViewById(R.id.addressEditText);
        mCityET = (EditText) formView.findViewById(R.id.cityEditText);
        mStateET = (EditText) formView.findViewById(R.id.stateEditText);
        mZipCodeET = (EditText) formView.findViewById(R.id.zipCodeEditText);
        mAptNumberET = (EditText) formView.findViewById(R.id.aptUnitEditText);
        mCompanyCodeET = (EditText) formView.findViewById(R.id.companyCodeEditText);
        mCompanyNameET = (EditText) formView.findViewById(R.id.companyNameEditText);


       return formView;
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()){

            case R.id.addUser:

                //get values of edit text
                String firstName = mFirstNameET.getText().toString().trim();
                String lastName = mLastNameET.getText().toString().trim();
                String email = mEmailET.getText().toString().trim();
                String password = mPasswordET.getText().toString().trim();
//                Long phoneNumber = Long.parseLong(mPhoneNumberET.getText().toString().trim());
                String phoneNumber = mPhoneNumberET.getText().toString().trim();
                String address = mAddressET.getText().toString().trim();
                String city = mCityET.getText().toString().trim();
                String state = mStateET.getText().toString().trim();
//                Long zipCode = Long.parseLong(mZipCodeET.getText().toString().trim());
                String zipCode = mZipCodeET.getText().toString().trim();
                String companyCode = mCompanyCodeET.getText().toString().trim();
//                Long companyCode = Long.parseLong(mCompanyCodeET.getText().toString().trim());

                if (mAptNumberET == null){
                    return false;
                }

                if (mCompanyNameET == null){
                    return false;
                }


                //TODO: check for empty fields

                //populate userData
                UserData newUser = new UserData(firstName, lastName, email, phoneNumber, address, city, state, zipCode, companyCode, password);

                if (mAptNumberET != null) {
//                    newUser.aptNumber = Long.parseLong(mAptNumberET.getText().toString().trim());
                    newUser.aptNumber = mAptNumberET.getText().toString().trim();
            }

            if (mCompanyNameET != null) {
                newUser.companyName = mCompanyNameET.getText().toString().trim();
             }

             //pass user data
             mListener.getUser(newUser);

                //dev
                Log.i(TAG, "onOptionsItemSelected: NEW USER" + firstName);
                return true;

        }//end of switch

        return false;
    }
}
