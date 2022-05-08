/**
 * @description       : 
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
public with sharing class XDSGetQuetions_Req_IB_v2 extends Base_IB{
    @auraEnabled public String agentId;
    @auraEnabled public String cellularNo;
    @auraEnabled public String idNumber;
    @auraEnabled public String passportNo;
    @auraEnabled public String percentage;

	/**
     * @description createDummyRequest
	 * @return XDSGetQuetions_Req_IB_v2
    */
    public static XDSGetQuetions_Req_IB_v2 createDummyRequest() {
		XDSGetQuetions_Req_IB_v2 requestBean = new XDSGetQuetions_Req_IB_v2();
		requestBean.agentId = '7011';
		requestBean.cellularNo = '0746004196';
		requestBean.idNumber = '7710256047181';
		requestBean.passportNo = '0000000004048195352';
		return requestBean;
	}

}