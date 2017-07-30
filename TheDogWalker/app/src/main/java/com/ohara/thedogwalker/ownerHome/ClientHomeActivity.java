package com.ohara.thedogwalker.ownerHome;

import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;

import com.ohara.thedogwalker.R;

public class ClientHomeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_client_home);

        BottomNavigationView bottomNavigationView = (BottomNavigationView) findViewById(R.id.clientNavigation);

        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {

                android.app.Fragment selectedFrag = null;

                switch (item.getItemId()) {

                    case R.id.pet_tab:

                        selectedFrag = PetFragment.newInsance();
                        break;

                    case R.id.profile_tab:

                        selectedFrag = ProfileFragment.newInstance();
                        break;

                    case R.id.schedules_tab:

                }

                getFragmentManager().beginTransaction().replace(R.id.clientContainer, selectedFrag).commit();

                return true;
            }
        });

        PetFragment petFragment = PetFragment.newInsance();
        getFragmentManager().beginTransaction().replace(R.id.clientContainer, petFragment, PetFragment.PET_TAG).commit();

    }
}
