package com.ohara.thedogwalker.walkerClientDetails;

import android.content.Intent;
import android.support.design.widget.TabLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.UserData;
import com.ohara.thedogwalker.walkerClientDetails.ClientPetFragment;
import com.ohara.thedogwalker.walkerClientDetails.ClientProfileFragment;

import java.util.ArrayList;
import java.util.List;

public class ClientDetailsActivity extends AppCompatActivity {

    private static final String TAG = "ClientDetailsActivity";

    public static final String EXTRA_FIRST = "com.ohara.android.EXTRA_FIRST";
    public static final String EXTRA_LAST = "com.ohara.android.EXTRA_LAST";
    public static final String EXTRA_EMAIL = "com.ohara.android.EXTRA_EMAIL";
    public static final String EXTRA_PHONE = "com.ohara.android.EXTRA_PHONE";
    public static final String EXTRA_ADDRESS = "com.ohara.android.EXTRA_ADDRESS";
    public static final String EXTRA_CITY = "com.ohara.android.EXTRA_CITY";
    public static final String EXTRA_STATE = "com.ohara.android.EXTRA_STATE";
    public static final String EXTRA_ZIP = "com.ohara.android.EXTRA_ZIP";
    public static final String EXTRA_COMPANY_CODE = "com.ohara.android.EXTRA_COMPANY_CODE";
    public static final String EXTRA_PASSWORD = "com.ohara.android.EXTRA_PASSWORD";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_owner_home);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("Welcome");
        setSupportActionBar(toolbar);

        // set up the ViewPager
        ViewPager viewPager = (ViewPager) findViewById(R.id.viewPager);
        setUpViewPager(viewPager);

        TabLayout tabLayout = (TabLayout) findViewById(R.id.tabs);
        tabLayout.setupWithViewPager(viewPager);

    }

    private void setUpViewPager(ViewPager viewPager){
        ViewPagerAdapter adapter = new ViewPagerAdapter(getSupportFragmentManager());
        Intent intent = getIntent();

        //get intent extra
        String first = intent.getStringExtra(EXTRA_FIRST);
        String last = intent.getStringExtra(EXTRA_LAST);
        String email = intent.getStringExtra(EXTRA_EMAIL);
        String phone = intent.getStringExtra(EXTRA_PHONE);
        String address = intent.getStringExtra(EXTRA_ADDRESS);
        String city = intent.getStringExtra(EXTRA_CITY);
        String state = intent.getStringExtra(EXTRA_STATE);
        String zip = intent.getStringExtra(EXTRA_ZIP);
        String comapnyCode = intent.getStringExtra(EXTRA_COMPANY_CODE);
        String password = intent.getStringExtra(EXTRA_PASSWORD);

        //dev
        Log.i(TAG, "setUpViewPager: !!!" + first);

        //populate class
        UserData userData = new UserData(first, last, email, phone, address, city, state, zip, comapnyCode, password);
        ClientProfileFragment clientProfileFragment =  ClientProfileFragment.newInstance(userData);

        adapter.addFrag(clientProfileFragment, "Client Profile");
        adapter.addFrag(new ClientPetFragment(), "Pet Profile");
        viewPager.setAdapter(adapter);

    }

    class ViewPagerAdapter extends FragmentPagerAdapter{
        private final List<Fragment> mFragList = new ArrayList<>();
        private final List<String> mFragTitle = new ArrayList<>();

        public ViewPagerAdapter(FragmentManager fragmentManager){
            super(fragmentManager);
        }


        @Override
        public Fragment getItem(int position) {
            return mFragList.get(position);
        }

        @Override
        public int getCount() {
            return mFragList.size();
        }

        public void addFrag(Fragment frag, String title){
            mFragList.add(frag);
            mFragTitle.add(title);
        }


        @Override
        public CharSequence getPageTitle(int position) {
            return mFragTitle.get(position);
        }
    }



}
