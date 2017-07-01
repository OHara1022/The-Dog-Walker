package com.ohara.thedogwalker;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Toast;

/**
 * Created by Scott on 6/22/17.
 */

public class WelcomeFragment extends Fragment implements View.OnClickListener{

    //TAG
    private static final String TAG = "WelcomeFragment";
    public static final String WELCOME_TAG = "WELCOME_TAG";

    //stored properties
    Button dogWalkerBtn;
    Button ownerBtn;


    public static WelcomeFragment newInstance(){

        WelcomeFragment welcomeFragment = new WelcomeFragment();
        Bundle args = new Bundle();
        welcomeFragment.setArguments(args);
        return welcomeFragment;
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

                Toast.makeText(getActivity(), "Dog Walker Selected", Toast.LENGTH_SHORT).show();
                return;

            case R.id.ownerButton:

                Toast.makeText(getActivity(), "Pet Owner Selected", Toast.LENGTH_SHORT).show();
                return;

        }

    }
}
