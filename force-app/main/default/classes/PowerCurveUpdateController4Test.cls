/**
* @description Test Class For PowerCurveUpdateController4
* @author  Himani Joshi: Absa
* @version v1.0
* @since   2020-09-15
*
*/
@IsTest
public class PowerCurveUpdateController4Test {
    /**
     * @description method to setup test data
     * @author Himani.Joshi@absa.africa | 2021-06-18 
    **/
    @testSetup
    static void createData() {
        Account account = new Account();
        account.Name = 'Absa Bank';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'SNIFFEL001';
        account.Sic = '35790';
        account.AccountNumber = '0';
        account.Registration_Number__c = '123456789';
        insert account;

        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today()+10;
        opp.AccountId = account.Id;
        //opp.Spouse_Account_Id__c=account.Id;
        insert opp;

        Group testGroup = new Group(Name = 'Credit Support Consultant', Type = 'Queue');
        insert testGroup;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }

        List<Group> groupDetail = new GroupsSelector().selectByNameSetAndType(new Set<String>{'Credit Support Consultant'},'Queue');

        Service_Group__c tstServQG = new Service_Group__c();
        tstServQG.Name = 'Financial Capture Group';
        tstServQG.Queue__c = groupDetail[0].id;
        insert tstServQG;

        Service_Type__c tstServT = new Service_Type__c();
        tstServT.name = 'check';
        insert tstServT;

        Service_Group_Type__c tstServQT = new Service_Group_Type__c();
        tstServQT.Service_type__c = tstServT.Id;
        tstServQT.Service_Group__c = tstServQG.Id;
        insert tstServQT;


        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        application.Account__c=account.id;
        insert application;


        Application_Principal__c appPrin = new Application_Principal__c();
        appPrin.Application__c = application.Id;
        appPrin.Casa_Reference__c = account.CASA_Reference_Number__c;
        appPrin.Casa_Result__c = account.CASA_Screening_Status__c;
        appPrin.CIF__c = account.CIF__c;
        appPrin.Controlling_Interest__c = 10;
        appPrin.Id_Number__c = account.Registration_Number__c;
        appPrin.Main__c = true;
        appPrin.Principal_Shareholder_Name__c = account.Name;
        insert appPrin;

        List<Application_Profile__c> appProfileList = new List<Application_Profile__c>();
        Application_Profile__c appProfile = new Application_Profile__c();
        appProfile.Applicant_Type__c = 'Main Applicant';
        appProfile.Is_Main_Applicant__c = true;
        appProfile.Client_CIF_Code__c = account.CIF__c;
        appProfile.Client_Name__c = account.Name;
        appProfile.Application__c = application.Id;
        appProfileList.add(appProfile);

        appProfile = new Application_Profile__c();
        appProfile.Applicant_Type__c = 'Principal';
        appProfile.Is_Main_Applicant__c = false;
        appProfile.Client_CIF_Code__c = account.CIF__c;
        appProfile.Client_Name__c = account.Name;
        appProfile.Application__c = application.Id;
        appProfile.Account__c = account.Id;
        appProfileList.add(appProfile);

        appProfile = new Application_Profile__c();
        appProfile.Client_CIF_Code__c = account.CIF__c;
        appProfile.Application__c=application.Id;
        appProfile.Applicant_Type__c = 'Principal';
        appProfile.Related_to_Client_ID_or_Reg_Number__c='123456789';
        appProfile.Applicant_Type__c = 'Main Applicant';
        appProfile.Client_Name__c = account.Name;
        appProfile.PCCE_Id__c='000000411196';
        appProfileList.add(appProfile);

        appProfile = new Application_Profile__c();
        appProfile.Client_CIF_Code__c = account.CIF__c;
        appProfile.Application__c=application.Id;
        appProfile.Applicant_Type__c = 'Principal';
        appProfile.Client_Name__c = account.Name;
        appProfile.Related_to_Client_ID_or_Reg_Number__c='123456789';
        appProfile.Applicant_Type__c = 'Spouse';
        appProfileList.add(appProfile);


        insert appProfileList;

