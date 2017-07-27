package com.ohara.thedogwalker.helperClasses;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;
import android.util.Patterns;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;


public class FieldValidation {

    //TAG
    private static final String TAG = "FieldValidation";

    //check for empty edit text fields
    public static Boolean isEmpty(EditText editText) {

        //check if edit text is empty
        if (editText.getText().toString().equals("")) {
            return true;
        } else {
            return false;
        }
    }

    //check for valid password
    public static Boolean validPassword(String password, Context context) {

        //firebase password must be at least 6 characters
        if (password.length() < 6) {
            //alert user password is invalid
            Toast.makeText(context, "Password must be 6 characters", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }

    //check email is valid
    public static Boolean validEmail(CharSequence email, Context context) {

        if (Patterns.EMAIL_ADDRESS.matcher(email).matches()) {
            return true;
        }
        //alert user email is invalid
        Toast.makeText(context, "Invalid Email", Toast.LENGTH_SHORT).show();
        return false;
    }

    //method to hide text view if data is available
    public static Boolean noData(Boolean hasData, TextView noData) {

        if (hasData) {
            //if data hide TV
            noData.setVisibility(View.GONE);

        } else {
            //if no data show TV
            noData.setVisibility(View.VISIBLE);
        }
        return false;
    }

    //method to check network is connected
    public static boolean networkConnection(Context _context){

        //get connectivity manager
        ConnectivityManager mgr = (ConnectivityManager) _context.getSystemService(Context.CONNECTIVITY_SERVICE);

        //check for connection
        if (mgr != null){

            //get network
            NetworkInfo info = mgr.getActiveNetworkInfo();

            //check network is available
            if (info != null){

                //check if network is connected
                if (info.isConnected()){

                    //dev
                    Log.i(TAG, "networkConnection: NETWORK CONNECTED");
                    return true;
                }

            }else{
                //dev
                Log.i(TAG, "networkConnection: NO NETWORK");

                //alert user there is no network
                Toast.makeText(_context, "No network available, please connect to network", Toast.LENGTH_LONG).show();
            }

        }

        return false;
    }


}
