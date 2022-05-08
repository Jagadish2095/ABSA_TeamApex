/**  * Test class for FinServAssetsAndLiabilitiesSelector
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date December 2020
 *
 **/
@IsTest
public class FinServAssetsAndLiabilitiesSelectorTest {
	@testSetup
    public static void dataCreation() {
        User user = [SELECT Name, Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetLicenseAssign WHERE PermissionSetLicense.MasterLabel = 'Financial Services Cloud Standard') AND IsActive=true and Profile.Name = 'Standard User (Business Banker)' LIMIT 1];
        Account account = new Account();
        account.Name = 'Test Account';
        account.CIF__c = 'SNIFFEL001';
        account.Sic='35790';
        account.AccountNumber='0';
        account.Registration_Number__c = '1990/011515/23';
        account.Client_Type__c = 'Individual';
        insert account;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opp Onboarding 1';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'New';
        opportunity.AccountId=account.Id;
        insert opportunity;
        
        System.runAs(user) {
            List<FinServ__AssetsAndLiabilities__c> accAssetsLiabilities = new List<FinServ__AssetsAndLiabilities__c>();
            Schema.sObjectType objType = FinServ__AssetsAndLiabilities__c.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            list <Schema.PicklistEntry> values = fieldMap.get('FinServ__AssetsAndLiabilitiesType__c').getDescribe().getPickListValues();
            String validPicklistVals = validAssetLiabTypes();
            
            for (Schema.PicklistEntry value : values) {
                for(String picklistVal : validPicklistVals.split(';')){
                    if(value.getValue() == picklistVal){
                        FinServ__AssetsAndLiabilities__c accAssetsLiability = new FinServ__AssetsAndLiabilities__c();
                        accAssetsLiability.Name = picklistVal;
                        accAssetsLiability.FinServ__AssetsAndLiabilitiesType__c = picklistVal;
                        accAssetsLiability.FinServ__Amount__c = 0.00;
                        accAssetsLiability.Amount_Owners_Valuation__c = 0.00;
                        accAssetsLiability.FinServ__PrimaryOwner__c = account.Id;
                        accAssetsLiability.RecordTypeId = getRecordTypeId(picklistVal,'FinServ__AssetsAndLiabilities__c');
                        accAssetsLiabilities.add(accAssetsLiability);
                    }
                }
            }
            
            if(accAssetsLiabilities != null && accAssetsLiabilities.size() > 0){
                insert accAssetsLiabilities;
            }
        }
    }
    
    @IsTest
    static void shouldSelectById(){
        Account account = [SELECT Id FROM Account LIMIT 1];
        List<FinServ__AssetsAndLiabilities__c> accAssetsLiablities = new FinServAssetsAndLiabilitiesSelector().selectAssetsAndLiabilitiesByAccountId(new Set<Id>{account.Id});
        Id accAssetsLiablitiesId = accAssetsLiablities[0].Id;
        
        Test.startTest();
        accAssetsLiablities = new FinServAssetsAndLiabilitiesSelector().selectById(new Set<Id>{accAssetsLiablitiesId});
        Test.stopTest();
        
        System.assertNotEquals(null, accAssetsLiablities);
        System.assertNotEquals(0, accAssetsLiablities.size());
        System.assertEquals(1, accAssetsLiablities.size());
    }
    
    @IsTest
    static void shouldSelectAssetsAndLiabilitiesByAccountId(){
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        List<FinServ__AssetsAndLiabilities__c> accAssetsLiablities = new FinServAssetsAndLiabilitiesSelector().selectAssetsAndLiabilitiesByAccountId(new Set<Id>{account.Id});
        Test.stopTest();
        
        System.assertNotEquals(null, accAssetsLiablities);
        System.assertNotEquals(0, accAssetsLiablities.size());
        System.assertEquals(28, accAssetsLiablities.size());
    }
    
    /** 
	 * get list of Asset and Liability records
     *
     * @return String
    */
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
	 * get record type Id of a picklist value
     *
     * @param picklistVal - picklist value for which to get record id
     * 
     * @return Id - record type Id
    */
    private static Id getRecordTypeId(String picklistVal, String objectName){
        String assetPicklistVals = 'Fixed properties and all improvements to properties;Shares in Private Company or Member\'s interest in Close Corporation;Loan Accounts to Businesses;';
        assetPicklistVals += 'Local Financial Instruments Listed (shares, unit trusts, etc.);Cash Investments (fixed and notice deposits);';
        assetPicklistVals += 'Total Foreign Assets;Net Capital of Business, Trade, Profession or Farming;Equipment, Machinery, Implements;Motor Vehicles, Caravans, Boats;';
        assetPicklistVals += 'Debtors;Stock;Livestock - elected values;Cash on Hand, in Bank and Other Similar Institutions;Personal Effects (Jewellery, paintings, furniture, etc.);Other Assets';
        String liabilityPicklistVals = 'Shareholder’s equity (if negative);Total Foreign Liabilities;Mortgage Bonds;Loan Accounts;Bank Overdraft;Credit Cards;Creditors;Other Liabilities';
        String fixedPropPicklistVals = 'Fixed Properties Bonded;Fixed Properties Unbonded;Fixed Properties Informal;Total Bond Registered;Notarial Bond Amount';
        
        for(String assetPicklistVal : assetPicklistVals.split(';')){
            if(picklistVal == assetPicklistVal){
                return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('NonfinancialAsset').getRecordTypeId();
            }
        }
        
        for(String liabilityPicklistVal : liabilityPicklistVals.split(';')){
            if(picklistVal == liabilityPicklistVal){
                return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('Liability').getRecordTypeId();
            }
        }
        
        for(String fixedPropPicklistVal : fixedPropPicklistVals.split(';')){
            if(picklistVal == fixedPropPicklistVal){
                return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('Fixed_Property_Bond').getRecordTypeId();
            }
        }
        
        return null;
    }
}