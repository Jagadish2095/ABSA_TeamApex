/*
 * Response Integration Bean for SearchProductsV2 Service
 * @author Jabulani Mashia
 * @created 2020-10-30
 */

public class SearchProductsV2_Resp_IB_v1 extends Base_IB {
	
    public String status;
    public Integer statusCode;
    public String message;

	public searchProductsV2ResponseMsg searchProductsV2ResponseMsg;
    
	public class searchProductsV2ResponseMsg{  
	public searchProductsV2ResponseDto searchProductsV2ResponseDto;
	public common common;
	}
    
	public class searchProductsV2ResponseDto{
		public list<cifProducts> cifProducts;
		public String productCount;
	}
	public class rules{
		public String usageValue;
		public String description;
		public String sortOrder;
		public String longName;
		public String createdOn;
		public String shortName;
		public String changedOn;
		public String code;
		public String oid;
	}
	public class features{
		public String changedOn;
		public String longName;
		public String shortName;
		public String description;
		public String code;
		public String usageValue;
		public String oid;
		public String sortOrder;
		public String createdOn;
		public list<rules> rules;
	}
	public class common{
		public String messageTimeStamp;
		public String messageSuccess;
	}
	public class cifProducts{
		public list<features> features;
		public list<rules> rules;
		public String description;
		public String definitionChangedOn;
		public String longName;
		public String createdOn;
		public String shortName;
		public String changedOn;
		public String code;
		public String cifShortName;
		public String oid;
	}
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"number":', '"z_number":');        
    }
}