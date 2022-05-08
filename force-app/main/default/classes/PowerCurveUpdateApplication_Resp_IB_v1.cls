/*
* Integration Response Bean for PowerCurveUpdateApplication Service
* @author Saurabh Pandey
* @created 2020-11-17
* Modified on 2020-12-29
*/

public class PowerCurveUpdateApplication_Resp_IB_v1 extends Base_IB{
    public String status;
    public Integer statusCode;
    public String message;
    
    public class RESAPPSCRD {
        public String CHEQCUTOFF;
        public String ODCUTOFF;
        public String BCCCUTOFF;
        public String FCCUTOFF;
        public String GCCUTOFF;
        public String TLCUTOFF;
        public String BRLCUTOFF;
        public String EPSCUTOFF;
        public String BGCUTOFF;
        public String TRFCUTOFF;
        public String AGRICUTOFF;
        public String CPFCUTOFF;
        public String MOODYCUTOFF;
        public String ORDCREDLIMIT;
        public String ORDCREDSCORINGMANDATE;
        public String VARSMONTHSWITHABSA;
        public String VARSTOTENQL12M;
        public String VARSTOTENQL3M;
        public String VARSWRSTARRSEVER;
        public String VARSDAYSMRECPPOPEN;
        public String VARSTOTNUMCLOSEDPPS;
        public String VARSWRSTBURREPORT;
        public String ODSCORE;
        public String TLNSCORE;
        public String SCORWRSTBURREPORT;
        public String SCORMONTHSWITHABSA;
        public String SCORDAYSSNCELASTCREDIT;
        public String SCORTOTENQL12M;
        public String SCORBEEXCSINDICATOR;
        public String SCOREXCSWRSTPRINCIPAL;
        public String SCORWRSTARRSEVER;
        public String SCORGUINESSRATING;
        public String SCORTOTENQL3M;
        public String SCORABSACHQACCRELATIONSHIP;
        public String SCORDAYSMRECPPOPEN;
        public String SCORTOTNUMCLOSEDPPS;
        public String SCORABSANUMBEROFPRODUCTS;
        public String ODRNGTIMESINCELASTCRED;
        public String ODRNGENQP1TOTNUML12M;
        public String ODRNGP1WRSTEVERARRS;
        public String ODRNGTOTGUINESSRATING;
        public String ODRNGTIMEWITHABSA;
        public String ODRNGBEEXCESSIND;
        public String ODRNGPRWRSTEXCESS;
        public String ODRNGPRWRSTREPORT;
        public String ODSCRTIMESINCELASTCRED;
        public String ODSCRENQP1TOTNUML12M;
        public String ODSCRP1WRSTEVERARRS;
        public String ODSCRTOTGUINESSRATING;
        public String ODSCRTIMEWITHABSA;
        public String ODSCRBEEXCESSIND;
        public String ODSCRPRWRSTEXCESS;
        public String ODSCRPRWRSTREPORT;
        public String TLRNGABSACHQACC;
        public String TLRNGENQP1TOTNUML12M;
        public String TLRNGENQP1TOTNUML3M;
        public String TLRNGTIMESINCEMRECOP;
        public String TLRNGP1WRSTEVERARRS;
        public String TLRNGABSANUMPRODUCTS;
        public String TLRNGTOTGUINESSRATING;
        public String TLRNGBEEXCESSIND;
        public String TLRNGPRWRSTEXCESS;
        public String TLRNGPRWRSTREPORT;
        public String TLSCRABSACHQACC;
        public String TLSCRENQP1TOTNUML12M;
        public String TLSCRENQP1TOTNUML3M;
        public String TLSCRTIMESINCEMRECOP;
        public String TLSCRP1WRSTEVERARRS;
        public String TLSCRABSANUMPRODUCTS;
        public String TLSCRTOTGUINESSRATING;
        public String TLSCRBEEXCESSIND;
        public String TLSCRPRWRSTEXCESS;
        public String TLSCRPRWRSTREPORT;
        public String TLRNGPPSALLCLSPPS;
        public String TLSCRPPSALLCLSPPS;
    }
    
    public class DERENTLMTS {
        public String TOTALLIMIT;
        public String TOTALCURRLIMIT;
    }
    
    public class RESAPPWCRM {
        public String REQUIRED;
        public String MODEL;
    }
    
    public class DECAPPINIT {
        public String DECISION;
    }
    
    public class DERAPPPRIN {
        public String PRINCAPPLICABLEIND;
    }
    
