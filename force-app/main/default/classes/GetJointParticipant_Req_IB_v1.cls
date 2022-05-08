public class GetJointParticipant_Req_IB_v1 extends Base_IB 
{
	public String clntCde;
    
    public GetJointParticipant_Req_IB_v1 createDummyRequest()
    {           
        GetJointParticipant_Req_IB_v1 bean = new GetJointParticipant_Req_IB_v1();
        bean.clntCde = 'RAMANS+001';
       
        System.debug('RequestBean: ' + bean);
        return bean;
    }
}