public class WillsHotDocsAnswerSetGenerator implements HotDocsAnswerSetGenerator {
	
	private Map<String, Object> context;
	private String answers;

	public void setContext(Map<String, Object> context) {
		this.context = context;
	}
	
	public void setAnswers(String answers) {
		this.answers = answers;
	}

	public String generate() {
		ID oppId = (ID) context.get('id');
		//Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(oppId);
		Opportunity opp = [SELECT Id, Name, AccountId, Adviser__c, Site__c, Adviser_Employee__c FROM Opportunity WHERE Id = :oppId];
        Set<Id> ids = new Set<Id>();
        ids.add(opp.AccountId);
        List<Account> accs = new AccountsSelector().selectById(ids, 1);
        Account acc = accs.get(0);
        Asset will = null;
        List<Asset> assets = new AssetsSelector().selectByAccountIdAndAssetType(acc.Id, 'Will');
        if (assets != null && !assets.isEmpty()) {
        	will = assets.get(0);
        }
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        Employee__c advisor = null;
        try {
            advisor = new EmployeesSelector().selectById(opp.Adviser_Employee__c);
        } catch (Exception ex) {
            throw new ApplicationException('There is no advisor assigned to this opportunity!');
        }
        Site__c site = null;
        if (opp.Site__c != null) {
        	site = [SELECT Id, Name, Site_Code__c FROM Site__c WHERE Id = :opp.Site__c];
        }
        
        String drafterABNumber = currentUser == null ? '' : currentUser.AB_Number__c == null ? '' : currentUser.AB_Number__c;
        String advisorCode = advisor == null ? '' : advisor.Advisor_Code__c == null ? '' : advisor.Advisor_Code__c;
        String advisorSiteCode = site == null ? '' : site.Site_Code__c == null ? '' : site.Site_Code__c;
        String willType = acc.Client_Type__c == null ? '' : acc.Client_Type__c == 'Individual' ? 'Single Will': 'Joint Will';
        String marriageContractType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('HotDocs', 'Marital Contract Type', //
        						acc.Marital_Contract_Type__pc, 'Outbound');
        if (acc == null  || will == null) {
        	throw new ApplicationException('This opportunity is not linked to a Will Asset!');
        }
		HotDocsAnswerSetBuilder.AnswerBuilder builder =	new HotDocsAnswerSetBuilder() //
						.title((String) context.get('title')) //
						.version('1.1') //
						.answers()//
						.answer('Draft_Date-dt', DateTime.now().format('dd/MM/yyyy'), false, HotDocsAnswerSetBuilder.TypeValue.DateValue)//
						.answer('Language-mc', String.isEmpty(acc.Communication_Language__pc) ? 'English' : acc.Communication_Language__pc, false, HotDocsAnswerSetBuilder.TypeValue.MCValue) //
                        .answer('Will_Reference_Number-t', will.SerialNumber, false, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
                        .answer('Drafters_AB_Number-t', drafterABNumber, false, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
                        .answer('Advisor_Code-t', advisorCode, false, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
                        .answer('Site_Code-t', advisorSiteCode, false, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
                        .answer('Will_Type-mc', willType, false, HotDocsAnswerSetBuilder.TypeValue.MCValue) //
                        .answer('Matrimonial_Regime-mc', marriageContractType, false, HotDocsAnswerSetBuilder.TypeValue.MCValue); //
                        //.answer('Muslim_Will-tf', false, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
                        List<Account> relatedAccounts = (willType == 'Joint Will') ? new AccountContactRelationSelector().selectListByAccId(acc.Id) : new List<Account>{acc};
                    	for (Account acct : relatedAccounts) {
                    		acct = new AccountsSelector().selectById(new Set<Id>{acct.Id}, 1).get(0);
                        	builder.answer('Testator_Name-t', acct.Name, true, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
	                        	   .answer('South_African_Citizen-tf', acct.ID_Type__pc, true, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
	                        	   .answer('Party_Identity_Number-t', acct.ID_Number__pc, true, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
	                        	   .answer('Passport_Nationality-t', acct.CountryPassport__pc, true, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
	                        	   .answer('Passport_Number-n', acct.ID_Number__pc, true, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
	                        	   .answer('Gender_1-mc', acct.Gender__pc, true, HotDocsAnswerSetBuilder.TypeValue.MCValue); //
	                        	   //.answer('Custom_Will-tf', false, false, HotDocsAnswerSetBuilder.TypeValue.TextValue) //
                    	}

						
		return builder.answerSet().buildJson(this.answers);
	}
}