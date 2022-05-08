/*
 * Integration Request Bean for PowerCurveUpdateApplication Service
 * @author Saurabh Pandey
 * @created 2020-11-17
 * Modified on 2020-12-29
 */

public class PowerCurveUpdateApplication_Req_IB_v1 extends Base_IB{
    
    
    
      public class Fault {
        public string faultcode;
        public string faultstring;   
        }
   //adding as per the extensive JSON from WSDL
      public class RequestedProducts01 {
        public APPPRDNEWF APPPRDNEWF;
        public INTPRDNEWF INTPRDNEWF;
        public APPPRDSECO APPPRDSECO;
        public DERPRDNEWF DERPRDNEWF;
        public String SANCTIONERMANDATENUMBER;
        public String PRICINGMANDATENUMBER;
    }

    public class APPENTAPRF {
        public String INSTORDCREDNONSCORED;
        public String INSTASSETFINNONSCORED;
        public String INSTMLOANNONSCORED;
    }

    public class APPAPPQUAL {
        public String CHANGEKEYMNGMNTL12M;
        public String CHANGEBUSDIRECTION;
        public String EXPINCREASEL6TO12M;
        public String ARREARSSARS;
        public String ACCOTHERBANK;
        public String DISPUTEBETWEENPARTIES;
        public String PREVIOUSWOFFBUSFAILURE;
        public String OTHERNEGKNOWLEDGE;
        public String DEBTORBOOKFUNDING;
        public String RESUPPORTAPPLICATION;
    }

    public Request Request;

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

    public class APPAPPWCRM {
        public String AVAILABLE;
        public String TIMSNCECAPTURE;
        public String PITPD;
        public String PITDG;
        public String TTCPD;
        public String TTCDG;
    }

    public class APPAPPMIAE {
        public String INCGROSSAPL;
        public String INCGROSSSPSE;
        public String INCGROSSHH;
        public String INCNETAPL;
        public String INCNETSPSE;
        public String INCNETHH;
        public String STATDEDMAINTAPL;
        public String STATDEDMAINTSPSE;
        public String STATDEDOTHERAPL;
        public String STATDEDOTHERSPSE;
        public String INCMAINTAPL;
        public String INCMAINTSPSE;
        public String EXPMAINTAPL;
        public String EXPMAINTSPSE;
        public String INSTEXTDECLAPL;
        public String INSTEXTDECLSPSE;
        public String INSTABSAAPL;
        public String INSTABSASPSE;
        public String INSTCBURNONABSAAPL;
        public String INSTCBURNONABSASPSE;
        public String EXPACCOMMODATION;
        public String EXPFOOD;
        public String EXPTRANSPORT;
        public String EXPEDUCATION;
        public String EXPMEDICAL;
        public String EXPWATERELECTRICITY;
        public String EXPINSURANCE;
        public String EXPOTHER;
        public String EXPTOTALDECL;
        public String INCDISCRETDECL;
        public String INSTEXTADJAPL;
        public String INSTEXTADJSPSE;
        public String EXPTOTALDECLADJ;
        public String INCDISCRETDECLADJ;
        public String EXPDOMESTICWAGES;
        public String EXPTELECOMMS;
        public String EXPENTERTAINMENT;
        public String EXPMULTICHOICE;
        public String EXPSECURITY;
        public String EXPTAX;
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
        public String APPENTINTENTIONTOLIQUIDATE;
        public String INTENTUNDERJUDICIALMNGMNT;
        public String INTENTFRAUDRISKMNGMNT;
        public INTENTRDET INTENTRDET;
        public INTENTSECE INTENTSECE;
        public APPENTFNST APPENTFNST;
        public APPENTASLB APPENTASLB;
        public APPENTBUR APPENTBUR;
        public INTENTBUR INTENTBUR;
        public String INTENTFINANCIALCRIMEHOLD;
        public String INTENTINSOLVENT;
        public String APPENTINTENTIONTOINSOLVENCY;
        public APPENTTIME APPENTTIME;
        public String APPENTAGEOLDESTRELATIONSHIP;
        public String INTENTCDUCTDAYSSNCELASTCREDIT;
        public String INTENTPARTOFCREDITGROUP;
        public String APPENTIDTYPE;
        public String APPENTTEMPPERMITNUM;
        public String APPENTGENDER;
        public String APPENTHOMECELLNUM;
        public String APPENTWORKADDRLINE1;
        public String APPENTWORKADDRLINE2;
        public String APPENTWORKADDRSUBURB;
        public String APPENTWORKADDRCITY;
        public String APPENTWORKADDRPCODE;
        public String APPENTPASSPORTNATIONALITY;
        public String APPENTEMAIL;
        public String APPENTRESIDENTIALSTATUS;
        public String APPENTGROSSINCOME;
        public String APPENTINCOMETAXNUM;
        public String APPENTAPPLCATEGORY;
        public String APPENTEVERDECLINSOLVENT;
        public String INTENTBURCOMMNOPOSSIBLEMATCH;
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
        public String CURRENFORCEDREDLIM;
        public String SECUREDBYMORTGAGEBOND;
    }

    public class ExistingProducts01 {
        public INTPRDEXST INTPRDEXST;
        public APPPRDEXST APPPRDEXST;
        public INTPRDSECE INTPRDSECE;
        public APPPRDSECO APPPRDSECO;
        public DERPRDEXST DERPRDEXST;
        public String SANCTIONERMANDATENUMBER;
        public String PRICINGMANDATENUMBER;
    }

    public class INTENTSECE {
        public String SURETYSHIPIFOAPPLICANT;
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
        public String INITIATIONFEEPAYMNTMETHOD;
        public String NCAAPPLICABLE;
        public String NCAAGREEMENTCAT;
        public String SECUREDBYMORTGAGEBOND;
        public String INSTSETTLEMENTS;
        public String JURISTICIND;
        public String ACCOUNTNUMBER;
        public String ESPINSTRUCTION;
        public String CARDTYPE;
        public String SETTLEMENTSAMNT;
        public String UNIQUEPRODID;
    }

