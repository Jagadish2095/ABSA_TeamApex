/**
 * @description       :
 * @author            : Almas.Aleem@absa.africa
 * @last modified on  : 2021-07-13
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-07-13   Almas.Aleem@absa.africa   Initial Version
**/
public class AuthorizedUsersController {
    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2021-07-13
     * @param oppId
     * @param appProductId
     * @return List<authorizedUsersWrapper>
    **/
	@AuraEnabled
    public static List<authorizedUsersWrapper> getRelatedParties(Id oppId, Id appProductId) {
		Account acc = new AccountsSelector().selectIndvByOpportunityId(oppId);
		List<Application_Product__c> applicationProductLst  = new ApplicationProductSelector().selectApplicationProductByproductName(oppId,'Credit Card');
		//Application_Product__c appProduct;
		// if(applicationProductLst.size() > 0) {
		//     appProduct = applicationProductLst[0];
		if(appProductId!=null) {
			List<Map<String,Object>> listParties = new List<Map<String,Object>>();
			List<AccountContactRelation> accnRelList = new List<AccountContactRelation>();
			List<authorizedUsersWrapper> authwrapList = new List<authorizedUsersWrapper>();

			accnRelList = [SELECT Id, Contact.FirstName, Contact.LastName, Contact.Title,Roles,
								Share_Percentage__c,contact.account.CASA_Reference_Number__pc,contact.account.cif__c,
								contact.account.ID_Number__pc, contact.account.Passport_Number__pc,
								contact.account.Registration_Number__c,
								contact.AccountId
								FROM AccountContactRelation
								WHERE AccountId =: acc.id AND Roles INCLUDES('Operators on primary accounts ( Internet Main Users, Signatories, Card Users)') order by Share_Percentage__c];

			List<ProductContactSignatoryRelationship__c> authuserrecList = new List<ProductContactSignatoryRelationship__c>();

			authuserrecList = [SELECT Address__r.Address1__c,Address__r.Address2__c,Address__r.Shipping_Suburb__c,
								Address__r.Shipping_Street__c,Address__r.Shipping_Zip_Postal_Code__c,Address__r.Shipping_State_Province__c,
								Id,AccountContactRelationshipId__c,OpportunityProductId__c,
								Delivery_Method__c,Name_on_Card__c,Action_Required__c,Card_Type__c,
								Credit_Limit__c,Product_Name__c,Aircraft_Registration_Number__c,
								Facility_Required__c,Designation__c,Type_of_Client__c,Branch_Name__c,Address__c FROM ProductContactSignatoryRelationship__c WHERE OpportunityProductId__c=:appProductId];

			Map<id,ProductContactSignatoryRelationship__c> authuserrecmap = new Map<id,ProductContactSignatoryRelationship__c>();

			for(ProductContactSignatoryRelationship__c authuserrec: authuserrecList) {
				authuserrecmap.put(authuserrec.AccountContactRelationshipId__c,authuserrec);
			}

			for(AccountContactRelation acr:accnRelList) {
				authorizedUsersWrapper authrec =  new authorizedUsersWrapper();
				authrec.Ids = acr.Id;
				authrec.FName = acr.Contact.FirstName+' '+acr.Contact.LastName;
				authrec.ClientCode = acr.contact.account.cif__c;
				authrec.Passport = acr.Contact.Account.ID_Number__pc != null ? acr.Contact.Account.ID_Number__pc : acr.Contact.Account.Passport_Number__pc != null ? acr.Contact.Account.Passport_Number__pc : acr.Contact.Account.Registration_Number__c != null ? acr.Contact.Account.Registration_Number__c : null;
				authrec.CASA = acr.contact.account.CASA_Reference_Number__pc;
				authrec.AppProductId = appProductId;
				authrec.NameCard = authrec.FName;
				authrec.AccountId = acr.Contact.AccountId;
				authrec.label = authrec.FName;
				authrec.value = acr.Id;

				if(authuserrecmap.containskey(acr.Id)) {
					authrec.AuthUserId = authuserrecmap.get(acr.Id).Id;
					authrec.ActionRequired = authuserrecmap.get(acr.Id).Action_Required__c;
					authrec.NameCard =  authuserrecmap.get(acr.Id).Name_on_Card__c;
					authrec.CreditLimit = authuserrecmap.get(acr.Id).Credit_Limit__c;
					authrec.FacilityRequired = authuserrecmap.get(acr.Id).Facility_Required__c;

					authrec.BranchName = authuserrecmap.get(acr.Id).Branch_Name__c;
					authrec.Address = authuserrecmap.get(acr.Id).Address__c;
					authrec.ClientType = authuserrecmap.get(acr.Id).Type_of_Client__c;
					authrec.CardType = authuserrecmap.get(acr.Id).Card_Type__c;
					authrec.AircraftRegNo = authuserrecmap.get(acr.Id).Aircraft_Registration_Number__c;
					authrec.Designation = authuserrecmap.get(acr.Id).Designation__c;
					authrec.DeliveryMethodValue = authuserrecmap.get(acr.Id).Delivery_Method__c;

					if(authrec.DeliveryMethodValue=='To another address' && authuserrecmap.get(acr.Id).Address__c!=null) {
						authrec.DeliveryAddressLine1 = authuserrecmap.get(acr.Id).Address__r.Address1__c;
						authrec.DeliveryAddressLine2 = authuserrecmap.get(acr.Id).Address__r.Address2__c;
						authrec.DeliveryAddressSuburb = authuserrecmap.get(acr.Id).Address__r.Shipping_Suburb__c;
						authrec.DeliveryAddressTown = authuserrecmap.get(acr.Id).Address__r.Shipping_Street__c;
						authrec.DeliveryAddressPostalCode = authuserrecmap.get(acr.Id).Address__r.Shipping_Zip_Postal_Code__c;
						authrec.DeliveryAddressCountry = authuserrecmap.get(acr.Id).Address__r.Shipping_State_Province__c;
					}
				}
				authwrapList.add(authrec);
			}
			return authwrapList;
		}
		return null;
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2021-07-13
     * @param accId
     * @return List<Address__c>
    **/
    @AuraEnabled
    public static List<Address__c> getAddresses(Id accId){
      return  SecuritiesPrepController.getAddresses(accId);
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2021-07-13
     * @param wrapRec
     * @param oppId
     * @return Id
    **/
    @AuraEnabled
    public static Id saveAuthorizedUsers(authorizedUsersWrapper wrapRec,Id oppId){
		List<Application_Product__c> applicationProductLst  = new ApplicationProductSelector().selectApplicationProductByproductName(oppId,'Credit Card');
		Application_Product__c appProduct;
		if(applicationProductLst.size() > 0) {
			appProduct = applicationProductLst[0];

			if(wrapRec!=null){
				Address__c addrs = new Address__c();

				if(wrapRec.DeliveryMethodValue=='To another address'){
					addrs.Address1__c = wrapRec.DeliveryAddressLine1!=null?wrapRec.DeliveryAddressLine1:null;
					addrs.Address2__c = wrapRec.DeliveryAddressLine2!=null?wrapRec.DeliveryAddressLine2:null;
					addrs.Shipping_Suburb__c = wrapRec.DeliveryAddressSuburb!=null?wrapRec.DeliveryAddressSuburb:null;
					addrs.Shipping_Street__c = wrapRec.DeliveryAddressTown!=null?wrapRec.DeliveryAddressTown:null;
					addrs.Shipping_Zip_Postal_Code__c = wrapRec.DeliveryAddressPostalCode!=null?wrapRec.DeliveryAddressPostalCode:null;
					addrs.Shipping_State_Province__c = wrapRec.DeliveryAddressCountry!=null?wrapRec.DeliveryAddressCountry:null;
					insert addrs;
				}

				ProductContactSignatoryRelationship__c AuthUserRec = new  ProductContactSignatoryRelationship__c();

				//if(wrapRec.Ids!=null && wrapRec.AppproductId!=null){
				if(wrapRec.Ids!=null) {
					if(wrapRec.AuthUserId!=null) {
						AuthUserRec.Id = wrapRec.AuthUserId;
					}

					AuthUserRec.AccountContactRelationshipId__c =  wrapRec.Ids;
					AuthUserRec.OpportunityProductId__c = appProduct.Id;//wrapRec.AppproductId;//'a225r0000009ViOAAU';
					AuthUserRec.Delivery_Method__c = wrapRec.DeliveryMethodValue;
					AuthUserRec.Name_on_Card__c = wrapRec.NameCard;
					AuthUserRec.Action_Required__c = wrapRec.ActionRequired;
					AuthUserRec.Card_Type__c = wrapRec.CardType;
					AuthUserRec.Credit_Limit__c = wrapRec.CreditLimit;
					AuthUserRec.Product_Name__c = 'Credit Card';
					AuthUserRec.Aircraft_Registration_Number__c = wrapRec.AircraftRegNo;
					AuthUserRec.Facility_Required__c = wrapRec.FacilityRequired;
					AuthUserRec.Designation__c = wrapRec.Designation;
					AuthUserRec.Type_of_Client__c = wrapRec.ClientType;

					if(wrapRec.DeliveryMethodValue == 'Branch'){
						AuthUserRec.Branch_Name__c = wrapRec.BranchName!=null? wrapRec.BranchName:null;
					}
					else if(wrapRec.DeliveryMethodValue == 'To another address') {
						AuthUserRec.Address__c = addrs?.Id;
					}
					else{
						AuthUserRec.Address__c = wrapRec.Address;
					}
					upsert AuthUserRec;
					return AuthUserRec.Id;
				}
			}
		}
		return  Null;
    }

    /**
     * @description
     * @author Almas.Aleem@absa.africa | 2021-07-13
    **/
    public class authorizedUsersWrapper{
        @auraEnabled public String Ids;
        @AuraEnabled public String AuthUserId;
        @AuraEnabled public String AppProductId;
        @AuraEnabled public String FName;
        @AuraEnabled public String ClientCode;
        @AuraEnabled public String Passport;
        @AuraEnabled public String CASA;
        @AuraEnabled public String ActionRequired;
        @AuraEnabled public String NameCard;
        @AuraEnabled public Double CreditLimit;
        @AuraEnabled public String FacilityRequired;
        @AuraEnabled public String AccountId;
        @AuraEnabled public String BranchName;
        @AuraEnabled public String Address;
        @AuraEnabled public String ClientType;
        @AuraEnabled public String CardType;
        @AuraEnabled public String AircraftRegNo;
        @AuraEnabled public String Designation;
        @AuraEnabled public String DeliveryMethodValue;
        @AuraEnabled public String DeliveryAddressLine1;
        @AuraEnabled public String DeliveryAddressLine2;
        @AuraEnabled public String DeliveryAddressSuburb;
        @AuraEnabled public String DeliveryAddressTown;
        @AuraEnabled public String DeliveryAddressPostalCode;
        @AuraEnabled public String DeliveryAddressCountry;
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
}