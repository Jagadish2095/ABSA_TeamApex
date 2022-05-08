/**
 * @description       : 
 * @author            : Mradul Maheshwari
 * @last modified on  : 30-08-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-005674
**/

/**
* @description       : 
* @author            : Mradul Maheshwari
* @last modified on  : 30-08-2021
* @last modified by  : Mradul Maheshwari
* @Work Id           : W-005674
**/
public with sharing class AccountRestructureRequest_Resp_IB_v1 extends Base_IB{
    @AuraEnabled
    public String status;
    @AuraEnabled
    public Integer statusCode;
    @AuraEnabled
    public String message;
    
    @AuraEnabled
    public Integer accountNumber;
    @AuraEnabled
    public String responseCode;
    @AuraEnabled
    public String responseMessage;
    @AuraEnabled
    public String restructureOption;
    
}