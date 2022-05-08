public class GetJointParticipant_Resp_IB_v1 extends Base_IB 
{
    public String status;
    public Integer statusCode;
    public String message;
    
	public String nbrRetrv;
    public cls_JntEntry[] jntEntry;
    public class cls_JntEntry
    {
        public String idDocType;
        public String idNumber;
        public String initials;
        public String titleCode;
        public String surname;
        public String resAddrLine1;
        public String resAddrLine2;
        public String resSuburb;
        public String resTown;
        public String resPosCde;
        public String firstNames;
        public String homeTelCode;
        public String homeTelephone;
        public String workTelCode;
        public String workTelephone;
        public String cellphone;
        public String practiceNumber;
        public String birthDate;
        public String sourceOfIncome;
        public String dateIdentified;
        public String dateVerified;
        public String employeeIdentified;
        public String employeeVerified;
        public String taxNumber;
        public String clientNationality;
        public String countryOfOrigin;
        public String tempPermitNumber;
        public String permitExpiryDate;
        public String homeTcodex;
        public String workTcodex;
        public String cellx;
        public String groupScheme;
        public String groupSchemeEmp;
        public String dateIssued;
        public String dateExempted;
        public String empExempted;
        public String statusOfExempt;
        public String exemptionInd;
        public String countryOfRes;
        public String countryOfBirth;
        public String occupationStatus;
        public String occupationCode;
        public String saTaxRegis;
        public String rsonSaTaxNotGiven;
        public String foreignTaxRegis;
        public cls_ForeignTaxData[] foreignTaxData;        
    }
    public class cls_ForeignTaxData 
    {
        public String foreignTaxCtry;
        public String foreignTaxNo;
        public String rsonFtaxNotGiven;
    }
}