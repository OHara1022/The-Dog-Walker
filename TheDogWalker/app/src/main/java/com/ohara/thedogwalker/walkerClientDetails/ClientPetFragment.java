package com.ohara.thedogwalker.walkerClientDetails;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.ohara.thedogwalker.R;

/**
 * Created by Scott on 7/31/17.
 */

public class ClientPetFragment extends android.support.v4.app.Fragment {


    public static ClientProfileFragment newInsance(){

        return new ClientProfileFragment();

    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.client_pet_fragment, container, false);
    }
}
