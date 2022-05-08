/**
 * @description Controller for ASPDeviceKofaxDocumentScanningController
 * @author  Paul du Randt
 * @created 2021-03-30
 */
public without sharing class ASPDeviceKofaxDocumentScanningController {
    /**
     * @description Function used to create Contract request
     * @param accountID
     * @param comments
     * @param ccApplicationNumber
     * @return string
     */
    @AuraEnabled
    public static String getKofaxScanningRequestMetadata(string accountID,string comments,string ccApplicationNumber){
        Account account = new AccountsSelector().selectAllById(accountID);
        ASPDeviceKofaxDocumentScanningRequest request = new ASPDeviceKofaxDocumentScanningRequest();
        request.CIFNumber = account.CIF__c;
        request.CustomerID = account.ID_Number__pc;
        request.CCApplicationNumber = ccApplicationNumber;
        request.Comments = comments;
        string usr = System.UserInfo.getUserId();
        User userInfo = [SELECT Email FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];
        request.UserEmail = userInfo.Email;
        String requestJson = JSON.serialize(request);
        return requestJson;
    }
}