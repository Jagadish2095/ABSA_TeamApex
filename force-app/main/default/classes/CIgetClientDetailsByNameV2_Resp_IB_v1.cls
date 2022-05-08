/*
 * Response Integration Bean for CIgetClientDetailsByNameV2 Service
 * @author Rudolf Niehaus
 * @created 2020-04-07
 */

public class CIgetClientDetailsByNameV2_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class Cip602o {
		public String lastSearchPos;
		public String nbrEntsRetrieved;
		public List<TblEntry> tblEntry;
	}

	public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public CIgetClientDetailsByNameV2Response CIgetClientDetailsByNameV2Response;

	public class TblEntry {
		public String cifKey;
		public String cifInitials;
		public String cifSurname;
		public String cifTitleCode;
		public String idDocType;
		public String idNbr;
		public String cifClntType;
		public String cifClntGroup;
		public String cifNbrOfAccts;
		public String cifBirthDate;
		public String cifAddrLine1;
		public String cifAddrLine2;
		public String cifPostlSuburb;
		public String cifPostlTown;
		public String cifPostlCodeRsa;
		public String cifCorpCode;
	}

	public class Nbsmsgo {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class CIgetClientDetailsByNameV2Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Cip602o cip602o;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
}