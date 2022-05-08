/**
 * @description       : Integration utilities class for Application Exposure Facilities
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-11
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

public class ApplicationExposureFacilities_IU_v1 {
    
	/**
	* @description : Method to map request fields
	* @author Ephetehe Mokgopanyane | 2021-06-11 
	* @param appExpFacilities 
	* @return ApplicationExposureFacilities_Req_IB_v1 
	**/
	public static ApplicationExposureFacilities_Req_IB_v1 mapRequestFields(List<Application_Exposure_Facility__c> appExpFacilities) {
    	List<ApplicationExposureFacilities_Req_IB_v1.cls_Client> clients = new List<ApplicationExposureFacilities_Req_IB_v1.cls_Client>();
        ApplicationExposureFacilities_Req_IB_v1.cls_Client client = new ApplicationExposureFacilities_Req_IB_v1.cls_Client();
        ApplicationExposureFacilities_Req_IB_v1.cls_Facility facility = new ApplicationExposureFacilities_Req_IB_v1.cls_Facility();
        ApplicationExposureFacilities_Req_IB_v1.cls_InstalmentFacility installmentFacility = new ApplicationExposureFacilities_Req_IB_v1.cls_InstalmentFacility();
        
        String previousClientName = '';
        
        for(Application_Exposure_Facility__c appExpFacility : appExpFacilities){
            if(appExpFacility.Client_Name__c != previousClientName){
                if(previousClientName != ''){
                	client.facility = facility;
                	client.installmentFacility = installmentFacility;
                    clients.add(client);
                }
                
                previousClientName = appExpFacility.Client_Name__c;
                client = new ApplicationExposureFacilities_Req_IB_v1.cls_Client();
                facility = new ApplicationExposureFacilities_Req_IB_v1.cls_Facility();
                installmentFacility = new ApplicationExposureFacilities_Req_IB_v1.cls_InstalmentFacility();
                client.Name = appExpFacility.Client_Name__c;
            }
            
            if(appExpFacility.Approved_Facility__c == 'Settlement Limits Approved'){
                facility.settlementLimitsApproved = appExpFacility.Exposure_Scored__c==null? 0.00 : appExpFacility.Exposure_Scored__c;
                installmentFacility.settlementLimitsApproved = appExpFacility.Installments_Scored__c==null? 0.00 : appExpFacility.Installments_Scored__c;
            } else if(appExpFacility.Approved_Facility__c == 'Approved Facilities Ordinary Credit - Business Bank'){
                facility.ordinaryCreditBusinessBank = appExpFacility.Exposure_Scored__c==null? 0.00 : appExpFacility.Exposure_Scored__c;
                installmentFacility.ordinaryCreditBusinessBank = appExpFacility.Installments_Scored__c==null? 0.00 : appExpFacility.Installments_Scored__c;
            } else if(appExpFacility.Approved_Facility__c == 'Approved Facilities Ordinary Credit - Retail'){
                facility.ordinaryCreditRetail = appExpFacility.Exposure_Scored__c==null? 0.00 : appExpFacility.Exposure_Scored__c;
                installmentFacility.ordinaryCreditRetail = appExpFacility.Installments_Scored__c==null? 0.00 : appExpFacility.Installments_Scored__c;
            } else if(appExpFacility.Approved_Facility__c == 'Approved Facilities Asset Finance - Business Bank'){
                facility.assetFinanceBusinessBank = appExpFacility.Exposure_Scored__c==null? 0.00 : appExpFacility.Exposure_Scored__c;
                installmentFacility.assetFinanceBusinessBank = appExpFacility.Installments_Scored__c==null? 0.00 : appExpFacility.Installments_Scored__c;
            } else if(appExpFacility.Approved_Facility__c == 'Approved Facilities Asset Finance- Retail'){
                facility.assetFinanceRetail = appExpFacility.Exposure_Scored__c==null? 0.00 : appExpFacility.Exposure_Scored__c;
                installmentFacility.assetFinanceRetail = appExpFacility.Installments_Scored__c==null? 0.00 : appExpFacility.Installments_Scored__c;
            } else if(appExpFacility.Approved_Facility__c == 'Approved Mortgage Facilities - Business Bank'){
                facility.mortgageBusinessBank = appExpFacility.Exposure_Scored__c==null? 0.00 : appExpFacility.Exposure_Scored__c;
                installmentFacility.mortgageBusinessBank = appExpFacility.Installments_Scored__c==null? 0.00 : appExpFacility.Installments_Scored__c;
            } else if(appExpFacility.Approved_Facility__c == 'Approved Mortgage Facilities - Retail'){
                facility.mortgageRetail = appExpFacility.Exposure_Scored__c==null? 0.00 : appExpFacility.Exposure_Scored__c;
                installmentFacility.mortgageRetail = appExpFacility.Installments_Scored__c==null? 0.00 : appExpFacility.Installments_Scored__c;
            }
        }
		
        if(previousClientName != ''){
            client.facility = facility;
            client.installmentFacility = installmentFacility;
            
            clients.add(client);
        }
        
        ApplicationExposureFacilities_Req_IB_v1 requestBean = new ApplicationExposureFacilities_Req_IB_v1();
        requestBean.client = clients;
        
        return requestBean;
    }
}