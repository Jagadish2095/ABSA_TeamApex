/**
 * @description       : Test class for PowerCurveFinancialsResponseCtrl
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-07-19
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-07-19   Ephetehe Mokgopanyane   Initial Version
**/

@isTest
public class PowerCurveFinancialsResponseCtrlTest {
	/**
	* @description : Method to create test data
	* @author Ephetehe Mokgopanyane | 2021-07-19 
	**/
	@testSetup
	public static void dataCreation() {
        Account account = new Account();
        account.Name = 'Test Account';
        account.CIF__c = 'SNIFFEL001';
        account.Sic='35790';
        account.AccountNumber='0';
        account.Registration_Number__c = '1990/011515/23';
        account.Client_Type__c = 'Individual';
        insert account;
        
        Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
		Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
		Id onboardingrecId = rtMapByName.get('Credit Onboarding').getrecordtypeId();
		
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opp Onboarding 1';
        opportunity.RecordTypeId = onboardingrecId;
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'New';
        opportunity.AccountId=account.Id;
        insert opportunity;
        
        Application__c application = new Application__c();
        application.Opportunity__c = opportunity.id;
        application.Account_Access__c = 'Cellphone';
        application.Surplus_Cash__c = 'Fixed Deposits';
        application.Borrowing_Requiment_General__c = 'Credit Card';
        application.Protection_Of_Services__c = 'Retirement';
        application.Title__c = 'dd';
        application.FirstNameSignature__c = 'Litha';
        application.SurnameSignature__c = 'Nosekeleza';
        application.Signing_Date__c = System.today();
        application.Stock_Number__c = '';
        insert application;
         
        Group testGroup = new Group(Name = 'Credit Support Consultant', Type = 'Queue');
		insert testGroup;

		System.runAs(new User(Id = UserInfo.getUserId())) {
			QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
			insert testQueue;
		}

		List<Group> groupDetail = new GroupsSelector().selectByNameSetAndType(new Set<String>{'Credit Support Consultant'},'Queue');

		Service_Group__c tstServQG = new Service_Group__c();
		tstServQG.Name = 'Financial Capture Group';
		tstServQG.Queue__c = groupDetail[0].id;
		insert tstServQG;

		Service_Type__c tstServT = new Service_Type__c();
		tstServT.name = 'check';
		insert tstServT;

		Service_Group_Type__c tstServQT = new Service_Group_Type__c();
		tstServQT.Service_type__c = tstServT.Id;
		tstServQT.Service_Group__c = tstServQG.Id;
		insert tstServQT;
        Application_Principal__c appPrinc = new Application_Principal__c();
        appPrinc.application__c = application.Id;
        appPrinc.Principal_Shareholder_Name__c = 'SNIFFEL001';
        appPrinc.CIF__c = 'SNIFFEL001';
        appPrinc.Is_Part_Of_Application__c = true;
        insert appPrinc;
        
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = new List<Application_Assets_and_Liabilities__c>();
        Schema.sObjectType objType = FinServ__AssetsAndLiabilities__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry> values = fieldMap.get('FinServ__AssetsAndLiabilitiesType__c').getDescribe().getPickListValues();
        String validPicklistVals = validAssetLiabTypes();
            
        for (Schema.PicklistEntry value : values) {
            for(String picklistVal : validPicklistVals.split(';')){
                if(value.getValue() == picklistVal){
                    Application_Assets_and_Liabilities__c appAssetLiability = new Application_Assets_and_Liabilities__c();
                    appAssetLiability.RecordTypeId = getRecordTypeId(picklistVal,'Application_Assets_and_Liabilities__c');
                    appAssetLiability.Name = picklistVal;
                    appAssetLiability.Type__c = picklistVal;
                    appAssetLiability.Application__c = application.Id;
                    appAssetLiability.Primary_Owner__c = account.Id;
                    appAssetLiabilities.add(appAssetLiability);
                }
            }
        }
        
        if(appAssetLiabilities != null && appAssetLiabilities.size() > 0){
            insert appAssetLiabilities;
        }
        
        Financial_Information__c finInfo = new Financial_Information__c();
        finInfo.Application__c = application.Id;
        finInfo.Client_Name__c = 'Test User';
        finInfo.Auditor_s_Certificate_Date__c = System.today();
        finInfo.Date_Financials_Signed_Client__c = System.today();
        finInfo.Financial_Statement_Qualified_Issue__c = 'YES';
        finInfo.Financial_Statement_Type__c = 'Audited - Qualified';
        finInfo.Statement_Date_Year_end__c = System.today();
        finInfo.Year_Selection__c = 'Year1';
        finInfo.Account__c = account.Id;
        insert finInfo;
        
        Application_Scoring__c appScoring = new Application_Scoring__c();
        appScoring.Application_Number__c = application.Id;
        insert appScoring;
        
        Application_Scoring_Entity__c appScoreEntity = new Application_Scoring_Entity__c();
        appScoreEntity.Application_Scoring__c = appScoring.Id;
        appScoreEntity.Entity_Name__c = 'PKBK 122';
        appScoreEntity.INTENTCLIENTCODE1__c = 'SNIFFEL001';
        appScoreEntity.Entity_Number__c = '2';
        insert appScoreEntity;
    }
    
