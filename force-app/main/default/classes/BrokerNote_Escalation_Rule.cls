/* 
* Shedular class Created to execute batch -caseEscalationCheckBatch
* @author   Vitthal Jivrag
* @since    2021-01-05
*/

global class BrokerNote_Escalation_Rule implements Schedulable{
    global void execute(SchedulableContext ctx) {
        Id jobID;
        caseEscalationCheckBatch bb=new caseEscalationCheckBatch();
        
        if(!Test.isRunningTest()){
        	jobID= Database.executeBatch(bb, 1);        
        }
    }
}