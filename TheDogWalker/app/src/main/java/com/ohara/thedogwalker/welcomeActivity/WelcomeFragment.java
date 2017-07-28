package com.ohara.thedogwalker.welcomeActivity;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Toast;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.ScheduleData;
import com.ohara.thedogwalker.login.LoginActivity;
import com.ohara.thedogwalker.register.PetRegisterActivity;
import com.ohara.thedogwalker.walkerHome.WalkerHomeActivity;
import com.ohara.thedogwalker.walkerHome.WalkerHomeFragment;

import static com.ohara.thedogwalker.R.id.container;


public class WelcomeFragment extends Fragment implements View.OnClickListener{

    //TAG
    private static final String TAG = "WelcomeFragment";
    public static final String WELCOME_TAG = "WELCOME_TAG";

    //stored properties
    FirebaseAuth mAuth;
    DatabaseReference mRef;
    private FirebaseAuth.AuthStateListener mAuthListener;
    Button dogWalkerBtn;
    Button ownerBtn;

    //new instance of frag
    public static WelcomeFragment newInstance(){

        WelcomeFragment welcomeFragment = new WelcomeFragment();
        Bundle args = new Bundle();
        welcomeFragment.setArguments(args);
        return welcomeFragment;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //instance of firebase auth
        mAuth = FirebaseAuth.getInstance();
        //init auth state listener
        mAuthListener = new FirebaseAuth.AuthStateListener() {

            @Override
            public void onAuthStateChanged(@NonNull FirebaseAuth firebaseAuth) {
                //get current user
                FirebaseUser user = firebaseAuth.getCurrentUser();

                if (user != null) {
                    //dev
                    Log.d(TAG, "onAuthStateChanged: SIGNED IN " + user.getUid());

                    //instance of database
                    mRef = FirebaseDatabase.getInstance().getReference().child("users").child(user.getUid());

                }
            }
        };
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {

        View welcomeView = inflater.inflate(R.layout.welcome_fragment, container, false);

        //init ui
        dogWalkerBtn = (Button) welcomeView.findViewById(R.id.dogWalkerButton);
        ownerBtn = (Button) welcomeView.findViewById(R.id.ownerButton);

        dogWalkerBtn.setOnClickListener(this);
        ownerBtn.setOnClickListener(this);

        //return created view
        return welcomeView;

    }

    @Override
    public void onClick(View v) {

        switch (v.getId()){

            case R.id.dogWalkerButton:

                mRef.child("roleID").setValue("Walker");

                Intent walkerHome = new Intent(getActivity(), WalkerHomeActivity.class);
                startActivity(walkerHome);


                Toast.makeText(getActivity(), "Dog Walker Selected", Toast.LENGTH_SHORT).show();
                return;

            case R.id.ownerButton:

                mRef.child("roleID").setValue("Owner");

                Intent ownerPetReg = new Intent(getActivity(), PetRegisterActivity.class);
                startActivity(ownerPetReg);

                Toast.makeText(getActivity(), "Pet Owner Selected", Toast.LENGTH_SHORT).show();
        }


    }


    @Override
    public void onStart() {
        super.onStart();
        //add listener for firebase auth
        mAuth.addAuthStateListener(mAuthListener);
    }

    @Override
    public void onStop() {
        super.onStop();
        //check listener
        if (mAuthListener != null) {
            //remove listener on stop
            mAuth.removeAuthStateListener(mAuthListener);
        }
    }
}
