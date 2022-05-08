/**
* Test Factory for Quoting Process
* @author  Rob McLean
* @created 2020-04-16
*/
public class QuotingProcessTestDataFactory {

    public QuotingProcessTestDataFactory(){

        List<user> uList = new List<user>();
        User u = createUser('User','System Administrator','ABCD123','123456','A12345678');
        uList.add(createUser('UserAdmin','System Administrator (Custom)', null,null,null)); 
        uList.add(u);
        insert uList;
        Datetime td	= System.today();
        Datetime cd = td.addYears(-5);
        Datetime sd = td.addYears(-30);
        Datetime accd = td.addYears(-35);
        Date dfSpouseDOB = date.newinstance(sd.year(), sd.month(), sd.day());
        String childDOB = cd.format('YYYY-MM-dd');
        String SpouseDOB = sd.format('YYYY-MM-dd');
        String accDOB = sd.format('YYYY-MM-dd');
        Account acc = createAccount(u.Id,accDOB);
        Contact con = createContact(acc.Id);
        Opportunity opp = createOpportunity(acc.Id, 'EPP 1', u.Id,dfSpouseDOB);
        Opportunity opp2 = createOpportunity(acc.Id, 'EPP 2', u.Id, null);
        createOppParty(opp.Id, 'Child', 'Dependant', childDOB, 'CHILD123456', null );
        createOppParty(opp.Id, 'Child', 'Beneficiary', childDOB, 'CHILD123456', 0.50 );
        createOppParty(opp.Id, 'Spouse', 'Spouse', SpouseDOB, 'SPOUSE123456', null );
        createFinancialNeedsAnalysis(acc.Id);
        createDocumentTemplate();
        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> priceBkEntrydList = new List<PricebookEntry>();
        List<Product2> prodList = new List<Product2>();
        priceBkEntrydList.add(createPriceBookEntry(pricebookId, 'EPP Executor Fees Policy'));
        priceBkEntrydList.add(createPriceBookEntry(pricebookId, 'EPP Executor Fees Policy Spouse'));
        priceBkEntrydList.add(createPriceBookEntry(pricebookId, 'EPP Estate Bridging Benefit'));
        priceBkEntrydList.add(createPriceBookEntry(pricebookId, 'EPP Estate Bridging Benefit Spouse'));
        priceBkEntrydList.add(createPriceBookEntry(pricebookId, 'EPP Funeral Benefit'));
        priceBkEntrydList.add(createPriceBookEntry(pricebookId, 'EPP Funeral Benefit Spouse'));
        priceBkEntrydList.add(createPriceBookEntry(pricebookId, 'Policy Fee'));
        prodList.add([SELECT Id, Name FROM Product2 WHERE Name = 'EPP Executor Fees Policy' LIMIT 1 ]);
        prodList.add([SELECT Id, Name FROM Product2 WHERE Name = 'EPP Executor Fees Policy Spouse' LIMIT 1 ]);
        prodList.add([SELECT Id, Name FROM Product2 WHERE Name = 'EPP Funeral Benefit' LIMIT 1 ]);
        Id qteId =  createQuote('EPP Quote', opp.Id, pricebookId);
        opp.SyncedQuoteId = qteId;
        Update opp;
        opp2.SyncedQuoteId = qteId;
      //  Update opp2;
        Id prodId1;
        Id prodId2;
        Id prodId3;
        if (prodList.size() > 0) {
            for (Product2 p : prodList) {
                if (p.Name == 'EPP Executor Fees Policy') {
                    prodId1 = p.Id;
                }else if (p.Name == 'EPP Executor Fees Policy Spouse') {
                    prodId2 = p.Id;
                }else if (p.Name == 'EPP Funeral Benefit') {
                    prodId3 = p.Id;
                }
            }
        }
        Id pBookEntId1;
        Id pBookEntId2;
        Id pBookEntId3;
        if (priceBkEntrydList.size() > 0) {
            for (PricebookEntry i : priceBkEntrydList) {
                if (i.Product2Id == prodId1) {
                    pBookEntId1 = i.Id;
                }else if (i.Product2Id == prodId2) {
                    pBookEntId2 = i.Id;
                }else if (i.Product2Id == prodId3) {
                    pBookEntId3 = i.Id;
                }
            }
        }
        List<QuoteLineItem> qteLineItemList = new List<QuoteLineItem>();
        qteLineItemList.add(createQteLineItem(prodId1, qteId, pBookEntId1, 1, 50));
        qteLineItemList.add(createQteLineItem(prodId2, qteId, pBookEntId2, 1, 50));
        qteLineItemList.add(createQteLineItem(prodId3, qteId, pBookEntId3, 1, 50));
        if (qteLineItemList.size()>0) {
            insert qteLineItemList;
        }
        List<EPP_Pricing_Matrix__c> eppPriMatList = new List<EPP_Pricing_Matrix__c>();
        eppPriMatList.add(createEppPriceMatrix(null,45,36,'30 000',null,null,30000.00,57.00,'Executors_Fees_Cover'));
        eppPriMatList.add(createEppPriceMatrix(null,60,46,'30 000',null,null,30000.00,65.00,'Executors_Fees_Cover'));
        eppPriMatList.add(createEppPriceMatrix(null,65,61,'30 000',null,null,30000.00,82.00,'Executors_Fees_Cover'));
        eppPriMatList.add(createEppPriceMatrix(System.today(),35,18,'30 000',null,null,30000.00,50.00,'Executors_Fees_Cover'));
        eppPriMatList.add(createEppPriceMatrix(System.today(),null,null,null,null,null,null,10.00,'Policy_Fee'));
        eppPriMatList.add(createEppPriceMatrix(System.today(),null,null,null,null,'Main Member',50000.00,40.00,'Family_Funeral'));
        eppPriMatList.add(createEppPriceMatrix(null,null,null,null,null,'Spouse',50000.00,40.00,'Family_Funeral'));
        eppPriMatList.add(createEppPriceMatrix(null,null,null,null,null,'Children aged 14-21',50000.00,40.00,'Family_Funeral'));
        eppPriMatList.add(createEppPriceMatrix(null,null,null,null,null,'Children aged 6-13',25000.00,40.00,'Family_Funeral'));
        eppPriMatList.add(createEppPriceMatrix(null,null,null,null,null,'Children aged 1-5',12500.00,40.00,'Family_Funeral'));
        eppPriMatList.add(createEppPriceMatrix(null,null,null,null,null,'Stillbirths til 11 months',6250.00,40.00,'Family_Funeral'));
        if (eppPriMatList.size()>0) {
            insert eppPriMatList;
        }
    }

