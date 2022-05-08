/**
 * @description       : Controller class for ProductTypeExposure component
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-11
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-10   Englarmerdge Mongwe   Initial Version
**/

public class ProductTypeExposureDetailsController {
    /**
 * @description       : Class to create the wrapper class
 * @author            : Englarmerdge Mongwe
 **/
    public class WrapperData {
        @AuraEnabled public String ClientName;
        @AuraEnabled public String Product;
        @AuraEnabled public Decimal Limit_z;
        @AuraEnabled public Decimal Excess;
        @AuraEnabled public Decimal Installment;
        @AuraEnabled public Decimal Arrears;
        @AuraEnabled public Boolean IsTotal;
        @AuraEnabled public Boolean IsFirstOutPVis;
        @AuraEnabled public Datetime LastModifiedDate;

        /**
        * @description :Setting the wrapper data
        * @author Englarmerdge Mongwe | 2021-06-10 
        **/
        public WrapperData() {
            ClientName = null;
            Product = null;
            Limit_z = 0.00;
            Excess = 0.00;
            Installment = 0.00;
            Arrears = 0.00;
            IsTotal = null;
            IsFirstOutPVis = null;
            LastModifiedDate = null;
        }
    }

    /**
    * @description :Method to get the Product type exposure details
    * @author Englarmerdge Mongwe | 2021-06-10 
    * @param oppID 
    * @return List<WrapperData> 
    **/
    @AuraEnabled
    public static List<WrapperData> getProductTypeExposureDetails(String oppID) {
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(oppID);
        List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(appList[0].Id);
        List<Application_Exposure__c> appExpList = new ApplicationExposureSelector().getAllApplicationExposure(appList[0].Id);
        List<WrapperData> wrapList = new List<WrapperData>();
        Integer count = 0;
        String clientName;
        List<String> clientNames = new List<String>();

        if(appExpList != null && appExpList.size() > 0) {

            List<Application_Profile__c> newOrdProList = ExposureController.orderedProfilesList(appProfileList, oppID);

            for(Application_Profile__c appProfile : newOrdProList) {
                system.debug('appProfile'+appProfile);
                count = 0;
                clientName = appProfile.Client_Name__c;
				system.debug('clientNames'+clientNames);
                system.debug('clientName'+clientName);
                if(!clientNames.contains(clientName)) {

                    List<Application_Exposure__c> appExpList2 = new ApplicationExposureSelector().getApplicationExposureByClientName(clientName, appList[0].Id);

                    for(String prod : productNames()) {
                        count++;
						system.debug('prod'+prod);
                        for(Application_Exposure__c appExp : appExpList2) {
                            
							system.debug('appExp.Exposure_Data_Type__c'+appExp.Exposure_Data_Type__c);
                            if(prod == appExp.Exposure_Data_Type__c) {
                                WrapperData rewrapp = new WrapperData();
                                rewrapp.Product = appExp.Exposure_Data_Type__c;
                                rewrapp.ClientName = appExp.Client_Name__c;
                                rewrapp.Limit_z = Decimal.valueOf(appExp.Limit__c);
                                rewrapp.Excess = Decimal.valueOf(appExp.Excess__c);
                                rewrapp.Installment = Decimal.valueOf(appExp.Installment__c);
                                rewrapp.Arrears = Decimal.valueOf(appExp.Arrears__c);

                                if(count == 1) {
                                    rewrapp.IsFirstOutPVis = true;
                                }

                                if(appExp.Exposure_Data_Type__c.contains('Total')) {
                                    rewrapp.Product = appExp.Exposure_Data_Type__c.right(5);
                                    rewrapp.IsTotal = true;
                                }

                                rewrapp.LastModifiedDate = appExp.LastModifiedDate;
                                wrapList.add(rewrapp);
                                system.debug('rewrapp'+rewrapp);
                                clientNames.add(clientName);
                                system.debug('clientName'+clientName);
                                break;
                            }
                        }
                    }
                }
            }
        }

        return wrapList;
    }

    private static List<String> productNames() {
        return new List<String>{'Cheques',
                                'Loans',
                                'Credit Card',
                                'Other Ordinary Credit',
                                'Asset Finance',
                                'Mortgage Loans',
                                'Mortgage Residential',
                                'Product Type Total'
                            };
    }
}