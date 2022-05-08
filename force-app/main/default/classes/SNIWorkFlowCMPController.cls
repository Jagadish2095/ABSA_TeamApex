public class SNIWorkFlowCMPController {

    @AuraEnabled
    public static void updateOpp(String oppId){
        Opportunity opp = [Select Id,MiddleOffice_KYC__c From OPportunity Where Id=: oppId LIMIT 1];
        opp.MiddleOffice_KYC__c = 'Middle Office - KYC';
        try{
            update opp;
        }catch(Exception e){
            
        }
    }
}