        Financial_Information__c fin = new Financial_Information__c();
        fin.Account__c = account.Id;
        fin.Auditor_s_Certificate_Date__c = Date.today();
        fin.Client_Name__c = 'SEDERKRANS BOERDERY SOUTPANSBERG BK';
        fin.Date_Financials_Signed_Client__c = Date.today();
        fin.Financial_Statement_Qualified_Issue__c = 'YES';
        fin.Financial_Statement_Type__c = 'Draft';
        fin.Intangible_Assets__c = 0.00;
        fin.Land_Bank__c = 433300;
        fin.Loans_from_Associates__c = 0.00;
        fin.Loans_from_Principals_Ceded__c = 0.00;
        fin.Loans_from_Principals_Non_Ceded__c = 0.00;
        fin.Loans_to_Principals_Associates__c = 0.00;
        fin.Other_Assets__c = 0.00;
        fin.Other_Current_Assets__c = 0.00;
        fin.Other_Current_Liabilities__c = 0.00;
        fin.Other__c = 0.00;
        fin.Qualification_Comments__c = 'Comment';
        fin.Revaluation_Of_Assets__c = 0.00;
        fin.Statement_Date_Year_end__c = Date.today();
        fin.Total_Fixed_Investments_Cash_and_Market__c = 0.00;
        fin.Year_Selection__c = 'Year1';
        insert fin;

