/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-09-02
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CIgetSigningInstructionsV4_Resp_IB_v2 extends Base_IB  {
    /**
 * @description       :
 */
	public class Cip082do {
		public String clientCode;
		public String nbrSignReqOperAcc;
		public string specialConditions;
		public String nbrSignRetrieved;
		public String restartKeyOutput;
		public List<OutputTable> outputTable;
	}
	/**
 * @description       :
 */
	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public string echoKey;
	}

	/**
 * @description       :
 */
	public CIgetSigningInstructionsV4Response CIgetSigningInstructionsV4Response;

	public class Nbsmsgo3 {
		public String version;
		public string sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}
	/**
 * @description       :
 */
	public class CIgetSigningInstructionsV4Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cip082do cip082do;
	}
/**
 * @description       :
 */
	public class MsgEntry {
		public string msgClass;
		public string msgCode;
		public string msgErrInd;
		public string msgTxt;
	}
/**
 * @description       :
 */
	public class OutputTable {
		public String title;
		public String initials;
		public String surname;
		public String name;
		public String idType;
		public String idNbr;
		public String dateIssued;
		public String compulsorySign;
		public String physicalAdd1;
		public string physicalAdd2;
		public String physicalSuburb;
		public String physicalTown;
		public String physicalPostal;
		public String clientNationality;
		public string countryOfOrigin;
		public String countryResAddress;
		public String birthOpCountry;
		public String homeTelCode;
		public String homeTelephone;
		public String emailAddress;
		public String gender;
		public String birthDate;
		public String occupationStatus;
		public String occupationCode;
		public String designation;
	}

}