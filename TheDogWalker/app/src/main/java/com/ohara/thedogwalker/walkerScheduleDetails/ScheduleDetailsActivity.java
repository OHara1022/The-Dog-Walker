package com.ohara.thedogwalker.walkerScheduleDetails;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;

import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.ScheduleData;

public class ScheduleDetailsActivity extends AppCompatActivity {

    //TAG
    private static final String TAG = "ScheduleDetailsActivity";

    //EXTRAS
    public static final String EXTRA_DATE = "com.ohara.android.EXTRA_DATE";
    public static final String EXTRA_TIME = "com.ohara.android.EXTRA_TIME";
    public static final String EXTRA_DURATION = "com.ohara.android.EXTRA_DURATION";
    public static final String EXTRA_PET_NAME = "com.ohara.android.EXTRA_PET_NAME";
    public static final String EXTRA_SPECIAL_INS = "com.ohara.android.EXTRA_SPECIAL_INS";
    public static final String EXTRA_MEDS = "com.ohara.android.EXTRA_MEDS";
    public static final String EXTRA_PRICE = "com.ohara.android.EXTRA_PRICE";
    public static final String EXTRA_BREED = "com.ohara.android.EXTRA_BREED";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_schedule_details);

        //get intent
        Intent intent = getIntent();

        //get intent extras
        String date = intent.getStringExtra(EXTRA_DATE);
        String time = intent.getStringExtra(EXTRA_TIME);
        String duration = intent.getStringExtra(EXTRA_DURATION);
        String petName = intent.getStringExtra(EXTRA_PET_NAME);
        String specialIns = intent.getStringExtra(EXTRA_SPECIAL_INS);
        String meds = intent.getStringExtra(EXTRA_MEDS);
        String price = intent.getStringExtra(EXTRA_PRICE);
        String breed = intent.getStringExtra(EXTRA_BREED);

        //dev
        Log.i(TAG, "onCreate: DATE " + date);
        Log.i(TAG, "onCreate: BREED " + breed);

        //populate obj w/ intent data
        ScheduleData scheduleData = new ScheduleData(date, time, duration, petName, specialIns, meds, price, breed);
        ScheduleDetailsFragment detailsFrag = ScheduleDetailsFragment.newInstance(scheduleData);
        getFragmentManager().beginTransaction().replace(R.id.schedulesContainer, detailsFrag, ScheduleDetailsFragment.DETAILS_TAG).commit();

    }
}
