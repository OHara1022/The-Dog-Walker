package com.ohara.thedogwalker.ownerHome;

import android.app.ListFragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.ohara.thedogwalker.R;


public class SchedulesFragment extends ListFragment {


    //new instance of schedulesfrag
    public static SchedulesFragment newInstance(){
        return new SchedulesFragment();
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

}
