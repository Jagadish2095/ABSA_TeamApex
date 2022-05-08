/*
* 
* @author Thabo K Senkomane
* @created 2020-07-30
*/
public class BankCodesUpdateCTRL {
    //method for sending registration data for closed case
    @AuraEnabled
    public static string SendRegistrationCaseToDigital(Id caseId)
    {
        String response;
        Set<Id> caseSetId = new Set<Id>();
        caseSetId.add(caseId);
        List<Case> caseList = new CasesSelector().selectByCaseId(caseId);
        if(caseList != null && caseList.size() > 0) {
            if(caseList[0].Status == Label.Approved_Status || caseList[0].Status == Label.Declined_Status){
                if(caseList[0].Reference_Number__c != null){
                    BankCodesUpdateCase_Req_IB_v1 requestBean = new BankCodesUpdateCase_Req_IB_v1();
                    requestBean.Id = caseList[0].Id;
                    requestBean.Reference_Number = caseList[0].Reference_Number__c;
                    requestBean.Reason = caseList[0].Reason;
                    requestBean.Status = caseList[0].Status;
                    requestBean.Request_Type = null;
                    requestBean.Reason_Combination = null;
                    requestBean.Consultant_Notes_Comments = caseList[0].Consultant_Notes_Comments__c;
                    requestBean.Request_From_Absa_Business_Client = caseList[0].Request_From_Absa_Business_Client__c;
                    requestBean.Account_Conduct_Checked = caseList[0].Account_Conduct_Checked__c;
                    requestBean.Account_Number_Confirmed = caseList[0].Account_Number_Confirmed__c;
                    requestBean.Email_Address_Confirmed = caseList[0].Email_Address_Confirmed__c;
                    requestBean.Request_From_Financial_Institution = caseList[0].Request_From_Financial_Institution__c;
                    requestBean.Name_Confirmed = caseList[0].Name_Confirmed__c;
                    requestBean.User_Type_Confirmed = caseList[0].User_Type_Confirmed__c;
                    requestBean.Working_History = caseList[0].Working_History__c;
                    //System.debug('requestBean ' +requestBean.Name_Confirmed );
                    
                    BankCodesUpdateCase_Resp_IB_v1 responseBean = BankCodesUpdateCase_IH_v1.BankCodesUpdateCase(requestBean);
                    string resp = JSON.serialize(responseBean);
                    if(responseBean.statusCode == 200){
                        System.debug('debug result :'+ responseBean.status);
                        if(responseBean.success == true)
                        {
                             response = 'SUCCESS';
                        }
                       else
                       {
                          response =  'Something went wrong, update failed!';
                       }
                    }
                    else
                    {
                        response =  'ERROR: ' + responseBean.success + ' ' + responseBean.status;  
                    }
                }
                else
                {
                    response = 'Case Reference is Required for Submission!';        
                }
            }
            else
            {
                response = 'Please Close the Case before Submitting!';                  
            }
        }
        return response;
    }
    //method for sending request data for closed case
    @AuraEnabled
    public static string SendRequestCaseToDigital(Id caseId)
    {
        String response;
        Set<Id> caseSetId = new Set<Id>();
        caseSetId.add(caseId);
        List<Case> caseList = new CasesSelector().selectByCaseId(caseId);
        if(caseList != null && caseList.size() > 0) {
            
            if(caseList[0].Status ==  Label.Case_Closed ){
                System.debug('Id ' +caseList[0].Id );
                if(caseList[0].Reference_Number__c != null){
                    BankCodesUpdateCase_Req_IB_v1 requestBean = new BankCodesUpdateCase_Req_IB_v1();
                    requestBean.Id = caseList[0].Id;
                    requestBean.Reference_Number = caseList[0].Reference_Number__c;
                    requestBean.Reason = caseList[0].Reason;
                    requestBean.Status = caseList[0].Status;
                    requestBean.Request_Type = 'Y';//caseList[0].Request_Type__c;
                    //
                    if(caseList[0].Type__c ==  Label.Full_General_Report){
                        requestBean.Bank_Code_1 =null;
                        requestBean.Bank_Code_2 = null;  
                    }
                    else
                    {
                        requestBean.Bank_Code_1 = caseList[0].Bank_Code_1__c;
                        requestBean.Bank_Code_2 = caseList[0].Bank_Code_2__c;
                    }
                    requestBean.Reason_Combination = caseList[0].Reason_Combination__c;
                    requestBean.Consultant_Notes_Comments = caseList[0].Consultant_Notes_Comments__c;
                    requestBean.ClosedDate = caseList[0].ClosedDate;// null;
                    requestBean.AB_Number = caseList[0].AB_number__c;
                    
                    requestBean.Working_History = caseList[0].Working_History__c;
                    // requestBean.Date_Issued =  null;caseList[0].createdDate;
                    //null values
                    requestBean.Account_Conduct_Checked = null;
                    requestBean.Account_Number_Confirmed = null;
                    requestBean.Name_Confirmed = null;
                    requestBean.Email_Address_Confirmed = null;
                    requestBean.Request_From_Absa_Business_Client = null;
                    requestBean.Request_From_Financial_Institution = null;
                    requestBean.User_Type_Confirmed = null;
                     System.debug('>'+requestBean.Reason_Combination);
                    System.debug('>'+ JSON.serialize(requestBean));
                    BankCodesUpdateCase_Resp_IB_v1 responseBean = BankCodesUpdateCase_IH_v1.BankCodesUpdateCase(requestBean);
                    string resp = JSON.serialize(responseBean);
                    System.debug('bean ' +JSON.serialize(responseBean));
                    if(responseBean.statusCode == 200){
                        response = 'SUCCESS';
                    }
                    else
                    {
                        response =  'ERROR: ' + responseBean.success + ' ' + responseBean.status;  
                    }
                }
                else
                {
                    response = 'Case Reference is Required for Submission!';        
                }
            }
            else
            {
                response = 'Please Close the Case before Submitting!';                  
            }
        }
        return response;
    }
}