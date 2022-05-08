/**
* Apex Integration Request Bean class for CASAPrimaryClientScreening v7
* Test Class Name: CASAPrimaryClientScreening_IH_v3_Test
* @author  Anka Ganta : Absa
* @since  2019-11-24
*
**/
public class CASAPrimaryClientScreening_Resp_IB_v3 extends Base_IB {
	public String status;
    public Integer statusCode;
    public String message;
    public String returnCode;
    public String reasonCode;
    public String msgNo;
    public String msg;
    public String refNo;
    public String casaStatus;
    
    //@AuraEnabled public DSretrieveDebitsCreditsInqV1Response DSretrieveDebitsCreditsInqV1Response{get;set;}
     public override void setFieldNameSubstitutions()
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"status":', '"casaStatus":');
    }
    
    public static CASAPrimaryClientScreening_Resp_IB_v3 dummyResponse(){
        CASAPrimaryClientScreening_Resp_IB_v3 responseBean = new CASAPrimaryClientScreening_Resp_IB_v3();
        responseBean.setFieldNameSubstitutions();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        responseBean.returnCode='0';
        responseBean.reasonCode='0';
        responseBean.msgNo='0';
        responseBean.msg='test';
        responseBean.refNo='0';
        responseBean.casaStatus='test';
        return responseBean;
       
    }
	
}