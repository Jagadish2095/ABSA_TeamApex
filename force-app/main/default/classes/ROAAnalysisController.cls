/**
 * @description Controller for ROA Analysis component
 * @author  Khaliq Pasha
 * @created 2021-07-15
 */
public without sharing class ROAAnalysisController {
	/**
	 * @description getROAQuestionnaire
	 *@param applicationId
	 *@param recordId
	 * @return value as String
	 */
	@AuraEnabled
	public static string getROAQuestionnaire(Id applicationId, Id recordId) {
		string roaQuestionnaire = '';
		Application__c roaQuestionnaireValues = [
			SELECT Id, ROAQuestionnaire__c
			FROM Application__c
			WHERE id = :applicationId AND Account__c = :recordId
			WITH SECURITY_ENFORCED
		];
		return roaQuestionnaire = roaQuestionnaireValues.ROAQuestionnaire__c;
	}

	/**
	 * @description  Method to return create and return OpportunityId and ApplicationId
	 * @param applicationId
	 * @param recordId
	 * @param listOfQuestions
	 * @return boolean
	 */
	@AuraEnabled
	public static boolean updateApplicationROAQuestionnaire(string applicationId, string recordId, String listOfQuestions) {
		boolean retValue = false;
		Application__c roaQuestionnaireValues = [
			SELECT Id, ROAQuestionnaire__c
			FROM Application__c
			WHERE id = :applicationId AND Account__c = :recordId
			WITH SECURITY_ENFORCED
		];
		roaQuestionnaireValues.ROAQuestionnaire__c = listOfQuestions;

		try {
			update roaQuestionnaireValues;
			retValue = true;
		} catch (DmlException ex) {
			retValue = false;
			throw ex;
		}
		return retValue;
	}

	/**
	 * @description  Method to return list of question fetchKnockoutQuestion
	 * @param listType
	 * @return result
	 */
	@AuraEnabled
	public static string fetchKnockoutQuestion(string listType) {
		/* string result ='';
result=  KnockoutQuestionsController.fetchKnockoutQuestions(listType);
return result;*/
		string result = '';
		List<Knockout_Question__c> lstOfRecords = [
			SELECT Name, Description__c
			FROM Knockout_Question__c
			WHERE ListType__c = :listType
			WITH SECURITY_ENFORCED
			ORDER BY Order__c
		];
		for (Knockout_Question__c kq : lstOfRecords) {
			result = result + kq.Description__c;
		}
		return result;
	}

	/**
	 * @description getROAQuestionnaire
	 * @param applicatioID
	 * @return value as String
	 */

	/*  @AuraEnabled
    public static string callGenerateDocs(id oppId) 
    {
        String versionNumber = ROAAnalysisController.callGenerateDocsStokvel(oppId);
        return versionNumber;
    }*/

	/**
	 * @description callGenerateDocs
	 * @param oppId
	 * @return String
	 */

	public static String callGenerateDocsStokvel(id oppId) {
		string versionNumber = '0';
		try {
			List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
			Account account = new AccountsSelector().selectAllById(opportunities.get(0).AccountId);
			//string usr = System.UserInfo.getUserId();
			User userInfo = [SELECT SiteCode__c, Teller_Operator_Code__c, AB_Number__c FROM User WHERE Id = :UserInfo.getUserId()];
			CASAGeneratedocumentsV7_Req_IB_v1 requestBean = CASAGeneratedocumentsV7_Req_IB_v1.GetInstance();
			requestBean.GetDocsRequest.RefNumber = account.CASA_Reference_Number__c;
			requestBean.GetDocsRequest.SBU = 'F';
			requestBean.GetDocsRequest.OriginatingSystem = 'BDP';
			requestBean.GetDocsRequest.Additional_Docs = '';
			requestBean.GetDocsRequest.Branch = userInfo.SiteCode__c;
			requestBean.GetDocsRequest.InitialAB = userInfo.AB_Number__c;
			CASAGeneratedocumentsV7_Resp_IB_v1 response = CASAGeneratedocumentsV7_IH_v1.CASAGeneratedocumentsV7(requestBean);
			versionNumber = response.Envelope.Body.GetDocsResponse.VersionNo;
			if (!versionNumber.contains('Error')) {
				account = [SELECT Id, Casa_Sequence_Number__c FROM Account WHERE Id = :account.Id];
				account.Casa_Sequence_Number__c = versionNumber;
				update account;
			}
		} catch (Exception e) {
			return versionNumber = '1';
		}

		return versionNumber;
	}

	/**
	 * @description callGenerateDocsForRelatedParty
	 * @param oppId
	 * @return String
	 */
	/*@AuraEnabled
	public static String callGenerateDocsForRelatedParty(id oppId) {
        system.debug('oppId1' + oppId);
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);		
		string casaSeqNumber='';
        string usr = System.UserInfo.getUserId();        
        User userInfo = [SELECT SiteCode__c,Teller_Operator_Code__c,AB_Number__c FROM User WHERE Id = :usr];
        String versionNumber = '';
        List<AccountContactRelation> accountlist = AccountContactController.getRelatedAccounts(opportunities.get(0).AccountId);
         system.debug('opportunities.get(0).AccountId1' + opportunities.get(0).AccountId);
        for(AccountContactRelation Item : accountlist){            
             Account account = AccountContactController.GetAccountControllerDetails(Item.ContactId);
			system.debug('account.CASA_Reference_Number__c' + account.CASA_Reference_Number__c);
            CASAGeneratedocumentsV7_Req_IB_v1 requestBean = CASAGeneratedocumentsV7_Req_IB_v1.GetInstance();
            requestBean.GetDocsRequest.RefNumber = account.CASA_Reference_Number__c ;
            requestBean.GetDocsRequest.SBU = 'F';
            requestBean.GetDocsRequest.OriginatingSystem = 'BDP';
            requestBean.GetDocsRequest.Additional_Docs = '';
            requestBean.GetDocsRequest.Branch = userInfo.SiteCode__c;
            requestBean.GetDocsRequest.InitialAB = userInfo.AB_Number__c;
            CASAGeneratedocumentsV7_Resp_IB_v1 response = CASAGeneratedocumentsV7_IH_v1.CASAGeneratedocumentsV7(requestBean);
             versionNumber =   response.Envelope.Body.GetDocsResponse.VersionNo;
			String accountId =  BranchFunctions.getAccountId(oppId);            
            if(!versionNumber.contains('Error')){
                account = [SELECT Id,Casa_Sequence_Number__c FROM Account Where Id =: accountId];
                account.Casa_Sequence_Number__c = versionNumber;
                update account;
            }		
        }
		return versionNumber;
	}  */
}