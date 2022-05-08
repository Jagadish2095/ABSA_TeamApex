public class GetRegulatoryCompliance_Resp_IB_v1 extends Base_IB
{
    public String status;
    public Integer statusCode;
    public String message;

    // Class which defines the Regulatory Compliance details returned in GetRegulatoryCompliance Service
    public cls_Content content;
    public String[] reglinks;

    public class cls_Content
    {
        public cls_MissingDocuments[] missingDocuments;
        public String[] missingData;
        public String nextRefreshDate;
        public cls_ReusableDocuments[] reusableDocuments;
        public cls_RefreshableDocuments[] refreshableDocuments;
        public cls_PartyFlags[] partyFlags;
    }

    public class cls_MissingDocuments extends cls_Details{}

    public class cls_ReusableDocuments extends cls_Document{}

    public class cls_RefreshableDocuments  extends cls_Document{}

    public abstract class cls_Document
    {
        public cls_Context context;
        public String lastRefreshDate;
        public String nextRefreshDate;
        public String receivedDate;
        public String source;
        public cls_RegType regType;
        public cls_SubType subType;
        public String uniqueIdInSourceSystem;
        public String vettedDate;
    }

    public class cls_Context extends cls_Details{}

    public class cls_PartyFlags
    {
        public String effectiveDate;
        public Boolean yesNoFlag;
        public cls_RegType regType; //Original - Type
        public String status;
    }

    public class cls_RegType extends cls_Details{}

    public class cls_SubType extends cls_Details{}

    public abstract class cls_Details
    {
        public String code;
        public string description;
    }

    public override void setFieldNameSubstitutions()
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"type":{', '"regType":{');
        fieldNameSubstitutionMap.put('"links":', '"reglinks":');
    }
}