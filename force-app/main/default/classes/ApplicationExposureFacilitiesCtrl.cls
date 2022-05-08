/**
 * @description       : Controller class for ApplicationExposureFacilities aura component
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-11
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

public class ApplicationExposureFacilitiesCtrl {
	/**
	* @description : Method to get application exposure facility
	* @author Ephetehe Mokgopanyane | 2021-06-11 
	* @param opportunityId 
	* @return List<Map<String, Object>> 
	**/
	@AuraEnabled(Cacheable = false)
	public static List<Map<String, Object>> getApplicationExposure(Id opportunityId) {
		List<Map<String, Object>> appClientExpFacilities = new List<Map<String, Object>>();
		List<Application_Exposure_Facility__c> appExpFacilities = new ApplicationExposureFacilitySelector().selectByOpportunityId(new Set<Id>{opportunityId});

		updateAppExpFacScoredValues(appExpFacilities);

		appExpFacilities = new ApplicationExposureFacilitySelector().selectByOpportunityId(new Set<Id>{opportunityId});

		for (Application_Exposure_Facility__c appExpFacility : appExpFacilities) {
			Map<String, String> mapObj = new Map<String, String>();
			mapObj.put('clientName', appExpFacility.Client_Name__c);
			mapObj.put('approvedFacility', appExpFacility.Approved_Facility__c);
			mapObj.put('exposureNonScored', (appExpFacility.Exposure_Non_Scored__c == null ? '0.00' : String.valueOf(appExpFacility.Exposure_Non_Scored__c)));
			mapObj.put('exposureScored', (appExpFacility.Exposure_Scored__c == null ? '0.00' : String.valueOf(appExpFacility.Exposure_Scored__c)));
			mapObj.put('exposureTotal', (appExpFacility.Exposure_Total__c == null ? '0.00' : String.valueOf(appExpFacility.Exposure_Total__c)));
			mapObj.put('installmentNonScored', (appExpFacility.Installments_Non_Scored__c == null ? '0.00' : String.valueOf(appExpFacility.Installments_Non_Scored__c)));
			mapObj.put('installmentScored', (appExpFacility.Installments_Scored__c == null ? '0.00' : String.valueOf(appExpFacility.Installments_Scored__c)));
			mapObj.put('installmentTotal', (appExpFacility.Installments_Total__c == null ? '0.00' : String.valueOf(appExpFacility.Installments_Total__c)));
			mapObj.put('Id', appExpFacility.Id);
			mapObj.put('lastUpdatedDate', String.valueOf(appExpFacility.LastModifiedDate));
			appClientExpFacilities.add(mapObj);
		}

		return appClientExpFacilities;
	}

	/**
	* @description : Method to get updated application exposure facility
	* @author Ephetehe Mokgopanyane | 2021-06-11 
	* @param appExpFacilities 
	**/
	public static void updateAppExpFacScoredValues(List<Application_Exposure_Facility__c> appExpFacilities) {
		fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[]{Application_Exposure_Facility__c.SObjectType});
		ApplicationExposureFacilities_Resp_IB_v1 responseBean = ApplicationExposureFacilities_IH_v1.applicationExposureFacilitiesAggregate(appExpFacilities);

		for (ApplicationExposureFacilities_Resp_IB_v1.cls_Client client : responseBean.client) {
			for (Application_Exposure_Facility__c appExpFac : appExpFacilities) {
				if (client.name == appExpFac.Client_Name__c && appExpFac.Approved_Facility__c == 'Approved Facilities Total') {
					for (ApplicationExposureFacilities_Resp_IB_v1.cls_Aggregation aggregation : client.aggregation) {
						if (aggregation.aggregationType == 'Approved Facility') {
							appExpFac.Exposure_Scored__c = aggregation.total;
						}
						else if (aggregation.aggregationType == 'Approved Facility Installments') {
							appExpFac.Installments_Scored__c = aggregation.total;
						}
					}
				}
			}
		}

		uow.registerDirty(appExpFacilities);
		uow.commitWork();
	}
}