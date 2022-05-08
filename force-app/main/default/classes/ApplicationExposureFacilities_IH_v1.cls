/**
 * @description       : Integration handler class for Application Exposure Facilities
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-11
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

public class ApplicationExposureFacilities_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'MicroserviceApprovedFacilities';

    /**
    * @description : Method to get all the aggregated application exposure facilities
    * @author Ephetehe Mokgopanyane | 2021-06-11 
    * @param appExpFacilities 
    * @return ApplicationExposureFacilities_Resp_IB_v1 
    **/
    public static ApplicationExposureFacilities_Resp_IB_v1 applicationExposureFacilitiesAggregate(List<Application_Exposure_Facility__c> appExpFacilities){
        ApplicationExposureFacilities_Req_IB_v1 requestBean = ApplicationExposureFacilities_IU_v1.mapRequestFields(appExpFacilities);
        ApplicationExposureFacilities_Resp_IB_v1 responseBean = (ApplicationExposureFacilities_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,ApplicationExposureFacilities_Resp_IB_v1.class);
        
        return responseBean;
    }
}