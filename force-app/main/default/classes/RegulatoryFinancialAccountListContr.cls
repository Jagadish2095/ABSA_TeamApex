/**
 * @description Class for RegulatoryFinancialAccount Aura Component
 *
 * @author  Tracy de Bruin - CloudSmiths
 * @since   2021-03-08
 */
public class RegulatoryFinancialAccountListContr {
	/**
	 * @description Get Product linked to Client
	 * @param recordId
	 * @param objectName
	 * @return List<Regulatory_Financial_Account__c>
	 */
	@AuraEnabled
	public static List<Regulatory_Financial_Account__c> getProductsList(String recordId, String objectName) {
		List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
		List<Regulatory_Financial_Account__c> productLst = new List<Regulatory_Financial_Account__c>();
		List<Regulatory_Financial_Account__c> productToReturn = new List<Regulatory_Financial_Account__c>();
		Map<String, Regulatory_Financial_Account__c> accNoProductMap = new Map<String, Regulatory_Financial_Account__c>();
		String errorMessage = '';
		String cifNo = null;
		String accountId;

		if (objectName == 'Opportunity') {
			Opportunity opportunityRecord = new OpportunitiesSelector().selectByOppId(recordId);
			accountId = opportunityRecord.AccountId;
		} else {
			accountId = recordId;
		}

		//Get Account CIF for Service
		Account accountRecord = new AccountsSelector().selectById(accountId);

		//Get all Regulatory Finacial Product Records
		List<Regulatory_Financial_Account__c> regulatoryFinancialAccounts = new RegulatoryFinancialAccountsSelector().selectByAccountId(accountRecord.Id);
		//Add Products to a map
		for (Regulatory_Financial_Account__c eachProduct : regulatoryFinancialAccounts) {
			accNoProductMap.put(eachProduct.Account_Number__c, eachProduct);
		}

		//Call CIgetAcctLinkedToClientCode Service to get Products
		try {
			if (accountRecord.CIF__c != null) {
				CIgetAcctLinkedToClientCode_Resp_IB_v1 resp = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode('SALESFORCE', accountRecord.CIF__c);
				if (resp != null && resp.statuscode == 200) {
					CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = resp.cip047o;
					List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;

					if (accTypes != null) {
						for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj : accTypes) {
							System.debug('### Each Product : ' + accWrObj);
							Regulatory_Financial_Account__c eachProduct = new Regulatory_Financial_Account__c();
							String accNo = accWrObj.oaccntnbr;

							//Update Product in Salesforce if exist, else create new
							if (accNoProductMap.containsKey(accNo)) {
								eachProduct = accNoProductMap.get(accNo);
							}

							eachProduct.Account__c = accountRecord.Id;
							eachProduct.Product__c = accWrObj.product;
							eachProduct.Product_Type__c = accWrObj.productType;
							eachProduct.Account_Number__c = accNo;
							eachProduct.Branch__c = accWrObj.branch;
							eachProduct.Status__c = accWrObj.status;

							if (accWrObj.availableBalance != null) {
								eachProduct.Available_Balance__c = Decimal.valueOf(accWrObj.availableBalance);
							}

							eachProduct.Date_Closed__c = accWrObj.dtclosed;

							//Use Integration Translations for Source of Funds
							String srcOfFundsTranslated;
							String srcOfFundsMulti;
							if (String.isEmpty(accWrObj.srcOfFnds1) == false && eachProduct.Source_of_Funds__c == null) {
								srcOfFundsTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
									StringConstants.CIF_STRING,
									'Source of Funds',
									accWrObj.srcOfFnds1,
									StringConstants.INBOUND_RECORD_TYPE
								);
								if (srcOfFundsTranslated != null) {
									srcOfFundsMulti = srcOfFundsMulti + ';' + srcOfFundsTranslated;
								}
							}
							if (String.isEmpty(accWrObj.srcOfFnds2) == false && eachProduct.Source_of_Funds__c == null) {
								srcOfFundsTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
									StringConstants.CIF_STRING,
									'Source of Funds',
									accWrObj.srcOfFnds2,
									StringConstants.INBOUND_RECORD_TYPE
								);
								if (srcOfFundsTranslated != null) {
									srcOfFundsMulti = srcOfFundsMulti + ';' + srcOfFundsTranslated;
								}
							}
							if (String.isEmpty(accWrObj.srcOfFnds3) == false && eachProduct.Source_of_Funds__c == null) {
								srcOfFundsTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
									StringConstants.CIF_STRING,
									'Source of Funds',
									accWrObj.srcOfFnds3,
									StringConstants.INBOUND_RECORD_TYPE
								);
								if (srcOfFundsTranslated != null) {
									srcOfFundsMulti = srcOfFundsMulti + ';' + srcOfFundsTranslated;
								}
							}
							if (String.isEmpty(accWrObj.srcOfFnds4) == false && eachProduct.Source_of_Funds__c == null) {
								srcOfFundsTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
									StringConstants.CIF_STRING,
									'Source of Funds',
									accWrObj.srcOfFnds4,
									StringConstants.INBOUND_RECORD_TYPE
								);
								if (srcOfFundsTranslated != null) {
									srcOfFundsMulti = srcOfFundsMulti + ';' + srcOfFundsTranslated;
								}
							}
							if (String.isEmpty(accWrObj.srcOfFnds5) == false && eachProduct.Source_of_Funds__c == null) {
								srcOfFundsTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
									StringConstants.CIF_STRING,
									'Source of Funds',
									accWrObj.srcOfFnds5,
									StringConstants.INBOUND_RECORD_TYPE
								);
								if (srcOfFundsTranslated != null) {
									srcOfFundsMulti = srcOfFundsMulti + ';' + srcOfFundsTranslated;
								}
							}

