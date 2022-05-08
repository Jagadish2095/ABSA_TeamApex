/**
* Controller for Material Disclosures Lightning component
* @author  Kyle Alexander
* @created 2018-09-26
*/
public class MaterialDisclosuresController {

    public class MaterialDisclosuresException extends Exception {}

    /**
     * Method that gets a list of all marerial disclosures 
     *
     * @param oppId - opportunity Id
     */
	@AuraEnabled
    public static List<Clause__c> getMaterialDisclosureData(Id oppId) {
        System.debug('OppId>>>> ' + oppId);
        List<Opportunity> opportunities = [SELECT Product__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
        List<Quote> quotes = [SELECT Commission_1st_Year__c, Commission_2nd_Year__c FROM Quote WHERE OpportunityId = :opportunities.get(0).Id AND IsSyncing = true];
        List<QuoteLineItem> quoteLineItems = [SELECT Id, PricebookEntry.Name FROM QuoteLineItem WHERE QuoteId = :quotes.get(0).Id];
        Account mainMember = new AccountsSelector().selectByOpportunityId(oppId);               
        List<Clause__c> clausesToShow = new List<Clause__c>();
        Boolean isSpouseAdded = false;
        double spouseAge;
        double mainAge = mainMember.Age__pc;
        Boolean spouse65 = false;
        Boolean main65 = false;
        String mainMemberDisclosure = '';
        String spouseMemberDisclosure = '';
        if(mainAge >= 65.00){
            main65 = true;
        } else {
            main65 = false;
        }
        for(QuoteLineItem qli : quoteLineItems){
            if(qli.PricebookEntry.Name.contains('Spouse')){
                isSpouseAdded = true;
                List<Opportunity_Party__c> oppPartyList =  New OpportunityPartiesSelector().selectByOpportunityId(oppId);
                for(Opportunity_Party__c member:oppPartyList)
                {
                    if(member.Relationship__c=='Spouse'){
                        spouseAge = member.Age__c;
                        if(spouseAge >= 65.00){
                            spouse65 = true;
                        } else {
                            spouse65 = false;
                        }
                    }
                }
            }
        }

        List<Financial_Product__c> financialProducts = [SELECT Id, Name FROM Financial_Product__c WHERE Name = :opportunities.get(0).Product__c];
        if(!financialProducts.isEmpty() && financialProducts.size() <= 1){
            System.debug('financialProducts >>>' + financialProducts );

            List<Clause__c> materialDisclosures = [SELECT Id, Name, Text_Content__c FROM Clause__c WHERE Financial_Product__c = :financialProducts.get(0).id AND Clause_Type__c = 'Material Disclosure' ORDER BY Order__c ASC];
            System.debug('materialDisclosures >>>' + materialDisclosures );

            List<Clause__c> recordsToRemove = new List<Clause__c>();			
            if(!materialDisclosures.isEmpty()){
                for(Clause__c materialDisclosureCheck : materialDisclosures){
                    if(materialDisclosureCheck.Name =='EPP Material Disclosure: Clause 6 - >= 65'){
                        if(main65 && !spouse65){
                            mainMemberDisclosure = 'Main member('+mainAge+') age is 65 or Older : '+materialDisclosureCheck.Text_Content__c;
                        }
                        if(spouse65 && !main65 && isSpouseAdded){
                            spouseMemberDisclosure = 'Spouse('+spouseAge+') age is 65 or Older : '+materialDisclosureCheck.Text_Content__c;
                        }
                        if (spouse65 && main65 && isSpouseAdded)
                        {
                            mainMemberDisclosure = 'Main member('+mainAge+') and spouse('+spouseAge+') age is 65 or Older : '+materialDisclosureCheck.Text_Content__c;
                        }
                        recordsToRemove.add(materialDisclosureCheck);
                    }                    
                    if(materialDisclosureCheck.Name =='EPP Material Disclosure: Clause 6 - <= 64'){
                        if(!main65 && spouse65){
                            mainMemberDisclosure = 'Main member('+mainAge+') age is 64 or younger : '+materialDisclosureCheck.Text_Content__c;
                        }
                        if(!main65 && !spouse65 && !isSpouseAdded){
                            mainMemberDisclosure = 'Main member('+mainAge+') age is 64 or younger : '+materialDisclosureCheck.Text_Content__c;
                        }
                        if(!spouse65 && main65 && isSpouseAdded){
                            spouseMemberDisclosure = 'Spouse('+spouseAge+') age is 64 or younger : '+materialDisclosureCheck.Text_Content__c;
                        }
                        if (!spouse65 && !main65 && isSpouseAdded)
                        {
                            mainMemberDisclosure = 'Main member('+mainAge+') and spouse('+spouseAge+') age is 64 or younger : '+materialDisclosureCheck.Text_Content__c;
                        }
                        recordsToRemove.add(materialDisclosureCheck);
                    }
                }
                for(Clause__c record: recordsToRemove){
                    materialDisclosures.remove(materialDisclosures.indexOf(record));
                }                
                for(Clause__c materialDisclosure : materialDisclosures){
                    if(materialDisclosure.Text_Content__c.contains('{!clause.First Year Commission}')){
                        if(quotes.get(0).Commission_1st_Year__c != null){
                            materialDisclosure.Text_Content__c = materialDisclosure.Text_Content__c.replace('{!clause.First Year Commission}', String.valueOf(quotes.get(0).Commission_1st_Year__c.setScale(2)));
                        }
                        else{
                            materialDisclosure.Text_Content__c = materialDisclosure.Text_Content__c.replace('{!clause.First Year Commission}', 'N/A');
                        }
                    }
                    if(materialDisclosure.Text_Content__c.contains('{!clause.Second Year Commission}')){
                        if(quotes.get(0).Commission_2nd_Year__c != null){
                            materialDisclosure.Text_Content__c = materialDisclosure.Text_Content__c.replace('{!clause.Second Year Commission}', String.valueOf(quotes.get(0).Commission_2nd_Year__c.setScale(2)));
                        }
                        else{
                            materialDisclosure.Text_Content__c = materialDisclosure.Text_Content__c.replace('{!clause.Second Year Commission}', 'N/A');
                        }                    
                    }
                    if(materialDisclosure.Text_Content__c.contains('{!clause.IsJointLife}')){
                        if(isSpouseAdded){
                            materialDisclosure.Text_Content__c = materialDisclosure.Text_Content__c.replace('{!clause.IsJointLife}', '');
                        }
                        else{
                            continue;
                            materialDisclosure.Text_Content__c = 'N/A';
                        }                    
                    }
                    if(materialDisclosure.Name=='EPP Material Disclosure: Clause 6')
                    {                        
                        if(spouseMemberDisclosure != '') {
                            materialDisclosure.Text_Content__c = mainMemberDisclosure+' ; '+spouseMemberDisclosure;
                        }
                        else{
                            materialDisclosure.Text_Content__c = mainMemberDisclosure;
                        }
                    }                    
                    clausesToShow.add(materialDisclosure);
                }
                return clausesToShow;
            }
        }        
        return null;
    }
    
    /**
     * Method that gets checks what material disciloures were selected
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static List<Id> checkSelected(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		String clauseJson = opportunities.get(0).Material_Disclosures__c;
		List<Id> clauseIds = (List<Id>)JSON.deserialize(clauseJson, List<Id>.class);
	 	System.debug(clauseIds);
        List<Clause__c> clauses = [Select Id From Clause__c WHERE Id IN :clauseIds];
        System.debug(clauses);
        return clauseIds;
    }
    
    /**
     * Method that checks if material disclosures were already done on load
     *
     * @param oppId - opportunity Id
     */
    @AuraEnabled
    public static String checkInitValidity(Id oppId) {
        Id directDeliveryOppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Opportunity').getRecordTypeId();
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);


        return opportunities.get(0).Material_Disclosure_Status__c;
    }

