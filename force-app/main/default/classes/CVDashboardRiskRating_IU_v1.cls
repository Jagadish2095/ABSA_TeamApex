/**
 * @description       : Integration utility class for Risk Rating
 * @author            : Mohammed Junaid
 * @group             :
 * @last modified on  : 10-05-2021
 * @last modified by  : Mohammed Junaid U
 * Modifications Log
 * Ver   Date         Author            Modification
 * 1.0   2021-10-05   Mohammed Junaid   Initial Version
**/
public class CVDashboardRiskRating_IU_v1 {
    
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-10-18 
    * @param accountP 
    * @return CVDashboardRiskRatingRequest_IB_v1 
    **/
    public static CVDashboardRiskRatingRequest_IB_v1 mapRequestFields(Account accountP){
        CVDashboardRiskRatingRequest_IB_v1 requestPayload = new CVDashboardRiskRatingRequest_IB_v1();
        requestPayload.apiVersionNo = '7.5';
        requestPayload.source ='FICREM';
        String referenceNo = accountP.CASA_Reference_Number__c == null || accountP.CASA_Reference_Number__c == ''? 
                accountP.CASA_Reference_Number__pc : accountP.CASA_Reference_Number__c;
        requestPayload.refNo = Integer.valueOf(referenceNo);
        return requestPayload;
    }

}