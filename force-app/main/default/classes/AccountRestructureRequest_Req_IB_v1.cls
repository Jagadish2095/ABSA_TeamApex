/**
* @description       : 
* @author            : Mradul Maheshwari
* @last modified on  : 30-08-2021
* @last modified by  : Mradul Maheshwari
* @Work Id           : W-005674
**/
public with sharing class AccountRestructureRequest_Req_IB_v1 extends Base_IB{
    @AuraEnabled
    public String systemId;
    @AuraEnabled
    public String accountNumber;
    @AuraEnabled
    public String advanceAmount;
    @AuraEnabled
    public String restructureOption;
    @AuraEnabled
    public String email;
    @AuraEnabled
    public String consent;
    @AuraEnabled
    public String newInstallment;
    @AuraEnabled
    public String newCalculatedInstallmentsNo;
    @AuraEnabled
    public String newTerm;
    @AuraEnabled
    public String newContractEndDate;
    @AuraEnabled
    public String newResidualAmount;
    
    
    /**
* @description 
* @author Mradul Maheshwari | 08-19-2021 
* @return AccountRestructureRequest_Req_IB_v1 
**/
    public static AccountRestructureRequest_Req_IB_v1 createDummyRequest() {
        AccountRestructureRequest_Req_IB_v1 requestBean = new AccountRestructureRequest_Req_IB_v1();
        requestBean.systemId = 'Salesforce';
        requestBean.accountNumber = '274373';
        requestBean.advanceAmount = '10000';
        requestBean.restructureOption = 'Term';
        requestBean.email = 'mradul.maheshwari@mphatek.com';
        requestBean.consent = 'Y';
        requestBean.newInstallment = '4322.11';
        requestBean.newCalculatedInstallmentsNo = '50';
        requestBean.newTerm = '68';
        requestBean.newContractEndDate = '20250701';
        requestBean.newResidualAmount  = '0';
        
        return requestBean;
    }
}