package com.ohara.thedogwalker.register;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.PetData;

public class PetRegisterActivity extends AppCompatActivity implements GetPetData {

    //TAG
    private static final String TAG = "PetRegisterActivity";

    //stored properties
    DatabaseReference mDatabaseRef;
    FirebaseAuth mAuth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pet_register);

        //get instance of firebaseAuth
        mAuth = FirebaseAuth.getInstance();
        //get instance of firebase database
        mDatabaseRef = FirebaseDatabase.getInstance().getReference();

        PetRegisterFragment petFrag = PetRegisterFragment.newInstance();
        getFragmentManager().beginTransaction().replace(R.id.petRegContainer, petFrag, PetRegisterFragment.PET_REG_TAG).commit();
    }

    @Override
    public void getPetData(PetData petData) {

        //dev
        Log.i(TAG, "getPetData: pet " + petData.petName);
        Log.i(TAG, "getPetData: breed " + petData.breed);

        //get current user
        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

        //check user is not null
        if (user != null) {

            String uid = user.getUid();

            petData.uid = uid;

            DatabaseReference ref = mDatabaseRef.child("pets").child(uid).push();

            ref.setValue(petData);
        }

        finish();
    }
}
