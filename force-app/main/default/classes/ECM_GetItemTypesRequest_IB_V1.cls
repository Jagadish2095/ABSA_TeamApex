/**
 * ECM_GetItemTypesRequest_IB_V1
 */
public class ECM_GetItemTypesRequest_IB_V1 extends Base_IB {

	public GetItemTypesRequest GetItemTypesRequest { get; set; }
	
    public static ECM_GetItemTypesRequest_IB_V1 getExample() {
        ECM_GetItemTypesRequest_IB_V1 getItemTypesRequest = new ECM_GetItemTypesRequest_IB_V1();
        GetItemTypesRequest req = new GetItemTypesRequest();
        req.token = '1234567890';
        getItemTypesRequest.getItemTypesRequest = req;
        return getItemTypesRequest;
    }
    
    public class GetItemTypesRequest {
    	
    	public String Token { get; set; }
    	
    }

}