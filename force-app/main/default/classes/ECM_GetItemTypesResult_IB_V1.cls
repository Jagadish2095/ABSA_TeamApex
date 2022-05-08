/**
 * ECM_GetItemTypesResult_IB_V1
 */
public class ECM_GetItemTypesResult_IB_V1 {
	
	public GetItemTypesResult getItemTypesResult { get; set; }
    
    public class GetItemTypesResult {

    	public String status { get; set; }

    	public String detail { get; set; }
    }
    
    public class ECM_ItemTypes {
    	
    	public List<ECM_ItemType> itemTypes { get; set; }
    	
    }
    
    public class ECM_ItemType {
    	public String name { get; set; }
    	public String description { get; set; }
    	public Fields Fields {get; set; }
    }
    
    public class Fields {
    	List<ECM_Field> Fields { get; set; }
    }
    
    public class ECM_Field {
    	
    	public String name { get; set; }
    	public String Type { get; set; }
    	public String size { get; set; }
    	public String nullable { get; set; }
    	public String unique { get; set; }
    	public String description { get; set; }
    }

}