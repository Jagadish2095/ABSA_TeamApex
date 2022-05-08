/*
 * Integration Handler for ExperianGetXML2Report Service version 2
 * @author Danie Booysen
 * @created 2020-10-01
 */

public class ExperianGetXML2Report_IH_v2 {

	public static final String INTEGRATION_SERVICE_NAME = 'Experian Get XML2 Report_V2';

    public static ExperianGetXML2Report_Resp_IB_v2 ExperianGetXML2Report(List<Contact> directorsListP) {
        ExperianGetXML2Report_Req_IB_v2 requestBean = ExperianGetXML2Report_IU_v2.mapRequestFields(directorsListP);
        ExperianGetXML2Report_Resp_IB_v2 responseBean = (ExperianGetXML2Report_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ExperianGetXML2Report_Resp_IB_v2.class);
        return responseBean;
    }
}