    public class DERAPPCOFC {
        public String TOTALTOTALCOSTFACILITIES;
        public String TOTALCURRTOTALCOSTFACILITIES;
    }
    
    public class DerivedCalcAppData {
        public DERAPPPRIN DERAPPPRIN;
        public DERAPPSPSE DERAPPSPSE;
        public DERAPPGPAM DERAPPGPAM;
        public DERAPPPAPR DERAPPPAPR;
        public DERAPPEXPO DERAPPEXPO;
        public DERAPPSECO DERAPPSECO;
        public DERAPPSECE DERAPPSECE;
        public DERAPPTURN DERAPPTURN;
        public DERAPPBCAP DERAPPBCAP;
        public DERAPPWCRM DERAPPWCRM;
        public DERAPPASV DERAPPASV;
        public DERAPPCOFC DERAPPCOFC;
        public DERAPPADOF DERAPPADOF;
        public DERAPPPRDO DERAPPPRDO;
        public DERAPPIDLM DERAPPIDLM;
        public DERAPPAPPLICATION DERAPPAPPLICATION;
        public DERAPPMIAE DERAPPMIAE;
        public APPAPPMIAE APPAPPMIAE;
    }
    
    public class APPENTBUR {
        public String CONSINPNATID;
    }
    
    public class ApplicationDV {
        public String APPAPPAPPLICATIONNUMBER;
        public String DERPCOUNIQUENUMBER;
        public DerivedCalcAppData DerivedCalcAppData;
        public StratRes1 StratRes1;
        public DecisionData DecisionData;
        public Entity01 Entity01;
        public Entity01 Entity02;
        public Entity01 Entity03;
        public Entity01 Entity04;
        public Entity01 Entity05;
        public Entity01 Entity06;
        public DerivedCalcEntity01 DerivedCalcEntity01;
        public DerivedCalcEntity01 DerivedCalcEntity02;
        public DerivedCalcEntity01 DerivedCalcEntity03;
        public DerivedCalcEntity01 DerivedCalcEntity04;
        public DerivedCalcEntity01 DerivedCalcEntity05;
        public DerivedCalcEntity01 DerivedCalcEntity06;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr01;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr02;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr03;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr04;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr05;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr06;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr07;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr08;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr09;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr10;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr11;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr12;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr13;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr14;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr15;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr16;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr17;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr18;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr19;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr20;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr21;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr22;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr23;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr24;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr25;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr26;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr27;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr28;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr29;
        public DerivedCalcPreAppr01 DerivedCalcPreAppr30;
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
        public String APPERRMSG;
    }
    
    public class RESENTFNST {
        public String REQUIRED;
        public String TYPEREQUIRED;
    }
    
    public class DERPRDEXST {
        
        public String OFFERADDITIONALAMNT;
        public String OFFERTOTALAMNT;
        public String OFFERREDUCTIONAMNT;
        public String OFFERREDUCTIONFREQ;
        public String OFFERREDUCTIONPERIOD;
        public String OFFERONCEOFFREDUCTIONAMNT;
        public String OFFERTERMOFLOAN;
        public String OFFERINSTALMENTFREQ;
        public String OFFERINSTALMENT;
        public String OFFERINTRATEPRIMEPLUS;
        public String OFFERINTRATE;
        public String OFFERFACILTYFEE;
        public String COFCCOSTOFFACILITY;
        public String OFFERSERVICEFEE;
        public String OFFERPRODTYPE;
        public String OFFERSUBPRODTYPE;
        public String OFFERODLIMITTYPE;
        public String NCAQUOTEREQ;
        public String NCAMAXRATE;
        public String NCAMAXRATETYPE;
        public String OFFERINITFEEAMOUNT;
        public String LOWERFEEALLOWABLE;
        public String OFFERREPAYMENTMETHOD;
        public String OFFERREVCREDITOPTION;
        public String OFFERINTRATEFACILITYFEEPERC;
        public String INTRATELOWERALLOWABLE;
        public String FINALADDITIONALAMNT;
        public String FINALTOTALAMNT;
        public String FINALREDUCTIONAMNT;
        public String FINALREDUCTIONFREQ;
        public String FINALREDUCTIONPERIOD;
        public String FINALONCEOFFREDUCTIONAMNT;
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
        public String COFCCURRCOSTOFFACILITY;
        public String FINALDECDATE;
        public String FINALDECTIME;
        public String REASONOVERRIDE;
        public String DECLINELETTER;
    }
    
