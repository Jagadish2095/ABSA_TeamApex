/**
 * Integration utilities class for Consumer Bureau Enquiry
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date November 2020
 */
public class ConsumerBureauEnquiry_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'ConsumerBureauEnquiry';

    public static ConsumerBureauEnquiry_Resp_IB_v1 consumerBureauEnquiry(String apppcceId){
        ConsumerBureauEnquiry_Req_IB_v1 requestBean = ConsumerBureauEnquiry_IU_v1.mapRequestFields(apppcceId);
        ConsumerBureauEnquiry_Resp_IB_v1 responseBean = (ConsumerBureauEnquiry_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ConsumerBureauEnquiry_Resp_IB_v1.class);

        return responseBean;
    }
}