    /**
     * @param oppId opportunity Id or lead Id
     * @param productName product name from financial products
     *
     * @return list of clauses
     */
    @AuraEnabled
    public static List<Clause__c> getDirectDeliveryMaterialDisclosureData(Id oppId, String productName) {


        List<Clause__c> clausesToShow = new List<Clause__c>();
        Id directDeliveryOppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Opportunity').getRecordTypeId();
        Id STIOppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('DD_STI_Opportunity').getRecordTypeId();
        Id directDeliveryLeadRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Lead').getRecordTypeId();
        //Added By Divya
        Id AIPLeadRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('AIP_Lead').getRecordTypeId();
       // Id ahpOppRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('DD_AHP_Opportunity').getRecordTypeId();
        if (String.valueOf(oppId).startsWith('006')) {
            List<Opportunity> opportunities = [SELECT Product__c, RecordTypeId, Product_Interest__c FROM Opportunity WHERE Id = :oppId LIMIT 1];
            if ((opportunities[0].RecordTypeId == directDeliveryOppRecTypeId || opportunities[0].RecordTypeId == STIOppRecTypeId) && opportunities[0].Product_Interest__c != null) {
                clausesToShow = [
                        SELECT Id, Name, Text_Content__c
                        FROM Clause__c
                        WHERE Financial_Product__r.Product__c = :productName
                        AND Clause_Type__c = 'Material Disclosure'
                        ORDER BY Order__c ASC
                ];
            } // Date : 2021-06-14 added below code for AHP material Disclosures by Pravin W.
          /*  else if(opportunities[0].RecordTypeId == ahpOppRecTypeId ){
                 clausesToShow = [
                        SELECT Id, Name, Text_Content__c
                        FROM Clause__c
                        WHERE Financial_Product__r.Product__c = :productName
                        ORDER BY Order__c ASC
                ];
                
            }  commented for AIP Deployment */
        } else
                if(String.valueOf(oppId).startsWith('00Q'))
                {
                    Lead leadRecord = [SELECT Id, RecordTypeId, Financial_Product__c FROM Lead WHERE Id =:oppId];
                    if ( (leadRecord.RecordTypeId == directDeliveryLeadRecTypeId || leadRecord.RecordTypeId == AIPLeadRecTypeId)&&  leadRecord.Financial_Product__c != null) {
                        clausesToShow = [
                                SELECT Id, Name, Text_Content__c
                                FROM Clause__c
                                WHERE Financial_Product__r.Product__c = :productName
                                AND Clause_Type__c = 'Material Disclosure'// AND Section__c = :section
                                ORDER BY Order__c ASC
                        ];
                    }
                }
        if (!clausesToShow.isEmpty()) {
            return clausesToShow;
        } else {
            return null;
        }
    }

