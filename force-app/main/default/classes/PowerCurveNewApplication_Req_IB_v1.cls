/**
 * Request Integration Bean for PowerCurveNewApplication Service
 * @author Englarmerdge Mongwe
 * @created 2020-09-28
 * Modified for the nth time : Saurabh 2020/01/09
 * Modified for the nth* time : E.Mongwe 2021-01-20
 */

public class PowerCurveNewApplication_Req_IB_v1 extends Base_IB {

    public Request Request;
	public class RequestedProducts01 {
		public APPPRDNEWF APPPRDNEWF;
		public INTPRDNEWF INTPRDNEWF;
	}

	public class APPENTAPRF {
		public String INSTORDCREDNONSCORED;
		public String INSTASSETFINNONSCORED;
		public String INSTMLOANNONSCORED;
	}

	public class INTAPPNCAP {
		public String MAINITFEESFIRST;
		public String MAINITFEESNEXTPERC;
		public String MAINITFEESMAX;
		public String MAINITFEESTHRESHOLD;
		public String MAMAXSERVICEFEES;
		public String MAINTERESTRATE;
		public String CAINITFEESFIRST;
		public String CAINITFEESNEXTPERC;
		public String CAINITFEESMAX;
		public String CAINITFEESTHRESHOLD;
		public String CAMAXSERVICEFEES;
		public String CAINTERESTRATE;
		public String UCTINITFEESFIRST;
		public String UCTINITFEESNEXTPERC;
		public String UCTINITFEESMAX;
		public String UCTINITFEESTHRESHOLD;
		public String UCTMAXSERVICEFEES;
		public String UCTINTERESTRATE;
		public String OCAINITFEESFIRST;
		public String OCAINITFEESNEXTPERC;
		public String OCAINITFEESMAX;
		public String OCAINITFEESTHRESHOLD;
		public String OCAMAXSERVICEFEES;
		public String OCAINTERESTRATE;
		public String STCTINITFEESFIRST;
		public String STCTINITFEESNEXTPERC;
		public String STCTINITFEESMAX;
		public String STCTINITFEESTHRESHOLD;
		public String STCTMAXSERVICEFEES;
		public String STCTINTERESTRATE;
		public String PRIMERATE;
		public String REPORATE;
	}

	public class INTAPPTOT {
		public String INSTSETTLEMENTS;
		public String LOANREQ;
		public String SETTLEMENTSAMNT;
	}

	public class INTENTLMTS {
		public String CC;
		public String CHEQ;
		public String OTHEROC;
	}

	public class Entity01 {
		public String INTENTCLIENTTYPE;
		public String APPENTAGE;
		public String INTENTCLIENTCODE1;
		public String INTENTCLIENTCODE2;
		public String INTENTCLIENTCODE3;
		public String INTENTCLIENTCODE4;
		public String INTENTCLIENTCODE5;
		public String INTENTCLIENTCODE6;
		public String INTENTNUMPARTICIPANTS1;
		public String INTENTNUMPARTICIPANTS2;
		public String INTENTNUMPARTICIPANTS3;
		public String INTENTNUMPARTICIPANTS4;
		public String INTENTNUMPARTICIPANTS5;
		public String INTENTNUMPARTICIPANTS6;
		public String INTENTNONRESIDENT;
		public String APPENTSHAREHOLDINGPERC;
		public String APPENTMNTHSSHAREHOLDINGPERC;
		public String INTENTMARITALSTATUS;
		public String INTENTMARITALCONTRACT;
		public String INTENTWRSTRISKGRADE;
		public INTENTEXPO INTENTEXPO;
		public APPENTEXPO APPENTEXPO;
		public INTENTCMTM INTENTCMTM;
		public String INTENTCTBALANCECHEQS;
		public String INTENTCTBALANCESAVINGS;
		public String INTENTCTBALANCENOTICEDEPOSITS;
		public String INTENTCTBALANCETERMDEPOSITS;
		public String INTENTCTBALANCECUSTINVESTMENTS;
		public String INTENTCTBALANCECASHCOVER;
		public INTENTARRS INTENTARRS;
		public INTENTEXCS INTENTEXCS;
		public INTENTARRS INTENTINST;
		public INTENTLMTS INTENTLMTS;
		public String INTENTCDUCTMAINPYTURNOVER;
		public INTENTTRID INTENTTRID;
		public String INTENTHIGHLEVELLIMITINDICATOR;
		public APPENTAPRF APPENTAPRF;
		public String INTENTUNDERDEBTCOUNSELLING;
		public String INTENTINLIQUIDATION;
		//public String APPENTINTENTIONTOLIQUIDATE;
		public String INTENTUNDERJUDICIALMNGMNT;
		public String INTENTFRAUDRISKMNGMNT;
		public INTENTRDET INTENTRDET;
		public APPENTBUR APPENTBUR;
		public INTENTBUR INTENTBUR;
		public String INTENTFINANCIALCRIMEHOLD;
		public String INTENTINSOLVENT;
		public String APPENTINTENTIONTOINSOLVENCY;
		//public APPENTTIME APPENTTIME;
		public String APPENTAGEOLDESTRELATIONSHIP;
		//public String APPENTEVERDECLINSOLVENT;
		public String APPENTIDTYPE;
	}

