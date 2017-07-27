package com.ohara.thedogwalker.register;


import com.ohara.thedogwalker.dataModel.PetData;
import com.ohara.thedogwalker.dataModel.UserData;

interface GetPetData {

    //method to pass created user data
    void getPetData(PetData petData);

}
