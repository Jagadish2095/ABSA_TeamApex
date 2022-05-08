@isTest
public class SVcreateLnkSavinsNoticeDepAcountV6Test {
 public static final String POSITIVE_RESPONSE_BODY = '{"headers":{"X-Backside-Transport":["OK OK"],"Connection":["Keep-Alive"],"Transfer-Encoding":["chunked"],"X-Powered-By":["Servlet/3.1"],"Content-Type":["application/json; charset=UTF-8"],"Content-Language":["en-US"],"Date":["Mon, 07 Dec 2020 10:13:34 GMT"],"Expires":["Thu, 01 Dec 1994 16:00:00 GMT"],"Cache-Control":["no-cache=\"set-cookie, set-cookie2\""],"X-Global-Transaction-ID":["1cf73a895fce004ec67f67ad"],"Access-Control-Expose-Headers":["APIm-Debug-Trans-Id, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-Global-Transaction-ID"],"Access-Control-Allow-Origin":["*"],"Access-Control-Allow-Methods":["POST"],"Set-Cookie":["LtpaToken2=\"\"; Expires=Thu, 01 Dec 1994 16:00:00 GMT; Path=/; Secure; HttpOnly","LtpaToken2=Qq0mFXVDnbh6/7BhhI1hjCV3+KnusyxFT6nT9aNiNwPjXvFB1HEeJTvzVTRRGtOqD4pg1f1xn1eJiWYxrydSiazSk+XWFqmvcCr8xvqefLZMQoxOHYt5dgUVHzo8YnsmiB3hqow3mU5/izpXvJtFzYboBgQVqsj0IUH2jlvPhsNKutTVe1aCuPnHyAIqvsVx0eDEuFpEUxyrFQGGAbrub8cASWpcAllj6vAV/A1FeIA0H6fBxopcWkj97uAodN0BMMtD+GZhCUN7jUaO4pbcVJXtEPhprfJnq8rJm7PzNs2xPwHw8Ah9x3W3JUuD+MuV; Path=/; HttpOnly"],"X-RateLimit-Limit":["name=100 Per Minute,100;"],"X-RateLimit-Remaining":["name=100 Per Minute,99;"]},"body":{"CIB003O":{"CIcreateClientV22Response":{"outputClientKey":""}},"NBSAPDPO":{"nbsapdpo":{"serviceVersion":"BUSO022","returnCode":0,"reasonCode":0,"version":""}},"NBSMSGO3":{"nbsmsgo3":{"sysErrTxt":"","nbrUserErrs":1,"nbrUserMsgs":1,"version":"","msgEntry":[{"msgClass":"","msgTxt":"DUPLICATE PROFILE EXITS","msgErrInd":"Y","msgCode":"0163"},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""},{"msgClass":"","msgTxt":"","msgErrInd":"","msgCode":""}]}}}';

