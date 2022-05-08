/**
 * @description       :
 * @author            : Tinashe.Shoko@absa.africa
 * @last modified on  : 2021-06-18
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-06-18   Tinashe.Shoko@absa.africa   Initial Version
**/
@isTest
public class PowerCurveUpdateCtrl6Test {

    public static string request = '{"Request":{"ApplicationDV":{"RequestedProducts01":{"INTPRDNEWF":{},"APPPRDNEWF":{"SETTLEMENTSAMNT":"0","REQTOTALAMNT":"100000","REQTERMOFLOAN":"0","REQREQEMPOWERMNTFUNDIND":"Y","REQREQEMPOWERMNTFUND":"002","REQREPAYMNTOPTION":"0","REQREDUCTIONFREQ":"0","REQREDUCTIONAMNT":"0","REQPRODUCT":"CHQ","REQPRODTYPE":"11016","REQPRODCOMBINATIONNUM":"0","REQPAYMNTMETHOD":"D","REQONCEOFFFREQAMNT":"0","REQODLIMITTYPE":"4","REQNUMSKIPPEDPAYMNTS":"0","REQLIMITTYPEIND":"","REQLIMIT":"100000","REQINSTALLMENTFREQ":"0","REQINITIATIONFEEPAYMNTMETHOD":"D","REQFACILITYTYPE":"0","REQCREDLIFEPREMIUM":"0","REQCAMPAIGNCODE":"","REQADDITIONALAMNT":"0","INSTSETTLEMENTS":"0","ESPINSTRUCTION":"","CARDTYPE":"","APPLICATIONSTATUS":"P"}},"INTAPPSICCODE":"50100","INTAPPOVERALLCONTROLBRANCH":"3840","INTAPPEXISTINGFRANCHISORTYPE":"425","INTAPPEXISTINGFRANCHISEFINANCING":"Y","INTAPPENTERPRDEVFUNDEXISTING":"TSAFRIC048","INTAPPBUSINESSSUBSEGMENT":"S","INTAPPBUSINESSSEGMENT":"F","INTAPPBRANCHCODE":"8198","ExistingProducts01":{"INTPRDSECE":{"SPECASVLIMITED":"0","SPECASVFULL":"0"},"INTPRDEXST":{"SECUREDBYMORTGAGEBOND":"N","PRODUCTTYPE":"11019","PRODUCT":"CHQ","NCAMAXINITFEEAMNT":"0","ESPINSTRUCTION":"","CURRSUBPRODTYPE":"","CURRSETTLEMENTAMNT":"0","CURRREDUCTIONFREQ":"0","CURRREDUCTIONAMNT":"0","CURRONCEOFFREDUCTION":"0","CURRLIMIT":"0","CURRINTRATEPRIMEOFFSET":"0","CURRINSTALMNTFREQ":"0","CURRINSTALLMENT":"0","CURRINITFEEPREVDEBITED":"","CURREXISTEMPOWERMNTFUNDIND":"Y","CURREXISTEMPOWERMNTFUND":"999","CURRENFORCEDREDLIM":"N","CURRBALANCE":"-6109596","CARDTYPE":"","ACCOUNTNUMBER":"1000157283"},"APPPRDSECO":{"SUPPORTINGSPECIFIC":"0","SPECIFIC":"0"},"APPPRDEXST":{"REQTOTALAMNT":"900000","REQTERMOFLOAN":"0","REQSUBPRODTYPE":"","REQREQEMPOWERMNTFUNDIND":"Y","REQREQEMPOWERMNTFUND":"999","REQREPAYMNTOPTION":"0","REQREDUCTIONFREQ":"0","REQREDUCTIONAMNT":"0","REQPRODTYPE":"11019","REQPRODCOMBINATIONNUM":"0","REQPAYMNTMETHOD":"","REQONCEOFFFREQAMNT":"0","REQODLIMITTYPE":"2","REQNUMSKIPPEDPAYMNTS":"0","REQLIMITTYPEIND":"0","REQINSTALLMENTFREQ":"0","REQINITIATIONFEEPAYMNTMETHOD":"D","REQFACILITYTYPE":"0","REQCREDLIFEPREMIUM":"0","REQCAMPAIGNCODE":"","REQADDITIONALAMNT":"0","INITIATIONFEEPAYMNTMETHOD":"","APPLICATIONSTATUS":"P"}},"Entity06":{"INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"N","INTENTTRID":{},"INTENTRDET":{},"INTENTPARTOFCREDITGROUP":"N","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"0","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"0","OTHEROC":"0","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"0","CC":"0"},"INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"","INTENTCLIENTCODE2":"ATSET  001","INTENTCLIENTCODE1":"","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRLINE2":"","APPENTWORKADDRLINE1":"","APPENTTEMPPERMITNUM":"","APPENTSHAREHOLDINGPERC":"","APPENTRESIDENTIALSTATUS":"","APPENTPASSPORTNATIONALITY":"","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTINCOMETAXNUM":"","APPENTIDTYPE":"","APPENTHOMECELLNUM":"","APPENTGROSSINCOME":"0","APPENTGENDER":"","APPENTEXPO":{"APPRFACILITIESODNONSCR":"0","APPRFACILITIESMLNONSCR":"0","APPRFACILITIESAFINNONSCR":"0"},"APPENTEMAIL":"","APPENTBUR":{},"APPENTAPRF":{"INSTORDCREDNONSCORED":"0","INSTMLOANNONSCORED":"0","INSTASSETFINNONSCORED":"0"},"APPENTAPPLCATEGORY":"","APPENTAGE":"0000"},"Entity05":{"INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"N","INTENTTRID":{},"INTENTRDET":{},"INTENTPARTOFCREDITGROUP":"N","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"","INTENTNUMPARTICIPANTS2":"0","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"0","OTHEROC":"0","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"0","CC":"0"},"INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"","INTENTCLIENTCODE2":"PRICING001","INTENTCLIENTCODE1":"","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRLINE2":"","APPENTWORKADDRLINE1":"","APPENTTEMPPERMITNUM":"","APPENTSHAREHOLDINGPERC":"","APPENTRESIDENTIALSTATUS":"","APPENTPASSPORTNATIONALITY":"","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTINCOMETAXNUM":"","APPENTIDTYPE":"","APPENTHOMECELLNUM":"","APPENTGROSSINCOME":"0","APPENTGENDER":"","APPENTEXPO":{"APPRFACILITIESODNONSCR":"0","APPRFACILITIESMLNONSCR":"0","APPRFACILITIESAFINNONSCR":"0"},"APPENTEMAIL":"","APPENTBUR":{},"APPENTAPRF":{"INSTORDCREDNONSCORED":"0","INSTMLOANNONSCORED":"0","INSTASSETFINNONSCORED":"0"},"APPENTAPPLCATEGORY":"","APPENTAGE":"0000"},"Entity04":{"INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"N","INTENTTRID":{},"INTENTRDET":{},"INTENTPARTOFCREDITGROUP":"Y","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"0","INTENTNUMPARTICIPANTS2":"","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"8777","OTHEROC":"0","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"0","CC":"0"},"INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"VWYK   305","INTENTCLIENTCODE2":"BONTSE 001","INTENTCLIENTCODE1":"","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRLINE2":"","APPENTWORKADDRLINE1":"","APPENTTEMPPERMITNUM":"","APPENTSHAREHOLDINGPERC":"","APPENTRESIDENTIALSTATUS":"","APPENTPASSPORTNATIONALITY":"","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTINCOMETAXNUM":"","APPENTIDTYPE":"","APPENTHOMECELLNUM":"","APPENTGROSSINCOME":"0","APPENTGENDER":"","APPENTEXPO":{"APPRFACILITIESODNONSCR":"0","APPRFACILITIESMLNONSCR":"0","APPRFACILITIESAFINNONSCR":"0"},"APPENTEMAIL":"","APPENTBUR":{},"APPENTAPRF":{"INSTORDCREDNONSCORED":"0","INSTMLOANNONSCORED":"0","INSTASSETFINNONSCORED":"0"},"APPENTAPPLCATEGORY":"","APPENTAGE":"0000"},"Entity03":{"INTENTWRSTRISKGRADE":"0","INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"","INTENTTRID":{"TOTSAVRETPAYMNTSL6M":"","TOTCHEQRETPAYMNTSL6M":"","NUMRDEVENTSSAVL6M":"0","NUMRDEVENTSSAVL3M":"0","NUMRDEVENTSCHEQL6M":"0","NUMRDEVENTSCHEQL3M":"0","NUMMNTHSEXCESSBALL6M":"0","NUMDEBITSL6M":"","NUMDAYSDEBITINL6M":"0","NUMDAYSCREDITINL6M":"0","MNTHSOLDESTSAVACCREL":"0","MNTHSOLDESTCUSTREL":"126","MNTHSOLDESTCHACCREL":"0","MNTHSOLDESTACCREL":"0","MAXOCSCORINGMANDATE":"130000","MAXCONSECDAYSINEXCESS":"0","EXPECTEDCREDTURNOVCUST":"0","EXCLUSIONTYPE":"P","EXCLUSIONREASON":"402","EXCLUSIONCREDITFACILITY":"","BEHAVSCOREMORTG":"0","BEHAVSCORELOANS":"0","BEHAVSCORECUSTALIGN":"0","BEHAVSCORECHEQ":"0","BEHAVSCORECC":"0","BEHAVSCOREAVAF":"0","AVGCTOL6ML12M":"0.00","AVGCTOL3ML6M":"0.00","AOL":"0","AMR":"0","AMMR":"0","AMLR":"0","ACCL":"0","ABRA":"0"},"INTENTRDET":{"WRSTCOLLRISKTYPE":"DCO","WRSTARMSHOLD":"","INBUSNRESC":"","EWLLISTING":"2.0","BUSNRESCAFFECTEDPARTY":"N"},"INTENTPARTOFCREDITGROUP":"Y","INTENTNUMPARTICIPANTS6":"","INTENTNUMPARTICIPANTS5":"","INTENTNUMPARTICIPANTS4":"","INTENTNUMPARTICIPANTS3":"0","INTENTNUMPARTICIPANTS2":"0","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"2","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"10000","CHEQ":"0","CC":"5000165"},"INTENTINST":{"TL":"8734","OTHEROC":"658","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTINLIQUIDATION":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFRAUDRISKMNGMNT":"Y","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"TOTALEXPOSURE":"2141912","TOTALDIRECTEXPOSURE":"2141912","RECOVERYEXPOSURE":"10635","ORDCRED":"994841","MORTGTOTAL":"198234","MORTGRES":"198234","MORTGCPF":"0","MORTGAGRI":"0","CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"5000","CHEQACCS":"809337","CC":"0"},"INTENTCTBALANCETERMDEPOSITS":"272788","INTENTCTBALANCESAVINGS":"234609","INTENTCTBALANCENOTICEDEPOSITS":"19894","INTENTCTBALANCECUSTINVESTMENTS":"0","INTENTCTBALANCECHEQS":"1214760","INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ORDCREDIT":"996378","MORTGTOTAL":"198234","MORTGRES":"198234","MORTGCPF":"0","MORTGAGRI":"0","ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"101","INTENTCLIENTCODE6":"","INTENTCLIENTCODE5":"","INTENTCLIENTCODE4":"","INTENTCLIENTCODE3":"FOURIE 961","INTENTCLIENTCODE2":"FOURIE 910","INTENTCLIENTCODE1":"FOURIBM001","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"30556","OTHEROC":"11565","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRPCODE":"2194","APPENTWORKADDRCITY":"RANDBURG","APPENTSHAREHOLDINGPERC":"","APPENTPASSPORTNATIONALITY":"South Africa","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTIDTYPE":"01","APPENTHOMECELLNUM":"123000000","APPENTGENDER":"M","APPENTEXPO":{"SETTLEMENTLIMITS":"3","APPRFACILITIESODNONSCR":"6","APPRFACILITIESMLNONSCR":"6","APPRFACILITIESAFINNONSCR":"3"},"APPENTBUR":{"CONSINPNATID":"7010075121089"},"APPENTAPRF":{"INSTORDCREDNONSCORED":"8","INSTMLOANNONSCORED":"8","INSTASSETFINNONSCORED":"4"},"APPENTAPPLCATEGORY":"","APPENTAGEOLDESTRELATIONSHIP":"126","APPENTAGE":"5000"},"Entity01":{"INTENTWRSTRISKGRADE":"0","INTENTUNDERJUDICIALMNGMNT":"N","INTENTUNDERDEBTCOUNSELLING":"N","INTENTTRID":{"TOTSAVRETPAYMNTSL6M":"","TOTCHEQRETPAYMNTSL6M":"","NUMRDEVENTSSAVL6M":"0","NUMRDEVENTSSAVL3M":"0","NUMRDEVENTSCHEQL6M":"0","NUMRDEVENTSCHEQL3M":"0","NUMMNTHSEXCESSBALL6M":"0","NUMDEBITSL6M":"","NUMDAYSDEBITINL6M":"0","NUMDAYSCREDITINL6M":"0","MNTHSOLDESTSAVACCREL":"0","MNTHSOLDESTCUSTREL":"297","MNTHSOLDESTCHACCREL":"0","MNTHSOLDESTACCREL":"0","MAXOCSCORINGMANDATE":"200000","MAXCONSECDAYSINEXCESS":"0","EXPECTEDCREDTURNOVCUST":"0","EXCLUSIONTYPE":"P","EXCLUSIONREASON":"405","EXCLUSIONCREDITFACILITY":"","BEHAVSCOREMORTG":"0","BEHAVSCORELOANS":"0","BEHAVSCORECUSTALIGN":"0","BEHAVSCORECHEQ":"0","BEHAVSCORECC":"0","BEHAVSCOREAVAF":"0","AVGCTOL6ML12M":"0.00","AVGCTOL3ML6M":"0.00","AOL":"0","AMR":"0","AMMR":"0","AMLR":"0","ACCL":"0","ABRA":"0"},"INTENTRDET":{"WRSTCOLLRISKTYPE":"INS","WRSTARMSHOLD":"BDH","INBUSNRESC":"N","EWLLISTING":"0.0","BUSNRESCAFFECTEDPARTY":"N"},"INTENTPARTOFCREDITGROUP":"","INTENTNUMPARTICIPANTS6":"0","INTENTNUMPARTICIPANTS5":"0","INTENTNUMPARTICIPANTS4":"0","INTENTNUMPARTICIPANTS3":"0","INTENTNUMPARTICIPANTS2":"0","INTENTNUMPARTICIPANTS1":"0","INTENTNONRESIDENT":"N","INTENTMARITALSTATUS":"","INTENTMARITALCONTRACT":"","INTENTLMTS":{"OTHEROC":"0","CHEQ":"0","CC":"0"},"INTENTINST":{"TL":"0","OTHEROC":"0","ML":"2136","CC":"0","ASSETFINANCE":"0"},"INTENTINSOLVENT":"N","INTENTINLIQUIDATION":"N","INTENTHIGHLEVELLIMITINDICATOR":"N","INTENTFRAUDRISKMNGMNT":"N","INTENTFINANCIALCRIMEHOLD":"N","INTENTEXPO":{"TOTALEXPOSURE":"7382297","TOTALDIRECTEXPOSURE":"7382297","RECOVERYEXPOSURE":"0","ORDCRED":"6109597","MORTGTOTAL":"1272700","MORTGRES":"0","MORTGCPF":"0","MORTGAGRI":"1272700","CONTINGENTLIABILITY":"0","ASSETFINANCE":"0"},"INTENTEXCS":{"OTHEROC":"0","CHEQACCS":"6109597","CC":"0"},"INTENTCTBALANCETERMDEPOSITS":"0","INTENTCTBALANCESAVINGS":"0","INTENTCTBALANCENOTICEDEPOSITS":"0","INTENTCTBALANCECUSTINVESTMENTS":"0","INTENTCTBALANCECHEQS":"0","INTENTCTBALANCECASHCOVER":"0","INTENTCMTM":{"ORDCREDIT":"7382297","MORTGTOTAL":"1272700","MORTGRES":"0","MORTGCPF":"0","MORTGAGRI":"1272700","ASSETFINANCE":"0"},"INTENTCLIENTTYPE":"02301","INTENTCLIENTCODE6":"CGTWO  001","INTENTCLIENTCODE5":"CGONE  002","INTENTCLIENTCODE4":"CGONE  001","INTENTCLIENTCODE3":"CGCC   002","INTENTCLIENTCODE2":"BCC    770","INTENTCLIENTCODE1":"SBSOUTP001","INTENTCDUCTMAINPYTURNOVER":"0","INTENTBUR":{},"INTENTARRS":{"TL":"0","OTHEROC":"0","ML":"298267","CC":"0","ASSETFINANCE":"0"},"APPENTWORKADDRLINE2":"","APPENTWORKADDRLINE1":"","APPENTTEMPPERMITNUM":"","APPENTSHAREHOLDINGPERC":"50","APPENTRESIDENTIALSTATUS":"","APPENTPASSPORTNATIONALITY":"","APPENTINTENTIONTOINSOLVENCY":"Y","APPENTINCOMETAXNUM":"","APPENTIDTYPE":"","APPENTHOMECELLNUM":"","APPENTGROSSINCOME":"0","APPENTGENDER":"","APPENTEXPO":{"SETTLEMENTLIMITS":"1","APPRFACILITIESODNONSCR":"2","APPRFACILITIESMLNONSCR":"2","APPRFACILITIESAFINNONSCR":"1"},"APPENTEMAIL":"","APPENTBUR":{},"APPENTAPRF":{"INSTORDCREDNONSCORED":"4","INSTMLOANNONSCORED":"4","INSTASSETFINNONSCORED":"2"},"APPENTAPPLCATEGORY":"","APPENTAGEOLDESTRELATIONSHIP":"297","APPENTAGE":"0000"},"DERPCOUNIQUENUMBER":"000000007620","AppData":{"INTAPPSECE":{"SPECASVALL":"0","SPECASVACCSSETTLE":"0","PERCNORMCHANGED":"N","OUSTANDINGSEC":"N","MASVAGRI":"0","MASV":"0","CESSIONDEBTORS":"N","CASHCOVER":"0","ASVOC":"0","APPRSECVALUE":"0"},"INTAPPNCAP":{"UCTMAXSERVICEFEES":"69","UCTINTERESTRATE":"27.75","UCTINITFEESTHRESHOLD":"1000","UCTINITFEESNEXTPERC":"11.5","UCTINITFEESMAX":"6040.5","UCTINITFEESFIRST":"189.75","STCTMAXSERVICEFEES":"69","STCTINTERESTRATE":"60","STCTINITFEESTHRESHOLD":"1000","STCTINITFEESNEXTPERC":"11.5","STCTINITFEESMAX":"1207.5","STCTINITFEESFIRST":"189.75","REPORATE":"7","PRIMERATE":"6.25","OCAMAXSERVICEFEES":"69","OCAINTERESTRATE":"21","OCAINITFEESTHRESHOLD":"1000","OCAINITFEESNEXTPERC":"11.5","OCAINITFEESMAX":"1207.5","OCAINITFEESFIRST":"189.75","MAMAXSERVICEFEES":"69","MAINTERESTRATE":"19","MAINITFEESTHRESHOLD":"10000","MAINITFEESNEXTPERC":"11.5","MAINITFEESMAX":"6037.5","MAINITFEESFIRST":"1265","CAMAXSERVICEFEES":"69","CAINTERESTRATE":"20.75","CAINITFEESTHRESHOLD":"1000","CAINITFEESNEXTPERC":"11.5","CAINITFEESMAX":"6050.5","CAINITFEESFIRST":"189.75"},"INTAPPEXPO":{},"INTAPPCCLP":{"TLCREDITLIFEMINAMNT":"0","TLCREDITLIFEMAXAMNT":"0","ODCREDITLIFEMINAMNT":"0","ODCREDITLIFEMAXAMNT":"0"},"INTAPPAFFECTEDPERSREG31F":"","INTAPPABSA":{"NUMBEROFPRODUCTS":"5","CHQACCRELATIONSHIP":"S"},"APPAPPSECUREDBYMORTGAGEBOND":"Y","APPAPPSECO":{"SUPPORTINGSPECIFIC":"0","SUPPORTINGNONSPECIFIC":"0","ASVOFFERED":"0","ASVADDOFFERED":"0"},"APPAPPNUMPARTICIPANTS":"","APPAPPNUMKEYPRINCIPALS":"4","APPAPPNUMCOREPRINCIPALS":"4","APPAPPNONRESPRINCIPALS":"0","APPAPPMNTHSSINCEBUSESTABLISHED":"0","APPAPPEXTR":{"TLNACC":"N","SAVAMNT":"0","SAVACC":"N","MLOANAMNT":"0","MLOANACC":"N","INVAMNT":"0","INVACC":"N","CHEQAMNT":"0","CHEQACC":"N","CARDAMNT":"0","CARDACC":"N","ASSETAMNT":"0","ASSETACC":"N"},"APPAPPBSTM":{"TURNOVER":"0","PERIOD":"0","ODLIMITS":"0","NUMRDITEMS":"0","MINBALANCE":"0"}},"APPBANKERNUMBER":"9145944","APPAPPTRADINGINDICATOR":"Y","APPAPPSTOKVELAPPLICATION":"N","APPAPPSTAGEID":"1","APPAPPREQUESTEDFRANCHISORTYPE":"","APPAPPREQUESTEDFRANCHISEFINANCING":"N","APPAPPFORMALAPPINDICATOR":"N","APPAPPFOREIGNCONTROLLEDPERC":"0","APPAPPEXTRTLAMNT":"57000","APPAPPESPINSTRUCTION":"0000004068","APPAPPENTERPRDEVFUNDREQ":"","APPAPPAPPLICATIONTYPE":"O","APPAPPAPPLICATIONTIME":"101751","APPAPPAPPLICATIONSUBSTATUS":"","APPAPPAPPLICATIONSTATUS":"P","APPAPPAPPLICATIONNUMBER":"0","APPAPPAPPLICATIONDATE":"2021-01-27"}}}';

