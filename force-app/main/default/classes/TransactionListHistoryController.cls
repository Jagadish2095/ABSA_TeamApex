/**
 * @description Apex controller class to get account details and Client transaction history
 * Author: Mashudu Raidimi
 * Date : 27/02/2020
 * @UpdatedBy : Humbelani Denge
 */

public class TransactionListHistoryController {
	/**
	 * @author Mashudu Raidimi
	 * @description Retrieves client account number list  based on AccountId
	 * @param  clientAccountId
	 * @return String
	 */
	@AuraEnabled
	public static String getAccountDetails(String clientAccountId) {
		String errorMessage = '';
		system.debug(LoggingLevel.FINE, 'clientAccountId' + clientAccountId);

		List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accountWrapperList;
		Set<Id> accIdSet = new Set<Id>();
		accIdSet.add(clientAccountId);
		List<Account> accountList = new AccountsSelector().selectById(accIdSet, 1);

		CIgetAcctLinkedToClientCode_Resp_IB_v1 response = CIgetAcctLinkedToClientCode_IH_v1.ciGetAcctLinkedToClientCode(
			StringConstants.SALESFORCE_STRING,
			accountList[0].CIF__c
		);

		if (response.statusCode == 200) {
			CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_Cip047o cls_Cip047oWrapper = response.cip047o;

			List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable> accTypes = cls_Cip047oWrapper.outputTable;

			accountWrapperList = new List<CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable>();

			for (CIgetAcctLinkedToClientCode_Resp_IB_v1.cls_outputTable accWrObj : accTypes) {
				accountWrapperList.add(accWrObj);
			}
			return JSON.serialize(accountWrapperList);
		} else {
			errorMessage = 'CIF not found for the Account';
			throw new AuraHandledException('Error: ' + errorMessage);
		}
	}

	/**
	 * Mashudu Raidimi
	 * @description Retrieves client transaction list  based on Account number
	 * @param  accountNumberP
	 * @param  fromDateP
	 * @param  toDateP
	 * @return String list
	 *
	 */
	@AuraEnabled
	public static String viewTransactionHistory(String accountNumberP, String fromDateP, String toDateP) {
		String errMessage = '';
		System.debug(LoggingLevel.FINE, 'Input : ' + accountNumberP);
		Map<NhlistAccTransactionHistoryv5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = NhlistAcctTransactionHistoryv5_IH_v1.callTonhlistaccttransactionhistoryv5(
			accountNumberP,
			fromDateP,
			toDateP
		);

		NhlistAccTransactionHistoryv5_Resp_IB_v1 responseBean = (new List<NhlistAccTransactionHistoryv5_Resp_IB_v1>(responseMap.keySet()))[0];

		if (responseBean.statusCode == 200) {
			system.debug('Status code returned  : ' + responseBean.statusCode);
			NhlistAccTransactionHistoryv5_Resp_IB_v1.NHlistAcctTransactionHistoryV5Response cls_retrieveTransactionInqWrapper = responseBean.NHlistAcctTransactionHistoryV5Response;
			NhlistAccTransactionHistoryv5_Resp_IB_v1.nhp021o nhp021o = cls_retrieveTransactionInqWrapper.nhp021o;

			return JSON.serialize(nhp021o);

			//system.debug('ResponseBean : Passed');
		} else {
			errMessage = 'No transactions for selected dates';
			return errMessage;
			//throw new AuraHandledException('Error: '+errMessage);
		}
	}

