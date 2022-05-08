/**
 * @description       : 
 * @author            : Mradul Maheshwari
 * @last modified on  : 07-09-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : 
**/

public with sharing class StaticSMSController {
    /**
    * @description 
    * @author Mradul Maheshwari | 07-09-2021 
    * @param caseRecordId 
    * @param phone
    * @param msg 
    * @param integrationService  
    * @return String 
    **/
     @AuraEnabled
    public static String sendSms(String caseRecordId, String phone, String msg,String integrationService){
        return NotifyBankerController.notifyClientBySMS(caseRecordId,phone,msg,integrationService);
    }

    /**
    * @description 
    * @author Mradul Maheshwari | 07-09-2021 
    * @param accountNumber 
    * @return String 
    **/
    @AuraEnabled
    public static String getAccountCategory(String accountNumber) {
        return ABSAOnlineStatementSearchController.getAccountCategory(accountNumber);
    }
    
}