public class RefreshRegulatoryCompliance_Resp_IB_v1 extends Base_IB 
{
    public String status;
    public Integer statusCode;
    public String message;
    
    public cls_Content Content;
    
    public class cls_Content 
    {
        public cls_Compliance compliance;
        public cls_Attestation attestation;
        public String regStatus;
    }
    
    public class cls_Compliance 
    {
		public String nextRefreshDate;
        public String[] missingData;   
        public cls_ReusableDocuments[] reusableDocuments;
        public cls_RefreshableDocuments[] refreshableDocuments;
        public cls_PartyFlags[] partyFlags;
    }
    
    public class cls_ReusableDocuments extends cls_Document{}
    
    public class cls_RefreshableDocuments  extends cls_Document{}
    
    public class cls_Attestation 
    {
		public cls_Address address;
        public cls_Identityfication identityfication;
    }
    
    public class cls_Address
    {
        public String attestedAddress;
        public cls_AttestedAddressDocument attestedAddressDocument;
        public cls_GoldenSourceAddress goldenSourceAddress;
        public cls_GoldenSourceDocument goldenSourceDocument;
        public Boolean matches;
    }
    
	public class cls_AttestedAddressDocument extends cls_Document{}
    
    public class cls_GoldenSourceAddress extends cls_Document
    {
		public Boolean matches;
		public String addressName1;
		public String addressName2;
		public String suburbName;
		public String cityName;
		public String postalCode;
		public String created;
		public String updated;
    }
    
    public abstract class cls_Document
    {
        public String source;
        public String lastRefreshDate;
        public String nextRefreshDate;
        public String receivedDate;
        public String uniqueIdInSourceSystem;
        public String vettedDate;
        public cls_Context context;
        public cls_RegType regType;
        public cls_SubType subType;
    }
    
    public class cls_Context extends cls_Details{}
    
    public class cls_GoldenSourceDocument
    {
        public Boolean present;
    }
    
    public class cls_Identityfication
    {
        public cls_AttestedId attestedId;
        public cls_AttestedAddressDocument attestedIdDocument {get;set;} 
        public cls_GoldenSourceId goldenSourceId;
        public cls_GoldenSourceDocument goldenSourceDocument;
        public Boolean matches;
    }
    
    public class cls_AttestedId
    {
        public String regNumber;
		public cls_RegType regType;
        public String expiryDate;
        public String issueDate;
    }
    
    public class cls_GoldenSourceId extends cls_Document
    {
        public String regNumber;
        public String regTypes;
        public String expiryDate;
        public String issueDate;
        public String ficaAttestationDate;
        public Boolean matches;
    }
    
    public class cls_MissingDocuments extends cls_Details {}

    public class cls_PartyFlags 
    {
        public String effectiveDate;
        public Boolean yesNoFlag;
        public cls_RegType regType; //Original - Type
        public String regStatus;
    }
    
    public class cls_RegType extends cls_Details {}
    
    public class cls_SubType extends cls_Details {}
    
    public abstract class cls_Details
    {
        public String code;
        public string description;
    }
    
    public override void setFieldNameSubstitutions()
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"type":null','"regTypes":null');
        fieldNameSubstitutionMap.put('"number":{', '"regNumber":{');
        fieldNameSubstitutionMap.put('"status":', '"regStatus":');
        fieldNameSubstitutionMap.put('"type":', '"regType":');
    }
}