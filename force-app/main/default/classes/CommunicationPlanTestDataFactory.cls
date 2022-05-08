/**
* Test Factory for Communcation Plan
* @author  Rob McLean
* @created 2020-03-27
*/

public class CommunicationPlanTestDataFactory {
    public CommunicationPlanTestDataFactory(){
        List<user> uList = new List<user>();
        uList.add(createUser('UserAdmin','System Administrator (Custom)')); 
        uList.add(createUser('UserA','Standard User (Business Banker)'));
        uList.add(createUser('UserB','Standard User (Business Banker)'));
        uList.add(createUser('UserC','Standard User (Business Banker)'));
        uList.add(createUser('UserD','Standard User (Business Banker)'));
        uList.add(createUser('UserE','Standard User (Business Banker)'));
        insert uList;
        Group g1;
        Group g2;
        List <Group> gList = new List<Group>();
        gList = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name LIKE '%Complaint%' AND QueueRoutingConfigId != null LIMIT 2];
        if (gList.size() > 0) {
            Integer cnt = 1;
            for (Group g : gList) {
                if (cnt==1) {
                    g1=g;
                }else if (cnt==2) {
                    g2=g;
                }
                cnt++;                
            }
        }
        User us = createUser('User','Standard User (Business Banker)');
        insert us;

        String emailTmp;
        String smsTmp;
        Id emailTmpID;
        Id smsTmpID;
        String afrEmailTmp;
        String afrSMSTmp;
        Id afrEmailTmpID;
        Id afrSMSTmpID;

        List<EmailTemplate> emailTmpList = new List<EmailTemplate>();
        List<Folder> folderIdList = new List<Folder>();
        folderIdList = [SELECT Id FROM Folder WHERE Name = 'Complaints Email Templates'];
        Id folderId;
        if (folderIdList.size() > 0) {
            folderId = folderIdList.get(0).Id;
        }
        emailTmpList = [SELECT Id, Name FROM EmailTemplate WHERE FolderId  = : folderId LIMIT 4];
        System.debug('------- emailTmpList : '+emailTmpList);
        if (emailTmpList.size() > 0) {
            Integer cnt = 1;
            for (EmailTemplate e : emailTmpList) {
                if (cnt == 1) {
                    emailTmp = e.Name;
                    emailTmpID = e.ID;
                }
                else if (cnt == 2) {
                    smsTmp = e.Name;
                    smsTmpID = e.ID;
                }
                else if (cnt == 3) {
                    afrEmailTmp = e.Name;
                    afrEmailTmpID = e.ID;
                }
                else if (cnt == 4) {
                    afrSMSTmp = e.Name;
                    afrSMSTmpID = e.ID;
                }
                cnt ++;
            }
        }
        Integration_API__c api = createApi();
        Integration_Service__c intsrv = createIntegServ(api.Id);