    public static User createUser(String lastName, String profile, String abNumber, String advCode, String brid){
        User u = new User();
        String uniqueUserName = lastName + DateTime.now().getTime() + '@testorg.com';
        String email = lastName +'@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name= :profile];
        u = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName=lastName, LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', UserName=uniqueUserName, MobilePhone='0823389021',
        AB_Number__c=abNumber, Advisor_Code__c=advCode, BRID__c=brid);        
        return u;        
    }

    public static void createDocumentTemplate(){
        Document_Template__c dt = new Document_Template__c();
        dt.Name = 'EPP Quote Stage';
        dt.XML__c = '<Account> <LastName>{Account.LastName}</LastName>';
        insert dt;
    }

    public static void createFinancialNeedsAnalysis(Id accId){
        Financial_Needs_Analysis__c testFna = new Financial_Needs_Analysis__c();
        testFna.Account__c = accId;
        testFna.Cash__c = 50;
        testFna.Investment__c = 100;
        insert testFna;
    }
    
    public static Account createAccount(Id ownId, String accDOB){
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
        testAccount.PersonBirthdate = Date.valueOf(accDOB);
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
        testAccount.OwnerId = OwnId;
        insert testAccount;
        return testAccount;
    }

    public static Contact createContact(Id accId){
        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.Title = 'Mr.';
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
        insert testContact;
        return testContact;
    }

    public static Opportunity createOpportunity(Id accId, String name, Id ownId, Date spouseDOB){
        Map <String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = accId;
        testOpportunity.RecordTypeId = OpportunityRecordTypeMap.get('General').getRecordTypeId();
        testOpportunity.Adviser_AB_Number__c = 'TEST001';
        testOpportunity.Name = name;
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
        testOpportunity.OwnerId = ownId;
      //  testOpportunity.currentQuote = 
        if (spouseDOB != null) {
            testOpportunity.Spouse_Date_of_Birth__c = spouseDOB;
        }
        insert testOpportunity;
        return testOpportunity;
    }

    public static void createOppParty(Id oppId, String relation, String type, String dateOfBirth, String idNum, Decimal benSplit ){
        Opportunity_Party__c oppParty = new Opportunity_Party__c();
        oppParty.Opportunity__c = oppId;
        oppParty.First_Name__c = relation+'Name';
        oppParty.Last_Name__c = relation+'LastName';
        oppParty.Date_of_Birth__c = Date.valueOf(dateOfBirth);
        oppParty.Party_Type__c = type;
        oppParty.RSA_ID_Number__c = idNum;
        oppParty.Relationship__c = relation;
      //  if (type=='Beneficiary') {
            oppParty.Benefit_Split__c = benSplit;
        //}        
        insert oppParty;
    }
    
     public static Opportunity_Party__c createOppParty1(Id oppId, String relation, String type, String dateOfBirth, String idNum, Decimal benSplit ){
        Opportunity_Party__c oppParty = new Opportunity_Party__c();
        oppParty.Opportunity__c = oppId;
        oppParty.First_Name__c = relation+'Name';
        oppParty.Last_Name__c = relation+'LastName';
        oppParty.Date_of_Birth__c = Date.valueOf(dateOfBirth);
        oppParty.Party_Type__c = type;
        oppParty.RSA_ID_Number__c = idNum;
        oppParty.Relationship__c = relation;
        if (type=='Beneficiary') {
            oppParty.Benefit_Split__c = benSplit;
        }        
        insert oppParty;
         return oppParty;
    }

    public static PricebookEntry createPriceBookEntry(Id pricebookId, String name){        
        Product2 prod = new Product2();
        prod.name = name;
        prod.IsActive = true;
        insert prod;
        PricebookEntry priceBkEntry = new PricebookEntry();
        priceBkEntry.UnitPrice = 0;
        priceBkEntry.Product2Id = prod.id;
        priceBkEntry.Pricebook2Id = pricebookId;
        priceBkEntry.IsActive = true;
        insert priceBkEntry;
        return priceBkEntry;
    }

    public static Id createQuote(String name, Id oppId, Id pBookID){
        Quote qte = new Quote();
        qte.Name = name;
        qte.OpportunityId = oppId;
        qte.Pricebook2Id = pBookID;
        qte.Commission_1st_Year__c = 100;
        qte.Commission_2nd_Year__c = 20;
        insert qte;
        return qte.Id;
    }

    public static QuoteLineItem  createQteLineItem(Id prodId, Id qteId, Id pBookEntId, Integer qty, Integer price){
        QuoteLineItem qteLineItem = new QuoteLineItem();
        qteLineItem.Product2Id = prodId;
        qteLineItem.QuoteId = qteId;
        qteLineItem.PriceBookEntryID = pBookEntId;
        qteLineItem.Quantity = qty;
        qteLineItem.UnitPrice = price;
        return qteLineItem;
    }
    
    public static EPP_Pricing_Matrix__c createEppPriceMatrix(Date efectDate, Integer endAge, Integer startAge, String execCov, String estCov, String funPlan, Decimal sumIns, Decimal prem, String recordType ){
        Map <String, Schema.RecordTypeInfo> EPPPricMatRecordTypeMap = EPP_Pricing_Matrix__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        EPP_Pricing_Matrix__c eppPM = new EPP_Pricing_Matrix__c();
        eppPM.RecordTypeId = EPPPricMatRecordTypeMap.get(recordType).getRecordTypeId();
        eppPM.Effective_Date__c = efectDate;
        eppPM.End_Age__c = endAge;
        eppPM.Estate_Bridging_Cover__c = estCov;
        eppPM.Executor_Fee_Cover__c = execCov;
        eppPM.Funeral_Plan_Member__c = funPlan;
        eppPM.Premium__c = prem;
        eppPM.Start_age__c = startAge;
        eppPM.Sum_Insured__c = sumIns;
        return eppPM;
    }
}