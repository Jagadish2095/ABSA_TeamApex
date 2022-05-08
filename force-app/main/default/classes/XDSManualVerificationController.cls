public class XDSManualVerificationController {
    @auraEnabled
    public static Account saveAccount(string verifyby, Date XDSDate, string recordId){
        Account acc = new Account();
        acc.XDS_Verify_By__c = verifyby;
        acc.XDS_Date__c = XDSDate;
        acc.Id=recordId;
        acc.AuthMessage__c = 'Manually Verified';
        update acc;
        return acc;
            
    }

}