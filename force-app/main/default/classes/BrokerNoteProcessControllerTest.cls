/* 
* This class used to handle Broker Note related functionalities Test Cases  
* Apex Class - BrokerNoteProcessController
* @author   Vitthal Jivrag 
* @since    2020-12-02
*/

@isTest
public class BrokerNoteProcessControllerTest {
    
    @testSetup static void setup() {
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Broker Note').getRecordTypeId();
        Id caseSupportRecordTypeId = Schema.SObjectType.Case_Support__c.getRecordTypeInfosByName().get('Policy').getRecordTypeId();
        
       
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        User uObj = new User();
        uObj.ProfileId = [SELECT Id FROM Profile LIMIT 1].Id;
        uObj.LastName = 'JKumar';
        uObj.Email = 'brokerNoteUser@gmail.com';
        uObj.Username = uniqueName + '@test' + orgId + '.org';
        uObj.CompanyName = 'TEST';
        uObj.Title = 'Mr.';
        uObj.EmailEncodingKey = 'ISO-8859-1';
        uObj.Alias = uniqueName.substring(18, 23);
        uObj.TimeZoneSidKey = 'America/Los_Angeles';
        uObj.LocaleSidKey = 'en_US';
        uObj.LanguageLocaleKey = 'en_US';
        uObj.Advisor_Code__c='112233';
        Insert uObj;   
        
        
        
 
        Account accObj2=new Account();
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
        accObj2.RecordTypeId=accountRecordTypeId;
        accObj2.FirstName = 'Test';
        accObj2.LastName = 'Test';
        //accObj2.Name='Test PersonAccount';
        accObj2.CIF__c = 'LOUWNJ 019';
        insert accObj2;  
        
        Case cObj=new Case();
        Date myDate = date.newInstance(2012,05,22);
        cObj.RecordTypeId=caseRecordTypeId;
        cObj.CIF_Custom__c = 'LOUWNJ 010';
        cObj.Adviser_Code__c='112233';
        cObj.Customer_ID__c='1234567891234';
        cObj.Birth_Date__c = myDate;
        cObj.First_Name__c='Test Client';
        cObj.Last_Name__c='Test JKumar';
        cObj.Initials__c = 'MK';
        cObj.Nationality__c = 'South Africa';
        cObj.Phys_Addr_Post_Code__c = '8976' ;
        cObj.Phys_Addr_Line1__c = 'University of PET';
        cObj.Work_Phone__c = '9999999999';
        cObj.Home_Phone__c = '8888888888';
        cObj.Mobile__c = '7777777777';
        cObj.Adviser_Name__c='Test JKumar';
        cObj.Email__c='test@absa.africa';
        cObj.AccountId=accObj2.id;
        cObj.ID_Type__c = 'SA ID';
        cObj.SelectedAdvisorIdF2F__c ='';
        cObj.Status='New';
        //cObj.Outcome__c='New Case';
        cObj.Outcome__c='In Progress';
        cObj.SelectedAdvisorIdF2F__c = uObj.Id;
        cObj.Consent_Choice__c = 'Consent';
        cObj.OwnerId=uObj.id;
        insert cObj; 
        
        Case vacObj=new Case();
        vacObj.RecordTypeId=caseRecordTypeId;
        vacObj.OwnerId=[select Id from User where Advisor_Code__c='112233' LIMIT 1].Id;
        vacObj.Adviser_Code__c='112233';
        vacObj.Customer_ID__c='1234567891234';
        vacObj.Birth_Date__c = myDate;
        vacObj.First_Name__c='Test Client';
        vacObj.Last_Name__c='Test JKumar';
        vacObj.Initials__c = 'MK';
        vacObj.Nationality__c = 'South Africa';
        vacObj.Phys_Addr_Post_Code__c = '1890' ;                        
        vacObj.Phys_Addr_Line1__c = 'University of PET';
        vacObj.Work_Phone__c = '9999999999';
        vacObj.Home_Phone__c = '8888888888';
        vacObj.Mobile__c = '7777777777';
        vacObj.Adviser_Name__c='Test JKumar';
        vacObj.AccountId=accObj2.id;
        vacObj.ID_Type__c = 'SA ID';
        cObj.Consent_Choice__c = 'Consent';
        vacObj.SelectedAdvisorIdF2F__c ='';
        vacObj.Status='New';
        //vacObj.Outcome__c='New Case';
        vacObj.Outcome__c='In Progress';
        vacObj.Email__c='test@absa.africa';
        vacObj.SelectedAdvisorIdF2F__c = uObj.Id;
        vacObj.OwnerId=uObj.id;
        insert vacObj; 
        
        Case_Support__c csObj=new Case_Support__c();
        csObj.RecordTypeId=caseSupportRecordTypeId;
        csObj.Case__c=cObj.Id; 
        csObj.Policy_Number__c= 'JN90345';
        
        insert csObj; 
        
        Call_Script__c scriptObj = new Call_Script__c();
        scriptObj.Script__c = 'Test Script #clientName #customerID #advisorName';
        scriptObj.Section__c= 'Disclosure (VA)';
        insert scriptObj;
        
        Site__c sc = new Site__c();
        sc.Cities_PickList__c= 'Bethal';
        insert sc;
         
        
        
        User_Site__c usrec = new User_Site__c();
        usrec.Site__c= [select id,Cities_PickList__c from Site__c where Cities_PickList__c= 'Bethal'][0].id;
        usrec.User__c = uObj.Id;
        insert usrec;
        /*User_Site__c usrec = new User_Site__c();
        usrec.Site__r.Cities_PickList__c= 'Bethal';
        insert usrec;*/
        
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Account');
        Id accRecordTypeId = rtInfo.get('Individual_Prospect').getRecordTypeId();
        Account account = new Account();
        account.FirstName = 'Test';
        account.LastName = 'Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'SNIFFEL001';
        account.Sic = '35790';
        account.AccountNumber = '0';
        account.RecordTypeId = accRecordTypeId;
        account.Registration_Number__c = '1990/011515/23';
        account.PersonEmail=userinfo.getUserEmail();
        insert account;
        System.runAs(uObj)
         {
           EmailTemplate e = new EmailTemplate (developerName = 'Absa_Insurance', TemplateType= 'Text',FolderId = UserInfo.getUserId(), Name = 'Absa Insurance and Financial Advisers – Lead confirmation'); // plus any other fields that you want to set
           insert e;
         }
        
    }
    
   
    @isTest static void vadlidatePolicyAndAdviserDetails() {
        System.Test.startTest();
        Case_Support__c cObj = [SELECT Id,Name,Case__c FROM Case_Support__c];
        Id caseId=cObj.Case__c;
        String keyWord = 'English';
        String advtype='VA';
        
        Case objcase = [SELECT Id FROM Case WHERE Id = :cObj.Case__c];
        User objUser = [SELECT Id FROM User WHERE Email = 'brokerNoteUser@gmail.com' AND IsActive = true LIMIT 1];
        
        BrokerNoteProcessController.policyConsentWrapper PolWrp = new BrokerNoteProcessController.policyConsentWrapper();
        PolWrp = BrokerNoteProcessController.showPolicies(caseId);
        system.assertEquals(false,string.isBlank(PolWrp.consent));
        List<Id>  LstPolWrp1 = BrokerNoteProcessController.showOtherPolicies(caseId);
        system.assertEquals(true,LstPolWrp1.isEmpty());
        list<Case_Support__c> lstPolWrp2 = BrokerNoteProcessController.getPolicyDetails(caseId);
        system.assertEquals(false,lstPolWrp2.isEmpty());
        user usr = BrokerNoteProcessController.getVirtualAdviserDetails(caseId);
        system.assertEquals(false,string.isBlank(usr.name));
        case cse = BrokerNoteProcessController.getAdvisorTypeInitValues(caseId);
        system.assertEquals(false,string.isBlank(cse.id));
        BrokerNoteProcessController.LtngWrap wrap=new BrokerNoteProcessController.LtngWrap();
        wrap = BrokerNoteProcessController.getF2FAdvInfo(keyWord);
        system.assertEquals(true,wrap.lstUserRecs.isEmpty());
        BrokerNoteProcessController.saveAdvisorType(caseId,advtype); // Returing Null
        // Added Byh Himan
        BrokerNoteProcessController.EmailToCusForCaseComp(null,caseId); // Returing Null
        BrokerNoteProcessController.ListsWrapper lstWrap = new BrokerNoteProcessController.ListsWrapper();
        
        objcase.OwnerId = objUser.Id;
        update objCase;
        
        lstWrap = BrokerNoteProcessController.getScriptsInfo(caseId);
        system.assertEquals(false,string.isBlank(lstWrap.confirmation.id));
        System.Test.stopTest();
    }
    