        Application_Assets_and_Liabilities__c assLiab = new Application_Assets_and_Liabilities__c();
        assLiab.Name = 'Boo hoo';
        assLiab.Application__c = application.Id;
        assLiab.Primary_Owner__c = account.Id;
        insert assLiab;
    }

    @isTest
    static void testPCO4() {
        string request = '{"Request":{"ApplicationDV":{"RequestedProducts01":{"INTPRDNEWF":{},"APPPRDSECO":{"SUPPORTINGSPECIFIC":"0","SPECIFIC":"0"},"APPPRDNEWF":{"UNIQUEPRODID":"APC-00004583","SETTLEMENTSAMNT":"0","SECUREDBYMORTGAGEBOND":"N","REQTOTALAMNT":"10000","REQTERMOFLOAN":"0","REQREQEMPOWERMNTFUNDIND":"N","REQREQEMPOWERMNTFUND":"","REQREPAYMNTOPTION":"0","REQREDUCTIONFREQ":"0","REQREDUCTIONAMNT":"0","REQPURPOSEFACILITYORLOAN":"4","REQPRODUCT":"CHQ","REQPRODTYPE":"11021","REQPRODCOMBINATIONNUM":"0","REQPAYMNTMETHOD":"D","REQONCEOFFFREQAMNT":"0","REQODLIMITTYPE":"1","REQNUMSKIPPEDPAYMNTS":"0","REQLIMITTYPEIND":"","REQLIMIT":"10000","REQINSTALLMENTFREQ":"0","REQINITIATIONFEEPAYMNTMETHOD":"D","REQFACILITYTYPE":"1","REQCREDLIFEPREMIUM":"0","REQCAMPAIGNCODE":"","REQADDITIONALAMNT":"10000","INSTSETTLEMENTS":"0","ESPINSTRUCTION":"","CARDTYPE":"","APPLICATIONSTATUS":"P"}},"INTAPPSICCODE":"41111","INTAPPOVERALLCONTROLBRANCH":"0","INTAPPEXISTINGFRANCHISORTYPE":"","INTAPPEXISTINGFRANCHISEFINANCING":"N","INTAPPENTERPRDEVFUNDEXISTING":"DBSOUTH001","INTAPPBUSINESSSUBSEGMENT":"","INTAPPBUSINESSSEGMENT":"","INTAPPBRANCHCODE":"8392","ExistingProducts01":{"INTPRDSECE":{"SPECASVLIMITED":"0","SPECASVFULL":"0"},"INTPRDEXST":{"SECUREDBYMORTGAGEBOND":"N","PRODUCTTYPE":"11021","PRODUCT":"CHQ","NCAMAXINITFEEAMNT":"0","ESPINSTRUCTION":"","CURRSUBPRODTYPE":"","CURRSETTLEMENTAMNT":"0","CURRREDUCTIONFREQ":"0","CURRREDUCTIONAMNT":"0","CURRONCEOFFREDUCTION":"0","CURRLIMIT":"0","CURRINTRATEPRIMEOFFSET":"6.00","CURRINSTALMNTFREQ":"0","CURRINSTALLMENT":"0","CURRINITFEEPREVDEBITED":"","CURREXISTEMPOWERMNTFUNDIND":"N","CURREXISTEMPOWERMNTFUND":"","CURRENFORCEDREDLIM":"N","CURRBALANCE":"0","CARDTYPE":"","ACCOUNTNUMBER":"4048460545"},"APPPRDEXST":{"REQTOTALAMNT":"0","REQTERMOFLOAN":"0","REQSUBPRODTYPE":"","REQREQEMPOWERMNTFUNDIND":"N","REQREQEMPOWERMNTFUND":"","REQREPAYMNTOPTION":"0","REQREDUCTIONFREQ":"0","REQREDUCTIONAMNT":"0","REQPURPOSEFACILITYORLOAN":"0","REQPRODTYPE":"11021","REQPRODCOMBINATIONNUM":"0","REQPAYMNTMETHOD":"","REQONCEOFFFREQAMNT":"0","REQODLIMITTYPE":"1","REQNUMSKIPPEDPAYMNTS":"0","REQLIMITTYPEIND":"0","REQINSTALLMENTFREQ":"0","REQINITIATIONFEEPAYMNTMETHOD":"D","REQFACILITYTYPE":"3","REQCREDLIFEPREMIUM":"0","REQCAMPAIGNCODE":"","REQADDITIONALAMNT":"0","INITIATIONFEEPAYMNTMETHOD":"","APPLICATIONSTATUS":"P"}},"Entity06":{"INTENTUNDERJUDICIALMNGMNT":"","INTENTUNDERDEBTCOUNSELLING":"","INTENTTRID":{},"INTENTRDET":{},"INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"","INTENTNUMPARTICIPANTS1":"","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{},"INTENTINST":{"ML":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFINANCIALCRIMEHOLD":"","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{},"INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"","INTENTCLIENTCODE2":"","INTENTCLIENTCODE1":"","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{"COMMINPREGNUMBER":""},"INTENTARRS":{"ML":"0","ASSETFINANCE":"0"},"APPENTSHAREHOLDINGPERC":"0","APPENTMNTHSSHAREHOLDINGPERC":"0","APPENTINTENTIONTOINSOLVENCY":"N","APPENTIDTYPE":"","APPENTEXPO":{},"APPENTBUR":{},"APPENTAPRF":{},"APPENTAGE":"0000"},"Entity05":{"INTENTUNDERJUDICIALMNGMNT":"","INTENTUNDERDEBTCOUNSELLING":"","INTENTTRID":{},"INTENTRDET":{},"INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"","INTENTNUMPARTICIPANTS1":"","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{},"INTENTINST":{"ML":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFINANCIALCRIMEHOLD":"","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{},"INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"","INTENTCLIENTCODE2":"","INTENTCLIENTCODE1":"","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{"COMMINPREGNUMBER":""},"INTENTARRS":{"ML":"0","ASSETFINANCE":"0"},"APPENTSHAREHOLDINGPERC":"0","APPENTMNTHSSHAREHOLDINGPERC":"0","APPENTINTENTIONTOINSOLVENCY":"N","APPENTIDTYPE":"","APPENTEXPO":{},"APPENTBUR":{},"APPENTAPRF":{},"APPENTAGE":"0000"},"Entity04":{"INTENTWRSTRISKGRADE":"0","INTENTUNDERJUDICIALMNGMNT":"","INTENTUNDERDEBTCOUNSELLING":"","INTENTTRID":{"TOTSAVRETPAYMNTSL6M":"","TOTCHEQRETPAYMNTSL6M":"","NUMRDEVENTSSAVL6M":"0","NUMRDEVENTSSAVL3M":"0","NUMRDEVENTSCHEQL6M":"0","NUMRDEVENTSCHEQL3M":"0","NUMMNTHSEXCESSBALL6M":"0","NUMDEBITSL6M":"0","NUMDAYSDEBITINL6M":"0","NUMDAYSCREDITINL6M":"0","MNTHSOLDESTSAVACCREL":"0","MNTHSOLDESTCUSTREL":"0","MNTHSOLDESTCHACCREL":"0","MNTHSOLDESTACCREL":"0","MAXOCSCORINGMANDATE":"0","MAXCONSECDAYSINEXCESS":"0","EXPECTEDCREDTURNOVCUST":"0","EXPECTEDCREDTURNOVCHEQ":"0","EXCLUSIONTYPE":"","EXCLUSIONREASON":"","EXCLUSIONCREDITFACILITY":"","BEHAVSCOREMORTG":"0","BEHAVSCORELOANS":"0","BEHAVSCORECUSTALIGN":"0","BEHAVSCORECHEQ":"0","BEHAVSCORECC":"0","BEHAVSCOREAVAF":"0","AVGCTOL6ML12M":"0.00","AVGCTOL3ML6M":"0.00","AOL":"0","AMR":"0","AMMR":"0","AMLR":"0","ACCL":"0","ABRA":"0"},"INTENTSECE":{"SURETYSHIPIFOAPPLICANT":"0"},"INTENTRDET":{"WRSTCOLLRISKTYPE":"","WRSTARMSHOLD":"","INBUSNRESC":"","EWLLISTING":"0.0","BUSNRESCAFFECTEDPARTY":""},"INTENTPARTOFCREDITGROUP":"","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"","INTENTNUMPARTICIPANTS1":"","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"0","OTHEROC":"0","ML":"0","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTINLIQUIDATION":"","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFRAUDRISKMNGMNT":"","INTENTFINANCIALCRIMEHOLD":"","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"0","CC":"0"},"INTENTCTBALANCETERMDEPOSITS":"0","INTENTCTBALANCESAVINGS":"0","INTENTCTBALANCENOTICEDEPOSITS":"0","INTENTCTBALANCECUSTINVESTMENTS":"0","INTENTCTBALANCECHEQS":"0","INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"00101","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"","INTENTCLIENTCODE2":"","INTENTCLIENTCODE1":"WESSEJ 022","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{"COMMINPREGNUMBER":""},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"0","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRSUBURB":"Sandton","APPENTWORKADDRPCODE":"2146","APPENTWORKADDRLINE1":"15 PIET STREET","APPENTWORKADDRCITY":"Johannesburg","APPENTSHAREHOLDINGPERC":"40.00","APPENTPASSPORTNATIONALITY":"South Africa","APPENTMNTHSSHAREHOLDINGPERC":"168","APPENTINTENTIONTOINSOLVENCY":"N","APPENTIDTYPE":"01","APPENTGENDER":"M","APPENTFNST":{"TYPE_Z":"0","TURNOVER":"0","TOTALASSETTURNOVER":"0","TOTALASSETS":"0","SOLEFULLAVAILABLE":"N","SALESGROWTHPERC":"0","RETAINEDEARNINGS":"0","QUALIFIED":"0","PROJTURNOVER":"0","PROFITNET":"0","PROFITBEFORETAX":"0","PERIODOFINCSTAT":"0","OPERATINGPROFITMARGIN":"0","NETWORTH":"0","NETPROFITPERC":"0.00","LONGTERMDEBTTOEBITDA":"0","LIABTOTSTOCK":"0","LIABTOTLONGTERMDEBT":"0","LIABTOTCURRLIAB":"0","LIABSHAREHFUNDS":"0","LIABLOANTOINSIDEPARTIES":"0","LIABLOANSTOPR":"0","LIABLOANSFROMPRCEDED":"0","LIABLOANFROMOTHINSTITUTIONS":"0","ICR":"0.00","IBDTOEQUITY":"0.00","IBDTOEBITDA":"0.00","GROSSPROFITPERC":"0.00","GROSSPROFIT":"0","EBITDA":"0","CURRENTRATIO":"0.00","AVAILABLE":"N","ASSINTANGIBLES":"0","ACIDTEST":"0.00"},"APPENTEXPO":{},"APPENTBUR":{"CONSINPNATID":"123456789"},"APPENTASLB":{"TOTALPROPERTIES":"0","NOTARIALBOND":"0","NETWORTHME":"0","NETWORTHCREDIT":"0","NETWORTH":"0","DEEDSSEARCHAVAILABLE":"","AVAILABLE":"N"},"APPENTAPRF":{},"APPENTAPPLCATEGORY":"","APPENTAGEOLDESTRELATIONSHIP":"0","APPENTAGE":"6700"},"Entity03":{"INTENTWRSTRISKGRADE":"0","INTENTUNDERJUDICIALMNGMNT":"","INTENTUNDERDEBTCOUNSELLING":"","INTENTTRID":{"TOTSAVRETPAYMNTSL6M":"","TOTCHEQRETPAYMNTSL6M":"","NUMRDEVENTSSAVL6M":"0","NUMRDEVENTSSAVL3M":"0","NUMRDEVENTSCHEQL6M":"0","NUMRDEVENTSCHEQL3M":"0","NUMMNTHSEXCESSBALL6M":"0","NUMDEBITSL6M":"0","NUMDAYSDEBITINL6M":"0","NUMDAYSCREDITINL6M":"0","MNTHSOLDESTSAVACCREL":"0","MNTHSOLDESTCUSTREL":"0","MNTHSOLDESTCHACCREL":"0","MNTHSOLDESTACCREL":"0","MAXOCSCORINGMANDATE":"0","MAXCONSECDAYSINEXCESS":"0","EXPECTEDCREDTURNOVCUST":"0","EXPECTEDCREDTURNOVCHEQ":"0","EXCLUSIONTYPE":"","EXCLUSIONREASON":"","EXCLUSIONCREDITFACILITY":"","BEHAVSCOREMORTG":"0","BEHAVSCORELOANS":"0","BEHAVSCORECUSTALIGN":"0","BEHAVSCORECHEQ":"0","BEHAVSCORECC":"0","BEHAVSCOREAVAF":"0","AVGCTOL6ML12M":"0.00","AVGCTOL3ML6M":"0.00","AOL":"0","AMR":"0","AMMR":"0","AMLR":"0","ACCL":"0","ABRA":"0"},"INTENTSECE":{"SURETYSHIPIFOAPPLICANT":"0"},"INTENTRDET":{"WRSTCOLLRISKTYPE":"","WRSTARMSHOLD":"","INBUSNRESC":"","EWLLISTING":"0.0","BUSNRESCAFFECTEDPARTY":""},"INTENTPARTOFCREDITGROUP":"","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"","INTENTNUMPARTICIPANTS1":"","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{},"INTENTINST":{"ML":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTINLIQUIDATION":"","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFRAUDRISKMNGMNT":"","INTENTFINANCIALCRIMEHOLD":"","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{},"INTENTCTBALANCETERMDEPOSITS":"0","INTENTCTBALANCESAVINGS":"0","INTENTCTBALANCENOTICEDEPOSITS":"0","INTENTCTBALANCECUSTINVESTMENTS":"0","INTENTCTBALANCECHEQS":"0","INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"00101","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"","INTENTCLIENTCODE2":"","INTENTCLIENTCODE1":"PATELJ 004","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{"COMMINPREGNUMBER":""},"INTENTARRS":{"ML":"0","ASSETFINANCE":"0"},"APPENTWORKADDRSUBURB":"Sandton","APPENTWORKADDRPCODE":"2146","APPENTWORKADDRLINE1":"15 piet street","APPENTWORKADDRCITY":"Johannesburg","APPENTSHAREHOLDINGPERC":"60.00","APPENTPASSPORTNATIONALITY":"South Africa","APPENTMNTHSSHAREHOLDINGPERC":"192","APPENTINTENTIONTOINSOLVENCY":"N","APPENTIDTYPE":"01","APPENTGENDER":"F","APPENTFNST":{"TYPE_Z":"0","TURNOVER":"0","TOTALASSETTURNOVER":"0","TOTALASSETS":"0","SOLEFULLAVAILABLE":"N","SALESGROWTHPERC":"0","RETAINEDEARNINGS":"0","QUALIFIED":"0","PROJTURNOVER":"0","PROFITNET":"0","PROFITBEFORETAX":"0","PERIODOFINCSTAT":"0","OPERATINGPROFITMARGIN":"0","NETWORTH":"0","NETPROFITPERC":"0.00","LONGTERMDEBTTOEBITDA":"0","LIABTOTSTOCK":"0","LIABTOTLONGTERMDEBT":"0","LIABTOTCURRLIAB":"0","LIABSHAREHFUNDS":"0","LIABLOANTOINSIDEPARTIES":"0","LIABLOANSTOPR":"0","LIABLOANSFROMPRCEDED":"0","LIABLOANFROMOTHINSTITUTIONS":"0","ICR":"0.00","IBDTOEQUITY":"0.00","IBDTOEBITDA":"0.00","GROSSPROFITPERC":"0.00","GROSSPROFIT":"0","EBITDA":"0","CURRENTRATIO":"0.00","AVAILABLE":"N","ASSINTANGIBLES":"0","ACIDTEST":"0.00"},"APPENTEXPO":{},"APPENTBUR":{"CONSINPNATID":"123456789"},"APPENTASLB":{"TOTALPROPERTIES":"0","NOTARIALBOND":"0","NETWORTHME":"0","NETWORTHCREDIT":"0","NETWORTH":"0","DEEDSSEARCHAVAILABLE":"","AVAILABLE":"N"},"APPENTAPRF":{},"APPENTAPPLCATEGORY":"","APPENTAGEOLDESTRELATIONSHIP":"0","APPENTAGE":"5903"},"Entity02":{"INTENTTRID":{},"INTENTRDET":{},"INTENTLMTS":{},"INTENTINST":{},"INTENTEXPO":{},"INTENTEXCS":{},"INTENTCMTM":{},"INTENTBUR":{},"INTENTARRS":{},"APPENTEXPO":{},"APPENTBUR":{},"APPENTAPRF":{}},"Entity01":{"INTENTWRSTRISKGRADE":"0","INTENTUNDERJUDICIALMNGMNT":"","INTENTUNDERDEBTCOUNSELLING":"","INTENTTRID":{"TOTSAVRETPAYMNTSL6M":"","TOTCHEQRETPAYMNTSL6M":"","NUMRDEVENTSSAVL6M":"0","NUMRDEVENTSSAVL3M":"0","NUMRDEVENTSCHEQL6M":"0","NUMRDEVENTSCHEQL3M":"0","NUMMNTHSEXCESSBALL6M":"0","NUMDEBITSL6M":"0","NUMDAYSDEBITINL6M":"0","NUMDAYSCREDITINL6M":"0","MNTHSOLDESTSAVACCREL":"0","MNTHSOLDESTCUSTREL":"0","MNTHSOLDESTCHACCREL":"0","MNTHSOLDESTACCREL":"0","MAXOCSCORINGMANDATE":"0","MAXCONSECDAYSINEXCESS":"0","EXPECTEDCREDTURNOVCUST":"0","EXPECTEDCREDTURNOVCHEQ":"0","EXCLUSIONTYPE":"","EXCLUSIONREASON":"","EXCLUSIONCREDITFACILITY":"","BEHAVSCOREMORTG":"0","BEHAVSCORELOANS":"0","BEHAVSCORECUSTALIGN":"0","BEHAVSCORECHEQ":"0","BEHAVSCORECC":"0","BEHAVSCOREAVAF":"0","AVGCTOL6ML12M":"0.00","AVGCTOL3ML6M":"0.00","AOL":"0","AMR":"0","AMMR":"0","AMLR":"0","ACCL":"0","ABRA":"0"},"INTENTSECE":{"SURETYSHIPIFOAPPLICANT":"N"},"INTENTRDET":{"WRSTCOLLRISKTYPE":"","WRSTARMSHOLD":"","INTENTBUSNRESC":"Y","INBUSNRESC":"","EWLLISTING":"0.0","BUSNRESCAFFECTEDPARTY":""},"INTENTPARTOFCREDITGROUP":"","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"","INTENTNUMPARTICIPANTS1":"","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"0","OTHEROC":"0","ML":"0","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTINLIQUIDATION":"","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFRAUDRISKMNGMNT":"","INTENTFINANCIALCRIMEHOLD":"","INTENTEXPO":{"TOTALEXPOSURE":"0","TOTALDIRECTEXPOSURE":"0","RECOVERYEXPOSURE":"0","ORDCRED":"0","MORTGTOTAL":"0","MORTGRES":"0","MORTGCPF":"0","MORTGAGRI":"0","CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"0","CC":"0"},"INTENTCTBALANCETERMDEPOSITS":"0","INTENTCTBALANCESAVINGS":"0","INTENTCTBALANCENOTICEDEPOSITS":"0","INTENTCTBALANCECUSTINVESTMENTS":"0","INTENTCTBALANCECHEQS":"0","INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ORDCREDIT":"0","MORTGTOTAL":"0","MORTGRES":"0","MORTGCPF":"0","MORTGAGRI":"0","ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"03101","INTENTCLIENTCODE1":"STCC   746","INTENTCDUCTMAINPYTURNOVER":"0","INTENTCDUCTDAYSSNCELASTCREDIT":"-6","INTENTBUR":{"COMMINPREGNUMBER":"199102712723"},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"0","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRSUBURB":"Eppindust","APPENTWORKADDRPCODE":"7490","APPENTWORKADDRCITY":"Elsies River","APPENTTIME":{},"APPENTSHAREHOLDINGPERC":"0","APPENTINTENTIONTOINSOLVENCY":"N","APPENTINCOMETAXNUM":"9180523038","APPENTIDTYPE":"05","APPENTGENDER":"","APPENTFNST":{"TYPE_Z":"U","TURNOVER":"31618240","TOTALASSETTURNOVER":"2.36","TOTALASSETS":"2","TMSNCECERTDATE":"0","TMSNCE":"13","SOLEFULLAVAILABLE":"N","SALESGROWTHPERC":"0.00","RETAINEDEARNINGS":"6530462","QUALIFIED":"N","PROJTURNOVER":"31618240","PROFITNET":"6530462","PROFITBEFORETAX":"8935375","PERIODOFINCSTAT":"365","OPERATINGPROFITMARGIN":"28.26","NETWORTH":"9154432","NETPROFITPERC":"28.26","LONGTERMDEBTTOEBITDA":"0.00","LIABTOTSTOCK":"13397765","LIABTOTLONGTERMDEBT":"0","LIABTOTCURRLIAB":"4243333","LIABSHAREHFUNDS":"2623970","LIABLOANTOINSIDEPARTIES":"0","LIABLOANSTOPR":"0","LIABLOANSFROMPRCEDED":"0","LIABLOANFROMOTHINSTITUTIONS":"0","ICR":"0.00","IBDTOEQUITY":"0.00","IBDTOEBITDA":"0","GROSSPROFITPERC":"39.38","GROSSPROFIT":"12451005","EBITDA":"0","CURRENTRATIO":"2.73","AVAILABLE":"Y","ASSINTANGIBLES":"0","ACIDTEST":"1.36"},"APPENTEXPO":{"SETTLEMENTLIMITS":"0","APPRFACILITIESODNONSCR":"0","APPRFACILITIESMLNONSCR":"0","APPRFACILITIESAFINNONSCR":"0"},"APPENTBUR":{},"APPENTASLB":{"TOTALPROPERTIES":"0","NOTARIALBOND":"0","NETWORTHME":"0","NETWORTHCREDIT":"0","NETWORTH":"0","DEEDSSEARCHAVAILABLE":"0","AVAILABLE":"N"},"APPENTAPRF":{"INSTORDCREDNONSCORED":"0","INSTMLOANNONSCORED":"0","INSTASSETFINNONSCORED":"0"},"APPENTAPPLCATEGORY":"","APPENTAGEOLDESTRELATIONSHIP":"0","APPENTAGE":"0000"},"DERPCOUNIQUENUMBER":"000000016413","AppData":{"INTAPPSECE":{"SPECASVALL":"0","SPECASVACCSSETTLE":"0","PERCNORMCHANGED":"N","OUSTANDINGSEC":"N","MASVAGRI":"0","CASHCOVER":"0","APPRSECVALUE":"0"},"INTAPPNCAP":{"UCTMAXSERVICEFEES":"69","UCTINTERESTRATE":"27.75","UCTINITFEESTHRESHOLD":"1000","UCTINITFEESNEXTPERC":"11.5","UCTINITFEESMAX":"6040.5","UCTINITFEESFIRST":"189.75","STCTMAXSERVICEFEES":"69","STCTINTERESTRATE":"60","STCTINITFEESTHRESHOLD":"1000","STCTINITFEESNEXTPERC":"11.5","STCTINITFEESMAX":"1207.5","STCTINITFEESFIRST":"189.75","REPORATE":"7","PRIMERATE":"6.0","OCAMAXSERVICEFEES":"69","OCAINTERESTRATE":"21","OCAINITFEESTHRESHOLD":"1000","OCAINITFEESNEXTPERC":"11.5","OCAINITFEESMAX":"1207.5","OCAINITFEESFIRST":"189.75","MAMAXSERVICEFEES":"69","MAINTERESTRATE":"19","MAINITFEESTHRESHOLD":"10000","MAINITFEESNEXTPERC":"11.5","MAINITFEESMAX":"6037.5","MAINITFEESFIRST":"1265","CAMAXSERVICEFEES":"69","CAINTERESTRATE":"20.75","CAINITFEESTHRESHOLD":"1000","CAINITFEESNEXTPERC":"11.5","CAINITFEESMAX":"6050.5","CAINITFEESFIRST":"189.75"},"INTAPPEXPO":{"TOTALGROUPEXPOSURE":"0","TGOE":"0","TGBE":"0","TGAE":"0","POLICYIND":""},"INTAPPCCLP":{"TLCREDITLIFEMINAMNT":"0","TLCREDITLIFEMAXAMNT":"0","ODCREDITLIFEMINAMNT":"0","ODCREDITLIFEMAXAMNT":"0"},"INTAPPAFFECTEDPERSREG31F":"","INTAPPABSA":{"CHQACCRELATIONSHIP":"S"},"APPAPPSECUREDBYMORTGAGEBOND":"N","APPAPPSECO":{"SUPPORTINGSPECIFIC":"0","SUPPORTINGNONSPECIFIC":"0","ASVOFFERED":"0","ASVADDOFFERED":"0"},"APPAPPNUMPARTICIPANTS":"","APPAPPNUMKEYPRINCIPALS":"2","APPAPPNUMCOREPRINCIPALS":"2","APPAPPNONRESPRINCIPALS":"0","APPAPPMNTHSSINCEBUSESTABLISHED":"353","APPAPPEXTR":{"TLNACC":"N","SAVAMNT":"0","SAVACC":"N","MLOANAMNT":"0","MLOANACC":"N","INVAMNT":"0","INVACC":"N","CHEQAMNT":"0","CHEQACC":"N","CARDAMNT":"0","CARDACC":"N","ASSETAMNT":"0","ASSETACC":"N"},"APPAPPBSTM":{"TURNOVER":"0","PERIOD":"0","ODLIMITS":"0","NUMRDITEMS":"0","MINBALANCE":"0"}},"APPBANKERNUMBER":"9145944","APPAPPTRADINGINDICATOR":"Y","APPAPPSTOKVELAPPLICATION":"N","APPAPPSTAGEID":"04","APPAPPREQUESTEDFRANCHISORTYPE":"","APPAPPREQUESTEDFRANCHISEFINANCING":"N","APPAPPFORMALAPPINDICATOR":"Y","APPAPPFOREIGNCONTROLLEDPERC":"0","APPAPPEXTRTLAMNT":"0","APPAPPESPINSTRUCTION":"0000033055","APPAPPENTERPRDEVFUNDREQ":"","APPAPPAPPLICATIONTYPE":"O","APPAPPAPPLICATIONTIME":"081704","APPAPPAPPLICATIONSUBSTATUS":"","APPAPPAPPLICATIONSTATUS":"P","APPAPPAPPLICATIONNUMBER":"47000357717","APPAPPAPPLICATIONDATE":"2021-03-19"}}}';

        PowerCurveUpdateApplication_Req_IB_v1 pcoUpdateRequestBean = (PowerCurveUpdateApplication_Req_IB_v1)Json.deserialize(request, PowerCurveUpdateApplication_Req_IB_v1.class);
        Opportunity opp = [SELECT Id, accountId FROM Opportunity];
        Test.startTest();
        System.assert(PowerCurveUpdateController4.mapStage4Fields(pcoUpdateRequestBean, opp) != null,true);
        Test.stopTest();
    }
}