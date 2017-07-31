package com.ohara.thedogwalker.walkerScheduleDetails;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.google.firebase.database.DatabaseReference;
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.ScheduleData;


public class ScheduleDetailsFragment extends Fragment {

    //TAG
    private static final String TAG = "ScheduleDetailsFragment";
    public static final String DETAILS_TAG = "DETAILS_TAG";


    //stored properties
    private static final String ARG_SCHEDULE = "SCHEDULEDETAILSFRAGMENTT.ARG.SCHEDULES";
    private ScheduleData mScheduleData;
    DatabaseReference mRef;
    String userID;
    private static final int REQUEST_EDIT = 0x02002;

    //new instance
    public static ScheduleDetailsFragment newInstance(ScheduleData _scheduleData){

        ScheduleDetailsFragment detailsFrag = new ScheduleDetailsFragment();
        Bundle args = new Bundle();
        //put obj
        args.putSerializable(ARG_SCHEDULE, _scheduleData);
        detailsFrag.setArguments(args);
        return detailsFrag;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.walker_edit_schedule, menu);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.walker_schedule_details_fragment, container, false);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        //get arguments
        Bundle args = getArguments();
        //get view
        View view = getView();

        if (args != null && args.containsKey(ARG_SCHEDULE) && view != null){

            //get data
            mScheduleData = (ScheduleData) args.getSerializable(ARG_SCHEDULE);

            //populate view w/ args
            TextView tv = (TextView) view.findViewById(R.id.scheduleDateTV);
            tv.setText(mScheduleData.date);

            tv = (TextView) view.findViewById(R.id.scheduleTimeTV);
            tv.setText(mScheduleData.time);

            tv = (TextView) view.findViewById(R.id.scheduleDurationTV);
            tv.setText(mScheduleData.duration);

            tv = (TextView) view.findViewById(R.id.schedulePetNameTV);
            tv.setText(mScheduleData.petName);

            tv = (TextView) view.findViewById(R.id.scheduleBreedTV);
            tv.setText(mScheduleData.breed);

            tv = (TextView) view.findViewById(R.id.scheduleSpecialInsTV);
            tv.setText(mScheduleData.specialIns);

            tv = (TextView) view.findViewById(R.id.scheduleMedsTV);
            tv.setText(mScheduleData.meds);
        }
    }
}
