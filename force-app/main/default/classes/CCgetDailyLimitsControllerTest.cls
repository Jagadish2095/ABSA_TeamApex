/*
Controller Test Class For CCgetDailyLimitsController Controller class
*
* @author  Muvhuso Nekhubvi : Absa
* @version v1.0
* @since   2019-10-31
*/

@isTest
public class CCgetDailyLimitsControllerTest {
    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
    }
    
     @isTest 
    public static void testGetaccountDetails(){
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        
        
    }
    @isTest 
    public static void testGetaccountDetailsA1(){
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        // Set mock callout class 
        //Test.setMock(HttpCalloutMock.class, new CAgetAccountDetails_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CA_GET_ACCOUNT_DETAILS});
        
        
        
        //make dummy response of CI get Acct Linked
        String getLinkedAccountResp ='{ 	"nbsapdpo": { 		"version": "", 		"returnCode": "0", 		"reasonCode": "0", 		"serviceVersion": "BUSO002", 		"echoKey": "" 	}, 	"nbsmsgo3": { 		"version": "MSG3001", 		"sysErrTxt": "", 		"nbrUserMsgs": "0", 		"nbrUserErrs": "0" 	}, 	"cip047o": { 		"counter": "22", 		"orestart": "", 		"outputTable": [{ 			"oaccntnbr": "00000003001390647", 			"product": "PLOAN", 			"productType": "PL", 			"branch": "8007", 			"corp": "ABS", 			"status": "CURRENT", 			"dtclosed  ": "", 			"balance": "-3326.22", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5  ": "" 		}, { 			"oaccntnbr": "00000004047955012", 			"product": "ISLMSAV", 			"productType": "SA", 			"branch": "8198", 			"corp": "ABS", 			"status": "OPEN-POR", 			"dtclosed": "", 			"balance": "6198.63", 			"limit": "+0000000000000  00.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "6148.63", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006440702949", 			"pro  duct": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440702957", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440704488", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440704925", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440738407", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "APR 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440738465", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "APR 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440821789", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "SEP 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440832380", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "IN FORCE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"s  rcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006624841062", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "4550270023487015", 			"product": "DUL", 			"productType": "CA", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "4550270023487015", 			"pro  duct": "", 			"productType": "CA", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006625152115", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "  LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOf  Fnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006626363313", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"  limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntn  br": "00000006627548566", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000  000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006628871544", 			"product": "", 			"productType": "  LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006628882129", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"  dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "  ", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000009051037423", 			"product": "FLEXI", 			"productType": "SA", 			"branch": "8198", 			"corp": "ABS", 			"status": "OPEN", 			"dtclosed": "", 			"balance": "8775.12", 			"limit": "+000000  000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "8725.12", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "0445143000004041  5", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "04483850000071015", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp  ": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"  srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "05359690000019061", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "000000040479550  12", 			"product": "PBANKCQ", 			"productType": "CQ", 			"branch": "8198", 			"corp": "ABS", 			"status": "CLS PORT", 			"dtclosed": "FEB 19", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}] 	} }';
        CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = new CIgetAcctLinkedToClientCode_Resp_IB_v1();
        CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBeanContent = (CIgetAcctLinkedToClientCode_Resp_IB_v1)responseBean.deserialize(getLinkedAccountResp, CIgetAcctLinkedToClientCode_Resp_IB_v1.class);
        
        responseBeanContent.status = 'OK';
        responseBeanContent.statusCode = 200;
        responseBeanContent.message = '';
        Sys_Log_Integration__c log = new Sys_Log_Integration__c();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        log = SystemLogger.mapResponseFields(log,responseBeanContent.statusCode ,  responseBeanContent.status,getLinkedAccountResp );
        logList.add(log);     
        
        Map<string,CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accNoMapToReponseWrapper = new  Map<string,CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();//Store all account details to client
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accDetailsList = responseBeanContent.cip047o.outputTable;
        String combiAccountNumber;
        for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accDetailsList){
            
            if(accWrObj.productType =='CO' && accWrObj.status =='ACTIVE' ){ // ADD CONDITION FOR STATUS
                accNoMapToReponseWrapper.put(accWrObj.oaccntnbr,accWrObj);
                combiAccountNumber = accWrObj.oaccntnbr;
                
                
            }
        }   
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CCgetDailyLimits_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CC_GET_DAILY_LIMITS});
        Test.startTest();
        
        String response = CCgetDailyLimitsController.getDailyLimits(combiAccountNumber);
       
        
        String responseTest = CCgetDailyLimitsController.updateDailyLimits('0', '0', '0', '0', combiAccountNumber, '10', '10', '10', '10', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1');
        
        Test.stopTest();
        
        
    } 
    
    @isTest 
    public static void testSendEmail(){
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();
         Account account = [SELECT Id FROM Account LIMIT 1];
         EmailTemplate eTemplate = [SELECT Id, Name FROM EmailTemplate LIMIT 1];
         Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud', Email_From_Address__c = 'test@ret.com', Email__c = 'test@ret.com', Incident_Date__c = System.Today(),
                                RecordTypeId = caseRecordTypeId, Approval_Status__c = 'Approved', SLA_Extension_Approval__c = 'Approved', Expectation_of_the_Customer__c = 'Testing',
                                Awaiting_Status__c = 'Awaiting Customer Documents', SLA_Extension_Reason__c = 'This is for testing',
                                SLA_Extension_Approval_Required__c = true, Deadlock_Reason_Motivation__c = 'Sample test', Subject = 'Test', Description ='Test',
                                Deadlock_Approval_Required__c = true, sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback', Type__c = 'Test', sd_Email_Template_Case_Classification__c = eTemplate.Name);
         insert caseRec;
        Id caseRecordId = caseRec.Id;     
        String emailAddress = 'muvhuso.nekhubvi@absa.africa'; 
        String mobileNumber='0987654321';
        String commMethod='Email';
        caseRec.Out_Of_SLA_Comments__c = 'Testt';
        caseRec.SLA_Pause_Flag__c = true;  
        update caseRec;
        
       
        
        List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
        insert caseList;
         CCgetDailyLimitsController.sendEmailNotifications(caseRecordId, emailAddress, mobileNumber, commMethod);
        

    }

    
}