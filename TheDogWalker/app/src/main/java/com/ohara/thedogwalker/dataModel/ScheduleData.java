package com.ohara.thedogwalker.dataModel;

import java.io.Serializable;


public class ScheduleData implements Serializable {

    //stored properties
    public String date;
    public String time;
    public String duration;
    public String petName;
    public String specialIns;
    public String meds;
    public String price;
    public String scheduleKey;
    public String paidFlag;
    public String checkIn;
    public String checkOut;
    public String breed;

    //firebase default constructor
    public ScheduleData(){
    }

    //constructor
    public ScheduleData(String date, String time, String duration, String petName, String specialIns, String meds, String price, String breed){

        this.date = date;
        this.time = time;
        this.duration = duration;
        this.petName = petName;
        this.specialIns = specialIns;
        this.meds = meds;
        this.price = price;
        this.breed = breed;
    }

    @Override
    public String toString() {
        return date + "                                                                 " + petName;
    }
}
