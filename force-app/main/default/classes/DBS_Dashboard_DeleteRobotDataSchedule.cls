global class DBS_Dashboard_DeleteRobotDataSchedule implements Schedulable
{
    global void execute(SchedulableContext sc)
    {      
       
        // We now call the batch class to be scheduled
        DBS_Dashboard_DeleteRobotData b = new DBS_Dashboard_DeleteRobotData();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(b,200);
    }
   
}