	public class INTPRDEXST {
		public String PRODUCT;
		public String PRODUCTTYPE;
		public String CURRSUBPRODTYPE;
		public String CURRBALANCE;
		public String CURRINSTALLMENT;
		public String CURRLIMIT;
		public String CURRINTRATEPRIMEOFFSET;
		public String CURRREDUCTIONAMNT;
		public String CURRREDUCTIONFREQ;
		public String CURRONCEOFFREDUCTION;
		public String CURRINSTALMNTFREQ;
		public String CURRSETTLEMENTAMNT;
		public String CURREXISTEMPOWERMNTFUNDIND;
		public String CURREXISTEMPOWERMNTFUND;
		public String CURRINITFEEPREVDEBITED;
		public String NCAMAXINITFEEAMNT;
		public String ACCOUNTNUMBER;
		public String ESPINSTRUCTION;
		public String CARDTYPE;
	}

	public class ExistingProducts01 {
		public INTPRDEXST INTPRDEXST;
		public APPPRDEXST APPPRDEXST;
	}

	public class APPPRDNEWF {
		public String APPLICATIONSTATUS;
		public String REQPRODUCT;
		public String REQFACILITYTYPE;
		public String REQPRODTYPE;
		public String REQSUBPRODTYPE;
		public String REQADDITIONALAMNT;
		public String REQTOTALAMNT;
		public String REQLIMIT;
		public String REQODLIMITTYPE;
		public String REQREDUCTIONAMNT;
		public String REQREDUCTIONFREQ;
		public String REQONCEOFFFREQAMNT;
		public String REQREPAYMNTOPTION;
		public String REQPURPOSEFACILITYORLOAN;
		public String REQTERMOFLOAN;
		public String REQINSTALLMENTFREQ;
		public String REQNUMSKIPPEDPAYMNTS;
		public String REQINITIATIONFEEPAYMNTMETHOD;
		public String REQPAYMNTMETHOD;
		public String REQCREDLIFEPREMIUM;
		public String REQREQEMPOWERMNTFUNDIND;
		public String REQREQEMPOWERMNTFUND;
		public String REQCAMPAIGNCODE;
		public String REQLIMITTYPEIND;
		public String REQPRODCOMBINATIONNUM;
		public String ESPINSTRUCTION;
		public String CARDTYPE;
		public String SETTLEMENTSAMNT;
        public String UNIQUEPRODID;
        public String SECUREDBYMORTGAGEBOND;
	}

	public class APPPRDEXST {
		public String APPLICATIONSTATUS;
		public String REQFACILITYTYPE;
		public String REQPRODTYPE;
		public String REQSUBPRODTYPE;
		public String REQADDITIONALAMNT;
		public String REQTOTALAMNT;
		public String REQODLIMITTYPE;
		public String REQREDUCTIONAMNT;
		public String REQREDUCTIONFREQ;
		public String REQONCEOFFFREQAMNT;
		public String REQREPAYMNTOPTION;
		public String REQPURPOSEFACILITYORLOAN;
		public String REQTERMOFLOAN;
		public String REQINSTALLMENTFREQ;
		public String REQNUMSKIPPEDPAYMNTS;
		public String REQINITIATIONFEEPAYMNTMETHOD;
		public String REQPAYMNTMETHOD;
		public String REQCREDLIFEPREMIUM;
		public String REQREQEMPOWERMNTFUNDIND;
		public String REQREQEMPOWERMNTFUND;
		public String REQLIMITTYPEIND;
		public String REQPRODCOMBINATIONNUM;
		public String REQCAMPAIGNCODE;
        public String SECUREDBYMORTGAGEBOND;
	}

