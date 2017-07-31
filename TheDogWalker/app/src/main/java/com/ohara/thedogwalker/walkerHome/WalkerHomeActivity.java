package com.ohara.thedogwalker.walkerHome;

import android.app.Fragment;
import android.content.Intent;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.MenuItem;

import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.ScheduleData;
import com.ohara.thedogwalker.dataModel.UserData;
import com.ohara.thedogwalker.walkerClientDetails.ClientDetailsActivity;
import com.ohara.thedogwalker.walkerClientDetails.ClientProfileFragment;
import com.ohara.thedogwalker.walkerClients.WalkerClientsFragment;
import com.ohara.thedogwalker.walkerProfile.WalkerProfileFragment;
import com.ohara.thedogwalker.walkerScheduleDetails.ScheduleDetailsActivity;

public class WalkerHomeActivity extends AppCompatActivity implements ScheduleSelected  {

    //TAG
    private static final String TAG = "WalkerHomeActivity";
    //result code
    private static final int REQUEST_DETAILS = 0x01001;
    private static final int REQUEST_CLIENTS = 0x03003;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_walker_home);

        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.navigation);

        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {

                Fragment selectedFrag = null;

                switch (item.getItemId()) {

                    case R.id.schedules_tab:

                        selectedFrag = WalkerHomeFragment.newInstance();
                        break;

                    case  R.id.clients_tab:

                        selectedFrag = WalkerClientsFragment.newInstance();
                        break;

                    case  R.id.walker_profile:

                        selectedFrag = WalkerProfileFragment.newInstance();
                }

                 getFragmentManager().beginTransaction().replace(R.id.container, selectedFrag).commit();

                return true;
            }
        });

        WalkerHomeFragment walkerHomeFragment = WalkerHomeFragment.newInstance();
        getFragmentManager().beginTransaction().replace(R.id.container, walkerHomeFragment,
                WalkerHomeFragment.HOME_TAG).commit();
    }

    @Override
    public void scheduleSelected(ScheduleData scheduleData) {

        //dev
        Log.i(TAG, "scheduleSelected: Date" + scheduleData.date);
        Log.i(TAG, "scheduleSelected: Time" + scheduleData.time);
        Log.i(TAG, "scheduleSelected: Duration" + scheduleData.duration);

        //pass data w/ intent
        Intent detailsIntent = new Intent(WalkerHomeActivity.this, ScheduleDetailsActivity.class);
        detailsIntent.putExtra(ScheduleDetailsActivity.EXTRA_DATE, scheduleData.date);
        detailsIntent.putExtra(ScheduleDetailsActivity.EXTRA_TIME, scheduleData.time);
        detailsIntent.putExtra(ScheduleDetailsActivity.EXTRA_DURATION, scheduleData.duration);
        detailsIntent.putExtra(ScheduleDetailsActivity.EXTRA_PET_NAME, scheduleData.petName);
        detailsIntent.putExtra(ScheduleDetailsActivity.EXTRA_SPECIAL_INS, scheduleData.specialIns);
        detailsIntent.putExtra(ScheduleDetailsActivity.EXTRA_MEDS, scheduleData.meds);
        detailsIntent.putExtra(ScheduleDetailsActivity.EXTRA_PRICE, scheduleData.price);
        detailsIntent.putExtra(ScheduleDetailsActivity.EXTRA_BREED, scheduleData.breed);
        startActivityForResult(detailsIntent, REQUEST_DETAILS);
    }

    @Override
    public void clientSelection(UserData userData) {

        //dev
        Log.i(TAG, "clientSelection: NAME" + userData.firstName);

        //pass data w/ intent
        Intent detailsIntent = new Intent(WalkerHomeActivity.this, ClientDetailsActivity.class);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_FIRST, userData.firstName);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_LAST, userData.lastName);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_EMAIL, userData.email);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_PHONE, userData.phoneNumber);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_ADDRESS, userData.address);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_CITY, userData.city);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_STATE, userData.state);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_ZIP, userData.zipCode);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_COMPANY_CODE, userData.companyCode);
        detailsIntent.putExtra(ClientDetailsActivity.EXTRA_PASSWORD, userData.password);
        startActivityForResult(detailsIntent, REQUEST_CLIENTS);
    }
}
