package com.ohara.thedogwalker.ownerHome;

import android.support.design.widget.TabLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import com.ohara.thedogwalker.R;
import java.util.ArrayList;
import java.util.List;

public class OwnerHomeActivity extends AppCompatActivity {

//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_owner_home);
//
//        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
//        toolbar.setTitle("Welcome");
//        setSupportActionBar(toolbar);
//
//        // set up the ViewPager
//        ViewPager viewPager = (ViewPager) findViewById(R.id.viewPager);
//        setUpViewPager(viewPager);
//
//        TabLayout tabLayout = (TabLayout) findViewById(R.id.tabs);
//        tabLayout.setupWithViewPager(viewPager);
//    }
//
//
//    private void setUpViewPager(ViewPager viewPager){
//        ViewPagerAdapter adapter = new ViewPagerAdapter(getSupportFragmentManager());
//        adapter.addFrag(new PetFragment(), "Pet Profile");
//        adapter.addFrag(new ProfileFragment(), "My Profile");
//        viewPager.setAdapter(adapter);
//
//    }
//
//    class ViewPagerAdapter extends FragmentPagerAdapter{
//        private final List<Fragment> mFragList = new ArrayList<>();
//        private final List<String> mFragTitle = new ArrayList<>();
//
//        public ViewPagerAdapter(FragmentManager fragmentManager){
//            super(fragmentManager);
//        }
//
//
//        @Override
//        public Fragment getItem(int position) {
//            return mFragList.get(position);
//        }
//
//        @Override
//        public int getCount() {
//            return mFragList.size();
//        }
//
//        public void addFrag(Fragment frag, String title){
//            mFragList.add(frag);
//            mFragTitle.add(title);
//        }
//
//
//        @Override
//        public CharSequence getPageTitle(int position) {
//            return mFragTitle.get(position);
//        }
//    }



}