    public class APPAPPBSTM {
        public String PERIOD;
        public String NUMRDITEMS;
        public String MINBALANCE;
        public String ODLIMITS;
        public String TURNOVER;
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
        public String INITIATIONFEEPAYMNTMETHOD;
        public String NCAAPPLICABLE;
        public String NCAAGREEMENTCAT;
        public String JURISTICIND;
    }

    public class APPENTEXPO {
        public String SETTLEMENTLIMITS;
        public String APPRFACILITIESODNONSCR;
        public String APPRFACILITIESAFINNONSCR;
        public String APPRFACILITIESMLNONSCR;
    }

    public class APPENTBUR {
        public String CONSINPSNAME;
        public String CONSINPFNAME1;
        public String CONSINPFNAME2;
        public String CONSINPDOB;
        public String CONSINPNATID;
        public String CONSINPRESADDR1;
        public String CONSINPRESADDR2;
        public String CONSINPRESSUBURB;
        public String CONSINPRESCTY;
        public String CONSINPRESPOSTCDE;
        public String CONSINPPSTADDR1;
        public String CONSINPPSTSUBURB;
        public String CONSINPPSTCTY;
        public String CONSINPPSTPOSTCDE;
        public String CONSINPOCC;
        public String CONSINPEMP;
        public String CONSINPHMPHN;
        public String CONSINPHMPHNCDE;
        public String CONSINPWRKPHN;
        public String CONSINPWRKPHNCDE;
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
        public APPAPPEXTR APPAPPEXTR;
        public APPAPPBSTM APPAPPBSTM;
        public INTAPPSECE INTAPPSECE;
        public APPAPPSECO APPAPPSECO;
        public APPAPPWCRM APPAPPWCRM;
        public INTAPPABSA INTAPPABSA;
        public String APPAPPSECUREDBYMORTGAGEBOND;
        public APPAPPQUAL APPAPPQUAL;
        public APPAPPMIAE APPAPPMIAE;
        public String APPAPPPRINCIPALSDELINKED;
        public String APPAPPPREVIOUSSYSTEMDECLINE;
        public String APPAPPPREVIOUSMANDATEDECLINE;
        public String APPAPPSPSESPOUSEDETAILSAVAILABLE;
        public String APPAPPBORROWINGPOWERS;
        public String APPAPPDAYSLASTDECLINE;
    }

    public class ApplicationDV {
        public String APPAPPAPPLICATIONDATE;
        public String APPAPPAPPLICATIONNUMBER;
        public String DERPCOUNIQUENUMBER;
        public String APPAPPAPPLICATIONTIME;
        public String APPAPPAPPLICATIONTYPE;
        public String APPAPPSTAGEID;
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
        public String APPAPPCREDITREFERDATE;
        public String APPAPPCREDITREFERTIME;
        public String APPAPPPRICINGREFERDATE;
        public String APPAPPPRICINGREFERTIME;    


        public AppData AppData;
        public Entity01 Entity01;
        public Entity01 Entity02;
        public Entity01 Entity03;
        public Entity01 Entity04;
        public Entity01 Entity05;
        public Entity01 Entity06;
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
        public String APPAPPREFERRALCOUNTER;
    }

    public class DERPRDEXST {
        public String FINALADDITIONALAMNT;
        public String FINALTOTALAMNT;
        public String FINALREDUCTIONAMNT;
        public String FINALREDUCTIONFREQ;
        public String FINALREDUCTIONPERIOD;
        public String FINALONCEOFFREDUCTIONAMNT;
        public String FINALREPAYMNTOPTION;
        public String FINALTERMOFLOAN;
        public String FINALINSTALMENTFREQ;
        public String FINALINSTALMENT;
        public String FINALINTRATE;
        public String FINALSERVICEFEE;
        public String FINALPRODTYPE;
        public String FINALSUBPRODTYPE;
        public String FINALODLIMITTYPE;
        public String FINALINITFEEAMOUNT;
        public String FINALREPAYMENTMETHOD;
        public String FINALREVCREDITOPTION;
        public String FINALINTRATEPRIMEPLUS;
        public String FINALFACILITYFEE;
        public String FINALINTRATEFACILITYFEEPERC;
        public String FINALDECISION;
        public String FINALDECDATE;
        public String FINALDECTIME;
    }

    public class INTENTEXPO {
        public String ORDCRED;
        public String ORDCREDOTHER;
        public String ASSETFINANCE;
        public String MORTGRES;
        public String MORTGCPF;
        public String MORTGAGRI;
        public String MORTGTOTAL;
        public String TOTALDIRECTEXPOSURE;
        public String TOTALEXPOSURE;
        public String RECOVERYEXPOSURE;
        public String CONTINGENTLIABILITY;
        public String DM9CARDHOLDCODE;
        public String DM9RECOVERYEXPOSURE;
    }

    public class INTENTBUR {
        public String COMMINPKIMNUMBER;
        public String COMMINPVATNUMBER;
        public String COMMINPTRADINGNAME;
        public String COMMINPBUSNAME;
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

    public class APPENTFNST {
        public String AVAILABLE;
        public String SOLEFULLAVAILABLE;
        public String TYPE_Z; // in json: TYPE
        public String PERIODOFINCSTAT;
        public String TMSNCE;
        public String TMSNCECERTDATE;
        public String QUALIFIED;
        public String TURNOVER;
        public String PROJTURNOVER;
        public String NETWORTH;
        public String TOTALASSETS;
        public String SALESGROWTHPERC;
        public String NETPROFITPERC;
        public String LIABSHAREHFUNDS;
        public String ASSINTANGIBLES;
        public String LIABLOANSFROMPRCEDED;
        public String LIABLOANSTOPR;
        public String GROSSPROFIT;
        public String PROFITNET;
        public String RETAINEDEARNINGS;
        public String PROFITBEFORETAX;
        public String LIABLOANTOINSIDEPARTIES;
        public String LIABLOANFROMOTHINSTITUTIONS;
        public String LIABTOTCURRLIAB;
        public String LIABTOTSTOCK;
        public String LIABTOTLONGTERMDEBT;
        public String CURRENTRATIO;
        public String GROSSPROFITPERC;
        public String ACIDTEST;
        public String IBDTOEQUITY;
        public String IBDTOEBITDA;
        public String LONGTERMDEBTTOEBITDA;
        public String ICR;
        public String TOTALASSETTURNOVER;
        public String OPERATINGPROFITMARGIN;
        public String EBITDA;
    }