	/**
	 * @author Rudolf Niehaus
	 * @description loadTransactions : get all transactions back from the service
	 * and insert the response into an temp object to be used for filtering
	 * Load a deafult of 3 months
	 * @param  pAccountNumber
	 * @param  fromDate
	 * @param  toDate
	 * @return Map<String, List<Object>>
	 */
	@AuraEnabled
	public static Map<String, List<Object>> loadTransactions(String pAccountNumber, Date fromDate, Date toDate) {
		Map<String, List<Object>> transactionMap = new Map<String, List<Object>>();

		String errMessage = '';

		//Load default 3 months of transactions
		if (fromDate == null || toDate == null) {
			fromDate = Date.today();
			fromDate = fromDate.addMonths(-3);
			toDate = Date.today();
		}

		//FOR TESTING REMOVE
		//pAccountNumber = '4048017641';

		Map<NhlistAccTransactionHistoryv5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = NhlistAcctTransactionHistoryv5_IH_v1.callTonhlistaccttransactionhistoryv5(
			pAccountNumber,
			fromDate.format().replace('/', ''),
			toDate.format().replace('/', '')
		);

		NhlistAccTransactionHistoryv5_Resp_IB_v1 responseBean = (new List<NhlistAccTransactionHistoryv5_Resp_IB_v1>(responseMap.keySet()))[0];
		List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
		logList.addAll(responseMap.values()[0]);
		if (logList.size() > 0) {
			insert logList;
		}

		if (responseBean.statusCode == 200) {
			NhlistAccTransactionHistoryv5_Resp_IB_v1.NHlistAcctTransactionHistoryV5Response cls_retrieveTransactionInqWrapper = responseBean.NHlistAcctTransactionHistoryV5Response;
			NhlistAccTransactionHistoryv5_Resp_IB_v1.nhp021o nhp021o = cls_retrieveTransactionInqWrapper.nhp021o;

			List<NhlistAccTransactionHistoryv5_Resp_IB_v1.StatementDetails> transactionData = nhp021o.StatementDetails;

			List<Transaction_Filter_List__c> transList = new List<Transaction_Filter_List__c>();

			if(transactionData != null){
				for (NhlistAccTransactionHistoryv5_Resp_IB_v1.StatementDetails rec : transactionData) {
					//Date conversion
					String year = '';
					String month = '';
					String day = '';
	
					String processDate = rec.processingDate;
	
					if (processDate.length() >= 8) {
						year = processDate.substring(0, 4);
						month = processDate.substring(4, 6);
						day = processDate.substring(6);
						processDate = year + '-' + month + '-' + day;
					} else {
						processDate = '0';
					}
	
					String effectDate = rec.effectiveDate;
	
					if (effectDate.length() >= 8) {
						year = effectDate.substring(0, 4);
						month = effectDate.substring(4, 6);
						day = effectDate.substring(6);
						effectDate = year + '-' + month + '-' + day;
					} else {
						effectDate = '0';
					}
	
					Transaction_Filter_List__c trans = new Transaction_Filter_List__c();
					String amount;
					String balance;
					trans.Processing_Date__c = (processDate != '0') ? Date.valueOf(processDate) : null;
					trans.Effective_Date__c = (effectDate != '0') ? Date.valueOf(effectDate) : null;
					trans.Description1__c = rec.description1;
					trans.Description2__c = rec.description2;
					trans.Description3__c = rec.description3;
	
					if (rec.tranAmount.substring(1).replaceFirst('^0+', '') == null || rec.tranAmount.substring(1).replaceFirst('^0+', '').trim() == '') {
						amount = '0';
					} else if (rec.tranAmount.substring(1).replaceFirst('^0+', '') != null && rec.tranAmount.substring(1).replaceFirst('^0+', '').trim() != '') {
						amount = (Decimal.valueOf(rec.tranAmount.substring(1).replaceFirst('^0+', '')).setScale(2) + 0.001).format();
					}
	
					if (rec.balAfterTran.substring(1).replaceFirst('^0+', '') == null || rec.balAfterTran.substring(1).replaceFirst('^0+', '').trim() == '') {
						balance = '0';
					} else if (
						rec.balAfterTran.substring(1).replaceFirst('^0+', '') != null &&
						rec.balAfterTran.substring(1).replaceFirst('^0+', '').trim() != ''
					) {
						balance = (Decimal.valueOf(rec.balAfterTran.substring(1).replaceFirst('^0+', '')).setScale(2) + 0.001).format();
					}
	
					trans.Balance_After_Transaction__c = rec.balAfterTran.substringBefore('0') + ' R ' + balance.substring(0, balance.length() - 1);
					trans.Transaction_Amount__c = rec.tranAmount.substringBefore('0') + ' R ' + amount.substring(0, amount.length() - 1);
					trans.Transaction_Cost__c = ' R ' + rec.tranCost;
					trans.Transaction_Type__c = rec.tranType;
					trans.Event_Number__c = rec.eventNum;
					trans.Line_Number__c = rec.lineNum;
					trans.Transaction_Category__c = rec.tranCat;
	
					transList.add(trans);
				}
			}

			List<Transaction_Filter_List__c> filteredTransactions = insertData(transList);
			transactionMap.put('filteredTransactions', filteredTransactions);
			transactionMap.put('responseBean', new List<NhlistAccTransactionHistoryv5_Resp_IB_v1>{ responseBean });

			return transactionMap;
		} else {
			errMessage = 'No transactions for selected dates';

			return new Map<String, List<Object>>();
		}
	}

