package com.ohara.thedogwalker.walkerProfile;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.UserData;


public class WalkerProfileFragment extends Fragment {

    //TAG
    private static final String TAG = "WalkerProfileFragment";

    //stored properties
    FirebaseAuth mAuth;
    DatabaseReference mRef;
    FirebaseUser mUser;
    String mUserID;

    public static WalkerProfileFragment newInstance() {

        WalkerProfileFragment profileFragment = new WalkerProfileFragment();
        return profileFragment;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //get instance of firebase auth
        mAuth = FirebaseAuth.getInstance();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.walker_profile_fragment, container, false);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        //get current user
        mUser = FirebaseAuth.getInstance().getCurrentUser();

        if (mUser != null) {

            //get userID
            mUserID = mUser.getUid();

            //get instance of DB
            mRef = FirebaseDatabase.getInstance().getReference().child("users").child(mUserID);

            final View view = getView();

            mRef.addValueEventListener(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot dataSnapshot) {

                    //dev
                    Log.i(TAG, "onDataChange: " + dataSnapshot.getValue());
                    Log.i(TAG, "onDataChange: " + dataSnapshot.child("firstName").getValue());

                    String first = (String) dataSnapshot.child("firstName").getValue();
                    String last = (String ) dataSnapshot.child("lastName").getValue();
                    String name = first + " " + last;
                    String email = (String) dataSnapshot.child("email").getValue();
                    String phone = (String) dataSnapshot.child("phoneNumber").getValue();
                    String address = (String) dataSnapshot.child("address").getValue();
                    String city = (String) dataSnapshot.child("city").getValue();
                    String state = (String) dataSnapshot.child("state").getValue();
                    String zip = (String) dataSnapshot.child("zipCode").getValue();
                    String fullAddress = address + " " + city + " " + state + " " + zip;
                    String companyName = (String) dataSnapshot.child("companyName").getValue();

                    TextView tv = (TextView) view.findViewById(R.id.nameTV);
                    tv.setText(name);

                    tv = (TextView) view.findViewById(R.id.emailTV);
                    tv.setText(email);

                    tv = (TextView) view.findViewById(R.id.phoneTV);
                    tv.setText(phone);

                    tv = (TextView) view.findViewById(R.id.addressTV);
                    tv.setText(fullAddress);

                    tv = (TextView) view.findViewById(R.id.companyNameTV);
                    tv.setText(companyName);
                }

                @Override
                public void onCancelled(DatabaseError databaseError) {

                }
            });
        }
    }

}