    public class INTENTBUR {
        public String COMMINPREGNUMBER;
    }
    
    public class RESAPPEXCS {
        public String WRSTPRINCIPALP1VP2;
        public String WRSTPRINCIPALO1VO2;
    }
    
    public class RESAPPOVRD {
        public String OVERRIDEALLOWABLE;
    }
    
    public class RESAPPFRDS {
        public String SLATIMEOUTVICTIM;
        public String SLATIMEOUTSUSPECT;
        public String SLATIMEOUTHIGHFRDPOTENTIAL;
        public String FRAUDCALLREQ;
        public String FRAUDDECREQ;
    }
    
    public class DERAPPMIAE {
        public String EXPNECESSARYSHORTFALL;
    }
    
    public class INTENTAPRF {
        public String RETAILOCE;
        public String RETAILOCINST;
        public String RETAILASSETFIN;
        public String RETAILASSETFININST;
        public String RETAILMLOANEXP;
        public String RETAILMLOANINST;
        public String BBOCE;
        public String BBOCEINST;
        public String BBASSETFIN;
        public String BBASSETFININST;
        public String BBMLOANEXP;
        public String BBMLOANINST;
    }
    
    public class RESENTCBST {
        public String JUDGEXPINDICATOR;
        public String JUDGTUINDICATOR;
        public String WOFFEXPINDICATOR;
        public String WOFFTUINDICATOR;
        public String ADVEXPINDICATOR;
        public String ADVTUINDICATOR;
        public String REPORT1;
        public String REPORT2;
        public String SECONDCALLREQUIRED;
        public String WRSTREPORT;
        public String RISKINDICATOR;
        public String CBCRGINDICATOR;
        public String LOOKUPPERIOD;
        public String ENFORCEREWORK;
    }
    
    public class RESAPPGPAM {
        public String EXPILLUSTDAYSNODECISION;
        public String EXPILLUSTDAYSAFTERDECISION;
        public String EXPILLUSTDAYSREMOVE;
        public String ABSADATARFRESHPERIOD;
        public String FRAUDREFERRALPROCESS;
        public String GUINESSRATING;
    }
    
    public class DERAPPBCAP {
        public String CLTURNFINAL;
        public String RUBCTURNFINAL;
        public String RBCTURNFINAL;
        public String BENETWORTH;
        public String RBCBENETWORTH;
        public String PRNWTOTAL;
        public String RUBCPRNETWORTH;
        public String RBCPRNETWORTH;
        public String PRNWORTH;
    }
    
    public class DERAPPSECO {
        public String TOTASVOFFERED;
    }
    
    public class DERAPPAPPLICATION {
        public String AMOUNTOFFERED;
        public String AMOUNTFINAL;
    }
    
    public class RESENTBSTM {
        public String ADVIND;
    }
    
    public class DERAPPADOF {
        public String EXPOPOTENTIALOCOFFERED;
    }
    
    public class DERAPPPAPR {
        public String PREAPPRIND;
        public String PREAPPRREPROCESSLOWERLMTIND;
    }
    
    public class RESAPPMIAE {
        public String REQUIRED;
    }
    
    public class DERENTSTOR {
        public String STRENGTHRELATIONSHIP;
    }
    
    public class DERAPPSECE {
        public String SPECASVALLACCAVAIL;
        public String NETEXSTASV;
        public String ASVSHORTFALLAFTERTOLER;
        public String ASVSHORTFALLAMNT;
        public String ASVTOTPOTENTIAL;
    }
    
    public class RequestedProducts01 {
        public DERPRDNEWF DERPRDNEWF;
        public APPPRDNEWF APPPRDNEWF;
    }
    
    public class RESAPPDLET {
        public String DECLINELETTERCODES;
    }
    
    public Response Response;
    
    public class DERAPPSPSE {
        public String SPOUSEDETAILSREQUIREDIND;
    }
    
    public class DECAPPILST {
        public String DECISION;
        public String DECISIONDATE;
        public String DECISIONTIME;
        public List<String> REASON;
        public List<String> REASONDESCRIPTION;
        public List<String> EXCEPTION_Z; //use the substitution Map
        public List<String> EXCEPTIONDESCRIPTION;
        public String REASON_STR;
        public String REASONDESCRIPTION_STR;
        public String EXCEPTION_STR;
        public String EXCEPTIONDESCRIPTION_STR;
    }
    
