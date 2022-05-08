/**
 * ECM_GetItemTypesRequest_IB_V1
 */
public class ECM_GetItemTypeRequest_IB_V1 {

	public GetItemTypeRequest GetItemTypeRequest { get; set; }
	
    public static ECM_GetItemTypeRequest_IB_V1 getExample() {
        ECM_GetItemTypeRequest_IB_V1 getItemTypeRequest = new ECM_GetItemTypeRequest_IB_V1();
        GetItemTypeRequest req = new GetItemTypeRequest();
        req.token = '1234567890';
        req.itemType = 'TestItemType';
        getItemTypeRequest.getItemTypeRequest = req;
        return getItemTypeRequest;
    }
    
    public class GetItemTypeRequest {
    	
    	public String Token { get; set; }
    	public String ItemType { get; set; }
    	
    }

}