	public class APPENTEXPO {
		public String SETTLEMENTLIMITS;
		public String APPRFACILITIESODNONSCR;
		public String APPRFACILITIESAFINNONSCR;
		public String APPRFACILITIESMLNONSCR;
	}

	public class APPENTBUR {
		public String CONSINPNATID;
	}

	public class AppData {
		public String APPAPPNUMKEYPRINCIPALS;
		public String APPAPPNUMCOREPRINCIPALS;
		public String APPAPPNONRESPRINCIPALS;
		public String APPAPPNUMPARTICIPANTS;
		public String APPAPPMNTHSSINCEBUSESTABLISHED;
		public String INTAPPAFFECTEDPERSREG31F;
		public INTAPPEXPO INTAPPEXPO;
		public INTAPPTOT INTAPPTOT;
		public INTAPPNCAP INTAPPNCAP;
		public INTAPPCCLP INTAPPCCLP;
	}

	public class ApplicationDV {
		public String APPAPPAPPLICATIONDATE;
		public String APPAPPAPPLICATIONNUMBER;
		public String APPAPPAPPLICATIONTIME;
		public String APPAPPAPPLICATIONTYPE;
		public String INTAPPBRANCHCODE;
		public String INTAPPOVERALLCONTROLBRANCH;
		public String INTAPPBUSINESSSEGMENT;
		public String INTAPPBUSINESSSUBSEGMENT;
		public String INTAPPSICCODE;
		public String APPAPPTRADINGINDICATOR;
		public String APPAPPFOREIGNCONTROLLEDPERC;
		public String INTAPPENTERPRDEVFUNDEXISTING;
		public String APPAPPENTERPRDEVFUNDREQ;
		public String APPAPPSTOKVELAPPLICATION;
		public String INTAPPEXISTINGFRANCHISEFINANCING;
		public String APPAPPREQUESTEDFRANCHISEFINANCING;
		public String INTAPPEXISTINGFRANCHISORTYPE;
		public String APPAPPREQUESTEDFRANCHISORTYPE;
		public String APPAPPFORMALAPPINDICATOR;
		public String APPAPPAPPLICATIONSTATUS;
		public String APPAPPAPPLICATIONSUBSTATUS;
		public String APPAPPESPINSTRUCTION;
		public String APPAPPEXTRTLAMNT;
		public String APPBANKERNUMBER;
		public AppData AppData;
		public Entity01 Entity06; //Entity06
		public Entity01 Entity05; //Entity05
		public Entity01 Entity04; //Entity04
		public Entity01 Entity03;
		public Entity01 Entity02;
		public Entity01 Entity01;
		public ExistingProducts01 ExistingProducts01;
		public ExistingProducts01 ExistingProducts02;
		public ExistingProducts01 ExistingProducts03;
		public ExistingProducts01 ExistingProducts04;
		public ExistingProducts01 ExistingProducts05;
		public ExistingProducts01 ExistingProducts06;
		public ExistingProducts01 ExistingProducts07;
		public ExistingProducts01 ExistingProducts08;
		public ExistingProducts01 ExistingProducts09;
		public ExistingProducts01 ExistingProducts10;
		public ExistingProducts01 ExistingProducts11;
		public ExistingProducts01 ExistingProducts12;
		public ExistingProducts01 ExistingProducts13;
		public ExistingProducts01 ExistingProducts14;
		public ExistingProducts01 ExistingProducts15;
		public ExistingProducts01 ExistingProducts16;
		public ExistingProducts01 ExistingProducts17;
		public ExistingProducts01 ExistingProducts18;
		public ExistingProducts01 ExistingProducts19;
		public ExistingProducts01 ExistingProducts20;
		public ExistingProducts01 ExistingProducts21;
		public ExistingProducts01 ExistingProducts22;
		public ExistingProducts01 ExistingProducts23;
		public ExistingProducts01 ExistingProducts24;
		public ExistingProducts01 ExistingProducts25;
		public ExistingProducts01 ExistingProducts26;
		public ExistingProducts01 ExistingProducts27;
		public ExistingProducts01 ExistingProducts28;
		public ExistingProducts01 ExistingProducts29;
		public ExistingProducts01 ExistingProducts30;
		public RequestedProducts01 RequestedProducts01;
		public RequestedProducts01 RequestedProducts02;
		public RequestedProducts01 RequestedProducts03;
		public RequestedProducts01 RequestedProducts04;
		public RequestedProducts01 RequestedProducts05;
		public RequestedProducts01 RequestedProducts06;
		public RequestedProducts01 RequestedProducts07;
		public RequestedProducts01 RequestedProducts08;
		public RequestedProducts01 RequestedProducts09;
		public RequestedProducts01 RequestedProducts10;
		public RequestedProducts01 RequestedProducts11;
		public RequestedProducts01 RequestedProducts12;
		public RequestedProducts01 RequestedProducts13;
		public RequestedProducts01 RequestedProducts14;
		public RequestedProducts01 RequestedProducts15;
		public RequestedProducts01 RequestedProducts16;
		public RequestedProducts01 RequestedProducts17;
		public RequestedProducts01 RequestedProducts18;
		public RequestedProducts01 RequestedProducts19;
		public RequestedProducts01 RequestedProducts20;
		public RequestedProducts01 RequestedProducts21;
		public RequestedProducts01 RequestedProducts22;
		public RequestedProducts01 RequestedProducts23;
		public RequestedProducts01 RequestedProducts24;
		public RequestedProducts01 RequestedProducts25;
		public RequestedProducts01 RequestedProducts26;
		public RequestedProducts01 RequestedProducts27;
		public RequestedProducts01 RequestedProducts28;
		public RequestedProducts01 RequestedProducts29;
		public RequestedProducts01 RequestedProducts30;
	}

