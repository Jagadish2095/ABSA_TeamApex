/**
* Descripton: Apex/Integration Handler class for nqcreateneworaddrecipientv2 service
* Test Class Name: NQcreateneworaddrecipientv22_IH_v1_Test
* @author  Satya Boyenepalli : Absa
* @since   01-12-2020
*
**/

public class NQcreateneworaddrecipientv22_IH_v1 {
 public static final String INTEGRATION_SERVICE_NAME = 'nqcreateneworaddrecipientv2';
     public static  NQcreateneworaddrecipientv22_Resp_IB_v1 Nqcreateneworaddrecipientv2(NQcreateneworaddrecipientv22_Req_IB_v1  requestBean){  
      NQcreateneworaddrecipientv22_Resp_IB_v1 responseBean = (NQcreateneworaddrecipientv22_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  NQcreateneworaddrecipientv22_Resp_IB_v1.class);
       return responseBean;
     
}
}