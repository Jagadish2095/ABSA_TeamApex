/*
* Response Integration Bean for PowerCurveNewApplication Service
* @author Englarmerdge Mongwe
* @created 2020-09-28
*/

public class PowerCurveNewApplication_Resp_IB_v1 extends Base_IB {
    //Saurabh overriding the bean fields to make them available in Aura
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

	public class Fault {
        public string faultcode;
        public string faultstring;
	}
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
	}

	public Response Response;

	public class DERAPPSPSE {
		public String SPOUSEDETAILSREQUIREDIND;
	}

	public class DERENTLMTS {
		public String TOTALLIMIT;
		public String TOTALCURRLIMIT;
	}

	public class Entity01 {
		public String INTENTCLIENTCODE1;
		public INTENTAPRF INTENTAPRF;
		public String APPENTIDTYPE;
		public APPENTBUR APPENTBUR;
		public INTENTBUR INTENTBUR;
	}

	public class DERAPPPRIN {
		public String PRINCAPPLICABLEIND;
	}

	public class DERAPPGPAM {
		public String REQMAXTERMVSPURPSLOANMAXTERM;
		public String REQMAXTERMVSPURPSLOANNOTBOND;
	}

	public class DerivedCalcAppData {
		public DERAPPPRIN DERAPPPRIN;
		public DERAPPSPSE DERAPPSPSE;
		public DERAPPGPAM DERAPPGPAM;
		public DERAPPPAPR DERAPPPAPR;
		public DERAPPEXPO DERAPPEXPO;
	}

	public class APPENTBUR {
		public String CONSINPNATID;
	}

	public class ApplicationDV {
		public String APPAPPAPPLICATIONNUMBER;
		public String DERPCOUNIQUENUMBER;
		public DerivedCalcAppData DerivedCalcAppData;
		public StratRes1 StratRes1;
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
		public String APPERRMSG;
	}

	public class INTENTBUR {
		public String COMMINPREGNUMBER;
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

	public class RESAPPEXCS {
		public String WRSTPRINCIPALP1VP2;
	}

	public class DERENTEXCS {
		public String TOTALAMNT;
		public String INDICATOR;
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

	public class RESAPPGPAM {
		public String EXPILLUSTDAYSNODECISION;
		public String EXPILLUSTDAYSAFTERDECISION;
		public String EXPILLUSTDAYSREMOVE;
		public String ABSADATARFRESHPERIOD;
		public String FRAUDREFERRALPROCESS;
		public String GUINESSRATING;
	}

	public class DerivedCalcPreAppr01 {
		public DERAPPPAPR_Z DERAPPPAPR;
	}

	public class Response {
		public ApplicationDV ApplicationDV;
	}

	public class DerivedCalcEntity01 {
		public DERENTCUST DERENTCUST;
		public DERENTINST DERENTINST;
		public DERENTLMTS DERENTLMTS;
		public DERENTEXCS DERENTEXCS;
		public DERENTEXCS DERENTARRS;
		public DERENTSTOR DERENTSTOR;
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
	}

	public class DERAPPPAPR {
		public String PREAPPRIND;
		public String PREAPPRREPROCESSLOWERLMTIND;
	}

	public class StratRes1 {
		public RESAPPSCRD RESAPPSCRD;
		public RESAPPGPAM RESAPPGPAM;
		public RESAPPCMNG RESAPPCMNG;
		public RESAPPEXCS RESAPPEXCS;
	}

	public class DERENTSTOR {
		public String STRENGTHRELATIONSHIP;
	}

	public class DERENTINST {
		public String TOTALINSTALLMENTS;
	}

}


        /* commenting as per new response received from XI for extensive request
public class Entity {
public APPENTBUR APPENTBUR;
public String APPENTIDTYPE;
public INTENTAPRF INTENTAPRF;
public INTENTBUR INTENTBUR;
public String INTENTCLIENTCODE1;
}

public class RESAPPSCRD {
public Integer AGRICUTOFF;
public Integer BCCCUTOFF;
public Integer BGCUTOFF;
public Integer BRLCUTOFF;
public Integer CHEQCUTOFF;
public Integer CPFCUTOFF;
public Integer EPSCUTOFF;
public Integer FCCUTOFF;
public Integer GCCUTOFF;
public Integer MOODYCUTOFF;
public Integer ODCUTOFF;
public Integer ORDCREDLIMIT;
public Integer ORDCREDSCORINGMANDATE;
public Integer TLCUTOFF;
public Integer TRFCUTOFF;
}

public Response Response;

public class DERAPPSPSE {
public String SPOUSEDETAILSREQUIREDIND;
}

public class DERENTLMTS {
public Integer TOTALLIMIT;
}

public class INTENTAPRF {
public Integer BBMLOANEXP;
public Integer BBMLOANINST;
public Integer BBOCE;
public Integer BBOCEINST;
public Integer RETAILMLOANEXP;
public Integer RETAILMLOANINST;
public Integer RETAILOCE;
public Integer RETAILOCINST;
}

public class DERAPPPRIN {
public String PRINCAPPLICABLEIND;
}

public class RESAPPGPAM {
public Integer ABSADATARFRESHPERIOD;
public Integer EXPILLUSTDAYSAFTERDECISION;
public Integer EXPILLUSTDAYSNODECISION;
public Integer EXPILLUSTDAYSREMOVE;
public Integer FRAUDREFERRALPROCESS;
public Integer GUINESSRATING;
}

public class DerivedCalcEntity {
public DERENTARRS DERENTARRS;
public DERENTCUST DERENTCUST;
public DERENTARRS DERENTEXCS;
public DERENTINST DERENTINST;
public DERENTLMTS DERENTLMTS;
public DERENTSTOR DERENTSTOR;
}

public class DERAPPGPAM {
public Integer REQMAXTERMVSPURPSLOANMAXTERM;
public String REQMAXTERMVSPURPSLOANNOTBOND;
}

public class DerivedCalcAppData {
public DERAPPEXPO DERAPPEXPO;
public DERAPPGPAM DERAPPGPAM;
public DERAPPPAPR DERAPPPAPR;
public DERAPPPRIN DERAPPPRIN;
public DERAPPSPSE DERAPPSPSE;
}

public class Response {
public ApplicationDV ApplicationDV;
}

public class APPENTBUR {
public Long CONSINPNATID;
}

public class ApplicationDV {
public Long APPAPPAPPLICATIONNUMBER;
public String APPERRMSG;
public String DERPCOUNIQUENUMBER;
public DerivedCalcAppData DerivedCalcAppData;
public List<DerivedCalcEntity> DerivedCalcEntity;
public List<Entity> Entity;
public StratRes1 StratRes1;
}

public class DERENTARRS {
public String INDICATOR;
public Integer TOTALAMNT;
}

public class DERENTCUST {
public String EXISTINGCLIENTINDICATOR;
public String EXISTINGCREDCLIENTINDICATOR;
}

public class DERAPPEXPO {
public Integer REQPOTENTIALTFL;
public Integer REQPOTENTIALTGAE;
public Integer REQPOTENTIALTGBE;
public Integer REQPOTENTIALTGOE;
public Integer REQPOTENTIALTOTDIRECT;
public Integer REQPOTENTIALTOTGROUP;
public Integer REQTOTADDPOTENTIALOC;
}

public class INTENTBUR {
public Long COMMINPREGNUMBER;
}

public class DERAPPPAPR {
public String PREAPPRIND;
public String PREAPPRREPROCESSLOWERLMTIND;
}

public class StratRes1 {
public RESAPPCMNG RESAPPCMNG;
public RESAPPEXCS RESAPPEXCS;
public RESAPPGPAM RESAPPGPAM;
public RESAPPSCRD RESAPPSCRD;
}

public class DERENTSTOR {
public String STRENGTHRELATIONSHIP;
}

public class RESAPPCMNG {
public Double HOCMMAXOFFSETREDUC;
public Double HOCMMINPLUSMINRATE;
public Double PMMAXOFFSETREDUC;
public Double PMMINPLUSMINRATE;
public Double REMAXOFFSETREDUC;
public Double REMINPLUSMINRATE;
public Double SMMAXOFFSETREDUC;
public Double SMMINPLUSMINRATE;
}

public class DERENTINST {
public Integer TOTALINSTALLMENTS;
}

public class RESAPPEXCS {
public String WRSTPRINCIPALP1VP2;
}


/* Commenting After update from Masimba
public class Entity {
public INTENTAPRF INTENTAPRF;
public String APPENTIDTYPE;
public APPENTBUR APPENTBUR;
}

public class DERENTEXCS {
public Integer TOTALAMNT;
public String INDICATOR;
}

public class RESAPPSCRD {
public Integer CHEQCUTOFF;
public Integer ODCUTOFF;
public Integer BCCCUTOFF;
public Integer FCCUTOFF;
public Integer GCCUTOFF;
public Integer TLCUTOFF;
public Integer BRLCUTOFF;
public Integer EPSCUTOFF;
public Integer BGCUTOFF;
public Integer TRFCUTOFF;
public Integer AGRICUTOFF;
public Integer CPFCUTOFF;
public Integer MOODYCUTOFF;
public Integer ORDCREDLIMIT;
public Integer ORDCREDSCORINGMANDATE;
}

public Response Response;

public class DERAPPSPSE {
public String SPOUSEDETAILSREQUIREDIND;
}

public class DERENTLMTS {
public Integer TOTALLIMIT;
}

public class INTENTAPRF {
public Integer RETAILOCE;
public Integer RETAILOCINST;
public Integer RETAILMLOANEXP;
public Integer RETAILMLOANINST;
public Integer BBOCE;
public Integer BBOCEINST;
public Integer BBMLOANEXP;
public Integer BBMLOANINST;
}

public class DERAPPPRIN {
public String PRINCAPPLICABLEIND;
}

public class RESAPPGPAM {
public Integer EXPILLUSTDAYSNODECISION;
public Integer EXPILLUSTDAYSAFTERDECISION;
public Integer EXPILLUSTDAYSREMOVE;
public Integer ABSADATARFRESHPERIOD;
public Integer FRAUDREFERRALPROCESS;
public Integer GUINESSRATING;
}

public class DerivedCalcEntity {
public DERENTCUST DERENTCUST;
public DERENTINST DERENTINST;
public DERENTLMTS DERENTLMTS;
public DERENTEXCS DERENTEXCS;
public DERENTEXCS DERENTARRS;
public DERENTSTOR DERENTSTOR;
}

public class DERAPPGPAM {
public Integer REQMAXTERMVSPURPSLOANMAXTERM;
public String REQMAXTERMVSPURPSLOANNOTBOND;
}

public class DerivedCalcAppData {
public DERAPPPRIN DERAPPPRIN;
public DERAPPSPSE DERAPPSPSE;
public DERAPPGPAM DERAPPGPAM;
public DERAPPPAPR DERAPPPAPR;
public DERAPPEXPO DERAPPEXPO;
}

public class Response {
public ApplicationDV ApplicationDV;
}

public class APPENTBUR {
public Long CONSINPNATID;
}

public class ApplicationDV {
public Long APPAPPAPPLICATIONNUMBER;
public String DERPCOUNIQUENUMBER;
public DerivedCalcAppData DerivedCalcAppData;
public StratRes1 StratRes1;
public Entity Entity;
//public List<DerivedCalcEntity> DerivedCalcEntity;
public DerivedCalcEntity DerivedCalcEntity;
public String APPERRMSG;
}

public class DERENTCUST {
public String EXISTINGCLIENTINDICATOR;
public String EXISTINGCREDCLIENTINDICATOR;
}

public class DERAPPEXPO {
public Integer REQTOTADDPOTENTIALOC;
public Integer REQPOTENTIALTOTDIRECT;
public Integer REQPOTENTIALTOTGROUP;
public Integer REQPOTENTIALTGBE;
public Integer REQPOTENTIALTGAE;
public Integer REQPOTENTIALTGOE;
public Integer REQPOTENTIALTFL;
}

public class DERAPPPAPR {
public String PREAPPRIND;
public String PREAPPRREPROCESSLOWERLMTIND;
}

public class StratRes1 {
public RESAPPSCRD RESAPPSCRD;
public RESAPPGPAM RESAPPGPAM;
public RESAPPCMNG RESAPPCMNG;
public RESAPPEXCS RESAPPEXCS;
}

public class RESAPPCMNG {
public Double REMAXOFFSETREDUC;
public Double REMINPLUSMINRATE;
public Double SMMAXOFFSETREDUC;
public Double SMMINPLUSMINRATE;
public Double PMMAXOFFSETREDUC;
public Double PMMINPLUSMINRATE;
public Double HOCMMAXOFFSETREDUC;
public Double HOCMMINPLUSMINRATE;
}

public class DERENTSTOR {
public String STRENGTHRELATIONSHIP;
}

public class RESAPPEXCS {
public String WRSTPRINCIPALP1VP2;
}

public class DERENTINST {
public Integer TOTALINSTALLMENTS;
}

/*
public override void setFieldNameSubstitutions()
{
fieldNameSubstitutionMap = new Map<String, String>();
fieldNameSubstitutionMap.put('"Entity":[', '"EntityList":[');
fieldNameSubstitutionMap.put('"DerivedCalcEntity":[', '"DerivedCalcEntityList":[');
} */



    //Saurabh : 20201001
    /* commented the below response as it was failing to parse.

public Response Response;

public class Response {
public ApplicationDV ApplicationDV;
}

public class ApplicationDV {
public String APPAPPAPPLICATIONNUMBER;
public String DERPCOUNIQUENUMBER;
public DerivedCalcAppData DerivedCalcAppData;
public StratRes1 StratRes1;
public Entity Entity;
public DerivedCalcEntity[] DerivedCalcEntity;
public String APPERRMSG;
}

public class DerivedCalcAppData {
public DERAPPPRIN DERAPPPRIN;
public DERAPPSPSE DERAPPSPSE;
public DERAPPGPAM DERAPPGPAM;
public DERAPPPAPR DERAPPPAPR;
public DERAPPEXPO DERAPPEXPO;
}

public class DERAPPPRIN {
public String PRINCAPPLICABLEIND;
}

public class DERAPPSPSE {
public String SPOUSEDETAILSREQUIREDIND;
}

public class DERAPPGPAM {
public Integer REQMAXTERMVSPURPSLOANMAXTERM;
public String REQMAXTERMVSPURPSLOANNOTBOND;
}

public class DERAPPPAPR {
public String PREAPPRIND;
public String PREAPPRREPROCESSLOWERLMTIND;
}

public class DERAPPEXPO {
public Integer REQTOTADDPOTENTIALOC;
public Integer REQPOTENTIALTOTDIRECT;
public Integer REQPOTENTIALTOTGROUP;
public Integer REQPOTENTIALTGBE;
public Integer REQPOTENTIALTGAE;
public Integer REQPOTENTIALTGOE;
public Integer REQPOTENTIALTFL;
}

public class StratRes1 {
public RESAPPSCRD RESAPPSCRD;
public RESAPPGPAM RESAPPGPAM;
public RESAPPCMNG RESAPPCMNG;
public RESAPPEXCS RESAPPEXCS;
}

public class RESAPPSCRD {
public Integer CHEQCUTOFF;
public Integer ODCUTOFF;
public Integer BCCCUTOFF;
public Integer FCCUTOFF;
public Integer GCCUTOFF;
public Integer TLCUTOFF;
public Integer BRLCUTOFF;
public Integer EPSCUTOFF;
public Integer BGCUTOFF;
public Integer TRFCUTOFF;
public Integer AGRICUTOFF;
public Integer CPFCUTOFF;
public Integer MOODYCUTOFF;
public Integer ORDCREDLIMIT;
public Integer ORDCREDSCORINGMANDATE;
}

public class RESAPPGPAM {
public Integer EXPILLUSTDAYSNODECISION;
public Integer EXPILLUSTDAYSAFTERDECISION;
public Integer EXPILLUSTDAYSREMOVE;
public Integer ABSADATARFRESHPERIOD;
public Integer FRAUDREFERRALPROCESS;
public Integer GUINESSRATING;
}

public class RESAPPCMNG {
public Integer REMAXOFFSETREDUC;
public Integer REMINPLUSMINRATE;
public Double SMMAXOFFSETREDUC;
public Double SMMINPLUSMINRATE;
public Integer PMMAXOFFSETREDUC;
public Integer PMMINPLUSMINRATE;
public Integer HOCMMAXOFFSETREDUC;
public Integer HOCMMINPLUSMINRATE;
}

public class RESAPPEXCS {
public String WRSTPRINCIPALP1VP2;
}

public class Entity {
public String INTENTCLIENTCODE1;
public INTENTAPRF INTENTAPRF;
public String APPENTIDTYPE;
public INTENTBUR INTENTBUR;
}

public class INTENTAPRF {
public Integer RETAILOCE;
public Integer RETAILOCINST;
public Integer RETAILMLOANEXP;
public Integer RETAILMLOANINST;
public Integer BBOCE;
public Integer BBOCEINST;
public Integer BBMLOANEXP;
public Integer BBMLOANINST;
}

public class INTENTBUR {
public String COMMINPREGNUMBER;
}

public class DerivedCalcEntity {
public DERENTCUST DERENTCUST;
public DERENTINST DERENTINST;
public DERENTLMTS DERENTLMTS;
public DERENTEXCS DERENTEXCS;
public DERENTARRS DERENTARRS;
public DERENTSTOR DERENTSTOR;
}

public class DERENTCUST {
public String EXISTINGCLIENTINDICATOR;
public String EXISTINGCREDCLIENTINDICATOR;
}

public class DERENTINST {
public Integer TOTALINSTALLMENTS;
}

public class DERENTLMTS {
public Integer TOTALLIMIT;
}

public class DERENTEXCS {
public Integer TOTALAMNT;
public String INDICATOR;
}

public class DERENTARRS {
public Integer TOTALAMNT;
public String INDICATOR;
}

public class DERENTSTOR {
public String STRENGTHRELATIONSHIP;
}
}

*/