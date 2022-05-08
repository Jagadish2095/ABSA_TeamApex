public class creditdebitordercntrllr {
@AuraEnabled
    public static Application_Product__c getCaseApplicationProductRecord(Id caseId){
        List<Case>caseList=new CasesSelector().selectByIdWithSLAInfo(caseId,1);
        Id appProductId=caseList[0].Application_Product_Id__c;
        Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(string.valueOf(appProductId));
        System.debug('Doinit appProdRec'+ appProdRec);
        return appProdRec;
    }
}