    public class APPENTASLB {
        public String NETWORTHCREDIT;
        public String NETWORTHME;
        public String TOTALPROPERTIES;
        public String DEEDSSEARCHAVAILABLE;
        public String NOTARIALBOND;
        public String AVAILABLE;
        public String NETWORTH;
    }

    public class DERPRDNEWF {
        public String FINALADDITIONALAMNT;
        public String FINALTOTALAMNT;
        public String FINALREDUCTIONAMNT;
        public String FINALREDUCTIONFREQ;
        public String FINALREDUCTIONPERIOD;
        public String FINALONCEOFFREDUCTIONAMNT;
        public String FINALREPAYMNTOPTION;
        public String FINALTERMOFLOAN;
        public String FINALINSTALMENTFREQ;
        public String FINALINSTALMENT;
        public String FINALINTRATE;
        public String FINALSERVICEFEE;
        public String FINALPRODTYPE;
        public String FINALSUBPRODTYPE;
        public String FINALODLIMITTYPE;
        public String FINALINITFEEAMOUNT;
        public String FINALREPAYMENTMETHOD;
        public String FINALREVCREDITOPTION;
        public String FINALDECISION;
        public String FINALINTRATEPRIMEPLUS;
        public String FINALFACILITYFEE;
        public String FINALDECDATE;
        public String FINALDECTIME;
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
        public String WRSTDM9CODE;
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

    public class INTAPPABSA {
        public String NUMBEROFPRODUCTS;
        public String CHQACCRELATIONSHIP;
    }

    public class INTAPPSECE {
        public String SPECASVALL;
        public String SPECASVACCSSETTLE;
        public String APPRSECVALUE;
        public String CASHCOVER;
        public String ASVOC;
        public String MASV;
        public String MASVAGRI;
        public String PERCNORMCHANGED;
        public String CESSIONDEBTORS;
        public String OUSTANDINGSEC;
    }

    public class APPAPPSECO {
        public String ASVOFFERED;
        public String SUPPORTINGNONSPECIFIC;
        public String SUPPORTINGSPECIFIC;
        public String ASVADDOFFERED;
    }

    public class APPPRDSECO {
        public String SPECIFIC;
        public String SUPPORTINGSPECIFIC;
    }

    public class INTPRDSECE {
        public String SPECASVFULL;
        public String SPECASVLIMITED;
    }

    public class APPAPPEXTR {
        public String CHEQACC;
        public String INVAMNT;
        public String SAVAMNT;
        public String CARDAMNT;
        public String ASSETAMNT;
        public String MLOANAMNT;
        public String CHEQAMNT;
        public String TLNACC;
        public String INVACC;
        public String SAVACC;
        public String CARDACC;
        public String ASSETACC;
        public String MLOANACC;
    }
    

