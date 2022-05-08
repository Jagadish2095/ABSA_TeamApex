/**
* @description Controller for Onboarding Related Parties lightning component
* @author Vladimir Panajic 
* @created 2020-02-17
*/ 
public class OnboardingRelatedPartiesControler {
    /**
* @description list of related parties for an account
* @param accountId 
* @return List<Map<String, Object>>
*/
    @AuraEnabled
    public static List<Map<String, Object>> getRelatedParties(Id accountId) {
        List<Map<String,Object>> listParties = new List<Map<String,Object>>();
        Account account = new AccountsSelector().selectFinancialStatementRedirectFieldsById(accountId);

        List<AccountContactRelation> accnRelList;
        if(account.Client_Type__c != null && account.Client_Type__c == 'Joint & Several'){
            accnRelList = [SELECT Id, AccountId, ContactId, Account.CIF__c ,Contact.Account.Gender__pc, Contact.FirstName, Contact.LastName, Contact.Title, Contact.ID_Number__c,ubo__c,Roles,Contact.Account.Client_Type__c, Share_Percentage__c,Designation__c,Tax_Number__c,Tax_Residency__c FROM AccountContactRelation WHERE AccountId =: accountId];
        }else{
           accnRelList = new AccountContactRelationSelector().selectRelationByAccountId(accountId);
        }
        //TdB - Query Business Entities for Relationship Section
        List<FinServ__AccountAccountRelation__c> accAccList = new AccountAccountRelationSelector().selectByPrimaryForRelationshipSection(accountId);
        Set<FinServ__AccountAccountRelation__c> deDupeSet = new Set<FinServ__AccountAccountRelation__c>();
        deDupeSet.addAll(accAccList);
        accAccList.clear();
        accAccList.addAll(deDupeSet);
        
        //Newly added By Rajesh to validate Country of Citizenship START
        List<String> personAccIdList = new List<String>();
        for(AccountContactRelation acc : accnRelList){
            personAccIdList.add(acc.ContactId);
        }
        
        Map<String,String> personAccIdVSCountryMap = new Map<String,String>();
        for(Account acc :[Select Id,Country_of_Citizenship__c,PersonContactId From Account Where IsPersonAccount = TRUE AND PersonContactId IN : personAccIdList]){
            personAccIdVSCountryMap.put(acc.PersonContactId,acc.Country_of_Citizenship__c);
            
        }
        //Newly added By Rajesh to validate Country of Citizenship START
        
        for(AccountContactRelation accnRel : accnRelList) {
            Map<String,String> mapObj = new Map<String,String>();   
            mapObj.put('Id', accnRel.Id);
            mapObj.put('Title', accnRel.Contact.Title);
            mapObj.put('FullName', accnRel.Contact.Title + ' ' + accnRel.Contact.FirstName + ' ' + accnRel.Contact.LastName);
            mapObj.put('ClientType', accnRel.Contact.Account.Client_Type__c);
            mapObj.put('FirstName', accnRel.Contact.FirstName);
            mapObj.put('LastName', accnRel.Contact.LastName);
            mapObj.put('IDNumber', accnRel.Contact.ID_Number__c);
            mapObj.put('Gender', accnRel.Contact.Account.Gender__pc);
            mapObj.put('Roles', accnRel.Roles);
            mapObj.put('ubo', accnRel.ubo__c);
            mapObj.put('Designation', accnRel.Designation__c);
            mapObj.put('SharePercentage', string.valueOf(accnRel.Share_Percentage__c));
            mapObj.put('Tax Number', accnRel.Tax_Number__c);
            mapObj.put('Tax Residency', accnRel.Tax_Residency__c);
            mapObj.put('CountryOfCitizenship',personAccIdVSCountryMap.get(accnRel.ContactId));
            mapObj.put('PersonContactId', accnRel.ContactId);
            mapObj.put('ContactAccountId', accnRel.Contact.AccountId);
            mapObj.put('isIndividual','true');
            mapObj.put('jointsCIF',accnRel.Account.CIF__c);
            listParties.add(mapObj);
        }
         //TdB - Add Business Entities to Map
         for(FinServ__AccountAccountRelation__c eachAcc : accAccList) {
            Map<String,String> mapObj = new Map<String,String>();   
            mapObj.put('Id', eachAcc.Id);
            mapObj.put('FullName', eachAcc.FinServ__RelatedAccount__r.Name);
            mapObj.put('ClientType', eachAcc.FinServ__RelatedAccount__r.Client_Type__c);
            mapObj.put('IDNumber', eachAcc.FinServ__RelatedAccount__r.Registration_Number__c);
            mapObj.put('Roles', eachAcc.Roles__c);
            mapObj.put('SharePercentage', string.valueOf(eachAcc.Shareholding_Percentage__c));
            mapObj.put('ContactAccountId', eachAcc.FinServ__RelatedAccount__c);
            mapObj.put('isIndividual','false');
            
            listParties.add(mapObj);            
        }
        return listParties;
    }
    