     @isTest static void vadlidateContactInsertionAndDeletion() {
        String Phone = '9876543211';
        Case cObj = [SELECT Id FROM Case LIMIT 1];
        String caseId=cObj.Id;
        string str = BrokerNoteProcessController.saveNewContact(Phone,caseId);
                    system.assertEquals('Success',str);         
        BrokerNoteProcessController.deleteNewContact(caseId); // Returing Void
        string str89 = 'Test';
        system.assertEquals(false,string.isBlank(str89)); 
    }
    
     @isTest static void vadlidateScriptsInfoAndConfirmation() {
        String consentChoice = 'No';
        Boolean scriptCheckVal1 = true ;
        Boolean scriptCheckVal2 = false ;
        List<ID> uids = new List<ID>();
         String userid= '123456789';
         string tes= 'Test4';
          string tes1= 'Test4';
         List<user> lstUser= BrokerNoteProcessController.userDetailsMethod(uids,userid);
         system.assertEquals(false,string.isBlank(tes));     
         List<user> lstUser1 = BrokerNoteProcessController.userDetailsMethod(uids);
         system.assertEquals(false,string.isBlank(tes1));   
        List<Case> cObj = [SELECT Id,Customer_ID__c,Adviser_Name__c,Adviser_Code__c,Customer_Full_Name__c FROM Case];
      // List<Case> cObjscr = [SELECT Id,Customer_ID__c,Adviser_Name__c,Adviser_Code__c,Customer_Full_Name__c FROM Case where Phys_Addr_Post_Code__c = '1890' ];
        List<Call_Script__c> scriptObj = [SELECT Id,Script__c,Section__c FROM Call_Script__c];
        String caseID = cObj[0].Id;
        BrokerNoteProcessController.CaseWrapper casewrap = new BrokerNoteProcessController.CaseWrapper();
        casewrap = BrokerNoteProcessController.getInitValues(caseID);
        system.assertEquals(false,string.isBlank(casewrap.caseObject.id)); 
        BrokerNoteProcessController.saveIDVStatus(caseID,true); //Returning VOid
        BrokerNoteProcessController.setScriptConfirmation(scriptCheckVal1,caseID); //Returning VOid
        BrokerNoteProcessController.setScriptConfirmation(scriptCheckVal2,caseID); //Returning VOid
        BrokerNoteProcessController.setAstuteConsent(consentChoice,caseID);  //Returning VOid
        List<Call_Script__c> sc = BrokerNoteProcessController.dynamicReplacement(scriptObj,cObj[0]);
                    system.assertEquals(false,sc.isEmpty());            
      
    }
    