    public static PowerCurveUpdateApplication_Req_IB_v1 createDummyRequest() {
       PowerCurveUpdateApplication_Req_IB_v1 requestBean = new PowerCurveUpdateApplication_Req_IB_v1();
        requestBean.Request = new PowerCurveUpdateApplication_Req_IB_v1.Request();
        requestBean.Request.ApplicationDV = new PowerCurveUpdateApplication_Req_IB_v1.ApplicationDV();
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONDATE = '2020-07-15';
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONNUMBER = '';
        requestBean.Request.ApplicationDV.DERPCOUNIQUENUMBER = '';
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTIME='';
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTYPE='';
        requestBean.Request.ApplicationDV.APPAPPSTAGEID='';
        requestBean.Request.ApplicationDV.INTAPPBRANCHCODE='';
        requestBean.Request.ApplicationDV.INTAPPOVERALLCONTROLBRANCH='';
        requestBean.Request.ApplicationDV.INTAPPBUSINESSSEGMENT='';
        requestBean.Request.ApplicationDV.INTAPPBUSINESSSUBSEGMENT='';
        requestBean.Request.ApplicationDV.INTAPPSICCODE='';
        requestBean.Request.ApplicationDV.APPAPPTRADINGINDICATOR='';
        requestBean.Request.ApplicationDV.APPAPPFOREIGNCONTROLLEDPERC='';
        requestBean.Request.ApplicationDV.INTAPPENTERPRDEVFUNDEXISTING='';
        requestBean.Request.ApplicationDV.APPAPPENTERPRDEVFUNDREQ='';
        requestBean.Request.ApplicationDV.APPAPPSTOKVELAPPLICATION='';
        requestBean.Request.ApplicationDV.INTAPPEXISTINGFRANCHISEFINANCING='';
        requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISEFINANCING='';
        requestBean.Request.ApplicationDV.INTAPPEXISTINGFRANCHISORTYPE='';
        requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISORTYPE='';
        requestBean.Request.ApplicationDV.APPAPPFORMALAPPINDICATOR='';
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONSTATUS='';
        requestBean.Request.ApplicationDV.APPAPPAPPLICATIONSUBSTATUS='';
        requestBean.Request.ApplicationDV.APPAPPESPINSTRUCTION='';
        requestBean.Request.ApplicationDV.APPAPPEXTRTLAMNT='';
        requestBean.Request.ApplicationDV.APPBANKERNUMBER='';
        requestBean.Request.ApplicationDV.APPAPPCREDITREFERDATE='';
        requestBean.Request.ApplicationDV.APPAPPCREDITREFERTIME='';
        requestBean.Request.ApplicationDV.APPAPPPRICINGREFERDATE='';
        requestBean.Request.ApplicationDV.APPAPPPRICINGREFERTIME='';    
        requestBean.Request.ApplicationDV.APPAPPREFERRALCOUNTER ='';
        
        //AppData
        requestBean.Request.ApplicationDV.AppData = new PowerCurveUpdateApplication_Req_IB_v1.AppData();
        requestBean.Request.ApplicationDV.AppData.APPAPPNUMKEYPRINCIPALS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPNUMCOREPRINCIPALS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPNONRESPRINCIPALS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPNUMPARTICIPANTS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMNTHSSINCEBUSESTABLISHED='';
        requestBean.Request.ApplicationDV.AppData.INTAPPAFFECTEDPERSREG31F='';
        requestBean.Request.ApplicationDV.AppData.APPAPPSECUREDBYMORTGAGEBOND ='';
        requestBean.Request.ApplicationDV.AppData.APPAPPPRINCIPALSDELINKED='';
        requestBean.Request.ApplicationDV.AppData.APPAPPPREVIOUSSYSTEMDECLINE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPPREVIOUSMANDATEDECLINE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPSPSESPOUSEDETAILSAVAILABLE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPBORROWINGPOWERS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPDAYSLASTDECLINE='';
        
        //ApplicationExposure 
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPEXPO();
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.POLICYIND='';
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGAE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGBE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGOE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TOTALGROUPEXPOSURE='';
        
        //INTAPPTOT
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPTOT();
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.INSTSETTLEMENTS='';
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.LOANREQ='';
        requestBean.Request.ApplicationDV.AppData.INTAPPTOT.SETTLEMENTSAMNT='';
        
        //INTAPPNCAP
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPNCAP();
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESFIRST='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESNEXTPERC='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESMAX='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESTHRESHOLD='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAMAXSERVICEFEES='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINTERESTRATE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESFIRST='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESNEXTPERC='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESMAX='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESTHRESHOLD='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAMAXSERVICEFEES='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINTERESTRATE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESFIRST='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESNEXTPERC='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESMAX='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESTHRESHOLD='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTMAXSERVICEFEES='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINTERESTRATE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESFIRST='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESNEXTPERC='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESMAX='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESTHRESHOLD='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAMAXSERVICEFEES='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINTERESTRATE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESFIRST='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESNEXTPERC='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESMAX='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESTHRESHOLD='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTMAXSERVICEFEES='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINTERESTRATE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.PRIMERATE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.REPORATE= '';
        
        //INTAPPCCLP
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPCCLP(); 
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.TLCREDITLIFEMINAMNT='';
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.TLCREDITLIFEMAXAMNT='';
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.ODCREDITLIFEMINAMNT='';
        requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.ODCREDITLIFEMAXAMNT='';
        
        //APPAPPEXTR
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPEXTR();
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.CHEQACC='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.INVAMNT='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.SAVAMNT='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.CARDAMNT='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.ASSETAMNT='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.MLOANAMNT='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.CHEQAMNT='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.TLNACC='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.INVACC='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.SAVACC='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.CARDACC='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.ASSETACC='';
        requestBean.Request.ApplicationDV.AppData.APPAPPEXTR.MLOANACC='';
        
        //APPAPPBSTM
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPBSTM();
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.PERIOD='';
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.NUMRDITEMS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.MINBALANCE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.ODLIMITS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPBSTM.TURNOVER= '';
        
        //INTAPPSECE
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPSECE();
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.SPECASVALL='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.SPECASVACCSSETTLE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.APPRSECVALUE='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.CASHCOVER='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.ASVOC='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.MASV='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.MASVAGRI='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.PERCNORMCHANGED='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.CESSIONDEBTORS='';
        requestBean.Request.ApplicationDV.AppData.INTAPPSECE.OUSTANDINGSEC='';
        
        //APPAPPSECO
        requestBean.Request.ApplicationDV.AppData.APPAPPSECO = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPSECO();
        requestBean.Request.ApplicationDV.AppData.APPAPPSECO.ASVOFFERED='';
        requestBean.Request.ApplicationDV.AppData.APPAPPSECO.SUPPORTINGNONSPECIFIC='';
        requestBean.Request.ApplicationDV.AppData.APPAPPSECO.SUPPORTINGSPECIFIC='';
        requestBean.Request.ApplicationDV.AppData.APPAPPSECO.ASVADDOFFERED='';
        
        //APPAPPWCRM
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPWCRM();
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.AVAILABLE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.TIMSNCECAPTURE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.PITPD='';
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.PITDG='';
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.TTCPD='';
        requestBean.Request.ApplicationDV.AppData.APPAPPWCRM.TTCDG='';
        
        //INTAPPABSA
        requestBean.Request.ApplicationDV.AppData.INTAPPABSA = new PowerCurveUpdateApplication_Req_IB_v1.INTAPPABSA();
        requestBean.Request.ApplicationDV.AppData.INTAPPABSA.NUMBEROFPRODUCTS='';
        requestBean.Request.ApplicationDV.AppData.INTAPPABSA.CHQACCRELATIONSHIP='';
        
        //APPAPPQUAL
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL = new PowerCurveUpdateApplication_Req_IB_v1.APPAPPQUAL();
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.CHANGEKEYMNGMNTL12M='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.CHANGEBUSDIRECTION='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.EXPINCREASEL6TO12M='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.ARREARSSARS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.ACCOTHERBANK='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.DISPUTEBETWEENPARTIES='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.PREVIOUSWOFFBUSFAILURE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.OTHERNEGKNOWLEDGE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.DEBTORBOOKFUNDING='';
        requestBean.Request.ApplicationDV.AppData.APPAPPQUAL.RESUPPORTAPPLICATION='';
        
        //APPAPPMIAE
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE =  new PowerCurveUpdateApplication_Req_IB_v1.APPAPPMIAE();
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSSPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCGROSSHH='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETSPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCNETHH='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDMAINTAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDMAINTSPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDOTHERAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.STATDEDOTHERSPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCMAINTAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCMAINTSPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMAINTAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMAINTSPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTDECLAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTDECLSPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTABSAAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTABSASPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTCBURNONABSAAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTCBURNONABSASPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPACCOMMODATION='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPFOOD='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTRANSPORT='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPEDUCATION='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMEDICAL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPWATERELECTRICITY='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPINSURANCE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPOTHER='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTOTALDECL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCDISCRETDECL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTADJAPL='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INSTEXTADJSPSE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTOTALDECLADJ='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.INCDISCRETDECLADJ='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPDOMESTICWAGES='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTELECOMMS='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPENTERTAINMENT='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPMULTICHOICE='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPSECURITY='';
        requestBean.Request.ApplicationDV.AppData.APPAPPMIAE.EXPTAX='';
        
        requestBean.Request.ApplicationDV.Entity01 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
        requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTTYPE='';
        requestBean.Request.ApplicationDV.Entity01.APPENTAGE='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTCODE1='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTCODE2='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTCODE3='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTCODE4='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTCODE5='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCLIENTCODE6='';
        requestBean.Request.ApplicationDV.Entity01.INTENTNUMPARTICIPANTS1='';
        requestBean.Request.ApplicationDV.Entity01.INTENTNUMPARTICIPANTS2='';
        requestBean.Request.ApplicationDV.Entity01.INTENTNUMPARTICIPANTS3='';
        requestBean.Request.ApplicationDV.Entity01.INTENTNUMPARTICIPANTS4='';
        requestBean.Request.ApplicationDV.Entity01.INTENTNUMPARTICIPANTS5='';
        requestBean.Request.ApplicationDV.Entity01.INTENTNUMPARTICIPANTS6='';
        requestBean.Request.ApplicationDV.Entity01.INTENTNONRESIDENT='';
        requestBean.Request.ApplicationDV.Entity01.APPENTSHAREHOLDINGPERC='';
        requestBean.Request.ApplicationDV.Entity01.APPENTMNTHSSHAREHOLDINGPERC='';
        requestBean.Request.ApplicationDV.Entity01.INTENTMARITALSTATUS='';
        requestBean.Request.ApplicationDV.Entity01.INTENTMARITALCONTRACT='';
        requestBean.Request.ApplicationDV.Entity01.INTENTWRSTRISKGRADE='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCECHEQS='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCESAVINGS='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCENOTICEDEPOSITS='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCETERMDEPOSITS='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCECUSTINVESTMENTS='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCTBALANCECASHCOVER='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCDUCTMAINPYTURNOVER='';
        requestBean.Request.ApplicationDV.Entity01.INTENTHIGHLEVELLIMITINDICATOR='';
        requestBean.Request.ApplicationDV.Entity01.INTENTUNDERDEBTCOUNSELLING='';
        requestBean.Request.ApplicationDV.Entity01.INTENTINLIQUIDATION='';
        requestBean.Request.ApplicationDV.Entity01.APPENTINTENTIONTOLIQUIDATE='';
        requestBean.Request.ApplicationDV.Entity01.INTENTUNDERJUDICIALMNGMNT='';
        requestBean.Request.ApplicationDV.Entity01.INTENTFRAUDRISKMNGMNT='';
        requestBean.Request.ApplicationDV.Entity01.APPENTAGEOLDESTRELATIONSHIP='';
        requestBean.Request.ApplicationDV.Entity01.INTENTCDUCTDAYSSNCELASTCREDIT='';
        requestBean.Request.ApplicationDV.Entity01.INTENTPARTOFCREDITGROUP='';
        requestBean.Request.ApplicationDV.Entity01.APPENTIDTYPE='';
        requestBean.Request.ApplicationDV.Entity01.APPENTTEMPPERMITNUM='';
        requestBean.Request.ApplicationDV.Entity01.APPENTGENDER='';
        requestBean.Request.ApplicationDV.Entity01.APPENTHOMECELLNUM='';
        requestBean.Request.ApplicationDV.Entity01.APPENTWORKADDRLINE1='';
        requestBean.Request.ApplicationDV.Entity01.APPENTWORKADDRLINE2='';
        requestBean.Request.ApplicationDV.Entity01.APPENTWORKADDRSUBURB='';
        requestBean.Request.ApplicationDV.Entity01.APPENTWORKADDRCITY='';
        requestBean.Request.ApplicationDV.Entity01.APPENTWORKADDRPCODE='';
        requestBean.Request.ApplicationDV.Entity01.APPENTPASSPORTNATIONALITY='';
        requestBean.Request.ApplicationDV.Entity01.APPENTEMAIL='';
        requestBean.Request.ApplicationDV.Entity01.APPENTRESIDENTIALSTATUS='';
        requestBean.Request.ApplicationDV.Entity01.APPENTGROSSINCOME='';
        requestBean.Request.ApplicationDV.Entity01.APPENTINCOMETAXNUM='';
        requestBean.Request.ApplicationDV.Entity01.APPENTAPPLCATEGORY='';
        requestBean.Request.ApplicationDV.Entity01.APPENTEVERDECLINSOLVENT='';
        requestBean.Request.ApplicationDV.Entity01.INTENTBURCOMMNOPOSSIBLEMATCH='';
        
        //INTENTEXPO 
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO = new PowerCurveUpdateApplication_Req_IB_v1.INTENTEXPO();
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.ORDCRED='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.ORDCREDOTHER='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.ASSETFINANCE='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.MORTGRES='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.MORTGCPF='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.MORTGAGRI='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.MORTGTOTAL='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.TOTALDIRECTEXPOSURE='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.TOTALEXPOSURE='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.RECOVERYEXPOSURE='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.CONTINGENTLIABILITY='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.DM9CARDHOLDCODE='';
        requestBean.Request.ApplicationDV.Entity01.INTENTEXPO.DM9RECOVERYEXPOSURE='';
        
        //APPENTEXPO 
         requestBean.Request.ApplicationDV.Entity01.APPENTEXPO = new PowerCurveUpdateApplication_Req_IB_v1.APPENTEXPO();
         requestBean.Request.ApplicationDV.Entity01.APPENTEXPO.SETTLEMENTLIMITS='';
         requestBean.Request.ApplicationDV.Entity01.APPENTEXPO.APPRFACILITIESODNONSCR='';
         requestBean.Request.ApplicationDV.Entity01.APPENTEXPO.APPRFACILITIESAFINNONSCR='';
         requestBean.Request.ApplicationDV.Entity01.APPENTEXPO.APPRFACILITIESMLNONSCR='';
        
         //INTENTCMTM
         requestBean.Request.ApplicationDV.Entity01.INTENTCMTM = new PowerCurveUpdateApplication_Req_IB_v1.INTENTCMTM();
         requestBean.Request.ApplicationDV.Entity01.INTENTCMTM.ORDCREDIT='';
         requestBean.Request.ApplicationDV.Entity01.INTENTCMTM.ASSETFINANCE='';
         requestBean.Request.ApplicationDV.Entity01.INTENTCMTM.MORTGRES='';
         requestBean.Request.ApplicationDV.Entity01.INTENTCMTM.MORTGCPF='';
         requestBean.Request.ApplicationDV.Entity01.INTENTCMTM.MORTGAGRI='';
         requestBean.Request.ApplicationDV.Entity01.INTENTCMTM.MORTGTOTAL='';
         
         //INTENTARRS        
         requestBean.Request.ApplicationDV.Entity01.INTENTARRS = new PowerCurveUpdateApplication_Req_IB_v1.INTENTARRS();
         requestBean.Request.ApplicationDV.Entity01.INTENTARRS.ASSETFINANCE='';
         requestBean.Request.ApplicationDV.Entity01.INTENTARRS.CC='';
         requestBean.Request.ApplicationDV.Entity01.INTENTARRS.ML='';
         requestBean.Request.ApplicationDV.Entity01.INTENTARRS.OTHEROC='';
         requestBean.Request.ApplicationDV.Entity01.INTENTARRS.TL='';
        
         //INTENTEXCS
         requestBean.Request.ApplicationDV.Entity01.INTENTEXCS = new PowerCurveUpdateApplication_Req_IB_v1.INTENTEXCS();
         requestBean.Request.ApplicationDV.Entity01.INTENTEXCS.CHEQACCS='';
         requestBean.Request.ApplicationDV.Entity01.INTENTEXCS.CC='';
         requestBean.Request.ApplicationDV.Entity01.INTENTEXCS.OTHEROC='';
        
        //INTENTINST
         requestBean.Request.ApplicationDV.Entity01.INTENTINST = new PowerCurveUpdateApplication_Req_IB_v1.INTENTARRS();
         requestBean.Request.ApplicationDV.Entity01.INTENTINST.ASSETFINANCE='';
         requestBean.Request.ApplicationDV.Entity01.INTENTINST.CC='';
         requestBean.Request.ApplicationDV.Entity01.INTENTINST.ML='';
         requestBean.Request.ApplicationDV.Entity01.INTENTINST.OTHEROC='';
         requestBean.Request.ApplicationDV.Entity01.INTENTINST.TL='';
        
         //INTENTLMTS
          requestBean.Request.ApplicationDV.Entity01.INTENTLMTS = new PowerCurveUpdateApplication_Req_IB_v1.INTENTLMTS();
          requestBean.Request.ApplicationDV.Entity01.INTENTLMTS.CC='';
          requestBean.Request.ApplicationDV.Entity01.INTENTLMTS.CHEQ='';
          requestBean.Request.ApplicationDV.Entity01.INTENTLMTS.OTHEROC='';
          
         //INTENTTRID
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID = new PowerCurveUpdateApplication_Req_IB_v1.INTENTTRID();
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MNTHSOLDESTCUSTREL='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MNTHSOLDESTACCREL='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MNTHSOLDESTCHACCREL='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MNTHSOLDESTSAVACCREL='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXCLUSIONTYPE='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXCLUSIONREASON='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXCLUSIONCREDITFACILITY='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCORECUSTALIGN='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCORECHEQ='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCORECC='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCOREMORTG='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCOREAVAF='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.BEHAVSCORELOANS='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXPECTEDCREDTURNOVCHEQ='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.EXPECTEDCREDTURNOVCUST='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AVGCTOL3ML6M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AVGCTOL6ML12M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMDAYSCREDITINL6M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMDAYSDEBITINL6M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMDEBITSL6M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMMNTHSEXCESSBALL6M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MAXCONSECDAYSINEXCESS='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.MAXOCSCORINGMANDATE='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AOL='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.ACCL='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AMLR='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.ABRA='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AMMR='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.AMR='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMRDEVENTSSAVL3M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMRDEVENTSSAVL6M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMRDEVENTSCHEQL3M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.NUMRDEVENTSCHEQL6M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.TOTSAVRETPAYMNTSL6M='';
          requestBean.Request.ApplicationDV.Entity01.INTENTTRID.TOTCHEQRETPAYMNTSL6M='';
          
          //APPENTAPRF
          requestBean.Request.ApplicationDV.Entity01.APPENTAPRF = new PowerCurveUpdateApplication_Req_IB_v1.APPENTAPRF();
          requestBean.Request.ApplicationDV.Entity01.APPENTAPRF.INSTORDCREDNONSCORED='';
          requestBean.Request.ApplicationDV.Entity01.APPENTAPRF.INSTASSETFINNONSCORED='';
          requestBean.Request.ApplicationDV.Entity01.APPENTAPRF.INSTMLOANNONSCORED='';
          
          //INTENTRDET
          requestBean.Request.ApplicationDV.Entity01.INTENTRDET = new PowerCurveUpdateApplication_Req_IB_v1.INTENTRDET();
          requestBean.Request.ApplicationDV.Entity01.INTENTRDET.INBUSNRESC='';
          requestBean.Request.ApplicationDV.Entity01.INTENTRDET.BUSNRESCAFFECTEDPARTY='';
          requestBean.Request.ApplicationDV.Entity01.INTENTRDET.WRSTCOLLRISKTYPE='';
          requestBean.Request.ApplicationDV.Entity01.INTENTRDET.WRSTARMSHOLD='';
          requestBean.Request.ApplicationDV.Entity01.INTENTRDET.EWLLISTING='';
          requestBean.Request.ApplicationDV.Entity01.INTENTRDET.WRSTDM9CODE='';
          requestBean.Request.ApplicationDV.Entity01.INTENTRDET.INTENTBUSNRESC='';
          
          //INTENTSECE
          requestBean.Request.ApplicationDV.Entity01.INTENTSECE = new PowerCurveUpdateApplication_Req_IB_v1.INTENTSECE();
          requestBean.Request.ApplicationDV.Entity01.INTENTSECE.SURETYSHIPIFOAPPLICANT = '';
          //APPENTFNST
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST = new PowerCurveUpdateApplication_Req_IB_v1.APPENTFNST();
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.AVAILABLE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.SOLEFULLAVAILABLE='';
          //requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TYPE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.PERIODOFINCSTAT='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TMSNCE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TMSNCECERTDATE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.QUALIFIED='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TURNOVER='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.PROJTURNOVER='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.NETWORTH='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TOTALASSETS='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.SALESGROWTHPERC='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.NETPROFITPERC='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABSHAREHFUNDS='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.ASSINTANGIBLES='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABLOANSFROMPRCEDED='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABLOANSTOPR='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.GROSSPROFIT='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.PROFITNET='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.RETAINEDEARNINGS='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.PROFITBEFORETAX='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABLOANTOINSIDEPARTIES='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABLOANFROMOTHINSTITUTIONS='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABTOTCURRLIAB='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABTOTSTOCK='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABTOTLONGTERMDEBT='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.CURRENTRATIO='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.GROSSPROFITPERC='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.ACIDTEST='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.IBDTOEQUITY='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.IBDTOEBITDA='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LONGTERMDEBTTOEBITDA='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.ICR='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TOTALASSETTURNOVER='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.OPERATINGPROFITMARGIN='';
          requestBean.Request.ApplicationDV.Entity01.APPENTFNST.EBITDA='';
        
          //APPENTASLB
          requestBean.Request.ApplicationDV.Entity01.APPENTASLB = new PowerCurveUpdateApplication_Req_IB_v1.APPENTASLB();
          requestBean.Request.ApplicationDV.Entity01.APPENTASLB.NETWORTHCREDIT='';
          requestBean.Request.ApplicationDV.Entity01.APPENTASLB.NETWORTHME='';
          requestBean.Request.ApplicationDV.Entity01.APPENTASLB.TOTALPROPERTIES='';
          requestBean.Request.ApplicationDV.Entity01.APPENTASLB.DEEDSSEARCHAVAILABLE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTASLB.NOTARIALBOND='';
          requestBean.Request.ApplicationDV.Entity01.APPENTASLB.AVAILABLE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTASLB.NETWORTH='';
          
          //APPENTBUR
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR = new PowerCurveUpdateApplication_Req_IB_v1.APPENTBUR();
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPSNAME='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPFNAME1='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPFNAME2='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPDOB='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPNATID='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPRESADDR1='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPRESADDR2='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPRESSUBURB='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPRESCTY='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPRESPOSTCDE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPPSTADDR1='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPPSTSUBURB='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPPSTCTY='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPPSTPOSTCDE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPOCC='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPEMP='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPHMPHN='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPHMPHNCDE='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPWRKPHN='';
          requestBean.Request.ApplicationDV.Entity01.APPENTBUR.CONSINPWRKPHNCDE='';
        
          //INTENTBUR
          requestBean.Request.ApplicationDV.Entity01.INTENTBUR = new PowerCurveUpdateApplication_Req_IB_v1.INTENTBUR();
          requestBean.Request.ApplicationDV.Entity01.INTENTBUR.COMMINPKIMNUMBER='';
          requestBean.Request.ApplicationDV.Entity01.INTENTBUR.COMMINPVATNUMBER='';
          requestBean.Request.ApplicationDV.Entity01.INTENTBUR.COMMINPTRADINGNAME='';
          requestBean.Request.ApplicationDV.Entity01.INTENTBUR.COMMINPBUSNAME='';
          requestBean.Request.ApplicationDV.Entity01.INTENTBUR.COMMINPREGNUMBER='';
        
          //APPENTTIME
          requestBean.Request.ApplicationDV.Entity01.APPENTTIME = new PowerCurveUpdateApplication_Req_IB_v1.APPENTTIME();
          requestBean.Request.ApplicationDV.Entity01.APPENTTIME.ATCURRADDR = '';
          
           //just intialise other Entitties as Blank
          requestBean.Request.ApplicationDV.Entity02 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
          requestBean.Request.ApplicationDV.Entity03 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01(); 
          requestBean.Request.ApplicationDV.Entity04 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
          requestBean.Request.ApplicationDV.Entity05 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
          requestBean.Request.ApplicationDV.Entity06 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
          
          //Existing Products 
          requestBean.Request.ApplicationDV.ExistingProducts01 = new PowerCurveUpdateApplication_Req_IB_v1.ExistingProducts01();
          requestBean.Request.ApplicationDV.ExistingProducts01.SANCTIONERMANDATENUMBER='';
          requestBean.Request.ApplicationDV.ExistingProducts01.PRICINGMANDATENUMBER='';
          //INTPRDEXST
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST = new PowerCurveUpdateApplication_Req_IB_v1.INTPRDEXST();
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.PRODUCT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.PRODUCTTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRSUBPRODTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRBALANCE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRINSTALLMENT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRLIMIT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRINTRATEPRIMEOFFSET='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRREDUCTIONAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRREDUCTIONFREQ='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRONCEOFFREDUCTION='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRINSTALMNTFREQ='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRSETTLEMENTAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURREXISTEMPOWERMNTFUNDIND='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURREXISTEMPOWERMNTFUND='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRINITFEEPREVDEBITED='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.NCAMAXINITFEEAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.ACCOUNTNUMBER='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.ESPINSTRUCTION='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CARDTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.CURRENFORCEDREDLIM='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDEXST.SECUREDBYMORTGAGEBOND='';
        
          //APPPRDEXST
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST = new PowerCurveUpdateApplication_Req_IB_v1.APPPRDEXST();
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.APPLICATIONSTATUS='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQFACILITYTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQPRODTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQSUBPRODTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQADDITIONALAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQTOTALAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQODLIMITTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQREDUCTIONAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQREDUCTIONFREQ='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQONCEOFFFREQAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQREPAYMNTOPTION='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQPURPOSEFACILITYORLOAN='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQTERMOFLOAN='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQINSTALLMENTFREQ='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQNUMSKIPPEDPAYMNTS='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQINITIATIONFEEPAYMNTMETHOD='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQPAYMNTMETHOD='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQCREDLIFEPREMIUM='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQREQEMPOWERMNTFUNDIND='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQREQEMPOWERMNTFUND='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQLIMITTYPEIND='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQPRODCOMBINATIONNUM='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.REQCAMPAIGNCODE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.INITIATIONFEEPAYMNTMETHOD='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.NCAAPPLICABLE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.NCAAGREEMENTCAT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDEXST.JURISTICIND='';
        
          //INTPRDSECE
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDSECE = new PowerCurveUpdateApplication_Req_IB_v1.INTPRDSECE();
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDSECE.SPECASVFULL='';
          requestBean.Request.ApplicationDV.ExistingProducts01.INTPRDSECE.SPECASVLIMITED='';
          //APPPRDSECO
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDSECO = new PowerCurveUpdateApplication_Req_IB_v1.APPPRDSECO();
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDSECO.SPECIFIC='';
          requestBean.Request.ApplicationDV.ExistingProducts01.APPPRDSECO.SUPPORTINGSPECIFIC='';
        
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST = new PowerCurveUpdateApplication_Req_IB_v1.DERPRDEXST();
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALADDITIONALAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALTOTALAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALREDUCTIONAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALREDUCTIONFREQ='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALREDUCTIONPERIOD='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALONCEOFFREDUCTIONAMNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALREPAYMNTOPTION='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALTERMOFLOAN='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALINSTALMENTFREQ='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALINSTALMENT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALINTRATE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALSERVICEFEE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALPRODTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALSUBPRODTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALODLIMITTYPE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALINITFEEAMOUNT='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALREPAYMENTMETHOD='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALREVCREDITOPTION='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALINTRATEPRIMEPLUS='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALFACILITYFEE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALINTRATEFACILITYFEEPERC='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALDECISION='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALDECDATE='';
          requestBean.Request.ApplicationDV.ExistingProducts01.DERPRDEXST.FINALDECTIME='';
          //repeat same structure for 29 times if needed
          
        
        
          //requested Products
          requestBean.Request.ApplicationDV.RequestedProducts01 = new PowerCurveUpdateApplication_Req_IB_v1.RequestedProducts01();
          requestBean.Request.ApplicationDV.RequestedProducts01.SANCTIONERMANDATENUMBER='';
          requestBean.Request.ApplicationDV.RequestedProducts01.PRICINGMANDATENUMBER='';
          
          //APPPRDNEWF
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF = new PowerCurveUpdateApplication_Req_IB_v1.APPPRDNEWF();
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.APPLICATIONSTATUS='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQPRODUCT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQFACILITYTYPE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQPRODTYPE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQSUBPRODTYPE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQADDITIONALAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQTOTALAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQLIMIT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQODLIMITTYPE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQREDUCTIONAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQREDUCTIONFREQ='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQONCEOFFFREQAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQREPAYMNTOPTION='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQPURPOSEFACILITYORLOAN='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQTERMOFLOAN='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQINSTALLMENTFREQ='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQNUMSKIPPEDPAYMNTS='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQINITIATIONFEEPAYMNTMETHOD='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQPAYMNTMETHOD='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQCREDLIFEPREMIUM='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQREQEMPOWERMNTFUNDIND='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQREQEMPOWERMNTFUND='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQCAMPAIGNCODE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQLIMITTYPEIND='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.REQPRODCOMBINATIONNUM='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.INITIATIONFEEPAYMNTMETHOD='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.NCAAPPLICABLE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.NCAAGREEMENTCAT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.SECUREDBYMORTGAGEBOND='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.INSTSETTLEMENTS='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.JURISTICIND='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.ACCOUNTNUMBER='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.ESPINSTRUCTION='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.CARDTYPE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.SETTLEMENTSAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDNEWF.UNIQUEPRODID='';
        
          requestBean.Request.ApplicationDV.RequestedProducts01.INTPRDNEWF = new PowerCurveUpdateApplication_Req_IB_v1.INTPRDNEWF();
          requestBean.Request.ApplicationDV.RequestedProducts01.INTPRDNEWF.NCAMAXINITFEEAMNT='';
        
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDSECO = new PowerCurveUpdateApplication_Req_IB_v1.APPPRDSECO();
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDSECO.SPECIFIC='';
          requestBean.Request.ApplicationDV.RequestedProducts01.APPPRDSECO.SUPPORTINGSPECIFIC='';
        
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF = new PowerCurveUpdateApplication_Req_IB_v1.DERPRDNEWF();
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALADDITIONALAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALTOTALAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALREDUCTIONAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALREDUCTIONFREQ='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALREDUCTIONPERIOD='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALONCEOFFREDUCTIONAMNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALREPAYMNTOPTION='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALTERMOFLOAN='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALINSTALMENTFREQ='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALINSTALMENT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALINTRATE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALSERVICEFEE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALPRODTYPE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALSUBPRODTYPE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALODLIMITTYPE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALINITFEEAMOUNT='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALREPAYMENTMETHOD='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALREVCREDITOPTION='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALDECISION='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALINTRATEPRIMEPLUS='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALFACILITYFEE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALDECDATE='';
          requestBean.Request.ApplicationDV.RequestedProducts01.DERPRDNEWF.FINALDECTIME='';
        //repeat same structure for 29 times if needed
        return requestBean;
    }

}