    /**
    * @description : Method to test GetApplicationScoringEntities method
    * @author Ephetehe Mokgopanyane | 2021-07-19 
    **/
    @isTest
    public static void testGetApplicationScoringEntities(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        List<Map<String,String>> appScoreEntity = PowerCurveFinancialsResponseCtrl.getApplicationScoringEntities(opp.Id);
        Test.stopTest();
        
        System.assert(appScoreEntity.size() > 0);
    }
    
    
    /**
    * @description : get list of Asset and Liability records
    * @author Ephetehe Mokgopanyane | 2021-07-19 
    * @return String 
    **/
    private static String validAssetLiabTypes(){
        String validPicklistVals = 'Fixed properties and all improvements to properties;Shares in Private Company or Member\'s interest in Close Corporation;';
        validPicklistVals += 'Loan Accounts to Businesses;Local Financial Instruments Listed (shares, unit trusts, etc.);Cash Investments (fixed and notice deposits);';
        validPicklistVals += 'Total Foreign Assets;Net Capital of Business, Trade, Profession or Farming;Equipment, Machinery, Implements;Motor Vehicles, Caravans, Boats;';
        validPicklistVals += 'Debtors;Stock;Livestock - elected values;Cash on Hand, in Bank and Other Similar Institutions;Personal Effects (Jewellery, paintings, furniture, etc.);';
        validPicklistVals += 'Other Assets;Shareholder’s equity (if negative);Total Foreign Liabilities;Mortgage Bonds;';
        validPicklistVals += 'Loan Accounts;Bank Overdraft;Credit Cards;Creditors;Other Liabilities;Fixed Properties Bonded;';
        validPicklistVals += 'Fixed Properties Unbonded;Fixed Properties Informal;Total Bond Registered;Notarial Bond Amount';
        
        return validPicklistVals;
    }
    
    
    /**
    * @description : get record type Id of a picklist value
    * @author Ephetehe Mokgopanyane | 2021-07-19 
    * @param picklistVal 
    * @param objectName 
    * @return Id 
    **/
    private static Id getRecordTypeId(String picklistVal, String objectName){
        String assetPicklistVals = 'Fixed properties and all improvements to properties;Shares in Private Company or Member\'s interest in Close Corporation;Loan Accounts to Businesses;';
        assetPicklistVals += 'Local Financial Instruments Listed (shares, unit trusts, etc.);Cash Investments (fixed and notice deposits);';
        assetPicklistVals += 'Total Foreign Assets;Net Capital of Business, Trade, Profession or Farming;Equipment, Machinery, Implements;Motor Vehicles, Caravans, Boats;';
        assetPicklistVals += 'Debtors;Stock;Livestock - elected values;Cash on Hand, in Bank and Other Similar Institutions;Personal Effects (Jewellery, paintings, furniture, etc.);Other Assets';
        String liabilityPicklistVals = 'Shareholder’s equity (if negative);Total Foreign Liabilities;Mortgage Bonds;Loan Accounts;Bank Overdraft;Credit Cards;Creditors;Other Liabilities';
        String fixedPropPicklistVals = 'Fixed Properties Bonded;Fixed Properties Unbonded;Fixed Properties Informal;Total Bond Registered;Notarial Bond Amount';
        
        for(String assetPicklistVal : assetPicklistVals.split(';')){
            if(picklistVal == assetPicklistVal){
                return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('NonfinancialAsset').getRecordTypeId();
            }
        }
        
        for(String liabilityPicklistVal : liabilityPicklistVals.split(';')){
            if(picklistVal == liabilityPicklistVal){
                return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('Liability').getRecordTypeId();
            }
        }
        
        for(String fixedPropPicklistVal : fixedPropPicklistVals.split(';')){
            if(picklistVal == fixedPropPicklistVal){
                return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('Fixed_Property_Bond').getRecordTypeId();
            }
        }
        
        return null;
    }
}