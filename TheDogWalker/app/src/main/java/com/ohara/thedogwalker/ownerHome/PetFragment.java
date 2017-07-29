package com.ohara.thedogwalker.ownerHome;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.ohara.thedogwalker.R;



public class PetFragment extends Fragment {

    //TAG
    private static final String TAG = "PetFragment";
    public static final String PET_TAG = "PET_TAG";

    //stored properties
    FirebaseAuth mAuth;
    DatabaseReference mRef;
    FirebaseUser mUser;
    String mUserID;


    public static PetFragment newInsance(){

        return new PetFragment();
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //set options menu to true
        setHasOptionsMenu(true);

        //get instance of firebase auth
        mAuth = FirebaseAuth.getInstance();
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        super.onCreateOptionsMenu(menu, inflater);
        //display options menu
        inflater.inflate(R.menu.edit_pet_menu,menu);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.pet_fragment, container, false);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        //get current user
        mUser = FirebaseAuth.getInstance().getCurrentUser();
        final View view = getView();

        if (mUser != null){
            //get userID
            mUserID = mUser.getUid();

            //get instance of DB
            mRef = FirebaseDatabase.getInstance().getReference().child("pets").child(mUserID);

            mRef.addValueEventListener(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot dataSnapshot) {

                    if (dataSnapshot != null) {

                        Log.i(TAG, "onDataChange: " + dataSnapshot.getValue());

                        for (DataSnapshot snapshot : dataSnapshot.getChildren()) {

                            //dev
                            Log.i(TAG, "onDataChange: " + snapshot.getValue());


                            for (DataSnapshot snap : snapshot.getChildren()) {
                                //dev
                                Log.i(TAG, "onDataChange: " + snap.getValue());
                                //TODO: populate views

                            }

                        }
                    }


                }

                @Override
                public void onCancelled(DatabaseError databaseError) {

                }
            });

        }

    }
}
