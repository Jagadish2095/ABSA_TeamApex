/*Description: Test Data Factory that can be used everyone
* NOTE: All the methods would return the data which is not inserted/saved to database
* @Author: Rakesh Byri(Absa)
* @Created Date: 2019-03-05
* CHANGE LOG:
*=======================================================================================================
* 
*=======================================================================================================
* */
@isTest
public class TestDataFactory {
    /** @description getTestUsers
     * @param profileName
     * @param numberOfUsers
     * @return List<User>
     **/
    public static List<User> getTestUsers(String profileName, Integer numberOfUsers){
        Id profileId = [SELECT Id FROM Profile WHERE Name=:profileName].Id;
        List<User> usersList = new List<User>();
        while(numberOfUsers > 0){
            User newUser = new User(
                Alias = 'dummyusr', 
                Email='testuser1'+numberOfUsers+'@absa.com', 
                EmailEncodingKey='UTF-8',
                FirstName = 'Test',
                LastName='User', 
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', 
                ProfileId = profileId,
                TimeZoneSidKey='Africa/Johannesburg', 
                UserName='testuser1'+numberOfUsers+'@absa2.com'
            );
            usersList.add(newUser);
            --numberOfUsers;            
        }
        return usersList;
    }
    /** @description getAttachments
     * @param recordTypeDevName
     * @param numberOfLeads
     * @return List<Lead>
     **/
    public static List<Lead> getLeads(String recordTypeDevName, Integer numberOfLeads){
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Lead');
        Id recTypeId = recordTypeDevName != null ? rtInfo.get(recordTypeDevName).getRecordTypeId() : null;        
        List<Lead> leadsList = new List<Lead>();
        List<Financial_Product__c> prodList = getProducts('BB - Borrow - Loans - Business Term Loan', 'Loans', 
                                                          'Borrow', 'Business Term Loan', 'Borrow', 
                                                          'Business Banking', 1);
        insert prodList;
        while(numberOfLeads > 0){
            Lead newLead = new Lead(
                FirstName = 'Test'+numberOfLeads,
                LastName = 'Lead'+numberOfLeads,
                Status = 'Assigned',
                Company = 'Absa'+numberOfLeads,
                MobilePhone = '074502819'+numberOfLeads,
                Phone = '074502819'+numberOfLeads,
                Financial_Product__c = prodList[0].Id,
                RecordTypeId = recTypeId
            );
            leadsList.add(newLead);
            --numberOfLeads;
        }
        return leadsList;
    }
    /** @description getTasks
     * @param recordTypeDevName
     * @param numberOfTasks
     * @param whoId
     * @param whatId
     * @param taskSubType
     * @return List<Task>
     **/
    public static List<Task> getTasks(String recordTypeDevName, Integer numberOfTasks, 
                                      String whoId, String whatId, String taskSubType)
    {
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Task');
        Id recTypeId = recordTypeDevName != null ? rtInfo.get(recordTypeDevName).getRecordTypeId() : null;
        List<Task> tasksList = new List<Task>();
        while(numberOfTasks > 0){
            Task newTask = new Task(
                Subject = 'Test',
                Outcome__c = 'No Answer',
                TaskSubType = taskSubType,
                Next_Step__c = 'Call back',
                Call_Successful__c = 'No',
                WhoId = whoId != null ? whoId : null,
                WhatId = WhatId != null ? whatId : null
                //RecordTypeId = recTypeId (uncomment when the record types are to the profile)
            );
            tasksList.add(newTask);
            --numberOfTasks;
        }
        return tasksList;
    }
    /** @description getAttachments
     * @param name
     * @param product
     * @param type
     * @param subProduct
     * @param productType
     * @param businessUnit
     * @param numberOfProd
     * @return List<Financial_Product__c>
     **/
    public static List<Financial_Product__c> getProducts(String name, String product, 
                                                         String type, String subProduct,
                                                         String productType, String businessUnit, 
                                                         Integer numberOfProd)
    {   
        List<Financial_Product__c> prodList = new List<Financial_Product__c>();
        while(numberOfProd > 0){
            Financial_Product__c newProd = new Financial_Product__c(
                Name = name,
                Description__c = 'test product', 
                Type__c = type, 
                Product__c = product, 
                Sub_Product__c = subProduct, 
                Product_Type__c = productType,
                Business_Unit__c = businessUnit
            );
            prodList.add(newProd);
            --numberOfProd;
        }
        return prodList;
    }
    /** @description getOpportunities
     * @param leadNumber
     * @param recordTypeDevName
     * @param numberOfOpps
     * @return List<Opportunity>
     **/
    public static List<Opportunity> getOpportunities(String leadNumber, String recordTypeDevName, Integer numberOfOpps){
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Opportunity');
        Id recTypeId = recordTypeDevName != null ? rtInfo.get(recordTypeDevName).getRecordTypeId() : null;        
        List<Opportunity> oppList = new List<Opportunity>();
        List<Financial_Product__c> prodList = getProducts('BB - Borrow - Loans - Business Term Loan', 'Loans', 
                                                          'Borrow', 'Business Term Loan', 'Borrow', 
                                                          'Business Banking', 1);
        insert prodList;
        while(numberOfOpps > 0){
            Opportunity newOpp = new Opportunity(
                Name = 'Test'+numberOfOpps,
                StageName = 'Proposal',
                CloseDate = Date.today(),
                Lead_Number__c = leadNumber,
                Product_Interest__c = prodList[0].Id,
                RecordTypeId = recTypeId
            );
            oppList.add(newOpp);
            --numberOfOpps;
        }
        return oppList;
    }
    /** @description getPersonAccounts
     * @param lastName
     * @param recordTypeDevName
     * @param numberOfAccs
     * @return List<Account>
     **/
    public static List<Account> getPersonAccounts(String lastName, String recordTypeDevName, Integer numberOfAccs){
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Account');
        Id recTypeId = recordTypeDevName != null ? rtInfo.get(recordTypeDevName).getRecordTypeId() : null;
        List<Account> accList = new List<Account>();
        while(numberOfAccs > 0){
            Account newAcc = new Account(
                FirstName = 'Test',
                LastName = lastName+numberOfAccs,
                RecordTypeId = recTypeId
            );
            accList.add(newAcc);
            --numberOfAccs;            
        }
        return accList;
    }
    /** @description getCases
     * @param recordTypeDevName
     * @param numberOfCases
     * @return List<Case>
     **/
    public static List<Case> getCases(String recordTypeDevName, Integer numberOfCases){
        
         map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
             
        List<Case> casesList = new List<Case>();
        
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        while(numberOfCases > 0){
            Case newCase = new Case(Communication_Method__c = 'Email',
                            Status = 'New',
                            Origin = 'Email'+numberOfCases, 
                            AccountId = acct.Id,
                            Risk_Management_Centre__c = 'Digital Fraud',
                            Email__c = 'test@test.com',
                            Subject = 'test'+numberOfCases,
                            Description = 'test'+numberOfCases,
                            Expectation_of_the_Customer__c = 'test'+numberOfCases,
                            Incident_Date__c = date.today(),
                            Type__c = 'deposit',
                            //IncidentTime__c = System.now(),
                            Claim_Amount__C = 150,
                            Amount_Withdrawn__c = 130,
                            Amount_Received__c = 100,
                        
                            recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId());
            casesList.add(newCase);
            --numberOfCases;
        }
        return casesList;
        
    }
    /** @description getTomCases
     * @param recordTypeDevName
     * @param numberOfCases
     * @return List<Case>
     **/
    public static List<Case> getTomCases(String recordTypeDevName, Integer numberOfCases){
        
         map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
             
        List<Case> casesList = new List<Case>();
        
        Account acct = new Account(Name = 'Test Account',CIF__c='12346755235',Source__c='CIF');
        //insert acct;
        DateTime dt=system.today();
        //Account actRec=[select id,firstname from account where name='Test Account' limit 1];
    
        while(numberOfCases > 0){
            Case newCase = new Case(Communication_Method__c = 'Email',
                            Status = 'New',
                            Origin = 'Email'+numberOfCases, 
                            
                            Risk_Management_Centre__c = 'Digital Fraud',
                            Email__c = 'testTOm@test.com',
                            Subject = 'test'+numberOfCases,
                            Description = 'test'+numberOfCases,
                            Expectation_of_the_Customer__c = 'test'+numberOfCases,
                            Incident_Date__c = date.today(),
                            Type__c = 'deposit',
                            //IncidentTime__c = System.now(),
                            Claim_Amount__C = 150,
                            Amount_Withdrawn__c = 130,
                            Amount_Received__c = 100,
                            SequenceNumber__c='12345',
                            Receipt_Slip_Available__c=true,
                            NonAbsaATMText__c='yes',
                            Account_Number__c ='12345',
                            //ATMNumber__c=65432,
                            IncidentTime__c=Time.newInstance(dt.hour(),dt.minute(),dt.second(),dt.millisecond()),                     
                            recordTypeId = caseRecordTypeMap.get(recordTypeDevName).getRecordTypeId());
            casesList.add(newCase);
            --numberOfCases;
        }
        return casesList;
        
    
}
/** @description createdocument
     * @param entityId
     **/
public static void createdocument(String entityId)
    {
        ContentVersion content=new ContentVersion();
        content.Title='Header_certificate';
        content.PathOnClient='/' + content.Title + '.jpg';
        Blob bodyBlob=Blob.valueOf('ContentVersion Body');
        content.VersionData=bodyBlob;
        content.origin = 'H';
        insert content;

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=entityId;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'I';
        contentlink.Visibility = 'AllUsers';
        insert contentlink;
    }
}