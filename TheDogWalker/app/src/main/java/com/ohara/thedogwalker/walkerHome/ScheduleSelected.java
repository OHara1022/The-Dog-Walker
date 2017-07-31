package com.ohara.thedogwalker.walkerHome;

import com.ohara.thedogwalker.dataModel.ScheduleData;
import com.ohara.thedogwalker.dataModel.UserData;

/**
 * Created by Scott on 7/30/17.
 */

public interface ScheduleSelected {

    void scheduleSelected(ScheduleData scheduleData);

    void clientSelection(UserData userData);
}
