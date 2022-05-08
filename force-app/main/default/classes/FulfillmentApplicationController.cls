/**
 * @description       : Controller class for the FulfillmentApplication component
 * @author            : Danie Booysen
 * @last modified on  : 2021-10-19
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-07-13   Danie Booysen   Initial Version
 **/
public with sharing class FulfillmentApplicationController{
	/**
	 * @description : Method called via init on FulfillmentApplication cmp
	 * @author Danie Booysen | 2021-07-13
	 * @param oppId
	 * @return List<ClientDataWrapper>
	 **/
	@AuraEnabled
	public static List<ClientDataWrapper> getClientData(String oppId){
		List<ClientDataWrapper> clientWrapperList = new List<ClientDataWrapper>();
		Account account = new AccountsSelector().selectByOpportunityId(oppId);
		List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(account.Id);
		//Securities Offered to be added as clients when the functionality for securities is working
		if (accnRelList != null && accnRelList.size() > 0){
			//Main entity - using first account for main entity because all the accounts in the AccountContactRelation is the same related account
			ClientDataWrapper client = new ClientDataWrapper();
			client.clientName = accnRelList[0].Account.Name;
			client.clientCode = accnRelList[0].Account.CIF__c;
			client.clientIdRegNumber = accnRelList[0].Account.Registration_Number__c;
			client.onboardingStatus = accnRelList[0].Account.Customer_Compliant__c;
			client.isApplicant = true;
			clientWrapperList.add(client);

			//Related parties - contacts with a share holding %. Roles: Shareholder/Controller, Director
			for (AccountContactRelation acr : accnRelList){
				if (acr.Share_Percentage__c != 0 || acr.Roles.contains('Sureties')){
					client = new ClientDataWrapper();
					client.clientName = String.valueOf(acr.Contact.FirstName + ' ' + acr.Contact.LastName);
					client.clientCode = acr.Contact.CIF__c;
					client.clientIdRegNumber = acr.Contact.ID_Number__c;
					client.Roles = acr.Roles;
					clientWrapperList.add(client);
				}
			}
		}
		return clientWrapperList;
	}

	/**
	 * @description : Method to fetch user
	 * @author Danie Booysen | 2021-07-13
	 * @param oppId
	 * @return Boolean
	 **/
	@AuraEnabled
	public static Boolean fetchUser(String oppId){
		// query current user information
		//user u = new UsersSelector().selectById(userinfo.getUserId());
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		if (opp != Null){
			User u = [select id, RBB_Super_Region__c
			          FROM User
			          Where id = :opp.OwnerId];
			if (u.RBB_Super_Region__c != Null && u.RBB_Super_Region__c != ''){
				return true;
			} else{
				return false;
			}
		} else
			return false;
	}

	/**
	 * @description : Method called via from the FulfillmentApplication cmp when validating to submit to fulfillment
	 * @author Danie Booysen | 2021-07-13
	 * @param oppId
	 * @return List<Security_Offered__c>
	 **/
	@AuraEnabled
	public static List<Security_Offered__c> getSecuritiesOfferedData(String oppId){
		List<Application__c> applicationList = new ApplicationsSelector().selectByOpportunityId(oppId);
		List<Security_Offered__c> securitiesOfferedList = new securitiesOfferedSelector().selectByApplicationId(applicationList[0].Id);

		return securitiesOfferedList;
	}

	/**
	 * @description : Method to get updated compliance
	 * @author Himani Joshi | 2021-07-13
	 * @param oppId
	 * @param checkboxValue
	 * @return Boolean
	 **/
	@AuraEnabled
	public static Boolean getUpdatedCompliance(String oppId, Boolean checkboxValue){
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		opp.Customer_Compliant__c = checkboxValue == True ? true : false;
		update opp;
		return opp.Customer_Compliant__c;
	}

	/**
	 * @description : Method called via init on FulfillmentApplication cmp
	 * @author Danie Booysen | 2021-07-13
	 * @param oppId
	 * @return Map<String, List<ProductDataWrapper>>
	 **/
	@AuraEnabled
	public static Map<String, List<ProductDataWrapper>> getCreditProductData(String oppId){
		List<ProductDataWrapper> applicationProductAccepted = new List<ProductDataWrapper>();
		Map<String, List<ProductDataWrapper>> applicationProductListMap = new Map<String, List<ProductDataWrapper>>();
		//check each product whether term loan,overdraft,CC,LDP accordingly create case for that
		List<Application_Product__c> relatedAppProductList = [Select Id, Application_Product_Parent__c, Accept_TOB__c, Product_Name__c, Product_Amount__c, Product_Status__c, tolabel(Product_Type__c)prodtype, Account_Number__c, Temp_Account_Number__c, Product_State__c, Secured_By_Mortgage_Bond__c, Agreement_Category__c, NCA_Appplicable__c, Business_Credit_Card_Sub_Product_Type__c
                                                              ,Facility_account_number__c
		                                                      From Application_Product__c
		                                                      where Opportunity__c = :oppId AND Application_Product_Parent__c = null AND Accept_TOB__c = true];
		if (relatedAppProductList != null){
			for (Application_Product__c appProd : relatedAppProductList){
				if (appProd.Product_Name__c.equalsIgnoreCase('cheque')){
					//start making product wrapper for overdraft
					List<ProductDataWrapper> overdraftWrapper = getODWrapper(appProd);
					applicationProductAccepted.addAll(overdraftWrapper);
				} else if (appProd.Product_Name__c.equalsIgnoreCase('Credit Card')){
					//start making product wrapper for Credit Card
					//start making product wrapper for overdraft
					ProductDataWrapper CCWrapper = getCCWrapper(appProd);
					applicationProductAccepted.add(CCWrapper);
				} else if (appProd.Product_Name__c.equalsIgnoreCase('Bank Guarantee')){
					//start making product wrapper for LDP
					
					ProductDataWrapper LDPWrapper = getLDPWrapper(appProd);
					applicationProductAccepted.add(LDPWrapper);
				}
				//add similar condition for terms loans and ldp
			}
		}
		applicationProductListMap.put('Accepted', applicationProductAccepted);
		return applicationProductListMap;
	}

	/**
	 * @description : Method to create OD wrapper class
	 * @author Danie Booysen | 2021-07-13
	 * @param appProd
	 * @return List<ProductDataWrapper>
	 **/
	public static List<ProductDataWrapper> getODWrapper(Application_Product__c appProd){
		List<ProductDataWrapper> odwrapper = new List<ProductDataWrapper>();

		//Inline query used for the toLabel query function to be included to get the label value for the api value of the picklist
		List<Application_Product__c> applicationProductList = [SELECT Id, Application_Product_Parent__c, Application_Product_Parent__r.Accept_TOB__c, Product_Name__c, Product_Amount__c, Application_Product_Parent__r.Product_Status__c, Agreement_Category__c, tolabel(Application_Product_Parent__r.Product_Type__c), tolabel(Product_Type__c)prodtype, Account_Number__c, Application_Product_Parent__r.Account_Number__c, Secured_By_Mortgage_Bond__c, NCA_Appplicable__c, Application_Product_Parent__r.Product_State__c, Application_Product_Parent__r.Product_Name__c, Temp_Account_Number__c, Application_Product_Parent__r.NCA_Appplicable__c, Application_Product_Parent__r.Temp_Account_Number__c
		                                                       FROM Application_Product__c
		                                                       WHERE Application_Product_Parent__c = :appProd.Id];

		for (Application_Product__c product : applicationProductList){
			if (product.Application_Product_Parent__r.Product_Status__c == 'Accepted' && product.Application_Product_Parent__r.Accept_TOB__c == true){
				 // add condition if accepted from accept tob list && product.Application_Product_Parent__r.Accept_TOB__c == true
				ProductDataWrapper productData = new ProductDataWrapper();
				if (product.Application_Product_Parent__r.Product_State__c != null && product.Application_Product_Parent__r.Product_State__c.equals('New')){
					if (product.Application_Product_Parent__r.Account_Number__c != null){
						productData.productAccountNumber = product.Application_Product_Parent__r.Account_Number__c != null ? String.valueOf(product.Application_Product_Parent__r.Account_Number__c) : null;

					} else if (product.Application_Product_Parent__r.Account_Number__c == null){
						productData.productAccountNumber = 'CHQ-' + product.Application_Product_Parent__r.Temp_Account_Number__c; //  product.Temp_Account_Number__c Need to check
					}
					//product.Account_Number__c = product.Application_Product_Parent__r.Temp_Account_Number__c;

				} else if (product.Application_Product_Parent__r.Product_State__c != null && product.Application_Product_Parent__r.Product_State__c.equals('Existing')){
					productData.productAccountNumber = product.Application_Product_Parent__r.Account_Number__c != null ? String.valueOf(product.Application_Product_Parent__r.Account_Number__c) : null;
					product.Account_Number__c = product.Application_Product_Parent__r.Account_Number__c;

				}
				String nameConcat = product.Product_Name__c + ' ' + product.Application_Product_Parent__r.Product_Name__c;// name parent....check and change later
				productData.productName = nameConcat;
				productData.productType = product.Application_Product_Parent__r.Product_Type__c;
				//productData.productAccountNumber = product.Application_Product_Parent__r.Account_Number__c;
				//productData.productAccountNumber =''+ product.Account_Number__c;
				productData.productAmount = product.Product_Amount__c; //child
				productData.productStatus = product.Application_Product_Parent__r.Product_Status__c;
				productData.productState = product.Application_Product_Parent__r.Product_State__c;
				productData.Id = product.Application_Product_Parent__c;
				productData.tempAccountNumber = product.Temp_Account_Number__c;//added by Manish for W-011452
				productData.parentTempAccountNumber = product.Application_Product_Parent__r.Temp_Account_Number__c;//added by Manish for W-011452
				productData.parentAccountNumber = product.Application_Product_Parent__r.Account_Number__c;//added by Manish for W-011452
				String agreementCategory = '';
				if (product.Secured_By_Mortgage_Bond__c == true){
					agreementCategory = 'Large';
				} else{
					if (product.Product_Amount__c < 15000 && product.Product_Amount__c > 0){
						agreementCategory = 'Small';
					} else if (product.Product_Amount__c >= 15000 && product.Product_Amount__c < 250000){
						agreementCategory = 'Intermediate';
					} else if (product.Product_Amount__c >  = 250000){
						agreementCategory = 'Large';
					}
				}
				productData.ncaAppplicable = !String.isBlank(agreementCategory) && product.Application_Product_Parent__r.NCA_Appplicable__c != null ? product.Application_Product_Parent__r.NCA_Appplicable__c + ' ' + agreementCategory : product.Application_Product_Parent__r.NCA_Appplicable__c;//added by Manish for W-011452
				odwrapper.add(productData);
			}
		}
		update applicationProductList;
		return odwrapper;
	}

	/**
	 * @description : Method to get wrapper for credit card
	 * @author Danie Booysen | 2021-07-13
	 * @param product
	 * @return ProductDataWrapper
	 **/
	public static ProductDataWrapper getCCWrapper(Application_Product__c product){
		ProductDataWrapper productData = new ProductDataWrapper();
		productData.productName = product.Product_Name__c;
		productData.productType = product.Business_Credit_Card_Sub_Product_Type__c;//+product.get('prodtype');
		//productData.productAccountNumber = product.Application_Product_Parent__r.Account_Number__c;
		productData.productAccountNumber = '' + product.Account_Number__c;
		productData.productStatus = product.Product_Status__c;
		productData.productState = product.Product_State__c;
		productData.Id = product.Id;
		productData.tempAccountNumber = product.Temp_Account_Number__c;
		// productData.parentTempAccountNumber = product.Application_Product_Parent__r.Temp_Account_Number__c;
		productData.parentAccountNumber = product.Account_Number__c;//added by Manish for W-011452
		String agreementCategory = '';
		if (product.Secured_By_Mortgage_Bond__c == true){
			agreementCategory = 'Large';
		} else{
			if (product.Product_Amount__c < 15000 && product.Product_Amount__c > 0){
				agreementCategory = 'Small';
			} else if (product.Product_Amount__c >= 15000 && product.Product_Amount__c < 250000){
				agreementCategory = 'Intermediate';
			} else if (product.Product_Amount__c >  = 250000){
				agreementCategory = 'Large';
			}
		}
		productData.ncaAppplicable = !String.isBlank(agreementCategory) && product.NCA_Appplicable__c != null ? product.NCA_Appplicable__c + ' ' + agreementCategory : product.NCA_Appplicable__c;

		//update Credit Card Final Limit From TOB

		List<Terms_Of_Business__c> tobList = [Select id, Application_Product__c, TOB_Classification__c, Tob_Description__c, Existing_Account__c, Requested__c, Final_Offered_Number__c, Offered_by_Powercurve__c, Final_Offered__c
		                                      from Terms_Of_Business__c
		                                      Where Application_Product__c = :product.Id];

		if (tobList != null){
			for (Terms_Of_Business__c tob : tobList){
				if (tob.Tob_Description__c.equalsIgnoreCase('Limit')){
					product.Credit_Card_Limit__c = Decimal.valueOf(tob.Final_Offered__c);
					//prWrapper.creditAdvanced = Decimal.valueOf(tob.Final_Offered__c);
					productData.productAmount = Decimal.valueOf(tob.Final_Offered__c);
				}
			}
		}
		update product;
		return productData;
	}

    
    
    /**
	 * @description : Method to get wrapper for credit card
	 * @author Almas Aleem| 2021-09-13
	 * @param product
	 * @return ProductDataWrapper
	 **/
	public static ProductDataWrapper getLDPWrapper(Application_Product__c product){
		ProductDataWrapper productData = new ProductDataWrapper();
		productData.productName = product.Product_Name__c;
		productData.productType = product.Product_Name__c;//+product.get('prodtype');
		//productData.productAccountNumber = product.Application_Product_Parent__r.Account_Number__c;
		 String accountNumber;
            if (product.Product_State__c == 'New') {
                accountNumber = product.Temp_Account_Number__c;
            } else {
                accountNumber = '' + product.Facility_account_number__c;
            }
		productData.productAccountNumber = accountNumber;
		productData.productStatus = product.Product_Status__c;
		productData.productState = product.Product_State__c;
		productData.Id = product.Id;
		productData.tempAccountNumber = product.Temp_Account_Number__c;
		// productData.parentTempAccountNumber = product.Application_Product_Parent__r.Temp_Account_Number__c;
		productData.parentAccountNumber = product.Account_Number__c;//added by Manish for W-011452
		String agreementCategory = '';
		if (product.Secured_By_Mortgage_Bond__c == true){
			agreementCategory = 'Large';
		} else{
			if (product.Product_Amount__c < 15000 && product.Product_Amount__c > 0){
				agreementCategory = 'Small';
			} else if (product.Product_Amount__c >= 15000 && product.Product_Amount__c < 250000){
				agreementCategory = 'Intermediate';
			} else if (product.Product_Amount__c >  = 250000){
				agreementCategory = 'Large';
			}
		}
		productData.ncaAppplicable = !String.isBlank(agreementCategory) && product.NCA_Appplicable__c != null ? product.NCA_Appplicable__c + ' ' + agreementCategory : product.NCA_Appplicable__c;

		//update Credit Card Final Limit From TOB

		List<Terms_Of_Business__c> tobList = [Select id, Application_Product__c, TOB_Classification__c, Tob_Description__c, Existing_Account__c, Requested__c, Final_Offered_Number__c, Offered_by_Powercurve__c, Final_Offered__c
		                                      from Terms_Of_Business__c
		                                      Where Application_Product__c = :product.Id];

		if (tobList != null){
			for (Terms_Of_Business__c tob : tobList){
				if (tob.Tob_Description__c.equalsIgnoreCase('Limit')){
					//product.Credit_Card_Limit__c = Decimal.valueOf(tob.Final_Offered__c);
					//prWrapper.creditAdvanced = Decimal.valueOf(tob.Final_Offered__c);
					productData.productAmount = Decimal.valueOf(tob.Final_Offered__c);
                    product.Requested_facility_limit__c =''+ tob.Final_Offered__c;
                    
				}
			}
		}
		update product;
		return productData;
	}

	/**
	 * @description : Method to create fullfillment case
	 * @author Danie Booysen | 2021-07-13
	 * @param oppId
	 * @return String
	 **/
	@AuraEnabled
	public static String createFulfillmentCase(String oppId){
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		//check each product whether term loan,overdraft,CC,LDP accordingly create case for that
		List<Application_Product__c> relatedAppProductList = [select Id, Product_Name__c, Application_Product_Parent__c
		                                                      From Application_Product__c
		                                                      where Opportunity__c = :oppId AND Application_Product_Parent__c = null AND Accept_TOB__c = true];
		if (relatedAppProductList != null){
			for (Application_Product__c appProd : relatedAppProductList){
				if (appProd.Product_Name__c.equalsIgnoreCase('cheque')){
					//start overdraft case creation logic
					createFulfillmentCaseOverDraft(oppID, appProd.Id);
				} else if (appProd.Product_Name__c.equalsIgnoreCase('Credit Card') || appProd.Product_Name__c.equalsIgnoreCase('LDP')){
					//start CC case creation logic
					createFulfillmentCaseCC(oppID, appProd.Id,appProd.Product_Name__c);
				}else if(appProd.Product_Name__c.equalsIgnoreCase('Bank Guarantee')){
                    //start LDP case creation logic   
                    createFulfillmentCaseLDP(oppID, appProd.Id);
                    
                }
				//add similar condition for terms loans and ldp
			}
		}
		//update opp stage
		opp.StageName = 'Submit For FulFilment';
		opp.Is_Submitted_FulFilment__c = true;
		try{
			update opp;
			//Added by Himanshu -W-011453
			User u = [select id, Name
			          from User
			          where id = :userInfo.getUserId()];
			CreditDecisionSummaryController.submitActivityHistory(oppId, 'Activity History', 'Submit to Fulfillment', u.Name, '0');
			pcoCallout(opp.Id);
			return 'Success';
		} catch (Exception ex){
			return 'Message: ' + ex.getMessage()+'. Stacktrace: ' + ex.getStackTraceString();
		}
	}

	/**
	 * @description : Method to creatr fullfillment case for CC
	 * @author Danie Booysen | 2021-07-13
	 * @param oppId
	 * @param appProdId
	 * @param prodName
	 **/
	public static void createFulfillmentCaseCC(String oppId, String appProdId, String prodName){
		Id caseRecordTypeId;
        List<Service_Group__c> serviceGroupList = new List<Service_Group__c>();
		if (prodName.equalsIgnoreCase('Credit Card')){
            caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Credit Card  Fulfilment').getRecordTypeId();
            serviceGroupList = new ServiceGroupsSelector().selectByName(new Set<String>{'Credit Card FulFillment Group'});
        } else if (prodName.equalsIgnoreCase('LDP')){
            caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LDP Fulfilment').getRecordTypeId();
            serviceGroupList = new ServiceGroupsSelector().selectByName(new Set<String>{'LDP Fulfilment Group'});
        }
		List<Service_Group_Type__c> serviceGroupTypes;
		if (serviceGroupList != null & serviceGroupList.size() == 1){
			serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(new Set<Id>{serviceGroupList[0].Id});
		}

		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		Application_Product__c appProduct = [SELECT Id, Application_Product_Parent__c, Accept_TOB__c, Product_Name__c, Product_Amount__c, Product_Status__c, tolabel(Product_Type__c)prodtype, Account_Number__c, Product_State__c
		                                     FROM Application_Product__c
		                                     WHERE Opportunity__c = :oppId AND Accept_TOB__c = true AND Id = :appProdId];

		Case fulfillmentCase = new Case();
		fulfillmentCase.RecordTypeId = caseRecordTypeId;
		fulfillmentCase.Application_Product_Id__c = appProduct.Id;//appProduct.Id; //appProduct.Application_Product_Parent__c; creating case on child
		fulfillmentCase.Status = 'New';
		fulfillmentCase.Opportunity__c = oppId;
		fulfillmentCase.Product__c = appProduct.Product_Name__c;
		fulfillmentCase.Subject = appProduct.Product_Name__c + ' FulFillment';
		fulfillmentCase.Relationship_Banker__c = opp.OwnerId;
		fulfillmentCase.Account_Number__c = appProduct.Account_Number__c != null ? String.valueOf(appProduct.Account_Number__c) : null;
		fulfillmentCase.AccountId = opp.AccountId;
		fulfillmentCase.Sanctioner__c = opp.Approval_Owner__c;
		fulfillmentCase.Type__c = 'Credit FulFillment';
		fulfillmentCase.Type = 'Credit FulFillment';

		if (serviceGroupTypes != null && serviceGroupTypes.size() > 0){
			fulfillmentCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
			fulfillmentCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
			fulfillmentCase.sd_Service_Group_Id__c = serviceGroupList[0].Id;
			fulfillmentCase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
			fulfillmentCase.sd_Service_Group__c = serviceGroupList[0].Name;
			fulfillmentCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
			fulfillmentCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
			fulfillmentCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
			fulfillmentCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
			fulfillmentCase.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
			fulfillmentCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
		}

		appProduct.Product_Status__c = 'Pipeline For Fulfillment';

		insert fulfillmentCase;
		update appProduct;
	}

	/**
	 * @description : Method called via from FulfillmentApplication cmp to insert a case for each parent application product record
	 * @author Danie Booysen | 2021-07-13
	 * @param oppId
	 * @param appProdId
	 * @return String
	 **/
	public static String createFulfillmentCaseOverDraft(String oppId, String appProdId){
		//create case
		Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Credit FulFillment').getRecordTypeId();
		//query service group type
		List<Service_Group__c> serviceGroupList = new ServiceGroupsSelector().selectByName(new Set<String>{'Credit FulFilment Group'});
		List<Service_Group_Type__c> serviceGroupTypes;
		if (serviceGroupList != null & serviceGroupList.size() == 1){
			serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(new Set<Id>{serviceGroupList[0].Id});
		}
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		List<Application_Product__c> childAppProductList = [SELECT Id, Application_Product_Parent__c, Application_Product_Parent__r.Accept_TOB__c, Product_Name__c, Product_Amount__c, Application_Product_Parent__r.Product_Status__c, tolabel(Application_Product_Parent__r.Product_Type__c), tolabel(Product_Type__c)prodtype, Account_Number__c, Application_Product_Parent__r.Account_Number__c, Application_Product_Parent__r.Product_State__c, Application_Product_Parent__r.Product_Name__c
		                                                    FROM Application_Product__c
		                                                    WHERE Opportunity__c = :oppId AND Application_Product_Parent__c != null AND Application_Product_Parent__r.Accept_TOB__c = true AND Application_Product_Parent__c = :appProdId];
		List<Case> fulfillmentCaseList = new List<Case>(); //change below mappings for parent
		for (Application_Product__c appProduct : childAppProductList){
			Case fulfillmentCase = new Case();
			fulfillmentCase.RecordTypeId = caseRecordTypeId;
			fulfillmentCase.Application_Product_Id__c = appProduct.Application_Product_Parent__c;//appProduct.Id; //appProduct.Application_Product_Parent__c; creating case on child
			fulfillmentCase.Status = 'New';
			fulfillmentCase.Opportunity__c = oppId;
			fulfillmentCase.Product__c = appProduct.Product_Name__c;
			fulfillmentCase.Subject = appProduct.Product_Name__c + ' FulFillment';
			fulfillmentCase.Relationship_Banker__c = opp.OwnerId;
			fulfillmentCase.Account_Number__c = appProduct.Application_Product_Parent__r.Account_Number__c != null ? String.valueOf(appProduct.Application_Product_Parent__r.Account_Number__c) : null;
			fulfillmentCase.AccountId = opp.AccountId;
			fulfillmentCase.Sanctioner__c = opp.Approval_Owner__c;
			fulfillmentCase.Type__c = 'Credit FulFillment';
			fulfillmentCase.Type = 'Credit FulFillment';

			if (serviceGroupTypes != null && serviceGroupTypes.size() > 0){
				fulfillmentCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
				fulfillmentCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
				fulfillmentCase.sd_Service_Group_Id__c = serviceGroupList[0].Id;
				fulfillmentCase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
				fulfillmentCase.sd_Service_Group__c = serviceGroupList[0].Name;
				fulfillmentCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
				fulfillmentCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
				fulfillmentCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
				fulfillmentCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
				fulfillmentCase.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
				fulfillmentCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
			}
			fulfillmentCaseList.add(fulfillmentCase);
		}

		try{
			insert fulfillmentCaseList;

			Application_Product__c appProduct = new Application_Product__c(Id = appProdId);
			appProduct.Product_Status__c = 'Pipeline For Fulfillment';

			update appProduct;
		} catch (exception e){
			return 'fail';
		}
		return 'success';
	}
    
      
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-10-19 
    * @param oppId 
    * @param appProdId 
    * @return string 
    **/
    public static string createFulfillmentCaseLDP(String oppId,String appProdId){
        //create case
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('LDP Fulfilment').getRecordTypeId();
      
        //query service group type
        List<Service_Group__c> serviceGroupList = new ServiceGroupsSelector().selectByName(new Set<String>{'LDP Fulfilment Group'}); //testing it with a sample group
        List<Service_Group_Type__c> serviceGroupTypes;
        if(serviceGroupList != null & serviceGroupList.size() == 1){
            serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(new Set<Id>{serviceGroupList[0].Id});
        }
        
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId) ;
        Application_Product__c appProduct = [SELECT Id, Application_Product_Parent__c,Accept_TOB__c, Product_Name__c, Product_Amount__c, Product_Status__c, 
                                             tolabel(Product_Type__c) prodtype, Account_Number__c,
                                             Product_State__c
                                             FROM Application_Product__c
                                             WHERE Opportunity__c =: oppId  AND Accept_TOB__c=true AND Id=:appProdId ];
        
        
        Case fulfillmentCase = new Case();
        fulfillmentCase.RecordTypeId = caseRecordTypeId;
        fulfillmentCase.Application_Product_Id__c = appProduct.Id;//appProduct.Id; //appProduct.Application_Product_Parent__c; creating case on child
        fulfillmentCase.Status = 'New';
        fulfillmentCase.Opportunity__c = oppId;
        fulfillmentCase.Product__c = appProduct.Product_Name__c;
        fulfillmentCase.Subject = appProduct.Product_Name__c + ' FulFillment';
        fulfillmentCase.Relationship_Banker__c = opp.OwnerId;
        fulfillmentCase.Account_Number__c = appProduct.Account_Number__c != null ? String.valueOf(appProduct.Account_Number__c) : null;
        fulfillmentCase.AccountId = opp.AccountId;
        fulfillmentCase.Sanctioner__c = opp.Approval_Owner__c;
        fulfillmentCase.Type__c = 'Bank Guaranty FulFillment';
        fulfillmentCase.Type = 'Credit FulFillment';
        
        if(serviceGroupTypes != null && serviceGroupTypes.size()>0){
            fulfillmentCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
            fulfillmentCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
            fulfillmentCase.sd_Service_Group_Id__c = serviceGroupList[0].Id;
            fulfillmentCase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
            fulfillmentCase.sd_Service_Group__c = serviceGroupList[0].Name;
            fulfillmentCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
            fulfillmentCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
            fulfillmentCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
            fulfillmentCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
            fulfillmentCase.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
            fulfillmentCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
        }
        
        
        try{
            insert fulfillmentCase; 
           
			appProduct.Product_Status__c = 'Pipeline For Fulfillment';

			update appProduct;
        }catch(Exception e){
			AuditTrailLog.logException(e, 'New', 'Warning', 'Fulfillment Credit', 'Track', ''+e.getStackTraceString());

        }
       return fulfillmentCase.Id; 
    }


	/**
	 * @description : Method to make pcoCallout based on opportunityID
	 * @author Danie Booysen | 2021-07-13
	 * @param OpportunityId
	 **/
	@future(callout = true)
	public static void pcoCallout(Id OpportunityId){
		PowerCurveStatusUpdate.pcoCallout(OpportunityId);
	}

	/**
	 * @description Method to get the required documents based on opportunity
	 * @Author : Manish :Absa
	 * @param  oppId - opportunity Id
	 * @return List<Signed_Documents_Checklist__mdt>
	 **/
	@AuraEnabled
	public static List<Signed_Documents_Checklist__mdt> getRequiredDocs(Id oppId){
		return [Select Product__c, Rule__c, Document_Type__c, Applications__c
		        from Signed_Documents_Checklist__mdt];
	}

	/**
	 * @description Custom wrapper class to consolidate client data
	 */
	public class ClientDataWrapper{
		@AuraEnabled
		public String clientName;
		@AuraEnabled
		public String clientIdRegNumber;
		@AuraEnabled
		public String clientCode;
		@AuraEnabled
		public String onboardingStatus;
		@AuraEnabled
		public Boolean isApplicant;
		@AuraEnabled
		public String Roles;
	}

	/**
	 * @description Custom wrapper class to consolidate product data
	 */
	public class ProductDataWrapper{
		@AuraEnabled
		public String Id;
		@AuraEnabled
		public String productName;
		@AuraEnabled
		public String productType;
		@AuraEnabled
		public String productAccountNumber;
		@AuraEnabled
		public Decimal productAmount;
		@AuraEnabled
		public String productStatus;
		@AuraEnabled
		public String productState;
		@AuraEnabled
		public String tempAccountNumber;//added by Manish for W-011452
		@AuraEnabled
		public String ncaAppplicable;//added by Manish for W-011452
		@AuraEnabled
		public String parentTempAccountNumber;//added by Manish for W-011452
		@AuraEnabled
		public Decimal parentAccountNumber;
		//added by Manish for W-011452
	}
}