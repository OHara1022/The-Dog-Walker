package com.ohara.thedogwalker.dataModel;

import java.io.Serializable;


public class UserData implements Serializable {

    //stored properties
    public String firstName;
    public String lastName;
    public String email;
    public String uid;
    public Long phoneNumber;
    public String address;
    public String city;
    public String state;
    public Long zipCode;
    public Long aptNumber;
    public Long companyCode;
    public String companyName;
    public String profileImg;
    public String roleID;
    public String password;//never store password in firebase, for testing purposes


    //firebase default constructor
    public UserData(){

    }

    //constructor
    public UserData(String firstName, String lastName, String email, Long phoneNumber, String address,
                    String city, String state, Long zipCode, Long companyCode, String password){

        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.city = city;
        this.state = state;
        this.zipCode = zipCode;
        this.companyCode = companyCode;
        this.password = password;
    }


}