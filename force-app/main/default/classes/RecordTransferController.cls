/**
* @description RecordTransferController record transfer class
*
*/

public without sharing class RecordTransferController 
{
    
    /**
* @description change Owner of record
* @param recId
* @param newowner
*/
    @AuraEnabled
    public static void changeOwner(String recId,String newowner) {
        
        if (recId.startsWith('006'))
        {
            Opportunity so = [select id,OwnerId from Opportunity where id =: recId];
            so.OwnerId = newowner;
            update so;
        }
        else if(recId.startsWith('00Q')){
            Lead so = [select id,OwnerId from Lead where id =: recId];
            so.OwnerId = newowner;
            so.Single_Transfer__c = true;
            update so;
        }
    }
    
    /**=================================================================================================================================
* Created By Eduardo Salia 13/03/2021
* @description Returns Object Type Name
* @param recordId  is our record Id from the Aura Component
* @return string
===================================================================================================================================**/
    @AuraEnabled
    public static String getObjectName(Id recordId)
    {
        return recordId.getSObjectType().getDescribe().getName();
    }
    
    
    /**=================================================================================================================================
* Created By Eduardo Salia 13/03/2021
* @description Sets Opportunity Stage and STI Sub Status
* @param opportunityId is our Opportunity Id from the Aura Component
* @param referralType  is the type of client referral chosen
* @param consultantEmailAddress  is the Email Address of the AIC Consultant from the Aura Component
* @param generatorEmailAddress  is the Email Address of the Lead Generator from the Aura Component
* @param clientNotes  is the additional information field from the from the Aura Component
* @param insuranceType type of insurance
* @return Boolean true or false
===================================================================================================================================**/
    @AuraEnabled
    public static Boolean updateOpportunity(Id opportunityId, String referralType, String consultantEmailAddress, String generatorEmailAddress, String clientNotes,String insuranceType)
    {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(
            opportunityId,
            StringConstants.MAX_ROW_COUNT);
        
        Opportunity opportunity = opportunities[0];
        opportunity.VA_AIC_Consultant_Email__c = consultantEmailAddress;
        opportunity.Lead_Originator_Email__c = generatorEmailAddress;
        opportunity.VA_Client_Referral_Notes__c = clientNotes;
        opportunity.Type_of_Insurance_Needed__c = insuranceType;
        UPDATE Opportunity;
        
        Boolean result = sendReferralEmail(opportunityId, referralType, consultantEmailAddress, generatorEmailAddress, clientNotes);
        
        return result;
    }
    
    /**=================================================================================================================================
* @description  Sets Opportunity Stage and STI Sub Status
* @param opportunityId : opportunityId is our Opportunity Id from the Aura Component
* @param referralType : referralType is the type of client referral chosen
* @param consultantEmailAddress : consultantEmailAddress is the Email Address of the AIC Consultant from the Aura Component
* @param generatorEmailAddress : generatorEmailAddress is the Email Address of the Lead Generator from the Aura Component
* @param clientNotes : clientNotes is the additional information field from the from the Aura Component
* @return true or false
===================================================================================================================================**/
    public static Boolean sendReferralEmail(Id opportunityId, String referralType, String consultantEmailAddress, String generatorEmailAddress, String clientNotes)
    { 
        OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address =: StringConstants.VIRTUAL_ADVISOR_OWD_EMAIL];
        
        //Get Opportunity By Id
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(
            opportunityId,
            StringConstants.MAX_ROW_COUNT);
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();       
        List<EmailTemplate> em = new List<EmailTemplate>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        List<String> sendCc = new List<String>();
        
        if(!Sys_Utilities_General.isListBlank(opportunities))
        {
            Opportunity opportunity = opportunities[0];
            if(referralType == StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_EXTERNAL)
            {
                em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where Name ='STI Client Referral External - Individual' limit 1];
                if(isSandbox())
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
                }
                else
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_PSG_ADDRESS_1);
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_PSG_ADDRESS_2);
                }               
            }
            else if(referralType == StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_AIFA)
            {
                em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where Name ='STI Client Referral Internal AIFA' limit 1];
                if(isSandbox())
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
                }
                else
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_AIFA_ADDRESS_1);
                } 
            }
            else if(referralType == StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_VA_LIFE)
            {
                em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where Name ='STI Client Referral Internal VA Life' limit 1];
                if(isSandbox())
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
                }
                else
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_VA_LIFE_ADDRESS_1);
                } 
            }
            else if(referralType == StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_IDIRECT)
            {
                em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where Name ='STI Client Referral Internal iDirect' limit 1];
                if(isSandbox())
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
                }
                else
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_IDIRECT_ADDRESS_1);
                } 
            }
            else if(referralType == StringConstants.OPPORTUNITY_STI_SUB_STATUS_REFERRED_INTERNAL_DIRECT_DELIVERY)
            {
                em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where Name ='STI Client Referral Internal Direct Delivery' limit 1];
                if(isSandbox())
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
                }
                else
                {
                    sendTo.add(StringConstants.VIRTUAL_ADVISOR_DD_ADDRESS_1);
                } 
            }
            
            sendCc.add(opportunity.Owner.Email);
            sendCc.add(consultantEmailAddress);
            sendCc.add(generatorEmailAddress);
            
            mail.setToAddresses(sendTo);
            mail.setCcAddresses(sendCc);
            mail.setOrgWideEmailAddressId(owd.Id);
            if(opportunity.ContactName__c!=null){
                mail.setTargetObjectId(opportunity.ContactName__c);
            }
            else{
                
                mail.setTargetObjectId(opportunity.Account.PersonContactId);
            }
            
            mail.setWhatId(opportunityId);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setSaveAsActivity(true);
            mail.setTemplateId(em[0].id);      
            mails.add(mail);
            
            //system.debug('Email--->'+mail);
            //system.debug('Size--->'+mails.size());
            Messaging.sendEmail(mails);
            
            
            opportunity.STI_Sub_Status__c = referralType;
            opportunity.StageName = StringConstants.OPPORTUNITY_STAGE_CLOSED_LOST;
            Update Opportunity;
            
            return true;
        } 
        
        return false;
        
    }
    
    /** 
@description isSandbox 
@return true or false
**/
    public static Boolean isSandbox()
    {
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
    /**=================================================================================================================================
* @auther Created By Eduardo Salia 13/03/2021
* @description Updates Case Object with Virtual Advisor and Notes
* @param caseId is our Case Id from the Aura Component
* @param ownerId is the Virtual Advisor Id from the Aura Component
* @param comments is the additional information field from the from the Aura Component
* @param referralType is the type of referral from the Aura Component
* @return Boolean true or false
===================================================================================================================================**/
    @AuraEnabled
    public static Boolean referCase(Id caseId, Id ownerId, String comments, String referralType)
    {
        List<Case> cases = new CasesSelector().selectByIdWithSLAInfo(
            caseId,
            StringConstants.MAX_ROW_COUNT);
        
        OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address =: StringConstants.VIRTUAL_ADVISOR_OWD_EMAIL];
        
        List<Messaging.SingleEmailMessage> emails =  new List<Messaging.SingleEmailMessage>();       
        List<EmailTemplate> emailTemplates = new List<EmailTemplate>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        List<String> sendCc = new List<String>();
        
        List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
        String defaulttargetObjectId = null;
        if (mdt.size()>0 ) {
            defaulttargetObjectId = mdt[0].Value__c;
        }
        
        Case currentCase = cases[0];
        //currentCase.VA_Client_Referral_Type__c = referralType;
        currentCase.Comments__c = comments;
        // UPDATE currentCase;
        currentCase.OwnerId = ownerId;
        currentCase.Advisor__c = ownerId;
        currentCase.Client_Review_Sub_Status__c = StringConstants.CASE_SUB_STATUS_REFERRED;        
        //system.debug('referralType---' + referralType);
        if(referralType == StringConstants.CASE_REFERRAL_TYPE_VA )
            currentCase.Status = StringConstants.CASE_STATUS_ASSIGNED;
        else
            currentCase.Status = StringConstants.CASE_STATUS_CLOSED;
        
        UPDATE currentCase;
        
        if(currentCase.RecordType.DeveloperName == StringConstants.CASE_RECORD_TYPE_CLIENT_REVIEW)
            emailTemplates = [SELECT Id, Subject, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName ='VA_Virtual_Advisor_Referral_Email' LIMIT 1];
        else if(currentCase.RecordType.DeveloperName == StringConstants.CASE_RECORD_TYPE_MATURITY)
            emailTemplates = [SELECT Id, Subject, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName ='VA_Virtual_Advisor_Referral_Email_Maturity' LIMIT 1];
        
        if(isSandbox())
        {
            sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
            sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
        }
        else
        {
            sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_1);
            sendTo.add(StringConstants.VIRTUAL_ADVISOR_TEST_EMAIL_2);
        }
        
        if(String.isNotBlank(currentCase.Owner.Email))
            sendCc.add(currentCase.Owner.Email);
        
        email.setToAddresses(sendTo);
        if(!sendCc.isEmpty())
            email.setCcAddresses(sendCc);
        
        email.setOrgWideEmailAddressId(owd.Id);
        if(currentCase.ContactId != null)
            email.setTargetObjectId(currentCase.ContactId);
        else
            email.setTargetObjectId(defaulttargetObjectId);
        
        email.setWhatId(currentCase.Id);
        email.setTreatTargetObjectAsRecipient(false);
        email.setSaveAsActivity(true);
        email.setTemplateId(emailTemplates[0].id);      
        emails.add(email);
        
        if(!Test.isRunningTest())Messaging.sendEmail(emails);
        
        return true;
    }
    
    /**
* @description getOpportunity
* Created By Pravin W. 09/07/2021
* @param  recordId
* @return Opportunity
**/
    @AuraEnabled
    public static Opportunity getOpportunity(Id recordId)
    {
        list<Opportunity> lstOpportunities = new list<Opportunity>();
        lstOpportunities = new OpportunitiesSelector().selectByOpportunityId(recordId,1);
        return lstOpportunities[0];
    }
    
    /**=================================================================================================================================
* Created By Pravin W. 09/07/2021
* Returns list of picklist values
* Param 1: object API Name is API name of object the field is on
* Param 2: field API name : picklist field name
===================================================================================================================================**/
    /**
* @description getPiklistValues
* Created By Pravin W. 09/07/2021
* @param  objName
* @param  fldName
* @return Map
**/
    @AuraEnabled
    public static Map<String, String> getPiklistValues(string objName,string fldName) {
        List<String> plValues = new List<String>();
        Map<String, String> valueLabelMap = new Map<String,String>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get(fldName).getDescribe();
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
        //Add the picklist values to list.
        for(Schema.PicklistEntry plv: picklistvalues){
            //plValues.add(plv.getValue());
            valueLabelMap.put(plv.getLabel(),plv.getValue());
        }
        //plValues.sort();
        return valueLabelMap;
    }   
    
    /**
* @description getAdvisers
* Created By Pravin W. 09/07/2021
* @param  lstLanguages
* @param  lstSkills
* @return list<user>
**/
    @AuraEnabled
    public static list<user> getAdvisers(list<string> lstLanguages,list<string> lstSkills)
    {
        string strLanguages = '(';
        string strSkills = '(';
        
        if( lstLanguages != null && lstLanguages.size() > 0 ){
            for(string key : lstLanguages){
                strLanguages += '\''+key + '\'' +','; 
            }
            if( !String.isBlank(strLanguages)  ) strLanguages = strLanguages.removeEnd(',');
            strLanguages += ')';
        }
        
        
        if( lstSkills != null && lstSkills.size() > 0 ){
            for(string key : lstSkills){
                strSkills += '\'' + key + '\'' + ','; 
            }
            if( !String.isBlank(strSkills) ) strSkills = strSkills.removeEnd(',');
            strSkills += ')';
        }
        
        list<user> lstUser = new list<user>();
        //system.debug('language '+strLanguages);
        //system.debug('strSkills '+strSkills);
       string Search = 'SELECT id,FirstName,LastName,Name,Skills_Products__c FROM User WHERE IsActive = true ';
if( lstLanguages != null && lstLanguages.size() > 0 ){ Search += ' AND LanguageLocaleKey IN ' +strLanguages;}
if( lstSkills != null && lstSkills.size() > 0 ){Search += ' AND Skills_Products__c IN '+strSkills;}

Search = Search + ' limit 40 ';
lstUser = database.query(search);
        
        //lstUser = [SELECT id,FirstName,LastName,Name,Skills_Products__c FROM User WHERE IsActive = true AND LanguageLocaleKey IN: lstLanguages AND Skills_Products__c IN: lstSkills limit 40];
        //system.debug(lstUser.size());
        return lstUser;
    }
     /**
* @description getPiklistValues
* Created By Pravin W. 09/07/2021
* @param  userId
* @param  oppId
* @param agentNotes
* @return String
**/
 @AuraEnabled
    public static String referOpportunityToVA(string userId, string oppId, String agentNotes)
    {
        String returnString = '';
        
        if(oppId != null){
            Opportunity opp = new Opportunity();
            OpportunitiesSelector oppSelector = new OpportunitiesSelector();
            opp = oppSelector.selectByOppId(oppId);
            // adding record type check for investment opportunity
            if(opp.RecordType.Name == 'Investment Opportunity'){
                opp.StageName = 'Closed';
                opp.Sub_Status__c = 'Referred to VA';
                opp.Sys_BypassValidation__c = true;
                //Commented By Divya 
                //Creating Clone Opportunity insted of Update owner
                //opp.OwnerId = userId;
                TriggerDispatcher.skip(TriggerHandlerOpportunity.class.getName());
                update opp;
                //Insert Child Opportunity
                newreferOpportunity(userId,opp.Id,agentNotes);
                returnString = 'Success';
            }
        }
        return returnString;
    }
