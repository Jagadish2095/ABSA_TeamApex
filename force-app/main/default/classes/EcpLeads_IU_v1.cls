/**
* @author Rajesh Nandigam
* @since 2021-07-20
* @description Ecp Leads Utility class
**/

public class EcpLeads_IU_v1 {
    /**
* @since 2021-07-20
* @description Ecp Leads Utility class
* @return 
* @param accId
* @param leadPrdInterest
* @param accStatus
**/
    public static EcpLeads_Req_IB_v1 mapRequestdFields(String accId, String leadPrdInterest, string accStatus){ 
        
        Account accRec = new AccountsSelector().selectAllById (accId);
        List<String> lProdInterest = leadPrdInterest.split(';');
        string execLayReqId = accRec.ExecutionLayerRequestID__c != null ? accRec.ExecutionLayerRequestID__c : '';
        string accNo = accRec.AccountNumber != null ? accRec.AccountNumber : '';       
        string firstName = accRec.FirstName != null ? accRec.FirstName : 'C1-';
        string lastName = accRec.LastName != null ? accRec.LastName : accRec.Name;
        string persEmail = accRec.PersonEmail != null ? accRec.PersonEmail : '';
        string persMobile = accRec.PersonMobilePhone != null ? accRec.PersonMobilePhone : '';
        
        
        
        
        
        EcpLeads_Req_IB_v1 EcpLeads = new EcpLeads_Req_IB_v1();
        EcpLeads.senderReference = 'Absa';
        EcpLeads.replyMessage = '';
        EcpLeads.replyTime = '2021-03-09T17:07:28Z';
        EcpLeads.nextTry = '2021-05-01T09:00:00Z';
        EcpLeads.fromNumber = persMobile;
        EcpLeads.backupContactNumber = persMobile;
        EcpLeads.emailAddress = persEmail;
        EcpLeads.campaign = 'Free Text';
        EcpLeads.campaignType = 'Free Text';
        EcpLeads.firstName =  firstName;
        EcpLeads.lastName = lastName;
        EcpLeads.originalMsg = 'Something the customer may have seen before';
        EcpLeads.packageId = 'sim-sme';
        
        
        
        return EcpLeads;
        
    }
}