							if (srcOfFundsMulti != null) {
								eachProduct.Source_of_Funds__c = srcOfFundsMulti;
							}

							productLst.add(eachProduct);
						}
						if (productLst != null && productLst.size() > 0) {
							upsert productLst;
						}
					} else {
						CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Nbsmsgo3 cls_Nbsmsgo3Wrapper = resp.nbsmsgo3;
						CIgetAcctLinkedToClientCode_Resp_IB_v1.MsgEntry msgEntry = cls_Nbsmsgo3Wrapper.MsgEntry;
						errorMessage = msgEntry.msgTxt;
						AuraHandledException e = new AuraHandledException(errorMessage);
						e.setMessage(errorMessage);
						throw e;
					}
				} else {
					errorMessage = 'Invalid CIF.Please check cif for the account';
					AuraHandledException e = new AuraHandledException(errorMessage);
					e.setMessage(errorMessage);
					throw e;
				}
			} else {
				errorMessage = 'CIF not found for the Account';
				AuraHandledException e = new AuraHandledException(errorMessage);
				e.setMessage(errorMessage);
				throw e;
			}

			//Only return certain products
			for (Regulatory_Financial_Account__c eachProduct : productLst) {
				String productType;
				String productStatus;

				if (eachProduct.product__c != null) {
					productType = eachProduct.product__c.toUpperCase();
				}

				if (eachProduct.Status__c != null) {
					productStatus = eachProduct.Status__c.toUpperCase();
				}

				if (objectName == 'Account') {
					productToReturn = productLst;
				} else {
					if (
						productType != 'COMBI' &&
						productType != 'ACSB' &&
						eachProduct.Status__c != 'CLOSED' &&
						eachProduct.Status__c != 'DETAIL' &&
						eachProduct.Status__c != 'ACC XFR' &&
						eachProduct.Status__c != 'INACTIVE' &&
						eachProduct.Status__c != 'LOST' &&
						eachProduct.Status__c != 'FRAUD' &&
						eachProduct.Status__c != 'UNUSED' &&
						eachProduct.Status__c != 'CARDHLD' &&
						eachProduct.Status__c != 'PENDING' &&
						eachProduct.Status__c != 'CLS ERLY' &&
						eachProduct.Status__c != 'DETAIL UNAVAILABLE AT PRESENT' &&
						eachProduct.Status__c != 'NTU'
					) {
						productToReturn.add(eachProduct);
					}
				}
			}
		} catch (Exception ex) {
			system.debug('Error Message :' + ex.getMessage() + 'Error Cause :' + ex.getCause() + 'Error Where:' + ex.getLineNumber());
			AuraHandledException e = new AuraHandledException(ex.getMessage());
			e.setMessage(errorMessage);
			throw e;
		}

		return productToReturn;
	}
}