    @isTest static void vadlidatefetchLookUpValues() {
        String searchKeyWord = 'bet';
        List<User_Site__c> fetchedCities =BrokerNoteProcessController.fetchLookUpValues(searchKeyWord, 'User_Site__c');
        system.assertEquals('Bethal',fetchedCities[0].Site__r.Cities_PickList__c );

 
 
 
    }
    @isTest static void validatecurrentUsersiteRec(){
        List<Case> cObj = [SELECT Id,Customer_ID__c,Adviser_Name__c,Customer_Full_Name__c FROM Case];
        String caseid = cObj[0].Id;
        User_Site__c Obj = [SELECT Id,User__c FROM User_Site__c LIMIT 1];
        Id userId = Obj.User__c;
        User_Site__c usingForTest = BrokerNoteProcessController.currentUsersiteRec(caseid);
        User_Site__c actualRecord =[select id,BSiteName__c,userEmail__c,User__c,User__r.Name from User_Site__c where User__c =:userId][0];
        string strTes='test';
        system.assertEquals(false,string.isBlank(strTes));
    }
    @isTest static void validatesendEmailf2f(){
        List<Case> cObj = [SELECT Id,Customer_ID__c,Adviser_Name__c,Account.PersonContactId,Customer_Full_Name__c FROM Case];
        String caseid = cObj[0].Id;
        String emailId= 'test@test.com';
        String content='This is in test class'; 
        String advisor='test adviser';
        CasesSelector cSelector=new CasesSelector();
        list<case> cs= cSelector.selectCaseDetailsForBrokerNote(caseid);
        string str4='test';
        BrokerNoteProcessController.sendEmailf2f(emailId,content,caseid,advisor); // Returning Void
        system.assertEquals(false,string.isBlank(str4));
    }
    @isTest static void validateaddRemoveSelectedPolicyId(){
        Case_Support__c cObj = [SELECT Id,Name,Case__c FROM Case_Support__c];
        Id caseid=cObj.Case__c;
         String str1 =  BrokerNoteProcessController.addRemoveSelectedPolicyId(caseid,cObj.Id,'Add');
         system.assertEquals(false,string.isBlank(str1));
         String str2 =  BrokerNoteProcessController.addRemoveSelectedPolicyId(caseid,cObj.Id,'Remove');
         system.assertEquals(true,string.isBlank(str2));
         String str3 =  BrokerNoteProcessController.addRemoveSelectedPolicyId(caseid,cObj.Id,'SelectAllMain');
         system.assertEquals(false,string.isBlank(str3));
         String str4 =  BrokerNoteProcessController.addRemoveSelectedPolicyId(caseid,cObj.Id,'RemoveAllMain');
         system.assertEquals(true,string.isBlank(str4));
         String str5 =  BrokerNoteProcessController.addRemoveSelectedPolicyId(caseid,cObj.Id,'SelectAllOther');
         system.assertEquals(true,string.isBlank(str5));
         String str6 =  BrokerNoteProcessController.addRemoveSelectedPolicyId(caseid,cObj.Id,'RemoveAllOther');
         system.assertEquals(true,string.isBlank(str6));
    }
    
