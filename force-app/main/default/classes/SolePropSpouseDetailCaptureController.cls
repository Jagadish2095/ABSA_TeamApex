/**
 * @description       : Controller for Credit Spouse Details Capture
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 07-06-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-10   almas.aleem@absa.africa   Initial Version
**/

public  with sharing class SolePropSpouseDetailCaptureController {
    /**
     * @description
     * @author almas.aleem@absa.africa | 2021-06-10
     * @param oppId
     * @return SpouseAccount
    **/
    @auraEnabled
    public static SpouseAccount getSpouseAccount(Id oppId){
        Account acc = new accountsselector().selectIndvByOpportunityId(oppId);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectById(new Set<Id>{oppId});

        //if(opportunities != null && opportunities.size() > 0){
            //List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{opportunities[0].Spouse_Account_Id__c});
            System.debug('spouseaccId'+acc.Spouse_Account_Id__c);
            List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{acc.Spouse_Account_Id__c});
            if(accounts != null && accounts.size() > 0){
                opportunities[0].Spouse_Account_Id__c = acc.Spouse_Account_Id__c;
                opportunities[0].Is_Spouse_Captured__c = true;
                SpouseAccount spouseAccount = new SpouseAccount();
                //spouseAccount.oppId = opportunities[0].Id;
                spouseAccount.oppId = oppId;
                spouseAccount.accId = accounts[0].Id;
                spouseAccount.firstName = accounts[0].FirstName;
                spouseAccount.lastName = accounts[0].LastName;
                spouseAccount.dateOfBirth = String.valueOf(accounts[0].PersonBirthdate);
                spouseAccount.idType = accounts[0].Id_Type__pc;
                spouseAccount.idPassNum = accounts[0].Id_Number__pc != null ? accounts[0].Id_Number__pc : accounts[0].Passport_Number__pc;
                spouseAccount.isUnderDebtCounselling = accounts[0].Under_Debt_Counselling__c;
                spouseAccount.isSpouseContributing = accounts[0].Is_Spouse_Contribute__c;

                // Make sure we can update the database before even trying
                if (!Schema.sObjectType.Opportunity.fields.Spouse_Account_Id__c.isUpdateable()) {
                    return null;
                }
                update opportunities;
                return spouseAccount;
            }
        //}

        return generateBlankSpouseAccount(oppId);
    }

    /**
     * @description
     * @author ephetehe.mokgopanyane@absa.africa | 2021-06-10
     * @param accountDetails
     * @param oppId
     * @return SpouseAccount
    **/
    @auraEnabled
    public static SpouseAccount saveSpouseAccount(String accountDetails,Id oppId){
        Account acc = new accountsselector().selectIndvByOpportunityId(oppId);
        SpouseAccount spouseAccount = (SpouseAccount) JSON.deserialize(accountDetails, SpouseAccount.class);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectById(new Set<Id>{spouseAccount.oppId});
		List<Account> accounts = new AccountsSelector().selectAccountByIdPassportRegNumber(spouseAccount.idPassNum);
        List<Validations__c> spouseValRecords = [Select Related_to_Object_Record_Id__c, Name from Validations__c where Related_to_Object_Record_Id__c =:spouseAccount.oppId and Name = 'Is_Spouse_Captured'];
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(spouseAccount.oppId);

        if(opportunities != null && opportunities.size() > 0){
            if(accounts != null && accounts.size() > 0){
                acc.Spouse_Account_Id__c = accounts[0].Id;
                opportunities[0].Spouse_Account_Id__c = accounts[0].Id;
                opportunities[0].Is_Spouse_Captured__c = true;
                accounts[0].Under_Debt_Counselling__c = spouseAccount.isUnderDebtCounselling;
                accounts[0].Is_Spouse_Contribute__c = spouseAccount.isSpouseContributing;

                if(accounts[0].Client_Type__c == null && accounts[0].CIF__c == null){
                    accounts[0].Client_Type__c = 'Individual';
                }

                try{
                    update acc;
                    
                    update accounts[0];
                    update opportunities[0];
 
                    if(spouseValRecords == null || spouseValRecords.size() == 0){
                        PowerCurveController.setValidationFields(spouseAccount.oppId, 'Is_Spouse_Captured', true);

                        if(!Test.isRunningTest()){
                       
                        AllocateStockNumberController.createAppProfileRecords(spouseAccount.oppId);
                        }
                        NonScoredApprovedFacilitiesCtrl.addSpouseFacilities(app.Id, opportunities[0]);
                    }

                    /*
                    Not necessary as the trigger caters for this
                    List<Application_Profile__c> appProfiles = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
                    Set<Id> appSecIds = new Set<Id>();

                    for(Application_Profile__c appProfile : appProfiles){
                        appSecIds.add(appProfile.Id);
                    }

                    ExposureController.getApplicationExposuresFutureCallQueue(appSecIds);*/

                    return generateSpouseAccount(accounts[0], spouseAccount.oppId);
                } catch(Exception exc){
                    system.debug('error--'+exc.getMessage()+'---'+exc.getStackTraceString());
                    throw new AuraHandledException('Error - ' + String.valueOf(exc));
                }
            } else {
                Account account = new Account();
                account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId();
                account.FirstName = spouseAccount.firstName;
                account.LastName = spouseAccount.lastName;
                account.Id_Type__pc = spouseAccount.idType;
                account.PersonBirthdate = Date.valueOf(spouseAccount.dateOfBirth);
                account.Is_Spouse_Contribute__c = spouseAccount.isSpouseContributing;
                account.Under_Debt_Counselling__c = spouseAccount.isUnderDebtCounselling;
                account.Client_Type__c = 'Individual';

                if(spouseAccount.idType.equalsIgnoreCase('SA Identity Document')){
                    account.ID_Number__pc = spouseAccount.idPassNum;
                } else if(spouseAccount.idType.equalsIgnoreCase('Passport')){
                    account.Passport_Number__pc = spouseAccount.idPassNum;
                }

                try{
                   
                    insert account;
                    acc.Spouse_Account_Id__c = account.Id;
                    
                    opportunities[0].Spouse_Account_Id__c = account.Id;
                    opportunities[0].Is_Spouse_Captured__c = true;
                    update opportunities;
                    update acc;

                    if(spouseValRecords == null || spouseValRecords.size() == 0){
                        PowerCurveController.setValidationFields(spouseAccount.oppId, 'Is_Spouse_Captured', true);
                        if(!Test.isRunningTest()){
                        AllocateStockNumberController.createAppProfileRecords(spouseAccount.oppId);
                        }
                        NonScoredApprovedFacilitiesCtrl.addSpouseFacilities(app.Id, opportunities[0]);
                            
                    }

                    /*
                    Not necessary as the trigger caters for this
                    List<Application_Profile__c> appProfiles = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
                    Set<Id> appSecIds = new Set<Id>();

                    for(Application_Profile__c appProfile : appProfiles){
                        appSecIds.add(appProfile.Id);
                    }

                    ExposureController.getApplicationExposuresFutureCallQueue(appSecIds);*/
                    return generateSpouseAccount(account, spouseAccount.oppId);
                } catch(Exception exc){
                    throw new AuraHandledException('Error - ' + String.valueOf(exc));
                }
            }
        }

        return SpouseAccount;
    }


    /**
     * @description delink spouse account
     * @author ephetehe.mokgopanyane@absa.africa | 2021-06-10
     * @param accountDetails
     * @param oppId
     * @return SpouseAccount
    **/
    @auraEnabled
    public static SpouseAccount delinkSpouseAccount(String accountDetails,Id oppId){
        Account acc = new accountsselector().selectIndvByOpportunityId(oppId);
        SpouseAccount spouseAccount = (SpouseAccount) JSON.deserialize(accountDetails, SpouseAccount.class);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectById(new Set<Id>{spouseAccount.oppId});
        List<Validations__c> spouseValRecords = [SELECT Related_to_Object_Record_Id__c, Name FROM Validations__c WHERE Related_to_Object_Record_Id__c =:spouseAccount.oppId AND Name = 'Is_Spouse_Captured'];

        if(opportunities != null && opportunities.size() > 0){
            opportunities[0].Is_Spouse_Captured__c = false;
            opportunities[0].Spouse_Account_Id__c = null;
            acc.Spouse_Account_Id__c = null;

            String clientName = spouseAccount.firstName + ' ' + spouseAccount.lastName;
            Application__c appDet = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
            List<Application_Exposure_Facility__c> existingAppFacs = new NonScoredApprovedFacilitiesSelector().selectByClientName(appDet.Id, clientName);

            try{
                update acc;
                update opportunities[0];
                delete spouseValRecords;
                delete existingAppFacs;

                return generateBlankSpouseAccount(spouseAccount.oppId);
            } catch(Exception exc){
                throw new AuraHandledException('Error - ' + String.valueOf(exc));
            }
        }

        return spouseAccount;
    }

    /**
     * @description generate blank account
     * @author ephetehe.mokgopanyane@absa.africa | 2021-06-10
     * @param oppId
     * @return SpouseAccount
    **/
    public static SpouseAccount generateBlankSpouseAccount(Id oppId){
        SpouseAccount spouseAccount = new SpouseAccount();
        spouseAccount.oppId = oppId;
        spouseAccount.accId = '';
        spouseAccount.firstName = '';
        spouseAccount.lastName = '';
        spouseAccount.dateOfBirth = '';
        spouseAccount.idType = '';
        spouseAccount.idPassNum = '';
        spouseAccount.isUnderDebtCounselling = false;
        spouseAccount.isSpouseContributing = false;

        return spouseAccount;
    }

    /**
     * @description save spouse account
     * @author ephetehe.mokgopanyane@absa.africa| 2021-06-10
     * @param acc
     * @param oppId
     * @return SpouseAccount
    **/
    public static SpouseAccount generateSpouseAccount(Account acc, Id oppId){
        SpouseAccount spouseAccount = new SpouseAccount();
        spouseAccount.oppId = oppId;
        spouseAccount.accId = acc.Id;
        spouseAccount.firstName = acc.FirstName;
        spouseAccount.lastName = acc.LastName;
        spouseAccount.dateOfBirth = String.valueOf(acc.PersonBirthdate);
        spouseAccount.idType = acc.Id_Type__pc;
        spouseAccount.idPassNum = acc.Id_Number__pc != null ? acc.Id_Number__pc : acc.Passport_Number__pc;
        spouseAccount.isUnderDebtCounselling = acc.Under_Debt_Counselling__c;
        spouseAccount.isSpouseContributing = acc.Is_Spouse_Contribute__c;

        return spouseAccount;
    }

    /**
     * @description  Spouse Account calss wrapper
     * @author almas.aleem@absa.africa | 2021-06-10
     *
    **/
    public class SpouseAccount {
		/** @description  OPP Id **/
        @auraEnabled public String oppId { get; set; }
        /** @description  Acc Id **/
        @auraEnabled public String accId { get; set; }
        /** @description  firstname **/
        @auraEnabled public String firstName { get; set; }
        /** @description  lastname **/
        @auraEnabled public String lastName { get; set; }
        /** @description  dob **/
        @auraEnabled public String dateOfBirth { get; set; }
        /** @description  idtype **/
        @auraEnabled public String idType { get; set; }
        /** @description  idpassNum **/
        @auraEnabled public String idPassNum { get; set; }
        /** @description  isUnderDebtCounselling **/
        @auraEnabled public Boolean isUnderDebtCounselling { get; set; }
        /** @description  isSpouseContributing **/
        @auraEnabled public Boolean isSpouseContributing { get; set; }
	}
}