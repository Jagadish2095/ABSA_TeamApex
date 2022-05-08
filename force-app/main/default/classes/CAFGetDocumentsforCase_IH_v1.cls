/*
 * Integration Handler Class for bcmsgetdocumentsforcase
 * @author Haritha Police
 * @created 20-01-2021
 */
public class CAFGetDocumentsforCase_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'BcmsGetDocumentsForCase';

    public static CAFGetDocumentsforCase_Resp_IB_v1 bcmsGenerateDocumentforcasev1data(string caseId) {
        CAFGetDocumentsforCase_Req_IB_v1 requestBean = CAFGetDocumentsforCase_IU_v1.mapRequestfieldsOfGenerateDocsForCase(caseId);
        CAFGetDocumentsforCase_Resp_IB_v1 responseBean = (CAFGetDocumentsforCase_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, CAFGetDocumentsforCase_Resp_IB_v1.class);
        return responseBean;
    }
}