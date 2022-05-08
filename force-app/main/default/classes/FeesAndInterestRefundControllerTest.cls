/* Lightning cmp controller Test for fees and interest refund
* Author: Lulu Rankwe
* Date :  17/12/2020 
* 
* */
@isTest
public class FeesAndInterestRefundControllerTest {
    
    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                Journal_Level__c = 'Level 1',
                                Journal_department__c = 'Region',
                                Debit_Account_Number__c = '00000001000550295',
                                Credit_Account_Number__c = '00000001000550295',
                                Cost_Centre__c = 'costCentre',
                                Corp_Code__c = 'corpCode',
                                Sub_Ledger__c = 'subledger',
                                Tab_Code__c = 'tabCode',
                                Amount__c = 3000, 
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(),
                                Reopen_Case_Approval_Required__c =true,
                                Reopen_Case_Reason__c ='Close in Error',
                                External_SLA_Notification_User__c = userInfo.getUserId());
        
        insert caseRec;  
        
        Opportunity opp = new Opportunity(Name = 'my opportunity');
        opp.CloseDate = Date.today();
        opp.StageName = 'Drafting';
        insert opp;
        
        Document__c doc = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Opportunity__c = opp.Id);
        insert doc;
        
        Document__c doc2 = new Document__c(Name = 'mydoc2.pdf', Reference__c = '123456', Opportunity__c = opp.Id);
        insert doc2;
        
        Document_Template__c dt = new Document_Template__c(Name = 'Absa 3741 Client Engagement', Client_Type__c = 'Private Individual', Document_Type__c = 'Absa 3741 Client Engagement');
        insert dt;
        
        Document_Template__c dts = new Document_Template__c(Name = 'Will', Client_Type__c = 'Private Individual', Document_Type__c = 'Will');
        insert dts;
        
    }
    @isTest 
    public static void testgetProducte(){
        Test.startTest(); 
        List<Product2> res = FeesAndInterestRefundController.getProduct();
        system.assertNotEquals(null, res);
        Test.stopTest();
    }
    
    @isTest 
    public static void testUpdateCase(){
         Account account = new Account(Name = 'Test Account');
        insert account;
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                Journal_Level__c = 'Level 1',
                                Journal_department__c = 'Region',
                                Debit_Account_Number__c = '00000001000550295',
                                Credit_Account_Number__c = '00000001000550295',
                                Cost_Centre__c = 'costCentre',
                                Corp_Code__c = 'corpCode',
                                Sub_Ledger__c = 'subledger',
                                Tab_Code__c = 'tabCode',
                                Amount__c = 3000, 
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today(),
                                Reopen_Case_Approval_Required__c =true,
                                Reopen_Case_Reason__c ='Close in Error',
                                External_SLA_Notification_User__c = userInfo.getUserId());
        
        insert caseRec;  
		Case caseRecord = [SELECT Id,Product_Search__c,Refund_Reason_Id__c, Refund_Transaction_Type_Id__c,AccountId,Journal_Level__c ,Refund_Date_Range_From__c,Refund_Date_Range_To__c,Effective_Date_for_Journal__c,Journal_department__c,Debit_Account_Number__c,Credit_Account_Number__c,Cost_Centre__c,Sub_Ledger__c,Corp_Code__c,Tab_Code__c,Amount__c FROM Case LIMIT 1];

        Test.startTest();  
        String res = FeesAndInterestRefundController.updateCase(caseRecord.Id,caseRecord.Product_Search__c,caseRecord.Refund_Reason_Id__c,caseRecord.Refund_Transaction_Type_Id__c,66,'','','','','','','2020/12/30','2020/12/30','2020/12/30','');
 		
        
        String output;
        
        system.assertNotEquals(null, res);
        Test.stopTest();
        
    }
    
    @isTest   
    public static void testGetDocumentAuditEmail(){
        
        Test.startTest();
        
        Opportunity testOpportunity = [SELECT Id,Name FROM Opportunity  Limit 1];
        Document__c doc = [SELECT Id FROM Document__c Where Opportunity__c =: testOpportunity.Id Limit 1];
        List<Document__c> documentAuditList = FeesAndInterestRefundController.getDocAuditHistoryEmail(testOpportunity.Id);
        system.assertNotEquals(null, documentAuditList);
        
        Test.stopTest();
    }
    
       static testMethod void testgetmandatorydocs()
    {
        string Entitytype = 'aa';
        Mandatory_Doc__mdt md1=new Mandatory_Doc__mdt();
        md1.Entity_Type__c='Sole Trader';
        md1.ECM_Type__c='Ent_Declaration';
        //return md1;
        Mandatory_Doc__mdt md2=new Mandatory_Doc__mdt();
        md1.Entity_Type__c='aa';
        md1.ECM_Type__c='bb';
        //md2.Type__c='bb';
        //return md2;Mandatory_Doc__mdt md1=new Mandatory_Doc__mdt();
        Mandatory_Doc__mdt md3=new Mandatory_Doc__mdt();
        md3.Entity_Type__c='Related Party Private Company';
        md3.ECM_Type__c='Ent_Declaration';
        
        Mandatory_Doc__mdt md4=new Mandatory_Doc__mdt();
        md4.Entity_Type__c='UBO';
        md4.ECM_Type__c='Ent_Declaration'; 
        
        //Opportunity opp=[select id,CheckMandatoryDocuments__c,StageName,Entity_Type__c from opportunity limit 1 ];
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Registration__c='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.Client_Type__c ='Private Company';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Country_of_Registration__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
        insert testAccount;
        
        Account account = new Account(Name = 'Test Account');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account.Country_of_Incorporation__c='South Africa';
        account.Client_Group__c = 'Non Individual';
        account.Client_Type__c ='Private Company';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        insert account;
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name1';
        acctSecondary.LastName = 'Last Name1';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.CASA_Reference_Number__pc = '12454' ;
        acctSecondary.CASA_Screening_Status__c = 'Matched';
        insert acctSecondary;  
        Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
        Id personContactId = acc.PersonContactId; 
        
        AccountContactRelation accConRel = new AccountContactRelation(
            AccountId = testAccount.Id, 
            ContactId = personContactId,
            Roles = 'Shareholder/Controller',
            Primary_Entity_Id__c = testAccount.Id,
            Share_Percentage__c = 50);
        insert accConRel;
        
        FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
        resRole.FinServ__CreateInverseRole__c = true;
        resRole.FinServ__InverseRole__c = 'Director';
        insert resRole;
        
        FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
            FinServ__Account__c = testAccount.Id, 
            FinServ__RelatedAccount__c = account.Id,
            Roles__c = 'Shareholder/Controller',
            FinServ__Role__c = resRole.id, 
            Primary_Entity_Id__c = testAccount.Id,
            Shareholding_Percentage__c = 50);    
        AccountAccountRelationController.calculateControllingPercentageVal(accAccRel);   
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        
        testOpp.StageName = 'Drafting';
        testOpp.accountId = testAccount.Id;
        insert testOpp;
        Document_Template__c d1=new Document_Template__c();
        d1.Name='ABSA 6280 - Tax Self- Certification and Declaration';
        d1.ECM_Item_Type__c='Ent_Declaration';
        insert d1;
        Document__c d= new Document__c();
        d.Name='aa';
        d.Type__c='ABSA 6280 - Tax Self- Certification and Declaration';
        d.Opportunity__c=testOpp.id;
        d.Account__c = testAccount.Id;
        d.ECM_Type__c='Ent_Declaration';
        d.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
        insert d;
        
        Document__c d2= new Document__c();
        d2.Name='aa';
        d2.Type__c='ABSA 6280 - Tax Self- Certification and Declaration';
        d2.Opportunity__c=testOpp.id;
        d2.Contact__c = personContactId;
        d2.ECM_Type__c='Ent_Declaration';
        d2.Reference__c = '92 3 ICM7 UGOLSDB13 Ent_Quotation59 26 A1001001A20F08C10108B0752518 A20F08C10108B075251 14 1868';
        insert d2;
        
        List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(testOpp.id);
        
        Test.startTest();
        FeesAndInterestRefundController.getDocs(testOpp.id);
        FeesAndInterestRefundController.getAllMandatoryDocuments(testOpp.Entity_Type__c);
        
        Test.stopTest();
    }
    
    static testMethod void testUpdateRec()
    {
        Opportunity opp=[select id,CheckMandatoryDocuments__c,StageName from opportunity limit 1 ];
        Test.startTest();
        try{
            new MandatoryDocumentSelector().getSObjectType();
            new MandatoryDocumentSelector().getSObjectFieldList();
            FeesAndInterestRefundController.updateRec(String.valueOf(opp.Id), 'true');
            
            FeesAndInterestRefundController.updateRec(String.valueOf(opp.Id), 'false');
            FeesAndInterestRefundController.updateRec('null','null');
            
        }
        catch(Exception e)
        {
            System.debug('Exception::'+e.getMessage());
        }
        Test.stopTest();
    }
    
    
      static testMethod void ECMLogin() {
        
        ECM_IH_V1Test.insertSettings();
        
        Test.startTest();
        FeesAndInterestRefundController.ECMLogin();
        Test.stopTest();
    }
    
    
     static testMethod void testGetDocumentsContent() {
        
        Document__c testDoc = [Select Id From Document__c Limit 1];
        ECM_IH_V1Test.insertSettings();
        String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
        
        Test.startTest();
        FeesAndInterestRefundController.getDocumentContent(testDoc.id);
        Test.stopTest();
    }
    
    
}