    /**
     * @param oppId opportunity Id or lead Id
     * @param productName product name from products
     *
     * @return
     */
    @AuraEnabled
    public static String checkInitValidityOnQuote(Id oppId, String productName) {
        List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,productName);

        if (String.valueOf(oppId).startsWith('006')) {
        return quotes.get(0).Material_Disclosure_Status__c;
        } else
                if(String.valueOf(oppId).startsWith('00Q'))
                {
                    Lead leadRecord = [SELECT Id, Material_Disclosure_Status__c FROM Lead WHERE Id =:oppId];
                    return leadRecord.Material_Disclosure_Status__c;
                } else {
                    return null;
                }
    }

    /**
     * Method that checks whether material disclosures are valid and saves them
     *
     * @param oppId opportunity Id or lead Id
     * @param clauses - list of all clauses added
     * @param productName product name from products
     */
    @AuraEnabled
    public static void saveDirectDeliveryMaterialDisclosureData(Id oppId, List<Clause__c> clauses,  String productName) {

        List<Id> clauseIds = new List<Id>();
		system.debug('Save quote method called '+oppId+'  for  '+productName+'  '+clauses);
        if (String.valueOf(oppId).startsWith('006')) {
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);

            //For Law 4u and Road cover, check if Casa and risk rating has been completed, if not throw an error
            if(productName == 'Law 4 u' || productName == 'Road Cover' || productName == 'Ultimate Protector'){
                if(String.isBlank(opportunities[0].Account.CASA_Reference_Number__pc) && String.isBlank(opportunities[0].Account.CASA_Screening_Status__pc) && opportunities[0].Risk_Rating__c != 'New') {
                    throw new MaterialDisclosuresException('Please complete CASA Screening and Risk Rating.');
                }
            }

            for (Clause__c clause : clauses) {
                clauseIds.add(clause.Id);
            }

            List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,productName);
            if(quotes.isEmpty()){
                throw new MaterialDisclosuresException('A quote for this product was not generated. Please go back and complete the quote.');
            }
			system.debug('quotes '+quotes);
            try {
                List<Flexi_Funeral_Relationship_Code__mdt> ddSettings = [
                        SELECT Id, Email_Template__c, Product__c, Quick_Text_Name__c
                        FROM Flexi_Funeral_Relationship_Code__mdt
                        where Product__c = :quotes[0].Description
                ];
                quotes[0].Material_Disclosure_Status__c = 'Valid';

                if (!ddSettings.isEmpty()) {
                    if(quotes[0].Email_and_SMS_sent__c == false){
                        if(String.isNotBlank(ddSettings[0].Quick_Text_Name__c)){
                            if(!Test.isRunningTest()){
                            dispatchSMS(opportunities.get(0).Account.PersonContactId,oppId,'','',ddSettings[0].Quick_Text_Name__c, StringConstants.DD_ITOUCH_SMS_INTEGRATION_SERVICE, true);
                            }
                        }
                        if(String.isNotBlank(ddSettings[0].Email_Template__c)){
                            emailMessage(opportunities.get(0),null,ddSettings[0].Email_Template__c);
                        }
                        quotes[0].Email_and_SMS_sent__c = true;
                    }
                }
                update quotes;
                opportunities.get(0).Material_Disclosures__c = JSON.serialize(clauseIds);
                update opportunities;

            } catch (Exception ex) {
                AuditTrailLog.logException(ex, 'New', 'Error', 'MaterialDisclosuresController', 'saveDirectDeliveryMaterialDisclosureData',
                        'Trying to Update records and send emails and sms for Opp');
            }

        } else
                if(String.valueOf(oppId).startsWith('00Q')){
                    Lead leadRecord = [SELECT Id, Email, Material_Disclosures__c,Material_Disclosure_Status__c,Email_and_SMS_sent__c  FROM Lead WHERE Id =:oppId];
                    for (Clause__c clause : clauses) {
                        clauseIds.add(clause.Id);
                    }
                    leadRecord.Material_Disclosure_Status__c = 'Valid';
                    leadRecord.Material_Disclosures__c = JSON.serialize(clauseIds);
                    try {
                        if( productName != 'AIP' ){
                            if(leadRecord.Email_and_SMS_sent__c == false){
                                if(!Test.isRunningTest()) {
                                    dispatchSMS(leadRecord.Id, null, '', '', 'Flexi Funeral', StringConstants.DD_ITOUCH_SMS_INTEGRATION_SERVICE, true);
                                }
                                emailMessage(null,leadRecord,'Flexi_Funeral');
                                leadRecord.Email_and_SMS_sent__c = true;
                            }
                        }
                        update leadRecord;
                    } catch (Exception ex){
                        AuditTrailLog.logException(ex, 'New', 'Error', 'MaterialDisclosuresController', 'saveDirectDeliveryMaterialDisclosureData',
                                'Trying to Update records and send emails and sms for Lead');
                    }

        }
    }
    
    /**
     * Method that checks whether material disclosures are valid and saves them
     *
     * @param oppId - opportunity Id
     * @param oppId - list of all clauses added
     */
    @AuraEnabled
    public static void saveMaterialDisclosureData(Id oppId, List<Clause__c> clauses) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Financial_Product__c> financialProducts = [SELECT Id, Name FROM Financial_Product__c WHERE Name = :opportunities.get(0).Product__c];
            
        List<Clause__c> materialDisclosures = [SELECT Id, Name FROM Clause__c WHERE Financial_Product__c = :financialProducts.get(0).id AND Clause_Type__c = 'Material Disclosure' ORDER BY Order__c ASC];
        
        List<Id> clauseIds = new List<Id>();
        for(Clause__c clause : clauses){
            clauseIds.add(clause.Id);
        }
        
        opportunities.get(0).Material_Disclosures__c = JSON.serialize(clauseIds);
        
        //if(materialDisclosures.size() == clauseIds.size()){
           // opportunities.get(0).Material_Disclosure_Status__c = 'Valid';
        //}
        opportunities.get(0).Material_Disclosure_Status__c = 'Valid';
        update opportunities;
    }

    /**
     * @description Used for Direct Delivery stream, SMS the client once verbal disclosures have been validated
     * @param whoId Lead or contact
     * @param whatId opportunity
     * @param phoneNumberOverride if phone number needs to be overridden
     * @param recipientNameOverride if the name needs to be overridden
     * @param quickTextName name of quick text that needs to be sent out
     * @param integrationService intergration service to be used
     * @param saveAsActivity save as an activity true or false
     */
    @Future(Callout=true)
    private static void dispatchSMS(Id whoId, Id whatId, String phoneNumberOverride, String recipientNameOverride, String quickTextName, String integrationService, boolean saveAsActivity) {
        SMSHandler.sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
    }

    /**
     * @description Used for Direct Delivery stream, Email the client once verbal disclosures have been validated
     * @param opportunityRecord Opportunity Id
     * @param leadRecord the lead record to send email to
     * @param emailTemplateName Email template name to be used
     *
     * @return boolean
     */
    public static Boolean emailMessage(Opportunity opportunityRecord,Lead leadRecord, String emailTemplateName){

        List<String> emailAddresses = new List<String>();
        if(opportunityRecord != null){
            Account person = [SELECT Id,PersonEmail,Alternative_Email__c FROM Account WHERE Id =: opportunityRecord.AccountId];

            System.debug('personEmail ' + person.PersonEmail + ' Alt email' + person.Alternative_Email__c);

            if(String.isNotBlank(person.PersonEmail) ){
                emailAddresses.add(person.PersonEmail);
            }
            if(String.isNotBlank(person.Alternative_Email__c)){
                emailAddresses.add(person.Alternative_Email__c);
            }

        }
        if(leadRecord != null){
            if(String.isNotBlank(leadRecord.Email)){
                emailAddresses.add(leadRecord.Email);
            }
        }

        System.debug('all email addresses ' + emailAddresses);
        if(!emailAddresses.isEmpty())
        {
            EmailTemplate template = [SELECT Id, HtmlValue, Subject FROM EmailTemplate WHERE DeveloperName =:emailTemplateName];
		//	system.debug('template '+template);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(template.Id);
            email.setToAddresses(emailAddresses);
            email.setSaveAsActivity(true);
            email.setWhatId(opportunityRecord != null ? opportunityRecord.Id : null);
            email.setTargetObjectId(opportunityRecord != null ? opportunityRecord.Account.PersonContactId : leadRecord.Id);
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'ABSA Do Not Reply'];
        	if (owea.size() > 0) {
            	email.setOrgWideEmailAddressId(owea.get(0).Id);
       		}
            Messaging.SendEmailResult [] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            system.debug('emailResult '+emailResult);
            if(emailResult[0].success)
            {
                System.debug('The email sent successfully: ');
                return true;
            } else {
                System.debug('Email did not send Error Message: ' + emailResult[0].errors[0].message);
                return false;
            }

        }
        else {
                return false;
        }
    }
}