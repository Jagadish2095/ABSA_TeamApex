/**
* @description Controller for Onboarding Non Individual Related Parties lightning component
* @author Vladimir Panajic
* @created 2020-02-17
*/ 
public class onboardingNonIndividualRelatedPartiesCon {

    /**
    * @description Experian Handler
    * @param registrationNumber 
    * @return String
    */
    @AuraEnabled
    public static String callExperianHandler(String registrationNumber){
        try{
            registrationNumber = registrationNumber.replace('/','');
            ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = ExperianBusinessDetailsGet_IH_v1.ExperianBusinessDetailsGet(registrationNumber);
            return responseBean.serialize(responseBean);
        } catch(Exception exc){
            System.debug('Exception Occurred'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ exc.getMessage());
        }
    }

    /** 
    * @description Method to calculate ControllingPercentage on Account Account Relationship
    * @param rolesValue
    * @param shareholdingpercentage
    * @param finservacct
    * @param finServRelatedAccount
    * @param finServRole
    * @param primaryEntityId
    * @param parentRelationshipId
    * @param clientType
    * @author: Chandra
    * @Date: 16/07/2020
    * @UserStory: W-004939
    */
    @AuraEnabled
    public static void calculateControllingPercentageforAccAccRel(String rolesValue, Decimal shareholdingpercentage,
                                                                 Id finservacct, Id finServRelatedAccount, Id finServRole,
                                                                 String primaryEntityId, String parentRelationshipId, String clientType){
        FinServ__AccountAccountRelation__c accAccRelObj = new FinServ__AccountAccountRelation__c();
        accAccRelObj.Roles__c = rolesValue;
        accAccRelObj.Shareholding_Percentage__c = shareholdingpercentage;
        accAccRelObj.FinServ__Account__c = finservacct;
        accAccRelObj.FinServ__RelatedAccount__c = finServRelatedAccount;
        accAccRelObj.FinServ__Role__c = finServRole;
        accAccRelObj.Primary_Entity_Id__c  = primaryEntityId;
        accAccRelObj.ParentRelationshipId__c  = parentRelationshipId;
        accAccRelObj.Client_Type__c  = clientType;
        try {
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRelObj);
            if(shareholdingpercentage > 0) {
                AccountAccountRelationController.calculateControllingPercentageVal2(accAccRelObj, primaryEntityId);
            } else {
                insert accAccRelObj;
            }
        } catch (DmlException e) {
            throw new AuraHandledException('An unexpected error has occurred: '+ e.getMessage());
        }
    }

    /**
    * @description Get account records type
    * @param recordTypeName 
    * @return Id
    */
    @AuraEnabled
    public static Id getAccountRecordTypeId(String recordTypeName) {

        Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        return accRecordTypeMap.get(recordTypeName).getRecordTypeId();
    }

    /**
    * @description Added by Masechaba Maseli 280720 for W-005223
    * @param primaryAccountId 
    * @param relatedAccountId 
    */
     @AuraEnabled
    public static void updateComplexContact(Id primaryAccountId, Id relatedAccountId) {

    List<Account> primaryAccList = new AccountsSelector().selectCasaFieldsById(primaryAccountId, 1);
    List<Account> relatedAcctsList = new AccountsSelector().selectCasaFieldsById(relatedAccountId, 1);

     If(relatedAcctsList[0].ID_Type__c == 'Registration Number' ){
     primaryAccList[0].Complex_Contact__c =  primaryAccList[0].Complex_Contact__c  + 1;}
     update primaryAccList[0];
    }
}