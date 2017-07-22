package com.ohara.thedogwalker.dataModel;

import java.io.Serializable;



public class PetData implements Serializable {

    //stored properties
    public String petName;
    public String birthday;
    public String breed;
    public String meds;
    public String vaccines;
    public String specialIns;
    public String emergencyContact;
    public String emergencyPhone;
    public String vetName;
    public String vetPhone;
    public String petImage;
    public String uid;
    public String petKey;

    //firebase default constructor
    public PetData(){
    }

    //constructor
    public PetData(String petName, String birthday, String breed, String meds, String vaccines, String vetName, String vetPhone){

        this.petName = petName;
        this.birthday = birthday;
        this.breed = breed;
        this.meds = meds;
        this.vaccines = vaccines;
        this.vetName = vetName;
        this.vetPhone = vetPhone;
    }


}
