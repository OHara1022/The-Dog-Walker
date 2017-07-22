package com.ohara.thedogwalker.walkerHome;

import android.app.ListFragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.Menu;
import android.view.MenuInflater;
import android.widget.ArrayAdapter;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.ScheduleData;

import java.util.ArrayList;

//TODO: add empty text view when no data is available
public class WalkerHomeFragment extends ListFragment{

    //TAG
    private static final String TAG = "WalkerHomeFragment";
    public static final String  HOME_TAG = "HOME_TAG";
    private static final int REQUEST_ADD = 0x02002;

    //stored properties
    FirebaseAuth mAuth;
    DatabaseReference mRef;
    FirebaseUser mUser;
    String mUserID;
    ScheduleData mQueriedScheduleData;
    public ArrayList<ScheduleData> mScheduleArrayList;
    public ArrayAdapter<ScheduleData> mAdapter;

    //new instance of home frag
    public static WalkerHomeFragment newInstance(){

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
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //show menu items
        setHasOptionsMenu(true);

        //get instance of firebase auth
        mAuth = FirebaseAuth.getInstance();
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.walker_home_menu, menu);
    }


}
