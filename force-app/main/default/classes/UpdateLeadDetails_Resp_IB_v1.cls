/**
 * @description       : Integration Response for UpdateLeadDetails service
 * @author            : Mbuyiseni Mbhokane
 * @group             : ZyberFox
 * @last modified on  : 05-26-2021
 * @last modified by  : Mbuyiseni Mbhokane
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-28-2021   Mbuyiseni Mbhokane   Initial Version
**/

public class UpdateLeadDetails_Resp_IB_v1 extends Base_IB{
    

    public List<Result> result;
/**
 * @description       : Inner class for updateLeadService
 */
	public class Result {
		public String code;
		public String message;
	}


	/**
	* @description UpdateLeadDetails service dummy method
	* @author Mbuyiseni Mbhokane | 05-21-2021 
	* @return UpdateLeadDetails_Resp_IB_v1 
	**/
	public static UpdateLeadDetails_Resp_IB_v1 dummyResponse() {

        UpdateLeadDetails_Resp_IB_v1 responseBean = new UpdateLeadDetails_Resp_IB_v1();
        UpdateLeadDetails_Resp_IB_v1.Result result = new UpdateLeadDetails_Resp_IB_v1.Result();
        List<UpdateLeadDetails_Resp_IB_v1.Result> results = new List<UpdateLeadDetails_Resp_IB_v1.Result>();

        result.code = '0000';
        result.message = 'success';
        results.add(result);
		return responseBean;
	}

}