	public class INTENTEXPO {
		public String ORDCRED;
		//public String ORDCREDOTHER;
		public String ASSETFINANCE;
		public String MORTGRES;
		public String MORTGCPF;
		public String MORTGAGRI;
		public String MORTGTOTAL;
		public String TOTALDIRECTEXPOSURE;
		public String TOTALEXPOSURE;
		public String RECOVERYEXPOSURE;
		public String CONTINGENTLIABILITY;
		//public String DM9CARDHOLDCODE;
		//public String DM9RECOVERYEXPOSURE;
	}

	public class INTENTBUR {
		public String COMMINPREGNUMBER;
	}

	public class INTENTARRS {
		public String ASSETFINANCE;
		public String CC;
		public String ML;
		public String OTHEROC;
		public String TL;
	}

	public class INTAPPCCLP {
		public String TLCREDITLIFEMINAMNT;
		public String TLCREDITLIFEMAXAMNT;
		public String ODCREDITLIFEMINAMNT;
		public String ODCREDITLIFEMAXAMNT;
	}

	public class APPENTTIME {
		public String ATCURRADDR;
	}

	public class INTENTRDET {
		public String INBUSNRESC;
		public String BUSNRESCAFFECTEDPARTY;
		public String WRSTCOLLRISKTYPE;
		public String WRSTARMSHOLD;
		public String EWLLISTING;
		//public String WRSTDM9CODE;
		public String INTENTBUSNRESC;
	}

	public class Request {
		public ApplicationDV ApplicationDV;
	}

	public class INTENTEXCS {
		public String CHEQACCS;
		public String CC;
		public String OTHEROC;
	}

	public class INTENTTRID {
		public String MNTHSOLDESTCUSTREL;
		public String MNTHSOLDESTACCREL;
		public String MNTHSOLDESTCHACCREL;
		public String MNTHSOLDESTSAVACCREL;
		public String EXCLUSIONTYPE;
		public String EXCLUSIONREASON;
		public String EXCLUSIONCREDITFACILITY;
		public String BEHAVSCORECUSTALIGN;
		public String BEHAVSCORECHEQ;
		public String BEHAVSCORECC;
		public String BEHAVSCOREMORTG;
		public String BEHAVSCOREAVAF;
		public String BEHAVSCORELOANS;
		public String EXPECTEDCREDTURNOVCHEQ;
		public String EXPECTEDCREDTURNOVCUST;
		public String AVGCTOL3ML6M;
		public String AVGCTOL6ML12M;
		public String NUMDAYSCREDITINL6M;
		public String NUMDAYSDEBITINL6M;
		public String NUMDEBITSL6M;
		public String NUMMNTHSEXCESSBALL6M;
		public String MAXCONSECDAYSINEXCESS;
		public String MAXOCSCORINGMANDATE;
		public String AOL;
		public String ACCL;
		public String AMLR;
		public String ABRA;
		public String AMMR;
		public String AMR;
		public String NUMRDEVENTSSAVL3M;
		public String NUMRDEVENTSSAVL6M;
		public String NUMRDEVENTSCHEQL3M;
		public String NUMRDEVENTSCHEQL6M;
		public String TOTSAVRETPAYMNTSL6M;
		public String TOTCHEQRETPAYMNTSL6M;
	}

