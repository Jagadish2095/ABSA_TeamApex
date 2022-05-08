/**
* Descripton: Apex/Integration Handler class for svchangeaccountdomcilebranchv1 service
* Test Class Name: SVChangeAccountDomcileBranchv1_IH_v1_Test
* @author  Anka Ganta : Absa
* @since   2020-07-23
*
**/
public class SVChangeAccountDomcileBranch_IH_v1 {
      public static final String INTEGRATION_SERVICE_NAME = 'svchangeaccountdomcilebranchv1';

    public static SVChangeAccountDomcileBranch_Resp_IB_v1 changeDomcileBranch(SVChangeAccountDomcileBranch_Req_IB_v1 requestBean){
        SVChangeAccountDomcileBranch_Resp_IB_v1 responseBean = (SVChangeAccountDomcileBranch_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, SVChangeAccountDomcileBranch_Resp_IB_v1.class);
        return responseBean;
    }
}