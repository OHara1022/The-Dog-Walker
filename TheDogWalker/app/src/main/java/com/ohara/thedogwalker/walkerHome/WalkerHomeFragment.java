package com.ohara.thedogwalker.walkerHome;

import android.app.ListFragment;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.MenuItem;
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
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.ScheduleData;

import java.util.ArrayList;

//TODO: add empty text view when no data is available
public class WalkerHomeFragment extends ListFragment {

    //TAG
    private static final String TAG = "WalkerHomeFragment";
    public static final String HOME_TAG = "HOME_TAG";
    private static final int REQUEST_ADD = 0x02002;

    //stored properties
    FirebaseAuth mAuth;
    DatabaseReference mRef;
    DatabaseReference mUserRef;
    FirebaseUser mUser;
    String mUserID;
    String mWalkerCode;
    ScheduleData mQueriedScheduleData;
    private ScheduleSelected mListener;
    public ArrayList<ScheduleData> mScheduleArrayList;
    public ArrayAdapter<ScheduleData> mAdapter;

    //new instance of home frag
    public static WalkerHomeFragment newInstance() {

        //instance of home frag
        WalkerHomeFragment walkerHomeFragment = new WalkerHomeFragment();
        //bundle info
        Bundle args = new Bundle();
        //set args
        walkerHomeFragment.setArguments(args);
        //return frag w/ info
        return walkerHomeFragment;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        //attach listener
        if (context instanceof ScheduleSelected){
            mListener = (ScheduleSelected) context;
        }else{
            throw new IllegalArgumentException("Please add ScheduleSelected interface");
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
        mScheduleArrayList = new ArrayList<>();

        //get current user
        mUser = FirebaseAuth.getInstance().getCurrentUser();

        if (mUser != null) {

            //get userID
            mUserID = mUser.getUid();

            //get instance of DB
            mRef = FirebaseDatabase.getInstance().getReference().child("schedules");
            mUserRef = FirebaseDatabase.getInstance().getReference().child("users").child(mUserID);

            mUserRef.addValueEventListener(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot dataSnapshot) {

                    //check snapshot has value
                    if (dataSnapshot != null) {

                        //get walker code
                        mWalkerCode = (String) dataSnapshot.child("companyCode").getValue();

                        //dev
                        Log.i(TAG, "onDataChange: " + mWalkerCode);
                    }
                }

                @Override
                public void onCancelled(DatabaseError databaseError) {

                }
            });

            //get schedule data
            getScheduleData();
        }
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {

        //dev
        Log.i(TAG, "onListItemClick: " + l.getAdapter().getItem(position));

        if (mListener != null){
            mListener.scheduleSelected((ScheduleData) l.getAdapter().getItem(position));

            //dev
            Log.i(TAG, "onListItemClick: CLICKED");
        }
    }

    public void getScheduleData() {

        mRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {

                //clear array list
                mScheduleArrayList.clear();

                //check snapshot has value
                if (dataSnapshot != null) {

                    //loop thru snapshot
                    for (DataSnapshot snapshot : dataSnapshot.getChildren()) {

//                        //dev
//                        Log.i(TAG, "onDataChange: " + dataSnapshot);
//                        Log.i(TAG, "onDataChange: SNAP" + snapshot);

                        //loop thru keys
                        for (DataSnapshot snap : snapshot.getChildren()) {

//                            //dev
//                            Log.i(TAG, "onDataChange: " + snap);
//                            Log.i(TAG, "onDataChange: CHILD" + snap.getValue());
                            //check for current user
                            if (mUser != null) {

                                //dev
                                Log.i(TAG, "onDataChange: CODE" + snap.child("companyCode").getValue());

                                //check if walker code matches code
                                if (snap.child("companyCode").getValue().equals(mWalkerCode)) {
//                                //dev
//                                Log.i(TAG, "onDataChange: " + snap.child("petName").getValue());

                                    //get data obj values from snapshot
                                    String date = (String) snap.child("date").getValue();
                                    String time = (String) snap.child("time").getValue();
                                    String duration = (String) snap.child("duration").getValue();
                                    String petName = (String) snap.child("petName").getValue();
                                    String specialIns = (String) snap.child("specialIns").getValue();
                                    String meds = (String) snap.child("meds").getValue();
                                    String price = (String) snap.child("price").getValue();
//                                    String companyCode = (String) snap.child("companyCode").getValue();
                                    String breed = (String) snap.child("breed").getValue();

//                                Log.i(TAG, "onDataChange: CODE" + companyCode);

                                    //populate class w/ new data
                                    mQueriedScheduleData = new ScheduleData(date, time, duration, petName, specialIns, meds, price, breed);


                                    //populate array
                                    mScheduleArrayList.add(mQueriedScheduleData);

                                }
                            }
                        }

                    }

                    //set adapter
                    mAdapter = new ArrayAdapter<>(
                            getActivity(),
                            android.R.layout.simple_list_item_1,
                            mScheduleArrayList);

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