	public class INTPRDNEWF {
		public String NCAMAXINITFEEAMNT;
	}

	public class INTAPPEXPO {
		public String POLICYIND;
		public String TGAE;
		public String TGBE;
		public String TGOE;
		public String TOTALGROUPEXPOSURE;
	}

	public class INTENTCMTM {
		public String ORDCREDIT;
		public String ASSETFINANCE;
		public String MORTGRES;
		public String MORTGCPF;
		public String MORTGAGRI;
		public String MORTGTOTAL;
	}




     public static PowerCurveNewApplication_Req_IB_v1 createDummyRequest() {
        PowerCurveNewApplication_Req_IB_v1 requestBean = new PowerCurveNewApplication_Req_IB_v1();
        requestBean.Request = new PowerCurveNewApplication_Req_IB_v1.Request();
        requestBean.Request.ApplicationDV = new PowerCurveNewApplication_Req_IB_v1.ApplicationDV();
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONDATE = '2020-11-06';
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONNUMBER = '46000125811';
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTIME = '102645';
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTYPE = '0';
		requestBean.Request.ApplicationDV.INTAPPSICCODE = '50100';
		requestBean.Request.ApplicationDV.APPAPPTRADINGINDICATOR = 'Y';
		requestBean.Request.ApplicationDV.APPAPPSTOKVELAPPLICATION = 'N';
		requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISEFINANCING = 'N';
		requestBean.Request.ApplicationDV.APPAPPFORMALAPPINDICATOR = 'Y';
		requestBean.Request.ApplicationDV.APPAPPESPINSTRUCTION = '72891';
		requestBean.Request.ApplicationDV.APPAPPEXTRTLAMNT = '0';
        requestBean.Request.ApplicationDV.APPBANKERNUMBER = '9145944';
        requestBean.Request.ApplicationDV.AppData = new PowerCurveNewApplication_Req_IB_v1.AppData();
        requestBean.Request.ApplicationDV.AppData.APPAPPNUMKEYPRINCIPALS = '5';
		requestBean.Request.ApplicationDV.AppData.APPAPPNUMCOREPRINCIPALS = '4';
		requestBean.Request.ApplicationDV.AppData.APPAPPNONRESPRINCIPALS = '0';
		requestBean.Request.ApplicationDV.AppData.APPAPPMNTHSSINCEBUSESTABLISHED = '0';
        requestBean.Request.ApplicationDV.AppData.INTAPPAFFECTEDPERSREG31F = '';

        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO = new PowerCurveNewApplication_Req_IB_v1.INTAPPEXPO();
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGAE = '515574';
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGBE = '0';
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGOE = '0';
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TOTALGROUPEXPOSURE = '515574';

        requestBean.Request.ApplicationDV.AppData.INTAPPTOT = new PowerCurveNewApplication_Req_IB_v1.INTAPPTOT();
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.INSTSETTLEMENTS = '';
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.LOANREQ = '';
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.SETTLEMENTSAMNT = '';

        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP = new PowerCurveNewApplication_Req_IB_v1.INTAPPNCAP();
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESFIRST = '1265.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESNEXTPERC = '11.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESMAX = '6037.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESTHRESHOLD = '10000.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAMAXSERVICEFEES = '69.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINTERESTRATE = '19.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESFIRST = '189.75';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESNEXTPERC = '11.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESMAX = '6050.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESTHRESHOLD = '1000.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAMAXSERVICEFEES = '69.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINTERESTRATE = '20.75';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESFIRST = '189.75';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESNEXTPERC = '11.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESMAX = '1207.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESTHRESHOLD = '1000.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTMAXSERVICEFEES = '69.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINTERESTRATE = '27.75';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESFIRST = '189.75';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESNEXTPERC = '11.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESMAX = '1207.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESTHRESHOLD = '1000.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAMAXSERVICEFEES = '69.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINTERESTRATE = '21.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESFIRST = '189.75';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESNEXTPERC = '11.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESMAX = '1207.50';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESTHRESHOLD = '1000.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTMAXSERVICEFEES = '69.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINTERESTRATE = '60.00';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.PRIMERATE = '10.25';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.REPORATE = '7.00';

        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP = new PowerCurveNewApplication_Req_IB_v1.INTAPPCCLP();
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.TLCREDITLIFEMINAMNT = '0';
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.TLCREDITLIFEMAXAMNT = '0';
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.ODCREDITLIFEMINAMNT = '0';
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.ODCREDITLIFEMAXAMNT = '0';

        //Entity Mapping start
        requestBean.Request.ApplicationDV.Entity01 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
        /*requestBean.Request.ApplicationDV.Entity02 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity03 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity04 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity05 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity06 = new PowerCurveNewApplication_Req_IB_v1.Entity01(); */


        //01 for main client
        requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTTYPE = '03101';
		requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTCODE1 = 'KHCC 001';
		requestBean.Request.ApplicationDV.Entity01.INTENTNONRESIDENT = 'N';
		requestBean.Request.ApplicationDV.Entity01.APPENTSHAREHOLDINGPERC = '0.00';
		//requestBean.Request.ApplicationDV.Entity01.INTENTMARITALSTATUS = '0';
		//requestBean.Request.ApplicationDV.Entity01.INTENTMARITALCONTRACT = '0';
		requestBean.Request.ApplicationDV.Entity01.INTENTWRSTRISKGRADE = '0';

		requestBean.Request.ApplicationDV.Entity01.INTENTEXPO = new PowerCurveNewApplication_Req_IB_v1.INTENTEXPO();
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.TOTALDIRECTEXPOSURE = '0';
		requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.TOTALEXPOSURE = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.CONTINGENTLIABILITY = '0';
        //coming as string in New
        /*requestBean.Request.ApplicationDV.Entity01.APPENTEXPO = new PowerCurveNewApplication_Req_IB_v1.APPENTEXPO();
        requestBean.Request.ApplicationDV.Entity01.APPENTEXPO.SETTLEMENTLIMITS = '0';
        requestBean.Request.ApplicationDV.Entity01.APPENTEXPO.APPRFACILITIESODNONSCR = '0';
        requestBean.Request.ApplicationDV.Entity01.APPENTEXPO.APPRFACILITIESAFINNONSCR = '0';
        requestBean.Request.ApplicationDV.Entity01.APPENTEXPO.APPRFACILITIESMLNONSCR = '0'; */

        requestBean.Request.ApplicationDV.Entity01.INTENTCMTM = new PowerCurveNewApplication_Req_IB_v1.INTENTCMTM();
		requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCECHEQS = '0';
		requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCESAVINGS = '0';
		requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCENOTICEDEPOSITS = '0';
		requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCETERMDEPOSITS = '0';
		requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCECUSTINVESTMENTS = '0';
		requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCECASHCOVER = '0';
		requestBean.Request.ApplicationDV.Entity01.INTENTARRS = new PowerCurveNewApplication_Req_IB_v1.INTENTARRS();
		requestBean.Request.ApplicationDV.Entity01.INTENTEXCS = new PowerCurveNewApplication_Req_IB_v1.INTENTEXCS();
		//requestBean.Request.ApplicationDV.Entity01.INTENTINST = new PowerCurveNewApplication_Req_IB_v1.INTENTINST();
        requestBean.Request.ApplicationDV.Entity01.INTENTLMTS = new PowerCurveNewApplication_Req_IB_v1.INTENTLMTS();

        requestBean.Request.ApplicationDV.Entity01.INTENTTRID = new PowerCurveNewApplication_Req_IB_v1.INTENTTRID();
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MNTHSOLDESTCUSTREL = '5';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MNTHSOLDESTACCREL = '999';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MNTHSOLDESTCHACCREL = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MNTHSOLDESTSAVACCREL = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXCLUSIONTYPE = 'N';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXCLUSIONCREDITFACILITY = '99';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCORECUSTALIGN = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCORECHEQ = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCORECC = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCOREMORTG = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCOREAVAF = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCORELOANS = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXPECTEDCREDTURNOVCHEQ = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXPECTEDCREDTURNOVCUST = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AVGCTOL3ML6M = '0.00';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AVGCTOL6ML12M = '0.00';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMDAYSCREDITINL6M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMDAYSDEBITINL6M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMDEBITSL6M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMMNTHSEXCESSBALL6M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MAXCONSECDAYSINEXCESS = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MAXOCSCORINGMANDATE = '200000';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AOL = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.ACCL = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AMLR = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.ABRA = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AMMR = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AMR = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMRDEVENTSSAVL3M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMRDEVENTSSAVL6M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMRDEVENTSCHEQL3M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMRDEVENTSCHEQL6M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.TOTSAVRETPAYMNTSL6M = '0';
        requestBean.Request.ApplicationDV.Entity01.INTENTTRID.TOTCHEQRETPAYMNTSL6M = '0';

        //coming as string
        /*requestBean.Request.ApplicationDV.Entity01.APPENTAPRF = new PowerCurveNewApplication_Req_IB_v1.APPENTAPRF();
        requestBean.Request.ApplicationDV.Entity01.APPENTAPRF.INSTORDCREDNONSCORED = '0';
        requestBean.Request.ApplicationDV.Entity01.APPENTAPRF.INSTASSETFINNONSCORED = '0';
		requestBean.Request.ApplicationDV.Entity01.APPENTAPRF.INSTMLOANNONSCORED = '0';*/

		requestBean.Request.ApplicationDV.Entity01.INTENTUNDERDEBTCOUNSELLING = 'N';
        //requestBean.Request.ApplicationDV.Entity01.INTENTINLIQUIDATION = 'N';

        requestBean.Request.ApplicationDV.Entity01.INTENTRDET = new PowerCurveNewApplication_Req_IB_v1.INTENTRDET();
        //requestBean.Request.ApplicationDV.Entity01.INTENTRDET.WRSTCOLLRISKTYPE = '';
        requestBean.Request.ApplicationDV.Entity01.INTENTRDET.WRSTARMSHOLD = '';
        //requestBean.Request.ApplicationDV.Entity01.INTENTRDET.EWLLISTING = '0';

        //requestBean.Request.ApplicationDV.Entity01.INTENTSECE = new PowerCurveNewApplication_Req_IB_v1.INTENTSECE();
        //requestBean.Request.ApplicationDV.Entity01.INTENTSECE.SURETYSHIPIFOAPPLICANT = '';

        //requestBean.Request.ApplicationDV.Entity01.APPENTFNST = new PowerCurveNewApplication_Req_IB_v1.APPENTFNST();
        //requestBean.Request.ApplicationDV.Entity01.APPENTFNST.AVAILABLE = 'N';
        //requestBean.Request.ApplicationDV.Entity01.APPENTFNST.SOLEFULLAVAILABLE = 'N';

        //requestBean.Request.ApplicationDV.Entity01.APPENTASLB = new PowerCurveNewApplication_Req_IB_v1.APPENTASLB();
        //requestBean.Request.ApplicationDV.Entity01.APPENTASLB.AVAILABLE = 'N';

        requestBean.Request.ApplicationDV.Entity01.INTENTBUR = new PowerCurveNewApplication_Req_IB_v1.INTENTBUR();
        requestBean.Request.ApplicationDV.Entity01.INTENTBUR.COMMINPREGNUMBER = '199303044823';
        /*
		requestBean.Request.ApplicationDV.Entity01.INTENTINSOLVENT = 'N';
		requestBean.Request.ApplicationDV.Entity01.APPENTINTENTIONTOINSOLVENCY = 'N';
		requestBean.Request.ApplicationDV.Entity01.APPENTTIME = '';
		requestBean.Request.ApplicationDV.Entity01.INTENTCDUCTDAYSSNCELASTCREDIT = '-6';
		requestBean.Request.ApplicationDV.Entity01.APPENTIDTYPE = '05';
		requestBean.Request.ApplicationDV.Entity01.APPENTEVERDECLINSOLVENT = 'N'; */

        //will have to confirm what is minimum  set of fields to make it work, Mapping dummy values for fields i know
        //Product Section
        requestBean.Request.ApplicationDV.RequestedProducts01 = new PowerCurveNewApplication_Req_IB_v1.RequestedProducts01();
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF = new PowerCurveNewApplication_Req_IB_v1.APPPRDNEWF();
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQPRODUCT = 'CHQ';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQFACILITYTYPE = '1';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQPRODTYPE = '11016';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQTOTALAMNT = '10000';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQLIMIT = '10000';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQODLIMITTYPE = '2';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQPURPOSEFACILITYORLOAN = '11';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQINSTALLMENTFREQ = '0';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQINITIATIONFEEPAYMNTMETHOD = 'D';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQREQEMPOWERMNTFUNDIND = 'N';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQREQEMPOWERMNTFUND = '';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQCAMPAIGNCODE = '';
        //requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.NCAAPPLICABLE = 'Y';
        //requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.NCAAGREEMENTCAT = 'S';
        requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.SECUREDBYMORTGAGEBOND = 'N';
        //requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.JURISTICIND = 'Y';

		//requestBean.Request.ApplicationDV.RequestedProducts01.INTPRDNEWF = '';
        //requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDSECO = new PowerCurveNewApplication_Req_IB_v1.APPPRDSECO();



        return requestBean;
    }