    public class APPAPPMIAE {
        public String INCDISCRETFINAL;
        public String INCBUFFERAMNT;
        public String INCDISCRETAVAILABLE;
        public String SURPLUS;
    }
    
    public class Entity01 {
        public String INTENTCLIENTCODE1;
        public INTENTAPRF INTENTAPRF;
        public String APPENTIDTYPE;
        public APPENTBUR APPENTBUR;
        public INTENTBUR INTENTBUR;
    }
    
    public class ExistingProducts01 {
        public DERPRDEXST DERPRDEXST;
        public INTPRDEXST INTPRDEXST;
    }
    
    public class INTPRDEXST{
        public String ACCOUNTNUMBER;
    }
    
    public class DECAPPSYST {
        public String DECISION;
        public String DECISIONDATE;
        public String DECISIONTIME;
    }
    
    public class DERAPPGPAM {
        public String REQMAXTERMVSPURPSLOANMAXTERM;
        public String REQMAXTERMVSPURPSLOANNOTBOND;
    }
    
    public class RESAPPRISK {
        public String ODAPPLICANTRISK;
        public String TLNAPPLICANTRISK;
        public String WRSTAPPLICANTRISK;
    }
    
    public class DecisionData {
        public DECAPPILST DECAPPILST;
        public DECAPPINIT DECAPPINIT;
        public DECAPPSYST DECAPPSYST;
        public DECAPPSYST DECAPPFINAL;
        public List<String> DECAPPREASON;
        public List<String> DECAPPREASONDESCRIPTION;
        public List<String> DECAPPEXCEPTION;
        public List<String> DECAPPEXCEPTIONDESCRIPTION;
        public String DECAPPREASON_STR;
        public String DECAPPREASONDESCRIPTION_STR;
        public String DECAPPEXCEPTION_STR;
        public String DECAPPEXCEPTIONDESCRIPTION_STR;
    }
    
    public class DERAPPIDLM {
        public String IDEALLIMITAMOUNT;
        public String IDEALLIMITBALANCE;
        public String IDEALLIMITREDUCTIONREQ;
    }
    
    public class RESAPPCMNG {
        public String REMAXOFFSETREDUC;
        public String REMINPLUSMINRATE;
        public String SMMAXOFFSETREDUC;
        public String SMMINPLUSMINRATE;
        public String PMMAXOFFSETREDUC;
        public String PMMINPLUSMINRATE;
        public String HOCMMAXOFFSETREDUC;
        public String HOCMMINPLUSMINRATE;
    }
    
    public class DERAPPASV {
        public String TOTALOFFERED;
    }
    
    public class DERENTEXCS {
        public String TOTALAMNT;
        public String INDICATOR;
    }
    public class APPPRDNEWF {
        public String UNIQUEPRODID;
    }
    public class DERPRDNEWF {
        public String OFFERADDITIONALAMNT;
        public String OFFERTOTALAMNT;
        public String OFFERREDUCTIONAMNT;
        public String OFFERREDUCTIONFREQ;
        public String OFFERREDUCTIONPERIOD;
        public String OFFERONCEOFFREDUCTIONAMNT;
        public String OFFERTERMOFLOAN;
        public String OFFERINSTALMENTFREQ;
        public String OFFERINSTALMENT;
        public String COFCCOSTOFFACILITY;
        public String OFFERSERVICEFEE;
        public String OFFERPRODTYPE;
        public String OFFERSUBPRODTYPE;
        public String OFFERODLIMITTYPE;
        public String NCAQUOTEREQ;
        public String NCAMAXRATE;
        public String NCAMAXRATETYPE;
        public String OFFERINITFEEAMOUNT;
        public String LOWERFEEALLOWABLE;
        public String OFFERREPAYMENTMETHOD;
        public String OFFERREVCREDITOPTION;
        public String OFFERINTRATEFACILITYFEEPERC;
        public String NTRATELOWERALLOWABLE;
        public String OFFERINTRATEPRIMEPLUS;
        public String OFFERINTRATE;
        public String OFFERFACILITYFEE;
        public String FINALADDITIONALAMNT;
        public String FINALTOTALAMNT;
        public String FINALREDUCTIONAMNT;
        public String FINALREDUCTIONFREQ;
        public String FINALREDUCTIONPERIOD;
        public String FINALONCEOFFREDUCTIONAMNT;
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
        public String COFCCURRCOSTOFFACILITY;
        public String FINALDECDATE;
        public String FINALDECTIME;
        public String REASONOVERRIDE;
        public String DECLINELETTER;
    }
    