    @TestSetup 
    static void makeData(){
        
                String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
        User au = new User(
            Alias = 'standt',
            Email = aemail,
            EmailEncodingKey = 'UTF-8',
            LastName = 'UserAdmin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ap.Id,
            TimeZoneSidKey = 'Africa/Johannesburg',
            UserName = auniqueUserName,
            MobilePhone = '0823389021',
            Advisor_Code__c = '112233'
        );
        insert au;
    }
    
    
    @isTest 
 static void createSavingsAccountTest() {          
     
       SVcreateLinkSavingsDepAccount_Req_IB_v2 requestBean = new SVcreateLinkSavingsDepAccount_Req_IB_v2();
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsapdpi nbsapdpi = new SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsapdpi();
        nbsapdpi.application = 'SF';
        nbsapdpi.channel = 'SF';
        nbsapdpi.trace = 'N';
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.finalMsgId msgIdClsObj = new SVcreateLinkSavingsDepAccount_Req_IB_v2.finalMsgId();
        msgIdClsObj.finalMsgClass = '';
        msgIdClsObj.finalMsgCode = '';
        system.debug('test 3');
        SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsmsgi nbsmsgi = new SVcreateLinkSavingsDepAccount_Req_IB_v2.nbsmsgi();
        nbsmsgi.finalMsgId = msgIdClsObj;
        nbsmsgi.msgLanguage = 'E';
        nbsmsgi.msgTarget = 'SF';
        
        SVcreateLinkSavingsDepAccount_Req_IB_v2.svpp15i svpp15i = new SVcreateLinkSavingsDepAccount_Req_IB_v2.svpp15i();
        svpp15i.marketersCode = '5035555';
        svpp15i.agencyCode = '0';
        
        svpp15i.effectiveDate = ('' + system.today()).substring(0, 10).replace('-', '');
        
        svpp15i.tellerCode =  '8474' ;
        svpp15i.versionNbr = '0';
        svpp15i.supervisorCode = '0';
        
        svpp15i.productCode = '090060';
        svpp15i.noticePeriod = '1';
        svpp15i.brandCode = 'ABS';
        
        svpp15i.withdrwlPerc = '5';
        svpp15i.tranSiteType = '034';
        svpp15i.channelInd = 'E';
        
        svpp15i.tranSiteCode = '8474';
        svpp15i.srcOfFnds1 = '';//sourceOfFunds;
        svpp15i.acctSiteType = '';
        svpp15i.srcOfFnds2 = '';
        
        svpp15i.acctSiteCode =  '';
        svpp15i.srcOfFnds3 = '';
        svpp15i.clientCode = '';
        svpp15i.srcOfFnds4 = '';
        
        svpp15i.rateOption =  '';
        svpp15i.crpCode = 'ABS';
        
        svpp15i.investTerm = '12';
        svpp15i.freqCode = '0';
        svpp15i.investAmount = '0';
        svpp15i.rbaEddRating = 'M';
        svpp15i.srcOfFnds5 = '';
        
        
        requestBean.SVcreateLinkSavingsNoticeDepAccountV6 = new SVcreateLinkSavingsDepAccount_Req_IB_v2.SVcreateLinkSavingsNoticeDepAccountV6();
        requestBean.SVcreateLinkSavingsNoticeDepAccountV6.nbsapdpi = nbsapdpi;
        requestBean.SVcreateLinkSavingsNoticeDepAccountV6.nbsmsgi = nbsmsgi;
        requestBean.SVcreateLinkSavingsNoticeDepAccountV6.svpp15i = svpp15i;
     
    /*  User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }*/
     
     Account mainacc = new Account(Name = 'TheStokvel', Phone = '0840404898', CIF__c = 'SEBENZA037',
                                      CASA_Reference_Number__c= '121229158',  Client_Group__c='Non Individual', Number_of_Participants__c = 2 );
        insert mainacc;
        
        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;
        
        Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings',ProductCode='09050');
        insert savingsprod; 
        
        PricebookEntry savingsPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
        insert savingsPrice;
        
        Sales_Process_Type__c salesProcess = new Sales_Process_Type__c();
        salesProcess.Request_Name__c = 'CAF Application';
        salesProcess.Name = 'CAF Application';
        salesProcess.Opportunity_Record_Type__c = 'CAF Application';
        insert salesProcess;
        
        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'TestCVSServicesHelper';
        account.LastName = 'Tester';
        account.Gender__pc = 'Male';
        account.Next_of_Kin_Last_Name__pc = 'Testing';
        account.Next_of_Kin_First_Name_s__pc = 'Testing';
        
        account.CIF__c='LTD 933';
        account.Language__c='english';
        account.Number_Of_Dependents__c=0;
        account.PersonEmail='test@absa.africa';
        account.PersonMobilePhone='0819908786';
        account.ID_Type__pc='PASSPORT';
        account.Nationality__pc='ZIM';
        account.Highest_Qualification__pc='Matric';
        account.Residential_Status__pc='Owner';
        account.Marital_Status__pc='MARRIED';
        account.CASA_Risk_Status__c = 'High';
        insert account;
        
        site__c siteRec=new site__c();
        siteRec.Site_Code__c='1334';
        siteRec.Name='Test';
        insert siteRec;   
        
        Opportunity savingsOpportunity = new Opportunity();
        savingsOpportunity.Name = 'Test Savings Onboarding';
        savingsOpportunity.CloseDate = Date.today();
        savingsOpportunity.StageName = 'New';
        savingsOpportunity.Pricebook2Id=pb.id;
        savingsOpportunity.AccountId=account.id;
        savingsOpportunity.Site__c=siteRec.id;
        savingsOpportunity.CBPIndicator__c = '123456789';
        insert savingsOpportunity;
        
        OpportunityLineItem savingsLineItem = new OpportunityLineItem();
        savingsLineItem.OpportunityId = savingsOpportunity.id;
        savingsLineItem.Product2Id = savingsprod.id;
        savingsLineItem.PricebookEntryId = savingsPrice.id;
        savingsLineItem.Quantity = 1;
        savingsLineItem.TotalPrice = 100;
       //savingsLineItem.Policy_Number__c='9051159122';
        insert savingsLineItem;
        
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233'
		);
		insert au;
        System.runAs(au) {     
        Test.startTest();
        Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        SVcreateLinkSavingsNoticeDepAccountV6 createAndLinkService = new SVcreateLinkSavingsNoticeDepAccountV6();
         SVcreateLinkSavingsDepAccount_Resp_IB_v2 responseBean = createAndLinkService.createSavingsAccount(requestBean);
        //System.assert(opportunity.size() =>0, 'Fail to query opportunity');
        System.assert(requestBean !=null, 'SUCCESS');
        Test.stopTest();
        }
}
}