    /**
* @description validate related parties for an account
* @param accountId
* @return string
*/
    @AuraEnabled
    public static string validateRelatedParties(Id accountId) {
        List<AccountContactRelation> accnList = [SELECT Id, AccountId, ContactId, Roles FROM AccountContactRelation WHERE AccountId =: accountId];
        string errorText = '';
        boolean director = false;
        boolean shareholder = false;
        boolean ceo = false;
        boolean authoritytoact = false;
        for(AccountContactRelation accn : accnList) {
            if(accn.Roles.contains('Director')) {
                director = true;
            }
            if(accn.Roles.contains('Shareholder/Controller')) {
                shareholder = true;
            }
            if(accn.Roles.contains('Managing Director/Chief Executive Officer')) {
                ceo = true;     
            }
            if(accn.Roles.contains('Individual with Authority to Act')) {
                authoritytoact = true;
            }
        }
        
        if(!director) {
            errorText = errorText + 'At least one related party with the Director role is required.\n';
        }
        if(!shareholder) {
            errorText = errorText + 'At least one related party with the Shareholder/Controller role is required.\n';
        }
        if(!ceo) {
            errorText = errorText + 'At least one related party with the Managing Director/Chief Executive Officer role is required.\n';
        }
        if(!authoritytoact) {
            errorText = errorText + 'At least one related party with the Individual with Authority to Act role is required.';
        }
        return errorText;
    }
    
