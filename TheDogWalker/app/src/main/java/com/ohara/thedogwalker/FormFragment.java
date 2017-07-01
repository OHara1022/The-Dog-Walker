package com.ohara.thedogwalker;

import android.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by Scott on 6/22/17.
 */

public class FormFragment extends Fragment {

    //TAG
    private static final String TAG = "FormFragment";
    public static final String FORM_TAG = "FORM_TAG";

    //new instance of form frag
    public static FormFragment newInstance() {
        //instance of form frag
        FormFragment formFragment = new FormFragment();
        //bundle info
        Bundle args = new Bundle();
        //set arguments
        formFragment.setArguments(args);
        //return frag w/ info
        return formFragment;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setHasOptionsMenu(true);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        super.onCreateOptionsMenu(menu, inflater);

        inflater.inflate(R.menu.form_menu, menu);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {

        View formView = inflater.inflate(R.layout.form_fragment, container, false);


       return formView;
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        switch (item.getItemId()){

            case R.id.addUser:

                Intent welcomeIntent = new Intent(getActivity(), WelcomeActivity.class);
                startActivity(welcomeIntent);
        }


        return true;
    }
}
