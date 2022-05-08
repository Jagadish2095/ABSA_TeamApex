/**
* GetCustomerVAPMSummary_Req_IB_v1
*
* @author  Muvhuso Nekhubvi : Absa
* @since   2019-09-13
*
*
*
**/
public class GetCustomerVAPMSummary_Req_IB_v1 {
    
    public CustomerVapmSummary GetCustomerVapmSummary; 
     
    public class CustomerVapmSummary{
        
        public String customerKey;
        
        
 }
    
   public GetCustomerVAPMSummary_Req_IB_v1 creatDummyRequest(){
        
        
        GetCustomerVAPMSummary_Req_IB_v1 reqBean = new GetCustomerVAPMSummary_Req_IB_v1();
        
        GetCustomerVAPMSummary_Req_IB_v1.CustomerVapmSummary requestSummary = new GetCustomerVAPMSummary_Req_IB_v1.CustomerVapmSummary();
        requestSummary.customerKey = 'ARENTAL001';
        reqBean.GetCustomerVapmSummary = requestSummary;
        return reqBean;
        
    }
   
}