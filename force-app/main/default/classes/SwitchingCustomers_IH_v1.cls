/**
* Integration Handler for Switching Customers
* @author André Pietersen
* @created 2020-10-01
* Edgar Blount 2020-10-05 - Added customerTrigger method
*/
public class SwitchingCustomers_IH_v1 {
    public static final String SwitchingCustomersGET = 'Switching Customers GET';
    public static final String SwitchingCustomersPOST = 'Switching Customers POST';
    
    public static SwitchingCustomers_Resp_IB_v1 getSwitchingCustomer(String identifier){
        SwitchingCustomers_Resp_IB_v1 responseBean = (SwitchingCustomers_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(null, '/search/findByIdentifier?identifier=' + identifier, SwitchingCustomersGET, SwitchingCustomers_Resp_IB_v1.class);
        return responseBean;
    }

    public static SwitchingCustomers_Resp_IB_v1 createSwitchingCustomer(SwitchingCustomers_Req_IB_v1 requestBean){
        SwitchingCustomers_Resp_IB_v1 responseBean = (SwitchingCustomers_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, SwitchingCustomersPOST, SwitchingCustomers_Resp_IB_v1.class);
        return responseBean;
    }
    public static SwitchingCustomers_Resp_IB_v1 customerTrigger(String customerId, String customerTrigger){
        SwitchingCustomers_Resp_IB_v1 resp = (SwitchingCustomers_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(null, '/'+ customerId +'/trigger?triggerName=' + customerTrigger, SwitchingCustomersGET, SwitchingCustomers_Resp_IB_v1.class);
        return resp;
    }

}