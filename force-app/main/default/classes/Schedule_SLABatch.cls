/**
* @description Shedular class to run batch class on every day.
* MVP3 - CLient Review & Client Maturity
* */
global class Schedule_SLABatch implements Schedulable {
    
    /**
* @description Requierd method for shedular class implementation execute bact class.
* @param sc - SchedulableContext
* */ 
    global void execute(SchedulableContext sc) {
      // VAShedule_SLABatch bObj =new VAShedule_SLABatch();
     //  System.schedule('Hourly', '0 0 * * * ?', bObj );
        SLA_CheckforReports b = new SLA_CheckforReports(); 
        database.executebatch(b); 
    }
}