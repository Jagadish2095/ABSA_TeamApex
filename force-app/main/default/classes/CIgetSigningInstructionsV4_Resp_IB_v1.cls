/*
 * Response Integration Bean for CIgetSigningInstructionsV4 Service
 * @author Prashant Jain
 * @created 2020-03-05
 */

public class CIgetSigningInstructionsV4_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class Cip082do {
		public String clientCode;
		public String nbrSignReqOperAcc;
		public String specialConditions;
		public String nbrSignRetrieved;
		public String restartKeyOutput;
		public List<OutputTable> outputTable;
	}

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public CIgetSigningInstructionsV4Response CIgetSigningInstructionsV4Response;

	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class CIgetSigningInstructionsV4Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cip082do cip082do;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

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
		public String physicalAdd2;
		public String physicalSuburb;
		public String physicalTown;
		public String physicalPostal;
		public String clientNationality;
		public String countryOfOrigin;
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