package com.ohara.thedogwalker.walkerClientDetails;



import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import com.ohara.thedogwalker.R;
import com.ohara.thedogwalker.dataModel.UserData;


public class ClientProfileFragment extends Fragment {

    //TAG
    private static final String TAG = "ClientProfileFragment";

    //stored properties
    private static final String ARG_CLIENT = "CLIENTPROFILEFRAGMENT.ARG.CLIENTS";
    private UserData mUserData;

    //new instance
    public static ClientProfileFragment newInstance(UserData _userData){

        ClientProfileFragment clientFrag = new ClientProfileFragment();
        Bundle args = new Bundle();
        args.putSerializable(ARG_CLIENT, _userData);
        clientFrag.setArguments(args);
        return clientFrag;
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.client_profile_fragment, container, false);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        Bundle args = getArguments();
        View view = getView();

        if (args != null && args.containsKey(ARG_CLIENT) && view != null){

            mUserData = (UserData) args.getSerializable(ARG_CLIENT);

            Log.i(TAG, "onActivityCreated: " + mUserData);

            TextView tv = (TextView) view.findViewById(R.id.clienteNameTV);
            tv.setText(mUserData.firstName + " " + mUserData.lastName);

            tv = (TextView) view.findViewById(R.id.clientEmailTV);
            tv.setText(mUserData.email);

            tv = (TextView) view.findViewById(R.id.clientPhoneTV);
            tv.setText(mUserData.phoneNumber);

            tv = (TextView) view.findViewById(R.id.clientAddrressTV);
            tv.setText(mUserData.address);

            tv = (TextView) view.findViewById(R.id.clientCityStateZipTV);
            tv.setText(mUserData.city + " " + mUserData.state + " " + mUserData.zipCode);

            tv = (TextView) view.findViewById(R.id.clientEmergencyContactTV);
            tv.setText("Scott");

            tv = (TextView) view.findViewById(R.id.clientEmergenctPhoneTV);
            tv.setText("954-774-8533");

        }
    }
}