    /**
    * @description method to setup test data
    * @author Tinashe.Shoko@absa.africa | 2021-06-18
    **/
    @testSetup
    public static void testData() {
        Account account = new Account();
		account.Name = 'Absa Bank';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
		insert account;

		Opportunity opp = new Opportunity();
		opp.Name = 'EPP';
		opp.StageName = 'Not Interested';
		opp.CloseDate = Date.today()+10;
		opp.AccountId = account.Id;
		//opp.Spouse_Account_Id__c=account.Id;
		insert opp;

		Application__c application = new Application__c();
		application.Opportunity__c = opp.Id;
		insert application;

        List<Application_Income_and_Expense__c> aieList = new List<Application_Income_and_Expense__c>();
        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Monthly Income', Expense_Value__c = 'Total Gross Monthly Income', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Monthly Income', Expense_Value__c = 'Net Monthly Income', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Monthly Income', Expense_Value__c = 'Statutory Deductions - Maintenance', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Monthly Income', Expense_Value__c = 'Statutory Deductions - Other', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Monthly Income', Expense_Value__c = 'Maintenance Income', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'External Installment', Expense_Value__c = 'Total External Instalments', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Maintenance Payments - Applicant', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Maintenance Payments - Spouse', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Rent', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Groceries', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Transport/Petrol Cost (excluding vehicle finance)', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Educational Fees', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Medical Expenses', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Municipal/Levies', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Insurance & Funeral Policies', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Other Expenses', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Total Living/Business Expenses', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Domestic & Gardener Wages', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Telecommunication', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Entertainment', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Multi Choice', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Security', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Living Expenses', Expense_Value__c = 'Tax', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Fixed Debt', Expense_Value__c = 'Total Absa Instalments', Total_MDI_Adjusted__c = 600));

        aieList.add(new Application_Income_and_Expense__c(Application__c =application.Id, Applicant_Type__c = 'Applicant', Applicant_Bureau_Value__c = 1000, Applicant_Value__c = 1200,
        Spouse_Value__c = 900, Operation_Type__c = 'Aggregation', Category__c = 'Disposable Income', Expense_Value__c = 'Tax', Total_MDI_Adjusted__c = 600));
        insert aieList;

        Application_Financial_Conduct__c appFinCon = new Application_Financial_Conduct__c();
        appFinCon.Application__c = application.Id;
        appFinCon.Balance__c = 10000;
        appFinCon.Conduct_Type__c = 'Primary Conduct';
        appFinCon.Account_Name_Number__c = '4047854674';
        insert appFinCon;
    }

    @isTest
	public static void testmapPowerCureveUpdateRequest() {
		PowerCurveUpdateApplication_Req_IB_v1 pcoUpdateRequestBean = (PowerCurveUpdateApplication_Req_IB_v1)Json.deserialize(request, PowerCurveUpdateApplication_Req_IB_v1.class);
        Opportunity opp = [select Id, accountId
		                   from Opportunity LIMIT 1];
		Test.startTest();
		System.assert(PowerCurveUpdateCtrl6.mapPowerCureveUpdateRequest(pcoUpdateRequestBean, opp.Id, 6) != null ,true);

        Opportunity opp2 = new Opportunity();
		opp2.Name = 'EPP2';
		opp2.StageName = 'Not Interested';
		opp2.CloseDate = Date.today()+10;
		opp2.AccountId = opp.accountId;
		insert opp2;

        Application__c application = new Application__c();
		application.Opportunity__c = opp2.Id;
		insert application;

        System.assert(PowerCurveUpdateCtrl6.mapPowerCureveUpdateRequest(pcoUpdateRequestBean, opp2.Id, 6) != null ,true);

		Test.stopTest();
    }
}