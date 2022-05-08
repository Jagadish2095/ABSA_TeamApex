/***
* @comment : 
* @description  
*/  

public class CIupdJointPByClientCodeV7_IB_Req_v1 extends Base_IB{
    /***
* @comment : 
* @description  
*/  
	public CIupdJointParticipantsByClientCodeV7 CIupdJointParticipantsByClientCodeV7;
     /***
    * @comment : 
     * @description  
    */  
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
    /***
* @comment : 
* @description  
*/  
	public class JntEntry {
		public String actionCode;
		public Integer idDocType;
		public Long idDocNbr;
		public String initials;
		public Integer titleCode;
		public String surname;
		public String addressLine1;
		public String addressLine2;
		public String suburbRsa;
		public String town;
		public Integer postalCode;
		public String firstNames;
		public Integer homeTelephoneCode;
		public Integer homeTelephoneNbr;
		public Integer workTelephoneCode;
		public Integer workTelephoneNbr;
		public Integer cellphoneNbr;
		public String practiceNumber;
		public Integer birthDate;
		public Integer sourceOfIncome;
		public Integer dateClientFicaIden;
		public Integer dateClientFicaVeri;
		public String employeeIdentified;
		public String employeeVerified;
		public Integer taxNumber;
		public String clientNationality;
		public String countryOfOrigin;
		public String tempPermitNumber;
		public Integer permitExpiryDate;
		public Integer controllerOverideNbr;
		public Integer groupScheme;
		public String groupSchemeEmployee;
		public Integer dateIssued;
		public Integer dateExempted;
		public Integer employeeExempted;
		public Integer exemptionStatus;
		public String exemptionIndicator;
		public String countryOfRes;
		public String countryOfBirth;
		public Integer occupationStatus;
		public Integer occupationCode;
		public String saTaxRegis;
		public String rsonSaTaxNotGiven;
		public String foreignTaxRegis;
	}
    /***
* @comment : 
* @description  
*/  
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
    /***
* @comment : 
* @description  
*/  
	public class Cib033i {
		public String clientCode;
		public Integer teller;
		public Integer branch;
		public Integer nbrOfRecords;
		public List<JntEntry> jntEntry;
	}
    /***
* @comment : 
* @description  
*/  
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
    /***
* @comment : 
* @description  
*/  
	public class CIupdJointParticipantsByClientCodeV7 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cib033i cib033i;
	}
}