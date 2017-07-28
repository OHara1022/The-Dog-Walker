package com.ohara.thedogwalker.register;

import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.PetData;


public class PetRegisterFragment extends Fragment {

    //TAG
    private static final String TAG = "PetRegisterFragment";
    public static final String PET_REG_TAG = "PET_REG_TAG";

    //edit text fields
    EditText mPetName;
    EditText mBday;
    EditText mBreed;
    EditText mMeds;
    EditText mVaccines;
    EditText mSpecialIns;
    EditText mEmergencyContact;
    EditText mEmergencyPhone;
    EditText mVetName;
    EditText mVetPhone;

    //interface listener
    GetPetData mListener;

    //new instance of pet reg frag
    public static PetRegisterFragment newInstance() {
        //instance of frag
        PetRegisterFragment petRegisterFragment = new PetRegisterFragment();
        //bundle info
        Bundle args = new Bundle();
        //set args
        petRegisterFragment.setArguments(args);
        //return frag w/info
        return petRegisterFragment;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        if (context instanceof GetPetData) {

            //attach listener
            mListener = (GetPetData) context;
        } else {
            throw new IllegalArgumentException("Please add get pet data interface");
        }
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setHasOptionsMenu to true
        setHasOptionsMenu(true);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        super.onCreateOptionsMenu(menu, inflater);
        inflater.inflate(R.menu.pet_reg_menu, menu);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {

        View petRegView = inflater.inflate(R.layout.pet_register_fragment, container, false);

        mPetName = (EditText) petRegView.findViewById(R.id.petNameEditText);
        mBday = (EditText) petRegView.findViewById(R.id.bdayEditText);
        mBreed = (EditText) petRegView.findViewById(R.id.breedEditText);
        mMeds = (EditText) petRegView.findViewById(R.id.medsEditText);
        mVaccines = (EditText) petRegView.findViewById(R.id.vaccinesEditText);
        mSpecialIns = (EditText) petRegView.findViewById(R.id.specialInsEditText);
        mEmergencyContact = (EditText) petRegView.findViewById(R.id.emergencycontactEditText);
        mEmergencyPhone = (EditText) petRegView.findViewById(R.id.emergencyPhoneEditText);
        mVetName = (EditText) petRegView.findViewById(R.id.vetNameEditText);
        mVetPhone = (EditText) petRegView.findViewById(R.id.vetPhoneEditText);

        return petRegView;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()) {

            case R.id.addPet:

                //get values of edit text
                String petName = mPetName.getText().toString().trim();
                String bday = mBday.getText().toString().trim();
                String breed = mBreed.getText().toString().trim();
                String meds = mMeds.getText().toString().trim();
                String vaccines = mVaccines.getText().toString().trim();
                String specialIns = mSpecialIns.getText().toString().trim();
                String emergencyContact = mEmergencyContact.getText().toString().trim();
                String emgergencyPhone = mEmergencyPhone.getText().toString().trim();
                String vetName = mVetName.getText().toString().trim();
                String vetPhone = mVetPhone.getText().toString().trim();

                //populate pet data
                PetData petData = new PetData(petName, bday, breed, meds, vaccines, vetName, vetPhone);
                petData.emergencyContact = emergencyContact;
                petData.emergencyPhone = emgergencyPhone;

                if (mSpecialIns != null){
                    petData.specialIns = specialIns;
                }

                //pass petData obj
                mListener.getPetData(petData);

                return true;
        }


        return false;
    }
}