/**
* @description newreferOpportunity
* Created By Pravin W. 09/07/2021
* @param  ownerId
* @param  parentOppId
* @param  agentNotes
**/
    public static void newreferOpportunity(string ownerId, String parentOppId, String agentNotes)
    {
        Opportunity referclient = new Opportunity();
        
        try{
            List<Org_Wide_Lookup_Value__mdt> mdt = new OrgWideLookupValuesSelector().selectByLabel('Email Template Default TargetObjectId');
            OpportunitiesSelector oppSelector = new OpportunitiesSelector();
            Opportunity parentOpp = oppSelector.selectByOppId(parentOppId);
            String defaulttargetObjectId = null;
            if (mdt.size()>0 ) {
                defaulttargetObjectId = mdt[0].Value__c;
            }
            
            
            referclient.Name =parentOpp.Name+'_clone';
            referclient.StageName = 'New';
            referclient.OwnerId = ownerId;
            referclient.AccountId = parentOpp.AccountId;
            referclient.RecordTypeId = parentOpp.RecordTypeId;
            referclient.Sys_BypassValidation__c = true;
            referclient.CloseDate =parentOpp.CloseDate;
            referclient.Parent_Opportunity__c = parentOpp.Id;
            referclient.ReferredByUser__c=UserInfo.getUserId();
            referclient.Comments__c= agentNotes;
            //Insert child Opportunity 
             TriggerDispatcher.skip(TriggerHandlerOpportunity.class.getName());
            insert referclient;
            
            referclient = oppSelector.selectByOppId(referclient.Id);
            
            // now send an email to new Advisor that Opportunity is referred
            UsersSelector usrSelector = new UsersSelector();
            User u = new User();
            u = usrSelector.selectById(ownerId);
            List<Messaging.SingleEmailMessage> emails =  new List<Messaging.SingleEmailMessage>();
            List<EmailTemplate> emailTemplates = new List<EmailTemplate>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            List<String> sendCc = new List<String>();
            OrgWideEmailAddress owd = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address =: StringConstants.VIRTUAL_ADVISOR_ABSA_EMAIL];
            emailTemplates = [SELECT Id, Subject, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName ='INV_VA_Advisor_Referral_Email' LIMIT 1];
            sendTo.add(u.email); // uncomment when testing complete
            email.setToAddresses(sendTo);
            //email.setCcAddresses(sendCc);
            email.setOrgWideEmailAddressId(owd.Id);
            if(string.isNotBlank(defaulttargetObjectId) )
                email.setTargetObjectId(defaulttargetObjectId);
            email.setWhatId(referclient.Id);
            email.setTreatTargetObjectAsRecipient(false);
            email.setSaveAsActivity(true);
            email.setTemplateId(emailTemplates[0].id);
            emails.add(email);
            //Send Email to Customer
            Messaging.SingleEmailMessage customeremail = BrokerNoteProcessController.getCustomerEmailTemplate(referclient,defaulttargetObjectId,u,owd,'INV_Refer_Email_to_Customer',true);
            Messaging.SingleEmailMessage customeremail1 = BrokerNoteProcessController.getCustomerEmailTemplate(referclient,defaulttargetObjectId,u,owd,'Investment_Opportunity_Notify_Adviser',false);
            emails.add(customeremail);
            emails.add(customeremail1);
            // send an sms to the customer
            if(!Test.isRunningTest()){
                Messaging.sendEmail(emails);
                //SMSHandler.sendSMS(null, referclient.Id, referclient.Mobile__c, '', StringConstants.INV_F2F_QUICK_TEXT, StringConstants.VA_ITOUCH_SMS_INTEGRATION_SERVICE, true);
            	BrokerNoteProcessController.dispatchSMS(null, referclient.Id, referclient.Mobile__c, '', StringConstants.INV_F2F_QUICK_TEXT, StringConstants.VA_ITOUCH_SMS_INTEGRATION_SERVICE, true);
            }
            TriggerDispatcher.skip(TriggerHandlerOpportunity.class.getName());
            referclient.Sys_BypassValidation__c = true;
            update referclient;
        }
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}