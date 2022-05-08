/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-16-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-16-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class CASAScreenRelatedParty_Resp_IB_v3 extends Base_IB {
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
    /**

* @description  CASAScreenRelatedParty_Resp_IB_v3

* @return CASAScreenRelatedParty_Resp_IB_v3

*/
    
    public static CASAScreenRelatedParty_Resp_IB_v3 createDummyRequest() {           
        CASAScreenRelatedParty_Resp_IB_v3 screenRelatedPartyResp = new CASAScreenRelatedParty_Resp_IB_v3();
        screenRelatedPartyResp.msgNo = '0';
        screenRelatedPartyResp.msg = 'CSA 0 added succesfully';
        screenRelatedPartyResp.refNo = '0';
        screenRelatedPartyResp.respStatus = '';
        
        System.debug('CASAScreenRelatedParty Req: ' + screenRelatedPartyResp);
        return screenRelatedPartyResp;
    }
}