/**
 * ECM_GetItemTypeResult_IB_V1
 */
public class ECM_GetItemTypeResult_IB_V1 {
	
	public GetItemTypeResult getItemTypeResult { get; set; }
    
    public class GetItemTypeResult {

    	public String status { get; set; }

    	public String detail { get; set; }
    }
}