	/**
	 * @author Rudolf Niehaus
	 * @description insertData : Delete existing and then insert the transaction result from the service
	 * into a custom object to be used for filtering
	 * @param  transList
	 * @return List<Transaction_Filter_List__c>
	 */
	private static List<Transaction_Filter_List__c> insertData(List<Transaction_Filter_List__c> transList) {
		//Clean out object if not empty already
		List<Transaction_Filter_List__c> deleteRecs = [SELECT Id FROM Transaction_Filter_List__c];

		if (deleteRecs.size() > 0) {
			try {
				delete deleteRecs;
			} catch (DmlException ex) {
				throw ex;
			}
		}

		//Insert new transaction list
		try {
			insert transList;
		} catch (DmlException ex) {
			throw ex;
		}

		return transList;
	}

	/**
	 * @description filterTransactions : Filter the result set bases on filter criteria
	 * @author Rudolf Niehaus
	 * @param  iipRefNo
	 * @param  payDate
	 * @param  data
	 * @param  admin
	 * @param  airtime
	 * @param  accFee
	 * @param  immediateDT
	 * @return List<Transaction_Filter_List__c>
	 */
	@AuraEnabled
	public static List<Transaction_Filter_List__c> filterTransactions(
		String iipRefNo,
		String payDate,
		String data,
		String admin,
		String airtime,
		String accFee,
		String immediateDT
	) {
		Set<String> transactionTypeSet = new Set<String>{ iipRefNo, payDate, data, admin, airtime, accFee, immediateDT };

		//Build-up SOQL filter query
		String query;
		TransactionsFilterSelector transactionSelector = new TransactionsFilterSelector();

		if (String.isNotBlank(iipRefNo) && String.isNotBlank(payDate)) {
			String dscSearch = '\'%' + String.escapeSingleQuotes(iipRefNo) + '%\'';
			return transactionSelector.getByDateAndDesc(Date.valueOf(payDate), dscSearch);
		} else if (String.isNotBlank(iipRefNo)) {
			String dscSearch = '\'%' + String.escapeSingleQuotes(iipRefNo) + '%\'';
			return transactionSelector.getByDescription(dscSearch);
		} else if (String.isNotBlank(payDate)) {
			return transactionSelector.getByDate(Date.valueOf(payDate));
		}

		if (!transactionTypeSet.isEmpty()) {
			return transactionSelector.getByTransactionSet(transactionTypeSet);
		} else {
			return new List<Transaction_Filter_List__c>();
		}
	}

	/**
	 * @author Humbelani Denge
	 * @description Method sends an email with an attachment
	 * @param caseId
	 * @param emailAddress
	 * @param emailTemplateName
	 * @param pdfData
	 * @param docName
	 * @return String
	 */
	@AuraEnabled
	public static string sendTransactions(String caseId, String emailAddress, String emailTemplateName, String pdfData, String docName) {
		return ProofOfPaymentSelController.sendEmailWithAttach(caseId, emailAddress, emailTemplateName, pdfData, docName);
	}

