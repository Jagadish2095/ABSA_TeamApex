/*
* Response Integration Bean for CASAScreenRelatedParty Service
* @author Pitso Sekhu
* @created 2019-03-13
*/


public class CASAScreenRelatedParty_Resp_IB_v2 extends Base_IB {
	public String status;
    public Integer statusCode;
    public String message;
    
    public String msgNo;
    public String msg;
    public String refNo;
    public String respStatus;
    
    public String relatedPartyName;
    public String relatedPartySfId;
    
    public override void setFieldNameSubstitutions(){
        
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('status', 'respStatus');
        
    }
}