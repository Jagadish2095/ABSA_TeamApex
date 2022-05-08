/**
* GetCustomerVAPMSummary_IU_v1
*
* @author  Muvhuso Nekhubvi : Absa
* @since   2019-09-13
*
*
*
**/
public class GetCustomerVAPMSummary_IU_v1 {
    
    public static GetCustomerVAPMSummary_Req_IB_v1 mapRequestdFields(String customerKey){
        
        GetCustomerVAPMSummary_Req_IB_v1 requestBean = new GetCustomerVAPMSummary_Req_IB_v1();
        GetCustomerVAPMSummary_Req_IB_v1.CustomerVapmSummary requestSummary = new GetCustomerVAPMSummary_Req_IB_v1.CustomerVapmSummary();
        requestSummary.customerKey = customerKey;
        requestBean.GetCustomerVapmSummary = requestSummary;
        return requestBean;
    }
    
    public static GetCustomerVAPMSummary_Resp_IB_v1 mapResponseFields(HttpResponse respP){
		GetCustomerVAPMSummary_Resp_IB_v1 responseBean = (GetCustomerVAPMSummary_Resp_IB_v1)JSON.deserialize(respP.getBody(), GetCustomerVAPMSummary_Resp_IB_v1.class);
		
		return responseBean;
	}
    
    public static GetCustomerVAPMSummary_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        GetCustomerVAPMSummary_Resp_IB_v1 getCustomerVAPMSummaryResponse = new GetCustomerVAPMSummary_Resp_IB_v1();
        getCustomerVAPMSummaryResponse.message = messageP;
        getCustomerVAPMSummaryResponse.status = statusP;
        getCustomerVAPMSummaryResponse.statusCode = statusCodeP;
        return getCustomerVAPMSummaryResponse;
	}
    
    
    
}