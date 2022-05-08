/**
 * @description Schedulable class for Everyday Banking Charge Control Process
 * @author  Koketso Mpshane
 * @date    24/08/2021
 */
global class EBChargeControlProcessSchedule implements Schedulable {
    /**
	 * @description method execute
	 * @param sc Schedulable Context
	 */
	global void execute(SchedulableContext sc) {
        executeChargeControlProcess();
	}
    
    /**
	 * @description method executeChargeControlProcess
	 */
    @future(callout=true)
    global static void executeChargeControlProcess() {
        
        List<Messaging.SendEmailResult> emailResults;
        
        List<Charge_Control__c> chargeControlList = new ChargeControlsSelector().filterByChargeProcessCode('0000');      
		
        EBChargeControl_Resp_IB_v1 responseBean = EBChargeControl_IH_v1.ChargeControl(chargeControlList);
        //check if response is null
        if (responseBean == null) {
            emailResults = sendChargeControlProcessErrors('Blank response received from service;');
        }
        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            emailResults = sendChargeControlProcessErrors(responseBean.message);
        }

        if(responseBean.response_Status != 'Success'){
            emailResults = sendChargeControlProcessErrors(JSON.serialize(responseBean));
        }
	}
    
    /**
	 * @description method to send an email
	 * @param errors
	 * @return List<Messaging.SendEmailResult>
	 */
	public static List<Messaging.SendEmailResult> sendChargeControlProcessErrors(String errors) {
        
		List<Messaging.SendEmailResult> results;
        
		List<string> recipientEmails = new List<string>();
		String lblEmailAddresses = Label.Charge_Control_Process_Emails;
		List<String> emailRecipients = lblEmailAddresses.split(';');
		if (emailRecipients.size() > 0) {
			for (String emails : emailRecipients) {
				recipientEmails.add(emails);
			}
		}

		if (recipientEmails.size() > 0) {
			List<Messaging.SingleEmailMessage> singleMessageList = new List<Messaging.SingleEmailMessage>();
			Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
			msg.setToAddresses(recipientEmails);
			msg.setSubject('Charge Control Process Errors');
            String emailBody = 'Good day, <br/><br/>Please note that Charge Control Process service returned the below errors :<br/><br/>'+errors;
			msg.setHtmlBody(emailBody);
			msg.setSaveAsActivity(false);
			singleMessageList.add(msg);
			//Send the email
			results = Messaging.sendEmail(singleMessageList);
		}
        
		return results;
	}
}