   /* public override void setIntegrationTranslations() {
        integrationTranslationsMap = new Map<String, String>();
                                                       //integrationTranslationsMap.put('BAPI_SF_DO_CHG.ZDEBIT_ORDER', 'PowerCurve;Overdraft Limit Type');
                                                       integrationTranslationsMap.put('BAPI_SF_DO_CHG.ZDEBIT_ORDER', 'PowerCurve;Product');
                                                       integrationTranslationsMap.put('BAPI_SF_DO_CHG.ZDEBIT_ORDER', 'PowerCurve;Debit Order Type');
                                                       integrationTranslationsMap.put('BAPI_SF_DO_CHG.ZDEBIT_ORDER', 'PowerCurve;Debit Order Type');
                                                      } */

}


/* We may have to add below Values in Existing Products Section once we know Data Type
 * I have copied from XML Now
 *        IntPrdExstProduct
      IntPrdExstProductType
      IntPrdExstCurrSubprodType
      IntPrdExstCurrBalance
      IntPrdExstCurrInstallment
      IntPrdExstCurrLimit
      IntPrdExstCurrIntRatePrimeOffset
      IntPrdExstCurrReductionAmnt
      IntPrdExstCurrReductionFreq
      IntPrdExstCurrOnceOffReduction
      IntPrdExstCurrInstalmntFreq
      IntPrdExstCurrSettlementAmnt
      IntPrdExstCurrExistEmpowermntFundInd
      IntPrdExstCurrExistEmpowermntFund
      IntPrdExstCurrInitFeePrevDebited
      IntPrdExstNcaMaxInitFeeAmnt
      IntPrdExstAccountNumber
      IntPrdExstEspInstruction
      IntPrdExstCardType
      AppPrdExstApplicationStatus
      AppPrdExstReqFacilityType
      AppPrdExstReqProdType
      AppPrdExstReqSubprodType
      AppPrdExstReqAdditionalAmnt
      AppPrdExstReqTotalAmnt
      AppPrdExstReqOdLimitType
      AppPrdExstReqReductionAmnt
      AppPrdExstReqReductionFreq
      AppPrdExstReqOnceOffFreqAmnt
      AppPrdExstReqRepaymntOption
      AppPrdExstReqPurposeFacilityOrLoan
      AppPrdExstReqTermOfLoan
      AppPrdExstReqInstallmentFreq
      AppPrdExstReqNumSkippedPaymnts
      AppPrdExstReqInitiationFeePaymntMethod
      AppPrdExstReqPaymntMethod
      AppPrdExstReqCredlifePremium
      AppPrdExstReqReqEmpowermntFundInd
      AppPrdExstReqReqEmpowermntFund
      AppPrdExstReqLimitTypeInd
      AppPrdExstReqProdCombinationNum
      AppPrdExstReqCampaignCode

*/