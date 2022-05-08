/**
 * @description Apex Class to schedule voucher reissue
 * @author Simangaliso Mathenjwa
 * @since 2021-11-04
 */
global class ScheduleVoucherReIssue implements Schedulable{
    public Map<String, String> requestFieldsMap;
    public static String jobId;
    
    /**
	 * @description constructor method
	 * @param requestFieldsMapP
	 */
    public ScheduleVoucherReIssue ( Map<String, String> requestFieldsMapP) {
        requestFieldsMap = requestFieldsMapP;

    }

    /**
	 * @description execute method 
	 * @param context
	 */
    global void execute(SchedulableContext context){
        ReIssueVoucher_Resp_IB_v1 responseBean = ReIssueVoucher_IH_IB_v1.callReissueVoucher(requestFieldsMap);
        CronTrigger ct = [SELECT TimesTriggered, Id, NextFireTime FROM CronTrigger WHERE Id = :context.getTriggerId()];
        jobId = String.valueOf(ct.Id);
    }

    /**
	 * @description finish method 
	 * @param BC
	 */
    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        //then use the active job id and abort it
        system.abortJob(jobId);
        }
}