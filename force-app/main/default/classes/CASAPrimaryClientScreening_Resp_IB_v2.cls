public class CASAPrimaryClientScreening_Resp_IB_v2 extends Base_IB {
	public String status;
    public Integer statusCode;
    public String message;
    public String returnCode;
    public String reasonCode;
    public String msgNo;
    public String msg;
    public String refNo;
    public String casaStatus;
    
    
     public override void setFieldNameSubstitutions()
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"status":', '"casaStatus":');
    }
	
}