/*
* Integration Handler Bean for IZcreateUniqueKeyV1 Service
* @author Satya Boyenepalli
* @created 10-11-2020
*/
public class IZcreateUniqueKeyV1_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'IZcreateUniqueKeyV1';
    
    public static  IZcreateUniqueKeyV1_Resp_IB_v1 IZcreateUniqueKey(IZcreateUniqueKeyV1_Req_IB_v1 requestBean){  
      IZcreateUniqueKeyV1_Resp_IB_v1 responseBean = (IZcreateUniqueKeyV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  IZcreateUniqueKeyV1_Resp_IB_v1.class);
       return responseBean;
     
    }
}