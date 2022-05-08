public class CASAScreenPrimaryClientV7_Resp_IB_v1 extends Base_IB {
    
    public String returnCode;
    public String reasonCode;
    public String msgNo;
    public String msg;
    public String refNo;
    public String casaStatus;

  
    public override void setFieldNameSubstitutions() {
      fieldNameSubstitutionMap = new Map<String, String>();
      fieldNameSubstitutionMap.put('"status":', '"casaStatus":');        
    }
}