/*
 * Integration Handler for TransunionProcessRequest41 Service
 * @author Prashant Jain
 * @created 2020-05-20
*--------------------------------------
* @Updated By - Pitso Sekhu
* @Updated Date- 2021-03-18
* @Update Notes - Changes to EnquirerContactPhoneNo & EnquirerContactName from Hard coded value to Custom Label
*--------------------------------------
*/

public class TransunionProcessRequest41_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'Transunion Process Request 41';

    public static TransunionProcessRequest41_Resp_IB_v1 TransunionProcessRequest41(TransunionProcessRequest41_Req_IB_v1 requestBean) {
        TransunionProcessRequest41_Resp_IB_v1 responseBean = (TransunionProcessRequest41_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, TransunionProcessRequest41_Resp_IB_v1.class);
        return responseBean;
    }
}