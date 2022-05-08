public class CIgetRelationshipsV1_IH_v1 {
        
        public static CIgetRelationshipsV1_Resp_IB_v1 CIgetRelationshipsV1(CIgetRelationshipsV1_Req_IB_v1  requestBeanP){
        //CIgetRelationshipsV1_Req_IB_v1  requestBeanP = CIgetRelationshipsV1_Req_IB_v1.createDummyRequest();
        CIgetRelationshipsV1_Resp_IB_v1 responseBean = (CIgetRelationshipsV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBeanP, null, 'CIgetRelationshipsV1', CIgetRelationshipsV1_Resp_IB_v1.class);
        system.debug('@@@responseBean'+responseBean);
        return responseBean;
        
        }
}