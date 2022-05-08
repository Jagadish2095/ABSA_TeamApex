/**
* Apex Integration Utility Bean class for TOM Complaint service
* @author  Anka Ganta : Absa
* @since   2019-08-13
*
**/
public class TOMComplaint_IU_v1{
    /* Creates a Request Bean from the Cases 
    * @param: List of Case objects
    * @return: TOMComplaint_Req_IB_v1.TOMComplaint_Req_IB_Payload_v1 bean object
    * */
    public static TOMComplaint_Req_IB_v1 mapRequestFields(Case caseRec){
        
        //TOMComplaint_Req_IB_v1.TOMComplaint_Req_IB_Payload_v1 requestBeanPayload = new TOMComplaint_Req_IB_v1.TOMComplaint_Req_IB_Payload_v1();
        TOMComplaint_Req_IB_v1 requestBeanPayload = new TOMComplaint_Req_IB_v1();
       
        requestBeanPayload.cifKey = caseRec.CIF__C;
        requestBeanPayload.AccountNumber = String.valueOf(caseRec.Account_Number__c);
        requestBeanPayload.complaintNumber = caseRec.CaseNumber;
        requestBeanPayload.type = caseRec.ATM_Service_Type__c;
        requestBeanPayload.incidentDate = String.valueOf(caseRec.Incident_Date__c);
        requestBeanPayload.incidentTime = String.valueOf(caseRec.IncidentTime__c);
        requestBeanPayload.claimAmount = String.valueOf(caseRec.Claim_Amount__c);
        requestBeanPayload.amountWithdrawn = String.valueOf(caseRec.Amount_Withdrawn__c);
        requestBeanPayload.amountReceived = String.valueOf(caseRec.Amount_Received__c);
        requestBeanPayload.ATMNumber = String.valueof(caseRec.Responsible_Site__r.Name);
        requestBeanPayload.absaATM = String.valueOf(caseRec.AbsaATM__c);
        requestBeanPayload.sequenceNumber = caseRec.SequenceNumber__c;
        requestBeanPayload.nonAbsaATMText = caseRec.NonAbsaATMText__c;
        requestBeanPayload.receipt = String.valueOf(caseRec.Receipt_Slip_Available__c);
        requestBeanPayload.clientName = caseRec.ClientName__c;
        requestBeanPayload.clientSurname = caseRec.ClientSurname__c;
       
        //requestBean.body = JSON.serialize(requestBeanPayload);
        return requestBeanPayload;  
    }
  
    
    /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: TOMComplaint_Resp_IB_v1 bean object
    * */
    
    public static TOMComplaint_Resp_IB_v1 mapResponseFields(HttpResponse respP,Case caseRec){
        System.debug('respP body'+respP.getBody());//To be removed
        
        TOMComplaint_Resp_IB_v1 responseBean = (TOMComplaint_Resp_IB_v1)JSON.deserialize(respP.getBody(),TOMComplaint_Resp_IB_v1.class);
       
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('TOM Service Success Response Bean after : ' + responseBean.status);//To be removed
        caseRec.TOM_Response__c = 'SUCCESS';
        caseRec.Is_Sent_To_TOM__c = true;
        caseRec.TOM_Sent_Time__c = System.Now();
        caseRec.TomDecision__c = 'Awaiting Feedback';
        caseRec.TomReason__c = 'Awaiting Feedback';
        caseRec.TomCaseNumber__C= responseBean.tomCaseNumber;
       return responseBean;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: TOMComplaint_Resp_IB_v1 bean object
    * */
    public static TOMComplaint_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        TOMComplaint_Resp_IB_v1 responseBean = new TOMComplaint_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('TOM Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}