    public class DERAPPPRDO {
        public String TOTODLIMITS;
    }
    
    public class DERAPPWCRM {
        public String DGRISKGRADE;
    }
    
    public class DerivedCalcPreAppr01 {
        public DERAPPPAPR_Z DERAPPPAPR;
    }
    
    public class Response {
        public ApplicationDV ApplicationDV;
    }
    
    public class RESAPPBSTM {
        public String BANKREPORTREQ;
    }
    
    public class DerivedCalcEntity01 {
        public DERENTCUST DERENTCUST;
        public DERENTINST DERENTINST;
        public DERENTLMTS DERENTLMTS;
        public DERENTEXCS DERENTEXCS;
        public DERENTEXCS DERENTARRS;
        public DERENTSTOR DERENTSTOR;
        public RESENTBSTM RESENTBSTM;
        public RESENTFNST RESENTFNST;
        public String DEREXPBURENTPCCEID;
        public String DERTUBURENTPCCEID;
        public RESENTCBST RESENTCBST;
    }
    
    public class DERAPPTURN {
        public String MONTHLYAVERAGE;
    }
    
    public class DERENTCUST {
        public String EXISTINGCLIENTINDICATOR;
        public String EXISTINGCREDCLIENTINDICATOR;
    }
    
    public class DERAPPPAPR_Z {
        public String TOTINSTREQ;
    }
    
    public class DERAPPEXPO {
        public String REQTOTADDPOTENTIALOC;
        public String REQPOTENTIALTOTDIRECT;
        public String REQPOTENTIALTOTGROUP;
        public String REQPOTENTIALTGBE;
        public String REQPOTENTIALTGAE;
        public String REQPOTENTIALTGOE;
        public String REQPOTENTIALTFL;
        public String OFFRTOTFINANCINGLMT;
        public String FINALTOTFINANCINGLMT;
        public String POTENTIALTOTDIRECTOFFERED;
        public String POTENTIALTGBEOFFERED;
        public String POTENTIALTGAEOFFERED;
        public String POTENTIALTGBOEOFFERED;
        public String POTENTIALTGEOFFERED;
        public String POTENTIALOCOFFERED;
        public String POTENTIALTOTDIRECTFINAL;
        public String POTENTIALTGBEFINAL;
        public String POTENTIALTGAEFINAL;
        public String POTENTIALTGBOEFINAL;
        public String POTENTIALTGEFINAL;
        public String POTENTIALOCFINAL;
    }
    
    public class StratRes1 {
        public RESAPPBSTM RESAPPBSTM;
        public RESAPPWCRM RESAPPWCRM;
        public RESAPPSCRD RESAPPSCRD;
        public RESAPPGPAM RESAPPGPAM;
        public RESAPPCMNG RESAPPCMNG;
        public RESAPPEXCS RESAPPEXCS;
        public RESAPPMIAE RESAPPMIAE;
        public RESAPPRISK RESAPPRISK;
        public RESAPPOVRD RESAPPOVRD;
        public RESAPPDLET RESAPPDLET;
        public RESAPPFRDS RESAPPFRDS;
    }
    
    public class DERENTINST {
        public String TOTALINSTALLMENTS;
    }
    
    public override void setFieldNameSubstitutions(){
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"REASON":"', '"REASON_STR":"');
        fieldNameSubstitutionMap.put('"REASONDESCRIPTION":"', '"REASONDESCRIPTION_STR":"');
        fieldNameSubstitutionMap.put('"EXCEPTION":"', '"EXCEPTION_STR":"');
        fieldNameSubstitutionMap.put('"EXCEPTIONDESCRIPTION":"', '"EXCEPTIONDESCRIPTION_STR":"');
        fieldNameSubstitutionMap.put('"DECAPPREASON":"', '"DECAPPREASON_STR":"');
        fieldNameSubstitutionMap.put('"DECAPPREASONDESCRIPTION":"', '"DECAPPREASONDESCRIPTION_STR":"');
        fieldNameSubstitutionMap.put('"DECAPPEXCEPTION":"', '"DECAPPEXCEPTION_STR":"');
        fieldNameSubstitutionMap.put('"DECAPPEXCEPTIONDESCRIPTION":"', '"DECAPPEXCEPTIONDESCRIPTION_STR":"');
        fieldNameSubstitutionMap.put('"EXCEPTION"', '"EXCEPTION_Z"');
        
    }
    
}