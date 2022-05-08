/**
 * @description       : Request class for GetProductExposure service
 * @author            : Gopi
 * @last modified on  : 2021-06-11
 
**/


public class GetProductExposureAggre_Req_IB_v1 extends Base_IB{
    public List<Client> client;
    /**
 * @description       : Inner class with params clientProfile and name
 * @author            : Gopi
 * @last modified on  : 2021-06-11
 
**/
	public class Client {
		public List<ClientProfile> clientProfile;
		public String name;
    }
    /**
 * @description       : Inner class with params product,aggregation,clientCode
 * @author            : Gopi
 * @last modified on  : 2021-06-11
 
**/
	public class ClientProfile {
		public List<Product> product;
		public Aggregation aggregation;
		public String clientCode;
    }
    /**
 * @description       : Inner class Product
 * @author            : Gopi
 * @last modified on  : 2021-06-11
 
**/
    public class Product {
		public Long liability;
		public Long limit_z;
		public Long installment;
		public String productCode;
		public Long exposure;
		public String subIndicator;
		public Long excess;
		public Long arrears;
    }
    /**
 * @description       : Inner class Aggregation
 * @author            : Gopi
 * @last modified on  : 2021-06-11
 
**/
	public class Aggregation{
		public Long installment;
		public Long liability;
		public Long exposure;
		public Long limit_z;
		public Long excess;
		public String type_z;
		public Long arrears;
	}

    /**
    * @description :Method to create dummy request
    * @author Gopi | 2021-06-11 
    * @return GetProductExposureAggre_Req_IB_v1 
    **/
    public static GetProductExposureAggre_Req_IB_v1 createDummyRequest() {
        //String reqString = '{"client":[{"name":"ABC","clientProfile":[{"clientCode":"ABC+001","product":[{"arrears":0,"excess":0,"exposure":250,"installment":0,"liability":250,"limit":0,"productCode":"CHQ","subIndicator":"A"},{"arrears":0,"excess":0,"exposure":600,"installment":0,"liability":600,"limit":0,"productCode":"CHQ2","subIndicator":"M"}],"aggregation":{"arrears":0,"excess":0,"exposure":0,"installment":0,"liability":0,"limit":0,"type":"Ordinary Credit Total"}},{"clientCode":"ABC+002","product":[{"arrears":0,"excess":1000,"exposure":1000,"installment":0,"liability":500,"limit":0,"productCode":"CHQ","subIndicator":"A"},{"arrears":0,"excess":0,"exposure":600,"installment":0,"liability":600,"limit":0,"productCode":"DMRECOV","subIndicator":"M"}],"aggregation":{"arrears":0,"excess":700,"exposure":0,"installment":800,"liability":50,"limit":0,"type":"Ordinary Credit Total"}}]},{"name":"John Hammond","clientProfile":[{"clientCode":"JHMMD+001","product":[{"arrears":0,"excess":0,"exposure":250,"installment":0,"liability":250,"limit":0,"productCode":"RECOVERY","subIndicator":"A"},{"arrears":0,"excess":0,"exposure":600,"installment":0,"liability":600,"limit":0,"productCode":"DMRECOV","subIndicator":"A"}],"aggregation":{"arrears":0,"excess":0,"exposure":0,"installment":0,"liability":0,"limit":0,"type":"Ordinary Credit Total"}},{"clientCode":"JHMMD+002","product":[{"arrears":0,"excess":1000,"exposure":1000,"installment":0,"liability":500,"limit":0,"productCode":"RECOVERY","subIndicator":"A"},{"arrears":0,"excess":0,"exposure":600,"installment":0,"liability":600,"limit":0,"productCode":"DMRECOV","subIndicator":"A"}],"aggregation":{"arrears":0,"excess":0,"exposure":0,"installment":0,"liability":0,"limit":0,"type":"Ordinary Credit Total"}}]}]}';
        String reqString = '{"client":[{"name":"ABC","clientProfile":[{"clientCode":"ABC+001","product":[{"arrears":250,"excess":250,"exposure":250,"installment":250,"liability":250,"limit":250,"productCode":"RECOVERY"},{"arrears":600,"excess":600,"exposure":600,"installment":600,"liability":600,"limit":600,"productCode":"DMRECOV"}],"aggregation":{"arrears":1000,"excess":1000,"exposure":1000,"installment":1000,"liability":1000,"limit":1000,"type":"Ordinary Credit Total"}},{"clientCode":"ABC+002","product":[{"arrears":1000,"excess":1000,"exposure":1000,"installment":500,"liability":500,"limit":1000,"productCode":"RECOVERY"},{"arrears":600,"excess":600,"exposure":600,"installment":600,"liability":600,"limit":1000,"productCode":"DMRECOV"}],"aggregation":{"arrears":500,"excess":500,"exposure":500,"installment":500,"liability":500,"limit":1000,"type":"Asset Finance"}}]},{"name":"John Hammond","clientProfile":[{"clientCode":"JHMMD+001","product":[{"arrears":250,"excess":250,"exposure":250,"installment":250,"liability":250,"limit":1000,"productCode":"RECOVERY"},{"arrears":250,"excess":250,"exposure":600,"installment":250,"liability":600,"limit":1000,"productCode":"DMRECOV"}],"aggregation":{"arrears":1000,"excess":1000,"exposure":1000,"installment":200,"liability":1000,"limit":1000,"type":"Ordinary Credit Total"}},{"clientCode":"JHMMD+002","product":[{"arrears":200,"excess":1000,"exposure":1000,"installment":200,"liability":500,"limit":1000,"productCode":"RECOVERY"},{"arrears":500,"excess":500,"exposure":600,"installment":200,"liability":600,"limit":1000,"productCode":"DMRECOV"}],"aggregation":{"arrears":850,"excess":400,"exposure":400,"installment":200,"liability":400,"limit":1000,"type":"Loans"}}]}]}';
        GetProductExposureAggre_Req_IB_v1 reqBean = new GetProductExposureAggre_Req_IB_v1();
        reqBean = (GetProductExposureAggre_Req_IB_v1)reqBean.deserialize(reqString, GetProductExposureAggre_Req_IB_v1.class);

        System.debug('reqBean :::: ' + JSON.serializePretty(reqBean));

        return reqBean;
    }

    /**
    * @description Method to set field names
    * @author Gopi| 2021-06-11 
    **/
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"limit":', '"limit_z":');
        fieldNameSubstitutionMap.put('"type":', '"type_z":');
    }
}