        List<sd_Communication_Plan__c> commPlanList = new List<sd_Communication_Plan__c> ();
        sd_Communication_Plan__c commPlanCase = createCommPla('Actionline Plan');
        commPlanList.add(commPlanCase);
        sd_Communication_Plan__c commPlanLead = createCommPla('Default Lead Plan');
        commPlanList.add(commPlanLead);
        insert commPlanList;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours WHERE Name = 'Monday to Friday (7h00 - 16h30) excluding public holidays' LIMIT 1];
        Id busHrsId =  businessHr.Id;
        Id commPlanCaseId = commPlanCase.Id;
        Id commPlanLeadId = commPlanLead.Id;
        Id intSvcId = intsrv.Id;

        Service_Type__c servType = createServiceType();
        service_Group__c servGroup = createGroupType(busHrsId);

        Account testAccount = createAccount();
        Contact testContact = createContact(testAccount.Id);
        Opportunity testOpportunity = createOpportunity(testAccount.Id);

        List<sd_Communication_Rule__c> commRuleList = new List<sd_Communication_Rule__c>();
    /* Case User Preference */
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, null, 'Case Created in a Queue', 'User Preference', 'Before', 0, 
            'Case', 'Case Created in a Queue', 'Created Date', 'Immediate', null, null, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, null, 'Case Created in a Queue', 'User Preference', 'After', 24,
            'Case', 'Case Created in a Queue', 'Created Date', 'Time Based', null, null, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, null, 'Case Closed', 'User Preference', 'Before', 0, 'Case',
            'Case Closed', 'Created Date', 'Immediate', null, null, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, null, 'Case Closed', null, 'Before', 0, 'Case',
            'Case Closed', 'Created Date', 'Immediate', null, null, null, null, null, null)) ;
        // commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, null, 'Case Created in a Queue', 'User Preference', 'After', 24,
        //     'Case', 'Case Created in a Queue', 'Created Date', 'Time Based', null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, null, 'Case Owner Change to Queue', 'User Preference', 'Before', 0,
            'Case', 'Case Owner Change to Queue', 'Created Date', 'Immediate', null, null, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, null, 'Case External SLA Date Change', 'User Preference', 'Before', 0,
            'Case', 'Case External SLA Date Change', 'Created Date', 'Immediate', null, null, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, null, 'Case Open', 'User Preference', 'Before', 0, 'Case',
            'Case Open', 'Created Date', 'Immediate', null, null, null, null, null, null)) ;
    /* Case User Email */
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, emailTmp, null, 'Status Change to In Progress', 'Email', 'Before', 0,
            'Case', 'Status Change to In Progress', 'Created Date', 'Immediate', emailTmpID, null, null, null, null, null)) ;
    /* Case SMS */
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, smsTmp, 'Case Created as Closed', 'SMS', 'After', 8, 'Case',
            'Case Created as Closed', 'Assigned Date', 'Immediate', null, smsTmpID, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, smsTmp, 'Case Created for a User', 'SMS', 'After', 8, 'Case',
            'Case Created for a User', 'Assigned Date', 'Immediate', null, smsTmpID, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, smsTmp, 'Case Owner Change to User', 'SMS', 'After', 8, 'Case',
            'Case Owner Change to User', 'Assigned Date', 'Immediate', null, smsTmpID, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, null, smsTmp, 'Case Closed', 'SMS', 'Before', 0, 'Case', 'Case Closed', 
            'Created Date', 'Immediate', null, smsTmpID, null, null, null, null)) ;
        // commRuleList.add(createCommRule(busHrsId, commPlanCaseId, intSvcId, EmailTmp, SMSTmp, 'Case Owner Change to User', 'SMS', 'After', 8, 'Case',
        //     'Case Owner Change to User', 'Assigned Date', 'Immediate', null)) ; 
    /* Lead User Preference */    
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, null, 'Lead Created Not As Internal Propensity', 'User Preference',
            'Before', 0, 'Lead', 'Lead Created Not As Internal Propensity', 'Created Date', 'Immediate', null, null, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, null, 'Status Change to Abandoned', 'User Preference', 'Before', 0,
            'Lead', 'Status Change to Abandoned', 'Created Date', 'Immediate', null, null, null, afrSMSTmp, null, afrSMSTmpID)) ;
    /* Lead User Email */
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, emailTmp, null, 'Lead Created Not As Internal Propensity', 'Email',
            'Before', 0, 'Lead', 'Lead Created Not As Internal Propensity','Created Date', 'Immediate', emailTmpID, null, null, null, null, null )) ;
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, emailTmp, null, 'Status Change to Abandoned', 'Email', 'After', 48, 'Lead',
            'Status Change to Abandoned', 'Created Date', 'Time Based', emailTmpID, null, null, null, null, null)) ;
    /* Lead SMS */
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, smsTmp, 'First Unsuccessful Call', 'SMS', 'Before', 0, 'Lead',
            'First Unsuccessful Call', 'Created Date', 'Immediate', null, smsTmpID, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, null, 'First Unsuccessful Call', 'SMS', 'Before', 0, 'Lead',
            'First Unsuccessful Call', 'Created Date', 'Immediate', null, null, null, afrSMSTmp, null, afrSMSTmpID)) ;
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, null, 'Lead Converted', 'SMS', 'Before', 1, 'Lead',
             'Lead Converted', 'Created Date', 'Time Based', null, null, null, afrSMSTmp, null, afrSMSTmpID)) ;
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, null, 'Lead Not Converted', 'SMS', 'Before', 1, 'Lead',
             'Lead Not Converted', 'Created Date', 'Time Based', null, null, null, afrSMSTmp, null, afrSMSTmpID)) ;
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, null, 'Status Change to Unqualified', 'SMS', 'Before', 0, 'Lead',
            'Status Change to Unqualified', 'Created Date', 'Immediate', null, null, null, afrSMSTmp, null, afrSMSTmpID)) ;
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, smsTmp, 'Status Change to Abandoned', 'SMS', 'After', 48, 'Lead',
            'Status Change to Abandoned', 'Created Date', 'Time Based', null, smsTmpID, null, null, null, null)) ;
        commRuleList.add(createCommRule(busHrsId, CommPlanLeadId, IntSvcId, null, smsTmp, 'Status Change to Abandoned', null, 'After', 48, 'Lead',
            'Status Change to Abandoned', 'Created Date', 'Time Based', null, smsTmpID, null, null, null, null)) ;
        
        insert commRuleList;
        createLeads (commPlanLeadId,commPlanCaseId,us.Id);
        createCases(testAccount.Id,testContact.Id,busHrsId,g1.Id,us.Id,commPlanCaseId,servType.Id,servGroup.Id,emailTmp);
        
    }

    public static Integration_API__c createApi(){
        Integration_API__c api = new Integration_API__c();
        api.Name = 'iTouchxx';
        api.Environment__c = 'Development';
        api.Base_URL__c = 'https://testme/';
        api.Client_ID__c = '89797897987';
        api.Client_Secret__c = '789798';
        insert api;
        return api;
    }

    public static Integration_Service__c createIntegServ(Id ApiID){
        Integration_Service__c intsrv = new Integration_Service__c();
        intsrv.Integration_API_ID__c = ApiID;
        intsrv.Name = 'iTouch For PBB';
        intsrv.Method__c = 'POST';
        intsrv.URL_Extension__c = 'iTouch';
        intsrv.Username__c = 'abc';
        intsrv.Password__c = 'zyx';
        intsrv.Content_Type__c = 'application/json';
        insert intsrv;
        return intsrv;
    }

    public static sd_Communication_Plan__c createCommPla(String Name){
        sd_Communication_Plan__c commPlan = new sd_Communication_Plan__c();
        commPlan.Name = Name;
        return commPlan; 
    }
    
    public sd_Communication_Rule__c createCommRule (Id BusHrsId, Id CommPlanId, Id IntSvcId, String EmailTmp, String SMSTmp,String RuleDesc, String RuleAct, String RuleBefAft, Integer RuleQty, 
    String RuleObj, String RuleTrgCond, String RuleTrgDateFld,  String RuleWhenTrg, Id EmailTmpID, Id SMSTmpID, String AfrEmailTmp, String AfrSMSTmp, Id AfrEmailTmpID, Id AfrSMSTmpID ){

        String RuleUnits = 'Hour(s)';
        String RuleEmailFld;
        String RuleSMSFld;
        switch on RuleObj {
            when 'Lead' {
                if (RuleAct == 'SMS' && RuleDesc == 'Status Change to Abandoned' ) {
                    RuleSMSFld = 'Owner Mobile';
                }
                else {
                    RuleSMSFld = 'Mobile Phone';
                }
                RuleEmailFld = 'Email';  
            }
            when 'Case'{
                RuleEmailFld = 'Email';
                RuleSMSFld = 'Mobile';
            }
        }
        sd_Communication_Rule__c commRule = new sd_Communication_Rule__c();
        commRule.sd_Communication_Plan__c = CommPlanId;
        commRule.sd_Integration_Service__c = IntSvcId;
        commRule.sd_Business_Hours__c = BusHrsId;
        commRule.sd_Rule_Description__c = RuleDesc;
        commRule.sd_Action__c = RuleAct;
        commRule.sd_Before_After__c = RuleBefAft;
        commRule.sd_Quantity__c = RuleQty;
        commRule.sd_Email_Field__c = RuleEmailFld;
        commRule.sd_SMS_Field__c = RuleSMSFld;
        commRule.sd_Object__c = RuleObj;
        commRule.sd_Email_Template__c = EmailTmp;
        commRule.sd_Email_Template_Id__c = EmailTmpID;
        commRule.sd_Email_Template_AFR__c = AfrEmailTmp;
        commRule.sd_Email_Template_Id_AFR__c = AfrEmailTmpID;
        commRule.sd_SMS_Template_AFR__c = AfrSMSTmp;
        commRule.sd_SMS_Template_Id_AFR__c = AfrSMSTmpID;
        commRule.sd_SMS_Template__c = SMSTmp;
        commRule.sd_SMS_Template_Id__c = SMSTmpID;
        commRule.sd_Trigger_Condition__c = RuleTrgCond;
        commRule.sd_Trigger_Date_Field__c = RuleTrgDateFld;
        commRule.sd_Units__c = RuleUnits;
        commRule.sd_When_to_Trigger__c = RuleWhenTrg;
        return commRule;
    }

    public void createLeads (Id CommPlanLead, Id CommPlanCase, Id OwnerId){

        List<Lead> lList = new List<Lead>();
        Financial_Product__c testFinancialProduct = new Financial_Product__c();
        testFinancialProduct.Name = 'Estate Provider Plan';
        testFinancialProduct.Type__c = 'Borrow';
        testFinancialProduct.Description__c = 'Test Product';
        testFinancialProduct.Business_Unit__c = 'Business Banking';
        testFinancialProduct.Product_Type__c = 'Bank';
        insert testFinancialProduct;
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Business Bank Lead').getRecordTypeId();

        Lead lead1 = new Lead();
        lead1.RecordTypeId = leadRecordTypeId;
        lead1.FirstName = 'Activity1';
        lead1.LastName = 'TestLead1';
        lead1.Company = 'Activity Test Lead1';
        lead1.Financial_Product__c = testFinancialProduct.Id;
        lead1.MobilePhone = '0831111111';
        lead1.Phone = '0831111111';
        lead1.Email = 'UserA@testorg.com';
        lead1.Language_Preference__c= 'English'; 
        lead1.sd_Communication_Plan_Id__c = commPlanLead;
        lead1.LeadSource = 'Other';
        lead1.Unsuccessful_Calls__c = null;
        lead1.Preferred_Communication_Channel__c = 'Email';
        lead1.Status = 'Nurturing';
        lead1.OwnerId = OwnerId;
        lead1.Bypass_Validation_Rules__c = false;
        lList.add(lead1);

        Lead lead2 = new Lead();
        lead2.RecordTypeId = leadRecordTypeId;
        lead2.FirstName = 'Activity2';
        lead2.LastName = 'TestLead2';
        lead2.Company = 'Activity Test Lead2';
        lead2.Financial_Product__c = testFinancialProduct.Id;
        lead2.MobilePhone = '0832222222';
        lead2.Phone = '0832222222';
        lead2.Email = 'UserB@testorg.com';
        lead2.Language_Preference__c= 'Afrikaans'; 
        lead2.sd_Communication_Plan_Id__c = commPlanLead;
        lead2.LeadSource = 'Other';
        lead2.Unsuccessful_Calls__c = null;
        lead2.Preferred_Communication_Channel__c = 'Email';
        lead2.Status = 'Nurturing';
        lead2.OwnerId = OwnerId;
        lead2.Bypass_Validation_Rules__c = false;
        lList.add(lead2);

        Lead lead3 = new Lead();
        lead3.RecordTypeId = leadRecordTypeId;
        lead3.FirstName = 'Activity3';
        lead3.LastName = 'TestLead3';
        lead3.Company = 'Activity Test Lead3';
        lead3.Financial_Product__c = testFinancialProduct.Id;
       	lead3.MobilePhone = '0823333333';
        lead3.Phone = '0823333333';
        lead3.Email = 'UserC@testorg.com';
        lead3.Language_Preference__c= 'Afrikaans';        
        lead3.sd_Communication_Plan_Id__c = commPlanLead;
        lead3.LeadSource = 'Other';
        lead3.Unsuccessful_Calls__c = 1;
        lead3.Preferred_Communication_Channel__c = 'SMS';
        lead3.Status = 'Nurturing';
        lead3.OwnerId = OwnerId;
        lead3.Bypass_Validation_Rules__c = false;
        lList.add(lead3);

        Lead lead4 = new Lead();
        lead4.RecordTypeId = leadRecordTypeId;
        lead4.FirstName = 'Activity4';
        lead4.LastName = 'TestLead4';
        lead4.Company = 'Activity Test Lead4';
        lead4.Financial_Product__c = testFinancialProduct.Id;
       	lead4.MobilePhone = '0824444444';
        lead4.Phone = '0824444444';
        lead4.Email = 'UserD@testorg.com';
        lead4.Language_Preference__c= 'Afrikaans';        
        lead4.sd_Communication_Plan_Id__c = commPlanLead;
        lead4.LeadSource = 'Other';
        lead4.Unsuccessful_Calls__c = 1;
        lead4.Preferred_Communication_Channel__c = 'Post';
        lead4.Status = 'Nurturing';
        lead4.OwnerId = OwnerId;
        lead4.Bypass_Validation_Rules__c = false;
        lList.add(lead4);

        insert lList;
    }
    
    public static User createUser(String lastName, String Profile){
        User u = new User();
        String uniqueUserName = lastName + DateTime.now().getTime() + '@testorg.com';
        String email = lastName +'@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name= :Profile];
        u = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName=lastName, LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', UserName=uniqueUserName, MobilePhone='0823389021');        
        return u;        
    }

    public static Service_Type__c createServiceType(){
        Service_Type__c sType = new Service_Type__c();
        sType.Name = 'Additionals';
        sType.Case_Record_Type__c = 'Complaint';
        sType.Subtype__c = 'Additionals';
        sType.Type__c = 'Request';
        insert sType;
        return sType;
    }

    public static Service_Group__c createGroupType(Id busHrsId){
        Service_Group__c sGroup = new Service_Group__c();
        sGroup.Name = 'Savings and Investment - Retail Complaints';
        sGroup.Assign_Record_Type__c = 'Complaint';
        sGroup.Business_Hours__c = busHrsId;
        sGroup.Internal_SLA_Time_Measure__c = 'Day(s)';
        sGroup.Internal_SLA_Units__c = '2';
        sGroup.Pause_Statuses__c = 'None';
        sGroup.Queue__c = 'Everyday Banking Complaints';
        sGroup.Response_Email_Address__c = 'complaintsresolution@absa.africa';
        sGroup.Internal_SLA_Warning__c = 80;
        sGroup.Active__c = true;
        sGroup.Track_Status_Changes__c = false;
        sGroup.Open_New_Case__c = false;
        insert sGroup;
        return sGroup;
    }

    public static Account createAccount(){
        Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

        Account testAccount = new Account();
        testAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        testAccount.CASA_Reference_Number__c = '1712994';
        testAccount.CASA_Risk_Status__c = 'Low';
        testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testAccount.CASA_Screening_Status__c = 'Approved';
        testAccount.CASA_Analyst_Comments__c = '30406';
        testAccount.PersonMobilePhone = '0747003747';
        testAccount.Country_of_Residence__pc='South Africa';
        testAccount.PersonBirthdate = Date.valueOf('1981-07-11');
        testAccount.PersonEmail = 'test@test.co.za';
        testAccount.FirstName = 'Tony';
        testAccount.External_Siebel_ID__c = '1-1IV9MC';
        testAccount.ID_Number__pc = '8107115017084';
        testAccount.ID_Type__pc = 'SA Identity Document';
        testAccount.LastName = 'Stark';
        testAccount.Nationality__pc = 'South Africa';
        testAccount.Occupation__pc = 'Engineer';
        testAccount.Onboarding_Channel__c = 'Test';
        testAccount.Communication_Language__pc = 'Afrikaans';
        testAccount.PersonTitle = 'Mr.';
        testAccount.Client_Type__c = 'Individual Client';
        testAccount.Phone = '0114453322';
        testAccount.Gender__pc = 'Male';
        testAccount.Initials__pc = 'T';
        testAccount.Country_of_Birth__pc = 'South Africa';
        testAccount.Marital_Status__pc = 'Married';
        testAccount.Marital_Contract_Type__pc = 'Community of Property';
        testAccount.Income_Source__pc = 'Bonus';
        testAccount.Occupation_Status__pc = 'Full Time Employed';
        testAccount.Income_Bracket__pc = 'R20;000 - R75;000 pm';
        testAccount.Occupation_Category__pc = 'Advertising';
        testAccount.ShippingCity = 'CAPE TOWN';
        testAccount.ShippingCountry = 'South Africa';
        testAccount.ShippingStreet = '01 PUERTA DEL SOL';
        testAccount.ShippingPostalCode = '8001';
        testAccount.BillingCity = 'GROBLERSDAL';
        testAccount.BillingCountry = 'South Africa';
        testAccount.BillingStreet = '01 MABOPANE SECTION';
        testAccount.BillingPostalCode = '1060';
        testAccount.CIF__c = 'AFIFTAP001';
        testAccount.Alternative_Email__c = 'test@test.com';
        testAccount.Alternative_Email_1__c = 'test@test.com';
        testAccount.Alternative_Email_2__c = 'test@test.com';
        testAccount.Alternative_Email_3__c = 'test@test.com';
        testAccount.Alternative_Email_4__c = 'test@test.com';
        testAccount.PersonAssistantPhone = '0114453322';
        testAccount.PersonAssistantName = 'Test Name';
        testAccount.PersonHomePhone = '0114453322';
        testAccount.PersonOtherPhone = '0114453322';
        testAccount.Phone = '0114453322';
        testAccount.Fax = '0114453322';
        testAccount.FinServ__CurrentEmployer__pc = 'Current Employer';
        testAccount.AccountNumber = '0011j00000WkXuGAAV';
        insert testAccount;
        return testAccount;
    }

    public static Contact createContact(Id accId){
                Contact testContact = new Contact();
                testContact.FirstName = 'Test';
                testContact.LastName = 'Contact';
                testContact.Title = 'Mr.';
                //testContact.AccountId = accId;
                testContact.CASA_Reference_Number__c = '1712994';
                testContact.CASA_Risk_Status__c = 'Low';
                testContact.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
                testContact.CASA_Screening_Status__c = 'Approved';
                testContact.CASA_Analyst_Comments__c = '30406';
                testContact.Occupation__c ='South Africa';
                testContact.Income_Source__c = 'Bonus';
                testContact.Occupation_Status__c = 'Full Time Employed';
                testContact.Income_Bracket__c = 'R20;000 - R75;000 pm';
                testContact.Occupation_Category__c = 'Advertising';
                testContact.Communication_Language__c = 'Afrikaans';
                testContact.ID_Type__c = 'SA Identity Document';
                testContact.Nationality__c = 'South Africa';
                testContact.Country_of_Origin__c = 'South Africa';
                testContact.Country_of_Residence__c = 'South Africa';
                testContact.Country_of_Birth__c = 'South Africa';
                testContact.MobilePhone = '0747003747';
                testContact.AssistantPhone = '0112232233';
                testContact.Fax = '0112232233';
                testContact.HomePhone = '0112232233';
                testContact.OtherPhone = '0112232233';
                testContact.Phone = '0112232233';
                testContact.AssistantName = 'Test Assistant';
                testContact.Email = 'test123@test.com';
                testContact.FinServ__CurrentEmployer__c = 'Current Employer';
                testContact.Initials__c = 'JJ';
                testContact.Maiden_Name__c = 'Monroe';
                testContact.MailingStreet = 'Test Mailing';
                testContact.OtherStreet = 'Test Other';
                testContact.Preferred_Communication_Method__c = 'Email';
                insert testContact;
                return testContact;
    }

    public static Opportunity createOpportunity(Id accId){
        Map <String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = accId;
        testOpportunity.RecordTypeId = OpportunityRecordTypeMap.get('General').getRecordTypeId();
        testOpportunity.Adviser_AB_Number__c = 'TEST001';
        testOpportunity.Name = 'EPP';
        testOpportunity.Product__c = 'Estate Provider Plan';
        testOpportunity.LeadSource = 'Siebel Campaign';
        testOpportunity.Sub_Product__c = 'Estate Provider Plan';
        testOpportunity.Type = 'Cross Sell';
        testOpportunity.Originating_Adviser_AB_Number__c = 'EXTC150';
        testOpportunity.External_Siebel_ID__c = '1-BSGP6F';
        testOpportunity.StageName = 'Not Interested';
        testOpportunity.CloseDate = Date.today() + 10;
        testOpportunity.Will_Number__c = '12345678923';
        testOpportunity.Commission_1st_Year__c = 2000;
        testOpportunity.Commission_2nd_Year__c = 590;
        testOpportunity.Debit_Order_Debit_Day__c='30';
        testOpportunity.Debit_Order_Salary_Day__c='10';
        testOpportunity.DebitOrderThirdParty__c=true;
        testOpportunity.Commencement_Date__c = Date.today();
        testOpportunity.Debit_Order_Date__c = Date.today();
        testOpportunity.Debit_Order_Account_Number__c = '1234567890';
        testOpportunity.Selected_Email__c = 'test@test.com';
        insert testOpportunity;
        return testOpportunity;
    }

    public static void createCases(Id AccId, Id ConId, Id BhrsId, Id GroupId, Id UserId, Id ComPlanId, Id ServTypId, Id ServGrpId, String EmailTmp){
        //System.debug('----- createCases');
        //System.debug('----- GroupId : '+GroupId);
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
        List<Case> caseList = new List<Case>();
        Datetime td	= System.today();
        Datetime fd =  td.addMonths(-2);
        //System.debug('----- td : '+td);
        //System.debug('----- fd : '+fd);
        Case case1 = new Case(ContactId=ConId, AccountId=AccId, BusinessHoursId=BhrsId, RecordTypeId=caseRecordTypeId, Status='New', Origin='Email', Subject='Case 1',
        Priority='Medium', Description='Case 1 Test', Approval_Status__c='Approved', Awaiting_Status__c='Awaiting Customer Documents', Communication_Method__c='Email',
        Deadlock_Approval_Required__c=true, Deadlock_Reason_Motivation__c='Sample test', Email_From_Address__c='test@ret.com', Email__c='test@ret.com',
        Entity__c='Individual', Expectation_of_the_Customer__c='Testing', Incident_Date__c=System.Today(), originated_By__c='Absa Customer', Risk_Management_Centre__c='Digital Fraud',
        SLA_Extension_Approval__c='Approved', SLA_Extension_Reason__c='This is for testing', Service_Type_Search__c=ServTypId, Type__c='Test',
        sd_Email_Template_Case_Classification__c='RBB Contact Centre - Auto Response on email receipt_Sanctions',  sd_Pause_Statuses__c='Awaiting Customer Documents, Awaiting Customer Feedback',
        Service_Group_Search__c=ServGrpId,  sd_Communication_Plan_Id__c=ComPlanId, Case_Ownership__c='FPOC', Number_of_Requests__c=1, OwnerId=GroupId,
        SLA_Extension_Approval_Required__c=true,  Mobile__c='0987654321', Bypass_Validation_Rules__c=true);
        caseList.add(case1);

        Case case2 = new Case (ContactId=ConId, AccountId=AccId, RecordTypeId=caseRecordTypeId, Status='New', Origin='Email', Subject='Case 2', Description ='Case 2 Test',
        Approval_Status__c='Approved', Awaiting_Status__c='Awaiting Customer Documents', Communication_Method__c = 'SMS', Deadlock_Approval_Required__c = true, 
        Deadlock_Reason_Motivation__c='Sample test', Email_From_Address__c='test@ret.com', Email__c='test@ret.com', Expectation_of_the_Customer__c='Testing', Incident_Date__c = System.Today(),
        Risk_Management_Centre__c='Digital Fraud', SLA_Extension_Approval__c='Approved', SLA_Extension_Reason__c='This is for testing',Type__c='Test',
        sd_Email_Template_Case_Classification__c=EmailTmp, sd_Pause_Statuses__c='Awaiting Customer Documents, Awaiting Customer Feedback',sd_Communication_Plan_Id__c=ComPlanId,
        OwnerId = GroupId, SLA_Extension_Approval_Required__c = true,Mobile__c='0987654321', Bypass_Validation_Rules__c=true);
        caseList.add(case2);

        Case case3 = new Case (ContactId=ConId, AccountId=AccId, RecordTypeId=caseRecordTypeId, Status='New', Origin='Email', Subject='Case 3', Description ='Case 3 Test',
        Approval_Status__c='Approved', Awaiting_Status__c='Awaiting Customer Documents', Communication_Method__c = 'Email', Deadlock_Approval_Required__c = true, 
        Deadlock_Reason_Motivation__c='Sample test', Email_From_Address__c='test@ret.com', Email__c='test@ret.com', Expectation_of_the_Customer__c='Testing', Incident_Date__c = System.Today(),
        Risk_Management_Centre__c='Digital Fraud', SLA_Extension_Approval__c='Approved', SLA_Extension_Reason__c='This is for testing',Type__c='Test',
        sd_Email_Template_Case_Classification__c=EmailTmp, sd_Pause_Statuses__c='Awaiting Customer Documents, Awaiting Customer Feedback',sd_Communication_Plan_Id__c=ComPlanId,
        OwnerId = GroupId, SLA_Extension_Approval_Required__c = true,Mobile__c='0987654321', Bypass_Validation_Rules__c = true);
        caseList.add(case3);

        Case case4 = new Case (ContactId=ConId, AccountId=AccId, RecordTypeId=caseRecordTypeId, Status='New', Origin='Email', Subject='Case 4', Description ='Case 4 Test',
        Approval_Status__c='Approved', Awaiting_Status__c='Awaiting Customer Documents', Communication_Method__c = 'SMS', Deadlock_Approval_Required__c = true, 
        Deadlock_Reason_Motivation__c='Sample test', Email_From_Address__c='test@ret.com', Email__c='test@ret.com', Expectation_of_the_Customer__c='Testing', Incident_Date__c = System.Today(),
        Risk_Management_Centre__c='Digital Fraud', SLA_Extension_Approval__c='Approved', SLA_Extension_Reason__c='This is for testing',Type__c='Test',
        sd_Email_Template_Case_Classification__c=EmailTmp, sd_Pause_Statuses__c='Awaiting Customer Documents, Awaiting Customer Feedback',sd_Communication_Plan_Id__c=ComPlanId,
        OwnerId = GroupId, SLA_Extension_Approval_Required__c = true,Mobile__c='0987654321', Bypass_Validation_Rules__c=true, Case_Ownership__c='I will Resolve', External_SLA_End_Date__c=fd);
        caseList.add(case4);

        Case case5 = new Case (ContactId=ConId, AccountId=AccId, RecordTypeId=caseRecordTypeId, Status='New', Origin='Email', Subject='Case 5', Description ='Case 5 Test',
        Approval_Status__c='Approved', Awaiting_Status__c='Awaiting Customer Documents', Communication_Method__c = 'Email', Deadlock_Approval_Required__c = true, 
        Deadlock_Reason_Motivation__c='Sample test', Email_From_Address__c='test@ret.com', Email__c='test@ret.com', Expectation_of_the_Customer__c='Testing', Incident_Date__c = System.Today(),
        Risk_Management_Centre__c='Digital Fraud', SLA_Extension_Approval__c='Approved', SLA_Extension_Reason__c='This is for testing',Type__c='Test',
        sd_Email_Template_Case_Classification__c=EmailTmp, sd_Pause_Statuses__c='Awaiting Customer Documents, Awaiting Customer Feedback',sd_Communication_Plan_Id__c=ComPlanId,
        OwnerId = UserId, SLA_Extension_Approval_Required__c = true,Mobile__c='0987654321', Bypass_Validation_Rules__c=true, Case_Ownership__c='I will Resolve');
        caseList.add(case5);

        Case case6 = new Case (ContactId=ConId, AccountId=AccId, RecordTypeId=caseRecordTypeId, Status='New', Origin='Email', Subject='Case 6', Description ='Case 6 Test',
        Approval_Status__c='Approved', Awaiting_Status__c='Awaiting Customer Documents', Communication_Method__c = 'Post', Deadlock_Approval_Required__c = true, 
        Deadlock_Reason_Motivation__c='Sample test', Email_From_Address__c='test@ret.com', Email__c='test@ret.com', Expectation_of_the_Customer__c='Testing', Incident_Date__c = System.Today(),
        Risk_Management_Centre__c='Digital Fraud', SLA_Extension_Approval__c='Approved', SLA_Extension_Reason__c='This is for testing',Type__c='Test',
        sd_Email_Template_Case_Classification__c=EmailTmp, sd_Pause_Statuses__c='Awaiting Customer Documents, Awaiting Customer Feedback',sd_Communication_Plan_Id__c=ComPlanId,
        OwnerId = GroupId, SLA_Extension_Approval_Required__c = true,Mobile__c='0987654321', Bypass_Validation_Rules__c=true, Case_Ownership__c='I will Resolve', External_SLA_End_Date__c=fd);
        caseList.add(case6);

        insert caseList;
    }
}