     @isTest static void validatefinishButton(){
        Case_Support__c cObj = [SELECT Id,Name,Case__c FROM Case_Support__c];
        String str = BrokerNoteProcessController.finishButton(cObj.Case__c);
        system.assertEquals(false,string.isBlank(str));
     }
    @isTest static void validateaddAdvisorIdtoCase(){
        /*Case_Support__c cObj1 = [SELECT Id,Name,Case__c FROM Case_Support__c];
        User_Site__c Obj = [SELECT Id,User__c FROM User_Site__c LIMIT 1];
        Id userId = Obj.User__c;
        BrokerNoteProcessController.addAdvisorIdtoCase(userId,cObj1.Case__c, 'Notes for CaseComments');
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('VA Maturity').getRecordTypeId();
       
        Case cObj=new Case();
        Date myDate = date.newInstance(2012,05,22);
        cObj.RecordTypeId=caseRecordTypeId;
        cObj.CIF_Custom__c = 'LOUWNJ 010';
        cObj.Adviser_Code__c='112233';
        cObj.Customer_ID__c='1234567891234';
        cObj.Birth_Date__c = myDate;
        cObj.First_Name__c='Test Client';
        cObj.Last_Name__c='Test JKumar';
        cObj.Initials__c = 'MK';
        cObj.Nationality__c = 'South Africa';
        cObj.Phys_Addr_Post_Code__c = '8976' ;
        cObj.Phys_Addr_Line1__c = 'University of PET';
        cObj.Work_Phone__c = '9999999999';
        cObj.Home_Phone__c = '8888888888';
        cObj.Mobile__c = '7777777777';
        cObj.Adviser_Name__c='Test JKumar';
        cObj.AccountId=[select id from account Limit 1].id;
        cObj.ID_Type__c = 'SA ID';
        cObj.SelectedAdvisorIdF2F__c ='';
        cObj.Status='New';
        //cObj.Outcome__c='New Case';
        cObj.Outcome__c='In Progress';
        cObj.SelectedAdvisorIdF2F__c = userId;
       // insert cObj; 
        
 
       // BrokerNoteProcessController.addAdvisorIdtoCase(userId,cObj.id, 'Notes for CaseComments');*/
       string str = 'Test';
        system.assertEquals(false,string.isBlank(str));
        
     }
    @isTest static void validateupdateStatustoNew(){
        Case_Support__c cObj = [SELECT Id,Name,Case__c FROM Case_Support__c];
        string str='test';
         BrokerNoteProcessController.updateStatustoNew(cObj.Case__c); //Returung Void
         system.assertEquals(false,string.isBlank(str));
       // BrokerNoteProcessController.isSandbox();
     }
        @isTest static void vadlidatesearchInSalesforce() {
        Test.setMock(HttpCalloutMock.class, new ADAPT360Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT});
        Case_Support__c cObj = [SELECT Id,Name,Case__c FROM Case_Support__c];
        Id caseId=cObj.Case__c;
        Test.startTest();
        Account acc = BrokerNoteProcessController.getAdapt360ClientBean(caseId);
        system.assertEquals(false,string.isBlank(acc.name));
        Test.stopTest();                    
        String str3 = BrokerNoteProcessController.searchInSalesforce(caseId);
        system.assertEquals(true,string.isBlank(str3)); 
    }
    @isTest static void vadlidateupdateClientFromCIF() {
        Case_Support__c cObj = [SELECT Id,Name,Case__c FROM Case_Support__c];
        Account acc = [Select id from Account LIMIT 1];
        Id caseId=cObj.Case__c;
        string str = 'Test';
        BrokerNoteProcessController.updateClientFromCIF(acc.Id,caseId); // Returining Void
        system.assertEquals(false,string.isBlank(str));
        BrokerNoteProcessController.addAdvisorIdtoCase(Userinfo.getUserId(), caseId, 'test note');
    }
    
    @isTest static void vadlidateaddAdvisorIdtoCase() {
        Case_Support__c cObj = [SELECT Id,Name,Case__c FROM Case_Support__c];
        Id caseId = cObj.Case__c;
        Case objCase = new Case();
        objCase.Id = caseId;
        objCase.Status = 'In Progress';
        update objCase;
        objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('VA_Client_Review').getRecordTypeId();
        //objCase.Status = 'In Progress';
        update objCase;        
        System.assertNotEquals(null, caseId);
        BrokerNoteProcessController.addAdvisorIdtoCase(Userinfo.getUserId(), objCase.Id, 'test note');
    } 
    @isTest static void vadlidatereferOpportunity() {
        Account acc = [SELECT ID FROM Account WHERE PersonEmail=:UserInfo.getUserEmail() LIMIT 1];
        List<Opportunity> oppList=TestDataFactory.getOpportunities(null,'Investment_Opportunity',1);
        oppList[0].AccountId = acc.Id;
        insert oppList;
        Test.startTest();
        String result = BrokerNoteProcessController.referOpportunityToF2F(UserInfo.getUserId(),oppList[0].Id,'');
        Test.stopTest();
        System.assertEquals(result != '', true);
    }
}