    /** @description remove a related party for an account
* @param accnConRelId
*/
@AuraEnabled
public static void removeRelatedParty(Id accnConRelId) {
    string message;
    try {
        //Get object Name to determin which type of relationship
        String objectNameVal = accnConRelId.getSObjectType().getDescribe().getName();
        
        if(objectNameVal == 'FinServ__AccountAccountRelation__c') {
            FinServ__AccountAccountRelation__c accnAccRel = new AccountAccountRelationSelector().selectbyAccAccRelId(accnConRelId);
            delete accnAccRel;
        } else if (objectNameVal == 'AccountContactRelation') {
            AccountContactRelation accnConRel = new AccountContactRelationSelector().selectbyAccountContactRelationId(accnConRelId);
            delete accnConRel;
        }
        
    } catch (DmlException e) {
        message = 'An unexpected error has occurred: ' + e.getMessage();
    } 
}
    /**
* @description delete related parties for an account
* @param accnConRelId
* @return mesage
*/
@AuraEnabled
public static String deleteRelatedParty(Id accnConRelId) {
    
    //Get object Name to determin which type of relationship
    String objectNameVal = accnConRelId.getSObjectType().getDescribe().getName();
    FinServ__AccountAccountRelation__c accnAccRel;
    AccountContactRelation accnConRel;
    String accIdToDelete;   
    
    String strToreturn = '';
    
    if(objectNameVal == 'FinServ__AccountAccountRelation__c') {
        accnAccRel = new AccountAccountRelationSelector().selectbyAccAccRelId(accnConRelId);
        accIdToDelete = accnAccRel.FinServ__RelatedAccount__c;
    } else if (objectNameVal == 'AccountContactRelation') {
        accnConRel = new AccountContactRelationSelector().selectbyAccountContactRelationId(accnConRelId);
        Contact con = [Select Id,AccountId From Contact Where Id=:accnConRel.ContactId LIMIT 1];
        accIdToDelete = con.AccountId;
    }
    
    List<Address__c> addList = [Select Id,Account__c From Address__c Where Account__c =: accIdToDelete];
    
    Account acc = [Select Id From Account Where Id=: accIdToDelete LIMIT 1];
    try {
        if(accnConRel != null ) {
           delete accnConRel; 
        }
        
        if(accnAccRel != null) {
           delete accnAccRel; 
        }
        
        if(addList != null){
            delete addList;
        }
        delete acc;
    } catch (DmlException e) {            
        strToreturn = e.getMessage();
    } 
    return strToreturn;
}
    /**
* @description delete related parties for an account
* @param personAccId
* @return Account
*/
    @AuraEnabled
    public static Account fetchPersonAccDetails(String personAccId) {
        Account acc = new AccountsSelector().selectPersonAccountById(personAccId);
        return acc;
    }
    /**
* @description delete related parties for an account
* @param personAcc

*/
    @AuraEnabled
    public static void updatePersonAccDetails(Account personAcc) {
        //try {
        update personAcc;
        /*} catch(DmlException e) {
System.debug('The following exception has occurred: ' + e.getMessage());
}*/
    }
    /**
* @description fetch related parties for an account
* @param accnConRelId
* @return Address__c

*/
    @AuraEnabled
    public static List<Address__c> fetchAddressList(Id accnConRelId) {
        
        /*AccountContactRelation accnConRel = [SELECT Id,AccountId,ContactId FROM AccountContactRelation WHERE Id =: accnConRelId];
System.debug('accnConRel.AccountId '+accnConRel.AccountId);

List<Address__c> addList = [Select Id,Address1__c,Account__c,Address_Type__c,Billing_Suburb__c,Shipping_Street__c,Shipping_Suburb__c From Address__c Where Account__c =: accnConRel.AccountId];
System.debug('addList '+addList);
return addList;*/
        AccountContactRelation accnConRel = [SELECT Id,AccountId,ContactId FROM AccountContactRelation WHERE Id =: accnConRelId];
        
        Account acc = [Select Id,FirstName,(Select Id,Address1__c,Account__c,Address_Type__c,Address3__c,Address5__c,Address2__c From Addresses__r) From Account Where IsPersonAccount = TRUE AND PersonContactId =:accnConRel.ContactId LIMIT 1];
        List<Address__c> addList = new List<Address__c>(); //[Select Id,Address1__c,Account__c,Address_Type__c,Address3__c,Address5__c,Address2__c From Address__c Where Account__c =: accnConRel.ContactId];
        addList.addAll(acc.Addresses__r);
        return addList;
    }
    /**
* @description getselectOptions related parties for an account
* @param objObject
* @param fld
* @return Address__c

*/
    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String>();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        //allOpts.sort();
        return allOpts;
    }
    /**
* @description SelectOptionCls related parties for an account
* @return Address__c

*/
    @AuraEnabled
    public static List<SelectOptionCls> getPickListValues(){
        
        List<SelectOptionCls> options = new List<SelectOptionCls>();
        
        Schema.DescribeFieldResult fieldResult = Contact.Country_of_Birth__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            SelectOptionCls opt = new SelectOptionCls();
            opt.label = f.getLabel();
            opt.value = f.getValue();
            options.add(opt);
        }       
        return options;
    }
    /**
* @description SelectOptionCls related parties for an account
*/
    public class SelectOptionCls{
        /**
* @description SelectOptionCls related parties for an account
*/
        @AuraEnabled 
        public String label{get;set;}
        /**
* @description SelectOptionCls related parties for an account
*/
        @AuraEnabled
        public String value{get;set;}
        
    }
    
    /**
* @description SelectOptionCls related parties for an account
* @param accConRelId
* @param sharePercentage
* @param roles
* @param primaryEntityId
*/
    @AuraEnabled
    public static void calculateControllingPercentage(Id accConRelId, Decimal sharePercentage, String roles, String primaryEntityId){
        AccountContactRelation accContactRelObj = new AccountContactRelationSelector().selectbyaccConRelId(accConRelId);
        accContactRelObj.Share_Percentage__c=sharePercentage;
        accContactRelObj.Roles=roles;
        try {
            // AccountContactRelationController.calculateControllingPercentageValOnUpdate(accContactRelObj);
            AccountContactRelationController.calculateControllingPercentageVal2(accContactRelObj, primaryEntityId);
        } catch (DmlException e) {            
            throw new AuraHandledException('An unexpected error has occurred: '+ e.getMessage());            
        }   
    }
    
    /**
* @description getClientRecordTypeByName related parties for an account
* @param recordTypeName
* @return

*/
    @AuraEnabled
    public static String getClientRecordTypeByName(String recordTypeName){
        
        String accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        return accountRecordTypeId;
    } 
    
    /**
* @description getselectectedRoleVal related parties for an account
* @param accConId
* @return AccountContactRelation

*/
    @AuraEnabled
    public static AccountContactRelation getselectectedRoleVal(Id accConId){
        return [SELECT Id, Roles ,Tax_Number__c,Tax_Residency__c,UBO__c FROM AccountContactRelation WHERE Id =: accConId];
    }
    
    /**
* @description getselectectedRoleVal related parties for an account
* @param accConRelId
* @param sharePercentage
* @param roles
* @param taxNumber
* @param taxResidency

*/
    @AuraEnabled
    public static void updateAccConRelationship(Id accConRelId, Decimal sharePercentage, String roles,string taxNumber , string taxResidency){
        AccountContactRelation accContactRelObj = new AccountContactRelationSelector().selectbyaccConRelId(accConRelId);
        accContactRelObj.Share_Percentage__c=sharePercentage;
        accContactRelObj.Roles=roles;
        accContactRelObj.Tax_Number__c=taxNumber;
        accContactRelObj.Tax_Residency__c=taxResidency;
        try {
            
            AccountContactRelationController.calculateControllingPercentageVal2(accContactRelObj,accContactRelObj.Primary_Entity_Id__c);
            // update accContactRelObj;
        } catch (DmlException e) {            
            throw new AuraHandledException('An unexpected error has occurred: '+ e.getMessage());            
        }   
    }
    
    /**
* @description Makes the callout to CPB service (W-007849)
* @param idNumber
* @return String

* */
    @AuraEnabled
    public static String callHanisServiceForRelatedParties(String idNumber){
        Map<HanisValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = HanisValidate_IH_v1.HanisValidate(idNumber);
        HanisValidate_Resp_IB_v1 responseBean = (new List<HanisValidate_Resp_IB_v1>(responseMap.keySet()))[0];
        List<Sys_Log_Integration__c> hanisLogs = responseMap.values()[0];
        if (hanisLogs != null && !hanisLogs.isEmpty()){
            Insert hanisLogs;
        }
        return responseBean.serialize(responseBean);
    }
    
    /**
* @description Makes the callout to CPB service (W-007849)
* @param idNumber
* @param lastName
* @return String
* */
    @AuraEnabled
    public static String callCPBServiceForRelatedParties(String idNumber, String lastName){
        Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate(idNumber, lastName);
        CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
        List<Sys_Log_Integration__c> cpbLogs = responseMap.values()[0];
        if (cpbLogs != null && !cpbLogs.isEmpty()){
            Insert cpbLogs;
        }
        return responseBean.serialize(responseBean);
    }
    
    /**
* @description Makes the callout to CPB service (W-007849)
* @param hanisData
* @param accRecordId
* @param name
*
*/
    @AuraEnabled
    public static void GenerateHanisCertificate(String hanisData, Id accRecordId, String name){
        
        HanisValidate_Resp_IB_v1 hanisDataClass = (HanisValidate_Resp_IB_v1)JSON.deserialize(hanisData, HanisValidate_Resp_IB_v1.class);
        if (accRecordId != null && hanisDataClass != null && hanisDataClass.Cert != null){
            String jsonStr = hanisDataClass.Cert;
            String fileName = name+' Hanis Certificate';
            OnboardingIndividualDetailsController.saveCertificateAsAttachment(accRecordId, jsonStr,'HANIS Certificate',fileName);
        }
    }
    
    /**
* @description Makes the callout to CPB service (W-007849)
* @param cpbData
* @param accRecordId
* @param name
* */
    @AuraEnabled
    public static void GenerateCPBCertificate(String cpbData, Id accRecordId, String name){
        
        CPBValidate_Resp_IB_v1 cpbDataClass = (CPBValidate_Resp_IB_v1)JSON.deserialize(cpbData, CPBValidate_Resp_IB_v1.class);
        if (accRecordId != null && cpbDataClass != null && cpbDataClass.Person.AddressInformation.ResidentialAddress.AddCert != null){
            String jsonStr = cpbDataClass.Person.AddressInformation.ResidentialAddress.AddCert;
            String fileName = name+' CPB Certificate';
            OnboardingIndividualDetailsController.saveCertificateAsAttachment(accRecordId, jsonStr,'CPB Certificate',fileName);
        }
    }
    
    /**
* @description Anka - Get Client type by AccountContactRelation
* @param  accContRelId
* @return String 
*/
    @AuraEnabled
    public static String getClientTypeByaccContRelId(String accContRelId){
        String PrimaryAccClientType; 
        Set<Id> acrIds = new Set<Id>();
        acrIds.add(accContRelId);
        AccountContactRelationSelector acrselector = new AccountContactRelationSelector();
        List<AccountContactRelation> acr = acrselector.selectById(acrIds);
        PrimaryAccClientType = acr[0].Account.Client_Type__c;
        
        return PrimaryAccClientType;
    } 
    
    /**
    * @description Anka - Get Stage Name 8562
    * @param  accountId
    * @return String Client Type
    */
    @AuraEnabled
    public static String OpportunityStage(String accountId){
         Id accId = accountId;
        Set<Id> accIds = new Set<Id>();
        accIds.add(accId);
        OpportunitiesSelector oppSelector = new OpportunitiesSelector();
        List<Opportunity> opportunity = oppSelector.selectBySetAccountIds(accIds);
        return opportunity.get(0).StageName;
    } 

    /**
    * @description Update Account Account Relationship
    * @param  accAccRelId
    * @param  sharePercentage
    * @param  roles
    */
    @AuraEnabled
    public static void updateAccountAccountRelationship(Id accAccRelId, Decimal sharePercentage, String roles){
        FinServ__AccountAccountRelation__c accAccRelObj = new AccountAccountRelationSelector().selectbyAccAccRelId(accAccRelId);
        accAccRelObj.Shareholding_Percentage__c=sharePercentage;
        accAccRelObj.Roles__c=roles;
        
        try {
            update accAccRelObj;
        } catch (Exception e) {            
            throw new AuraHandledException('An unexpected error has occurred: '+ e.getMessage());            
        } 
        
    }

       
    /** @description Makes the callout to Experian service
    * @param registrationNumber
    * @return String 
    */
    @AuraEnabled
    public static String callExperianHandler(String registrationNumber){
        try{
            registrationNumber = registrationNumber.replace('/', '');
            ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = ExperianBusinessDetailsGet_IH_v1.ExperianBusinessDetailsGet(registrationNumber);
           	
            return responseBean.serialize(responseBean);
        } catch (Exception exc){
            
            throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
        }
    }
    
     
    /**
	 * W-004836
	 * @description accId Account Id
	 * @param accId
	 * @param link
	 * */
    @SuppressWarnings('PMD.ApexOpenRedirect')
	@future(callout = true)
    public static void saveFile(String accId, String link){
        Blob body = !test.isRunningTest() ? new PageReference(link).getContentAsPDF() : Blob.valueOf('test');
        DocumentController.sendToECM(accId, 'Experian Certificate', 'Experian Certificate', EncodingUtil.base64Encode(body));
    }
    
    	/**
	 * @description generate experian and save to ecm
	 * @param experianData2
	 * @param accRecordId
	 */
    @AuraEnabled
    public static void generateExperianCertificate(String experianData2, Id accRecordId){        
        ExperianBusinessDetailsGet_Resp_IB_v1 experianData = (ExperianBusinessDetailsGet_Resp_IB_v1)JSON.deserialize(experianData2, ExperianBusinessDetailsGet_Resp_IB_v1.class);
        if (!String.isBlank(experianData.pdf)){ 
            saveFile(accRecordId, experianData.pdf);
        }
  
	}
   
}