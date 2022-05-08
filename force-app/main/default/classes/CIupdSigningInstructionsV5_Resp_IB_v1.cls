/*
 * Response Integration Bean for CIupdSigningInstructionsV5 Service
 * @author Prashant Jain
 * @created 2020-02-25
 */

public class CIupdSigningInstructionsV5_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public CIupdSigningInstructionsV5Response CIupdSigningInstructionsV5Response;

	public class Cip202o {
		public String changeNbr;
		public String nbrSignDeleted;
		public List<OutputTable> outputTable;
	}

	public class CIupdSigningInstructionsV5Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cip202o cip202o;
	}

	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class MsgEntry {
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	//public class TitleOld {
		//public String dollar_Z; // in json: $
	//}

	public class OutputTable {
		public String designationOld;
		public String occupCodeOld;
		public String occupStatusOld;
		public String birthDateOld;
		public String genderOld;
		public String emailAddressOld;
		public String homeTelephoneOld;
		public String homeTelCodeOld;
		public String birthOpCountryOld;
		public String countryResAddrOld;
		public String countryOfOriginOld;
		public String clntNationalityOld;
		public String physicalPostalOld;
		public String physicalTownOld;
		public String physicalSuburbOld;
		public String physicalAdd2Old;
		public String physicalAdd1Old;
		public String compulsorySignOld;
		public String dateIssuedOld;
		public String idNbrOldOut;
		public String idTypeOldOut;
		public String nameOld;
		public String surnameOld;
		public String initialsOld;
		public String titleOld;
	}
    
    /*public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map < String, String > ();
        fieldNameSubstitutionMap.put('"$":', '"dollar_Z":'); */
    }
//}