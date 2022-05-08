/**
 * @description       : Selector class for Application Profile object
 * @author            : Himani Joshi
 * @last modified on  : 2021-10-19
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   2021-06-07   Himani Joshi   Initial Version
**/

public class  ApplicationProfileSelector extends fflib_SObjectSelector {
    
    /**
    * @description : Method to get the sobject type
    * @author Himani Joshi | 2021-06-07 
    * @return Schema.SObjectType 
    **/
    public Schema.SObjectType getSObjectType(){
        return Application_Profile__c.sObjectType;
    }

    /**
    * @description : Method to get the sobject field list
    * @author Himani Joshi | 2021-06-07 
    * @return List<Schema.SObjectField> 
    **/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Profile__c.Id,
            Application_Profile__c.Applicant_Type__c,
            Application_Profile__c.Bureau_Worst_Report__c,
            Application_Profile__c.Client_CIF_Code__c,
            Application_Profile__c.Client_Name__c,
            Application_Profile__c.Is_Main_Applicant__c,
            Application_Profile__c.KIMNumber__c,
            Application_Profile__c.KIM_Number_No_Possible_Match__c
        };
    }
    
    /**
    * @description : Method to get application profiles using applicationId
    * @author Himani Joshi | 2021-06-07 
    * @param applicationId 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getApplicationProfiles(Id applicationId) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Related_to_Client_Code__c')
            .selectField('Related_to_Client_ID_or_Reg_Number__c')
            .selectField('Applicant_Type__c')
            .selectField('Client_CIF_Code__c')
            .selectField('client_name__c')
            .selectField('NoOfJointPartcpnt__c')
            .selectField('CuratorshipHold__c')
            .selectField('FinCrimeHold__c')
            .selectField('ApplyDebtCounsel__c')
            .selectField('Account__r.CIF__c')
            .selectField('Account__r.Client_Type__c')
            .selectField('Account__r.LastName')
            .selectField('Account__r.FirstName')
            .selectField('Account__r.Id_Number__pc')
            .selectField('Account__r.Passport_Number__pc')
            .selectField('Account__r.PersonBirthdate')
            .selectField('Account__r.Registration_Number__c')
            .selectField('Account__r.Occupation__pc')
            .selectField('Account__r.Employer_Name__pc')
            .selectField('Account__r.PersonMobilePhone')
            .selectField('Account__r.PersonMobilePhone')
            .selectField('Account__r.PersonOtherPhone')
            .selectField('Account__r.PersonOtherPhone')
            .selectField('Account__r.VAT_Registration_Number__c')
            .selectField('Account__r.Trading_Name__c')
            .selectField('Account__r.MiddleName')
            .selectField('Account__r.Name')
            .setCondition('Application__c =:applicationId')
            .toSOQL()
        );
    }

    
    /**
    * @description : Method to get bureau data using oppId
    * @author Himani Joshi | 2021-06-07 
    * @param opportunityId 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getAppProfileBureauData(Id opportunityId){
        //String mainApplicant = StringConstants.APPLICATION_PROFILE_APPLICANT_TYPE_MAIN;
        //String principalApplicant = StringConstants.APPLICATION_PROFILE_APPLICANT_TYPE_PRINCIPAL;
        String mainApplicant = 'Main Applicant';
        String spouseApplicant = 'Spouse';
        String principalApplicant = 'Principal';
        Set<String> applicantTypes = new Set<String>{mainApplicant, spouseApplicant,principalApplicant};

        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('PCCE_Id__c')
            .selectField('Bureau_JSON_Response__c')
            .selectField('Bureau_Report_1__c')
            .selectField('Bureau_Report_2__c')
            .selectField('Client_CIF_Code__c')
            .selectField('Account__c')
            .selectField('Account__r.Client_Type__c')
            .setCondition('Application__r.Opportunity__c =:opportunityId AND Applicant_Type__c IN: applicantTypes')
            .toSOQL()
        );
    }

    
    /**
    * @description : Method to get application profiles using set of applicationIds
    * @author Himani Joshi | 2021-06-07 
    * @param applicationIds 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getApplicationProfilesbyAppIdSet(Set<String> applicationIds) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Related_to_Client_ID_or_Reg_Number__c')
            .selectField('Applicant_Type__c')
            .selectField('Client_CIF_Code__c')
            .selectField('client_name__c')
            .selectField('Application__c')
            .selectField('noOfJointPartcpnt__c')
            .selectField('curatorshipHold__c')
            .selectField('finCrimeHold__c')
            .selectField('applyDebtCounsel__c')
            .selectField('Account__c')
            .selectField('Account__r.CIF__c')
            .selectField('Account__r.Client_Type__c')
            .selectField('Account__r.LastName')
            .selectField('Account__r.FirstName')
            .selectField('Account__r.ID_Number__pc')
            .selectField('Account__r.PersonBirthdate')
            .selectField('Account__r.PersonBirthdate')
            .selectField('Account__r.Occupation__pc')
            .selectField('Account__r.Employer_Name__pc')
            .selectField('Account__r.PersonMobilePhone')
            .selectField('Account__r.PersonMobilePhone')
            .selectField('Account__r.PersonOtherPhone')
            .selectField('Account__r.Registration_Number__c')
            .selectField('Account__r.VAT_Registration_Number__c')
            .selectField('Account__r.Trading_Name__c')
            .selectField('Account__r.Name')
            .setCondition('Application__c IN:applicationIds')
            .toSOQL()
        );
    }

    /**
    * @description : Method to get application profiles using set of Id 
    * @author Himani Joshi | 2021-06-07 
    * @param AppProfIds 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getApplicationProfilesbyId(Set<Id> AppProfIds) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Related_to_Client_ID_or_Reg_Number__c')
            .selectField('Applicant_Type__c')
            .selectField('Client_CIF_Code__c')
            .selectField('client_name__c')
            .selectField('Application__c')
            .selectField('Application__r.Opportunity__r.Account.sic')
            .selectField('noOfJointPartcpnt__c')
            .selectField('curatorshipHold__c')
            .selectField('finCrimeHold__c')
            .selectField('applyDebtCounsel__c')
            .setCondition('Id IN:AppProfIds')
            .toSOQL()
        );
    }

    /**
    * @description : Method to get application profiles using applicationId and apptypes
    * @author Himani Joshi | 2021-06-07 
    * @param applicationId 
    * @param appType 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getApplicationProfilesByType(Id applicationId,String appType) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .setCondition('Application__c =:applicationId AND Applicant_Type__c=:appType')
            .toSOQL()
        );
    }

    /**
    * @description : Method to get application profiles using related client code
    * @author Himani Joshi | 2021-06-07 
    * @param regNo 
    * @param appId 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getApplicationProfilesByRelatedClientCode(string regNo,Id appId) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Related_to_Client_ID_or_Reg_Number__c')
            .selectField('Applicant_Type__c')
            .selectField('Client_CIF_Code__c')
            .setCondition('Related_to_Client_ID_or_Reg_Number__c =:regNo AND application__c=:appId')
            .toSOQL()
        );
    }

    /**
    * @description : Method to get linked principals using idno,applicanttype and appId
    * @author Himani Joshi | 2021-06-07 
    * @param idNo 
    * @param applicantType 
    * @param appId 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getLinkedPrincipals(string idNo,string applicantType,Id appId) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Related_to_Client_ID_or_Reg_Number__c')
            .selectField('Applicant_Type__c')
            .selectField('Client_CIF_Code__c')
            .setCondition('Related_to_Client_ID_or_Reg_Number__c =:idNo AND Applicant_Type__c=:applicantType AND application__c=:appId')
            .toSOQL()
        );
    }

    /**
    * @description : Method to get getLinkedPrincipals using set of ids,applicant type and appId
    * @author Himani Joshi | 2021-06-07 
    * @param idNos 
    * @param applicantType 
    * @param appId 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getLinkedPrincipals(set<String> idNos,string applicantType,Id appId) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Related_to_Client_ID_or_Reg_Number__c')
            .selectField('Applicant_Type__c')
            .selectField('Client_CIF_Code__c')
            .setCondition('Related_to_Client_ID_or_Reg_Number__c IN:idNos AND Applicant_Type__c=:applicantType AND application__c=:appId')
            .toSOQL()
        );
    }

    
    /**
    * @description : Method to get application profiles using appId
    * @author Himani Joshi | 2021-06-07 
    * @param applicationId 
    * @return List<Application_Profile__c> 
    **/
    public List<Application_Profile__c> getApplicationProfilesByType(Id applicationId) {
        return Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('PCCE_Id__c')
            .selectField('Bureau_JSON_Response__c')
            .selectField('Credit_Card_Response__c')
            .selectField('Applicant_Type__c')
            .selectField('Is_Main_Applicant__c')
            .selectField('Account__r.ID_Number__pc')
            .selectField('Account__r.Passport_Number__pc')
            .selectField('Account__r.Registration_Number__c')
            .selectField('Total_Credit_Instalment_Amount__c')
            .setCondition('Application__c =:applicationId' )
            .toSOQL()
        );
    }
}