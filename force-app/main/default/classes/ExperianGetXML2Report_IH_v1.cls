/*
 * Integration Handler for ExperianGetXML2Report Service
 * @author Prashant Jain
 * @created 2020-05-22
 */

public class ExperianGetXML2Report_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'Experian Get XML2 Report';

    public static ExperianGetXML2Report_Resp_IB_v1 ExperianGetXML2Report(String Surname, String First_Name_1, String National_ID, String RSAid, String Birthday) {
        ExperianGetXML2Report_Req_IB_v1 requestBean = ExperianGetXML2Report_IU_v1.mapRequestFields(Surname, First_Name_1, National_ID, RSAid, Birthday);
        ExperianGetXML2Report_Resp_IB_v1 responseBean = (ExperianGetXML2Report_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ExperianGetXML2Report_Resp_IB_v1.class);
        return responseBean;
    }
}