	/**
	 * @author   Humbelani Denge
	 * @description Method generates a transaction history document from ECM
	 * @param transHistoryResponse
	 * @param transactionList
	 * @param accountNumber
	 * @param documentTemplateName
	 * @param accountId
	 * @param fromDate
	 * @param toDate
	 * @param accountType
	 * @return String: Document content or an error message
	 */
	@AuraEnabled
	public static string getDocumentData(
		String transHistoryResponse,
		String transactionList,
		String accountNumber,
		String documentTemplateName,
		String accountId,
		String fromDate,
		String toDate,
		String accountType
	) {
		List<Transaction_Filter_List__c> transactionHistoryList = (List<Transaction_Filter_List__c>) JSON.deserialize(
			transactionList,
			List<Transaction_Filter_List__c>.class
		);
		if (transactionHistoryList == null && transactionHistoryList.size() == 0) {
			return 'Error: No transactions available to send attachment: ' + transactionHistoryList;
		}

		NhlistAccTransactionHistoryv5_Resp_IB_v1 transHistoryResponseBean = (NhlistAccTransactionHistoryv5_Resp_IB_v1) JSON.deserialize(
			transHistoryResponse,
			NhlistAccTransactionHistoryv5_Resp_IB_v1.class
		);

		DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
		Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(documentTemplateName);
		Account accountRecord = new AccountsSelector().selectAllById(accountId);
		String currentBalance = transHistoryResponseBean.NHlistAcctTransactionHistoryV5Response.nhp021o.currentBal;
		String availableBalance = transHistoryResponseBean.NHlistAcctTransactionHistoryV5Response.nhp021o.availableBal;
		String unclearedAmount = transHistoryResponseBean.NHlistAcctTransactionHistoryV5Response.nhp021o.unclearedAmt;

		Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);
		//Add the client's ID number as the password required to open this document
		params.put('password', accountRecord.ID_Number__pc);
		//Map XML content
		contextBuilder.add('accountName', accountRecord.Name);
		contextBuilder.add('addressLine', accountRecord.BillingStreet);
		contextBuilder.add('city', accountRecord.BillingCity);
		contextBuilder.add('postalCode', accountRecord.BillingPostalCode);
		contextBuilder.add('accountNumber', accountNumber);
		contextBuilder.add('accountType', accountType);
		contextBuilder.add('currentBal', currentBalance.substring(0, 1) + (Decimal.valueOf(currentBalance.substring(1)).setScale(2) + 0.001).format());
		contextBuilder.add('availableBal', availableBalance.substring(0, 1) + (Decimal.valueOf(availableBalance.substring(1)).setScale(2) + 0.001).format());
		contextBuilder.add('unclearedAmt', unclearedAmount.substring(0, 1) + (Decimal.valueOf(unclearedAmount.substring(1)).setScale(2) + 0.001).format());
		contextBuilder.add('fromDate', fromDate);
		contextBuilder.add('toDate', toDate);

		String transactionHistoryListXML = '';
		//Create and map a DebitInfo tag for each payment from the benPaymentList to represent each payment in the XML template
		for (Transaction_Filter_List__c trans : transactionHistoryList) {
			String transactionItem =
				'<TransactionInfo>' +
				'<Date>' +
				String.valueOf(trans.Processing_Date__c.format()).replaceAll('/', '-') +
				'</Date>' +
				'<Transaction>' +
				trans.Description1__c.replaceAll('[^a-zA-Z0-9\\s+]', '') +
				'</Transaction>' +
				'<Amount>' +
				trans.Transaction_Amount__c +
				'</Amount>' +
				'</TransactionInfo>';
			//Add each beneficiaryItem to the beneficiaryPaymentListXML variable
			transactionHistoryListXML += transactionItem;
		}
		//Manually replace the XML placeholder with the value of the beneficiaryPaymentList
		documentTemplate.XML__c = documentTemplate.XML__c.replace('{TransactionInfo}', transactionHistoryListXML);

		//Generate document
		CC_GenerateContentResponse generateDocumentResponse = new DocumentTemplateProcessor().generateDocument(contextBuilder, documentTemplate, params);
		if (String.isBlank(generateDocumentResponse?.contentStoreToken)) {
			return 'Error: Document generation using DocumentTemplateProcessor service failed. Response: ' + JSON.serialize(generateDocumentResponse);
		}

		//Retrieve generated document
		Map<String, String> credentials = ECM_IH_V1.getCredentials();
		ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
		ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, generateDocumentResponse.contentStoreToken);

		if (String.isBlank(getResult?.Content?.data)) {
			return 'Error: Document download using ECM_IH_V1 service failed. Response: ' + JSON.serialize(getResult);
		}
		System.debug('getResult.Content.data: ' + getResult.Content.data);
		return getResult.Content.data;
	}
}