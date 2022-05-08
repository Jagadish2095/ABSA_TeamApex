/**
* Descripton: Apex/Integration Handler class for Generatedocumentsv1 service(docPack Orchestration service)
* Test Class Name: GetDocumentsv1_IH_v1_Test
* @author  Anka Ganta : Absa
* @since   2020-07-20
*
**/
public class GetDocumentsv1_IH_v1 {
   public static final String INTEGRATION_SERVICE_NAME = 'GetDocsOrchestration';

    public static GetDocumentsv1_Resp_IB_v1 getDocuments(GetDocumentsv1_Req_IB_v1 requestBean){
        GetDocumentsv1_Resp_IB_v1 responseBean = (GetDocumentsv1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, GetDocumentsv1_Resp_IB_v1.class);
        return responseBean;
    }
}