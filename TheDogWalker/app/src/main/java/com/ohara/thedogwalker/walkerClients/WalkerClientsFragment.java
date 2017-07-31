package com.ohara.thedogwalker.walkerClients;

import android.app.ListFragment;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.ohara.thedogwalker.dataModel.ScheduleData;
import com.ohara.thedogwalker.dataModel.UserData;
import com.ohara.thedogwalker.walkerHome.ScheduleSelected;
import com.ohara.thedogwalker.walkerHome.WalkerHomeFragment;

import java.util.ArrayList;


public class WalkerClientsFragment extends ListFragment {

    //TAG 
    private static final String TAG = "WalkerClientsFragment";

    //stored properties
    FirebaseAuth mAuth;
    DatabaseReference mRef;
    FirebaseUser mUser;
    DatabaseReference mUserRef;
    String mUserID;
    String mWalkerCode;
    UserData mQueriedClientData;
    private ScheduleSelected mListener;
    public ArrayList<UserData> mClientArrayList;
    public ArrayAdapter<UserData> mAdapter;

    public static WalkerClientsFragment newInstance() {

        //instance of home frag
        WalkerClientsFragment walkerClientsFragment = new WalkerClientsFragment();
        //bundle info
        Bundle args = new Bundle();
        //set args
        walkerClientsFragment.setArguments(args);
        //return frag w/ info
        return walkerClientsFragment;

    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);

        if (context instanceof ScheduleSelected){
            mListener  = (ScheduleSelected) context;
        }else {

            throw new IllegalArgumentException("Please add CLIENTSELECTED interface");
        }
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //get instance of firebase auth
        mAuth = FirebaseAuth.getInstance();
    }


    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        //init array list
        mClientArrayList = new ArrayList<>();

        //get current user
        mUser = FirebaseAuth.getInstance().getCurrentUser();

        if (mUser != null) {

            //get userID
            mUserID = mUser.getUid();

            //get instance of DB
            mRef = FirebaseDatabase.getInstance().getReference().child("users");
            mUserRef = FirebaseDatabase.getInstance().getReference().child("users").child(mUserID);

            mUserRef.addValueEventListener(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot dataSnapshot) {

                    //check snapshot has value
                    if (dataSnapshot != null) {
                        mWalkerCode = (String) dataSnapshot.child("companyCode").getValue();

                        //dev
                        Log.i(TAG, "onDataChange: " + mWalkerCode);

                    }
                }

                @Override
                public void onCancelled(DatabaseError databaseError) {

                }
            });

            //get client data
            getClientData();
        }
    }


    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {

        //dev
        Log.i(TAG, "onListItemClick: " + l.getAdapter().getItem(position));

        if (mListener != null){

            mListener.clientSelection((UserData) l.getAdapter().getItem(position));
        }
    }

    public void getClientData() {

        mRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {

                //clear array list
                mClientArrayList.clear();

                //check snapshot has value
                if (dataSnapshot != null) {

                    for (DataSnapshot snapshot : dataSnapshot.getChildren()) {

                        //dev
                        Log.i(TAG, "onDataChange: SNAP" + snapshot.getValue());
                        Log.i(TAG, "onDataChange: " + snapshot.child("roleID").getValue());

                        if (mUser != null) {

                            if (snapshot.child("roleID").getValue().equals("Owner") && snapshot.child("companyCode").getValue().equals(mWalkerCode)){

                                String first = (String) snapshot.child("firstName").getValue();
                                String last = (String) snapshot.child("lastName").getValue();
                                String email = (String) snapshot.child("email").getValue();
                                String phone = (String) snapshot.child("phoneNumber").getValue();
                                String address = (String) snapshot.child("address").getValue();
                                String city = (String) snapshot.child("city").getValue();
                                String state = (String) snapshot.child("state").getValue();
                                String zip = (String) snapshot.child("zipCode").getValue();
                                String companyCode = (String) snapshot.child("companyCode").getValue();
                                String password = (String) snapshot.child("password").getValue();

                                //dev
                                Log.i(TAG, "onDataChange: first" + first);
                                Log.i(TAG, "onDataChange: last" + last);

                                //populate class w/ client data
                                mQueriedClientData = new UserData(first, last, email, phone, address, city, state, zip, companyCode, password);

                                //populate arrayList
                                mClientArrayList.add(mQueriedClientData);

                            }

                        }
                    }

                    //set adapter
                    mAdapter = new ArrayAdapter<>(
                            getActivity(),
                            android.R.layout.simple_list_item_1,
                            mClientArrayList);

                    //set adapter to list
                    setListAdapter(mAdapter);
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
            }
        });

    }
}
