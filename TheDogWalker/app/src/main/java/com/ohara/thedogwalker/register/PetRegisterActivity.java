package com.ohara.thedogwalker.register;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.PetData;

public class PetRegisterActivity extends AppCompatActivity implements GetPetData {

    //TAG
    private static final String TAG = "PetRegisterActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pet_register);

        PetRegisterFragment petFrag = PetRegisterFragment.newInstance();
        getFragmentManager().beginTransaction().replace(R.id.petRegContainer, petFrag, PetRegisterFragment.PET_REG_TAG).commit();
    }

    @Override
    public void getPetData(PetData petData) {

        //dev
        Log.i(TAG, "getPetData: pet " + petData.petName);
        Log.i(TAG, "getPetData: breed " + petData.breed);


    }
}
