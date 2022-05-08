/**
* @description       : 
* @author            : Mradul Maheshwari
* @last modified on  : 30-08-2021
* @last modified by  : Mradul Maheshwari
* @Work Id           : W-005674
**/
public with sharing class CalculatorRequest_Req_IB_v1 extends Base_IB{
    
    @AuraEnabled
    public String systemId;
    @AuraEnabled
    public String accountNumber;
    @AuraEnabled
    public String advanceAmount;
    
    
    /**
* @description 
* @author Mradul Maheshwari | 08-18-2021 
* @return CalculatorRequest_Req_IB_v1 
**/
    public static CalculatorRequest_Req_IB_v1 createDummyRequest() {
        CalculatorRequest_Req_IB_v1 requestBean = new CalculatorRequest_Req_IB_v1();
        requestBean = new CalculatorRequest_Req_IB_v1();
        requestBean.systemId = 'Salesforce';
        requestBean.accountNumber = '75678237';
        requestBean.advanceAmount = '10000';
        
        return requestBean;
    }
}