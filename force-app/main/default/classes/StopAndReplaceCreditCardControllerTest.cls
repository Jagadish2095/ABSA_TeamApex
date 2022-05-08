/*
Controller Test Class For StopAndReplaceCard Controller class
*
* @author  Madhava Palla : Absa
* @version v1.0
* @since   2019-10-31
*/

@isTest
public class StopAndReplaceCreditCardControllerTest {
    
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
        
        
        Test.startTest();
        String responseBean = StopAndReplaceCreditCardController.getCardDetails(accountList[0].Id);
        system.assertNotEquals(null, responseBean, 'Assert Failed');
        Test.stopTest();
    }
    @isTest 
    public static void testGetaccountDetailsA1(){
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CAgetAccountDetails_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CA_GET_ACCOUNT_DETAILS});
        
        
        
        //make dummy response of CI get Acct Linked
        String getLinkedAccountResp ='{ 	"nbsapdpo": { 		"version": "", 		"returnCode": "0", 		"reasonCode": "0", 		"serviceVersion": "BUSO002", 		"echoKey": "" 	}, 	"nbsmsgo3": { 		"version": "MSG3001", 		"sysErrTxt": "", 		"nbrUserMsgs": "0", 		"nbrUserErrs": "0" 	}, 	"cip047o": { 		"counter": "22", 		"orestart": "", 		"outputTable": [{ 			"oaccntnbr": "00000003001390647", 			"product": "PLOAN", 			"productType": "PL", 			"branch": "8007", 			"corp": "ABS", 			"status": "CURRENT", 			"dtclosed  ": "", 			"balance": "-3326.22", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5  ": "" 		}, { 			"oaccntnbr": "00000004047955012", 			"product": "ISLMSAV", 			"productType": "SA", 			"branch": "8198", 			"corp": "ABS", 			"status": "OPEN-POR", 			"dtclosed": "", 			"balance": "6198.63", 			"limit": "+0000000000000  00.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "6148.63", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006440702949", 			"pro  duct": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440702957", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440704488", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440704925", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "NOV 17", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440738407", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "APR 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440738465", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "APR 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440821789", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "LAPSED", 			"dtclosed": "SEP 18", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"  oaccntnbr": "00000006440832380", 			"product": "LIFE", 			"productType": "LI", 			"branch": "9960", 			"corp": "LTI", 			"status": "IN FORCE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"s  rcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006624841062", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "4550270023487015", 			"product": "DUL", 			"productType": "CA", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "4550270023487015", 			"pro  duct": "", 			"productType": "CA", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006625152115", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "  LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOf  Fnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006626363313", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"  limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntn  br": "00000006627548566", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000  000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006628871544", 			"product": "", 			"productType": "  LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000006628882129", 			"product": "", 			"productType": "LX", 			"branch": "9960", 			"corp": "LTI", 			"status": "ACTIVE", 			"  dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "000000000000", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "  ", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "00000009051037423", 			"product": "FLEXI", 			"productType": "SA", 			"branch": "8198", 			"corp": "ABS", 			"status": "OPEN", 			"dtclosed": "", 			"balance": "8775.12", 			"limit": "+000000  000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "8725.12", 			"srcOfFnds1": "20", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "0445143000004041  5", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableB  alance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "04483850000071015", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp  ": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"  srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "05359690000019061", 			"product": "COMBI", 			"productType": "CO", 			"branch": "8198", 			"corp": "ABS", 			"status": "ACTIVE", 			"dtclosed": "", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}, { 			"oaccntnbr": "000000040479550  12", 			"product": "PBANKCQ", 			"productType": "CQ", 			"branch": "8198", 			"corp": "ABS", 			"status": "CLS PORT", 			"dtclosed": "FEB 19", 			"balance": "0", 			"limit": "+000000000000000.00", 			"balanceTxt": "", 			"detail": "", 			"availableBalance": "0", 			"srcOfFnds1": "", 			"srcOfFnds2": "", 			"srcOfFnds3": "", 			"srcOfFnds4": "", 			"srcOfFnds5": "" 		}] 	} }';
        CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = new CIgetAcctLinkedToClientCode_Resp_IB_v1();
        CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBeanContent = (CIgetAcctLinkedToClientCode_Resp_IB_v1)responseBean.deserialize(getLinkedAccountResp, CIgetAcctLinkedToClientCode_Resp_IB_v1.class);
        CAgetAccountDetails_Resp_IB_v1.dummyResponse();
        responseBeanContent.status = 'OK';
        responseBeanContent.statusCode = 200;
        responseBeanContent.message = '';
        Sys_Log_Integration__c log = new Sys_Log_Integration__c();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        log = SystemLogger.mapResponseFields(log,responseBeanContent.statusCode ,  responseBeanContent.status,getLinkedAccountResp );
        logList.add(log);     
        
        Map<string,CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accNoMapToReponseWrapper = new  Map<string,CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();//Store all account details to client
        List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accDetailsList = responseBeanContent.cip047o.outputTable;
        
        for(CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj: accDetailsList){
            
            if(accWrObj.productType =='CA' && accWrObj.status =='ACTIVE' ){ // ADD CONDITION FOR STATUS
                accNoMapToReponseWrapper.put(accWrObj.oaccntnbr,accWrObj);
            }
        }   
        
        
        //make translations
        List<Integration_Translation__c> itr = new  List<Integration_Translation__c>();
        Integration_Translation__c StopReplaceCard = new Integration_Translation__c();
        StopReplaceCard.System_Name__c='StopReplaceCard';
        StopReplaceCard.Value_Type__c='Reason';
        StopReplaceCard.Internal_Value__c = 'Reason';
        StopReplaceCard.External_Value__c = 'Reason';
        StopReplaceCard.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        itr.add(StopReplaceCard);
        
        Integration_Translation__c StopReplaceCard1 = new Integration_Translation__c();
        StopReplaceCard1.System_Name__c='StopReplaceCard';
        StopReplaceCard1.Value_Type__c='Circumstances';
        StopReplaceCard1.Internal_Value__c = 'Circumstances';
        StopReplaceCard1.External_Value__c = 'Circumstances';
        StopReplaceCard1.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        itr.add(StopReplaceCard1);
        
        Integration_Translation__c StopReplaceCard2 = new Integration_Translation__c();
        StopReplaceCard2.System_Name__c='StopReplaceCard';
        StopReplaceCard2.Value_Type__c='Delivery Method';
        StopReplaceCard2.Internal_Value__c = 'Delivery Method';
        StopReplaceCard2.External_Value__c = 'Delivery Method';
        StopReplaceCard2.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        
        itr.add(StopReplaceCard2);
        
        insert itr;
        
        Test.startTest();
        Map<String,List<StopaAndReplaceCardsWrapper>> replaceMap =  StopAndReplaceCreditCardController.callGetAccountDetailsService(accNoMapToReponseWrapper,logList);
        system.assertNotEquals(null, replaceMap);
        
        
        
        StopAndReplaceCreditCardController.getCardCircumstances();
        StopAndReplaceCreditCardController.getCardReasons();
        StopAndReplaceCreditCardController.getDeliveryMethods();
        StopAndReplaceCreditCardController.getStopServiceWrapper();
        
        Test.stopTest();
    } 
    @isTest 
    public static void testMakeCallOut(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CAstpLostStolenCardV2Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CA_STP_LOSTSTOLENCARD_V2});
        
        
        String jsonString = '{"whereLs":"qwer","visaFrdRsn":"","trace":"Y","tmsLs":"1","tellernr":"999999","sof5":"","sof4":"","sof3":"","sof2":"","sof1":"","siteCd":"12345","scnAction":"ADD","pxiStatOld":"AAA","pxiStatNew":"L0P","plasticNbr":"4550270023487023","pinIsSafeInd":"Y","phnNbrPer":"1234567890","phnNbrBus":"0987654321","operatorId":"BDP","msgTarget":"STD","msgLanguage":"E","mciFrdTyp":"","lsTmOfLoss":"0","lsRptRsnCd":"LST","lsRptdBy":"CLNT","lsPlLstUsed":"qwer","lsNbrCrdsMiss":"1","lsHowRptdCd":"PHN","lsDtLstUsed":"20191101","lsDt":"20191101","howLostLn1":"qwert","distSiteCd":"8114","distReasCd":"CB","crdRep":"N","crdIsSgndInd":"Y","circCd":"CPU","channel":"Salesforce","axiXfrRsn":"LST","axiXfrEffDt":"20191101","axiFrdCd":"","application":"Salesforce","advcNoUseInd":"Y"}';
        Test.startTest();
        
         //make translations
        List<Integration_Translation__c> itr = new  List<Integration_Translation__c>();
        Integration_Translation__c StopReplaceCard = new Integration_Translation__c();
        StopReplaceCard.System_Name__c='StopReplaceCard';
        StopReplaceCard.Value_Type__c='Reason';
        StopReplaceCard.Internal_Value__c = 'Reason';
        StopReplaceCard.External_Value__c = 'Reason';
        StopReplaceCard.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        itr.add(StopReplaceCard);
        
        Integration_Translation__c StopReplaceCard1 = new Integration_Translation__c();
        StopReplaceCard1.System_Name__c='StopReplaceCard';
        StopReplaceCard1.Value_Type__c='Circumstances';
        StopReplaceCard1.Internal_Value__c = 'Circumstances';
        StopReplaceCard1.External_Value__c = 'Circumstances';
        StopReplaceCard1.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        itr.add(StopReplaceCard1);
        
        Integration_Translation__c StopReplaceCard2 = new Integration_Translation__c();
        StopReplaceCard2.System_Name__c='StopReplaceCard';
        StopReplaceCard2.Value_Type__c='Delivery Method';
        StopReplaceCard2.Internal_Value__c = 'Delivery Method';
        StopReplaceCard2.External_Value__c = 'Delivery Method';
        StopReplaceCard2.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        
        itr.add(StopReplaceCard2);
        
        insert itr;
        
        CAstpLostStolenCardV2_Req_IB_v5.createDummyRequest();
        CAstpLostStolenCardV2_Resp_IB_v5.dummyResponse();
       StopAndReplaceCardsServiceWrapper wrapper = StopAndReplaceCardsServiceWrapper.dummyWrapper();
       CAstpLostStolenCardV2_IU_v5.mapRequestFields(wrapper);
       StopaAndReplaceCardsWrapper.dummyWrapperResponse();
        String responseBean = StopAndReplaceCreditCardController.makeStopCardsCallOut(jsonString);
        system.assertNotEquals(null, responseBean);
        Test.stopTest();
    }
     @isTest 
    public static void testMakeCallOutWithOutIntigrationSetting(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CAstpLostStolenCardV2Mock_ApiRest(StringConstants.POSITIVE_STRING)); 
       // IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CA_STP_LOSTSTOLENCARD_V2});
        
        
        String jsonString = '{"whereLs":"qwer","visaFrdRsn":"","trace":"Y","tmsLs":"1","tellernr":"999999","sof5":"","sof4":"","sof3":"","sof2":"","sof1":"","siteCd":"12345","scnAction":"ADD","pxiStatOld":"AAA","pxiStatNew":"L0P","plasticNbr":"4550270023487023","pinIsSafeInd":"Y","phnNbrPer":"1234567890","phnNbrBus":"0987654321","operatorId":"BDP","msgTarget":"STD","msgLanguage":"E","mciFrdTyp":"","lsTmOfLoss":"0","lsRptRsnCd":"LST","lsRptdBy":"CLNT","lsPlLstUsed":"qwer","lsNbrCrdsMiss":"1","lsHowRptdCd":"PHN","lsDtLstUsed":"20191101","lsDt":"20191101","howLostLn1":"qwert","distSiteCd":"8114","distReasCd":"CB","crdRep":"N","crdIsSgndInd":"Y","circCd":"CPU","channel":"Salesforce","axiXfrRsn":"LST","axiXfrEffDt":"20191101","axiFrdCd":"","application":"Salesforce","advcNoUseInd":"Y"}';
        Test.startTest();
        String responseBean = StopAndReplaceCreditCardController.makeStopCardsCallOut(jsonString);
        system.assertNotEquals(null, responseBean);
        Test.stopTest();
    }
    @isTest 
    public static void testSendEmail(){
        Account account = new Account(Name = 'Test Account');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;

		Service_Group__c serviceGroupRecord = new Service_Group__c(
			Name = 'AVAF Queries',
			Queue__c = 'Queue',
			Active__c = true,
			Assign_Record_Type__c = 'Service Request',
			Response_Email_Address__c = 'avafcancellation1@absa.co.za'
		);
		insert serviceGroupRecord;

		Case caseRec = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			AccountId = account.Id,
			Email__c = 'abcd@gg.com',
			recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
            Type__c = 'Service Request',
			Expectation_of_the_Customer__c = 'test',
            Out_Of_SLA_Reason__c = 'Incorrect Department',
			sd_Service_Group_Id__c = serviceGroupRecord.Id,
			Incident_Date__c = date.today()
		);
		insert caseRec;

        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId(); 
        
        //Case testCase = new Case(RecordTypeId = caseRecordTypeId, AccountId = accountList[0].Id);
        
        //insert testCase;
        
        Id caseRecordId = caseRec.Id;     
        String emailAddress = 'abcd@gg.com'; 
        String mobileNumber='0987654321';
        String commMethod='Email';
        String plasticCardNums='4550270023487015';
        
        Test.startTest();
       
           StopAndReplaceCreditCardController.sendEmailNotifications(caseRecordId,emailAddress,mobileNumber,commMethod,plasticCardNums);
           system.assertEquals(caseRecordTypeId, caseRec.RecordTypeId, 'Assert Failed');
        
        Test.stopTest();
    }
}