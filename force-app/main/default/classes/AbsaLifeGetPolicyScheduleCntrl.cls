/**
 * @description Controller for the Absa Life Send Policy Schedule
 * @author Bhanumurty Rayala
 * @created 2021-10-19
 */
public class AbsaLifeGetPolicyScheduleCntrl {
    /**
     * @description fetchPolicyDetails
     * @param policyNumber
     * @return String
     */
    @AuraEnabled
    public static String fetchPolicyDetails(String policyNumber) {
        String results;
        PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(policyNumber);

        //check if response is null
        if (responseBean == null) {
            return 'Error: Blank response received from service;';
        }

        //check if response status is not successful
        if (responseBean.statusCode != 200) {
            return 'Error: ' + responseBean.message;
        }

        if(responseBean.Policy_LoadByRefNoResponse?.Policy_LoadByRefNoResult != null){
            results = JSON.serialize(responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult);
        }
        return results;
    }
    
    /**
     * @description getPolicyDocument
     * @param policyNumber
     * @return AbsaLifeGetPolicySchedule_Resp_IB_v1
     */
    @AuraEnabled
    public static AbsaLifeGetPolicySchedule_Resp_IB_v1 getPolicyDocument(String policyNumber) {
        
        AbsaLifeGetPolicySchedule_Resp_IB_v1 responseBean = AbsaLifeGetPolicySchedule_IH_v1.policyScheduleGet(policyNumber);
        return responseBean;
    }
    
    /**
     * @description getAccountDetails
     * @param sendPolicyParams
     * @param pdfData
     * @return String
     */
    @AuraEnabled
    public static String sendEmail(Map<String,String> sendPolicyParams, String pdfData) {
        
        String fileName = 'Policy Schedule-' + sendPolicyParams.get('policyNumber');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.toAddresses = new String[] {sendPolicyParams.get('clientEmail')};
		mail.setSubject('Policy Schedule: ' +sendPolicyParams.get('policyNumber'));
        
        String body = 'Dear ' +sendPolicyParams.get('clientName') +',</br>';
		body += ' </br>';
		body += 'Policy number: ' + sendPolicyParams.get('policyNumber') + '</br>';
        body += ' </br>';
        body += 'Absa life has attached your policy document as per request. </br>';
        body += ' </br>';
        body += 'We trust that you will find the above to your satisfaction. </br>';
        body += ' </br>';
		body += ' Kind regards </br>';
		body += ' Absa Life Team </br>';

		mail.setHtmlBody(body);
        Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
        fileAttachment.setFileName(fileName + '.pdf');
        fileAttachment.setBody(EncodingUtil.base64Decode(pdfData));
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {fileAttachment});
		List<Messaging.SendEmailResult> result = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
		if (result[0].isSuccess()) {
			return 'true';
		} else {
			return 'false';
		}  
    }

}