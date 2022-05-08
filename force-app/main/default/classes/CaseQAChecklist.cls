/**
 * @description Class controller for CaseQAChecklist component.
 * @author Jaco de Lange
 * @since 2021-01-25
 **/
global with sharing class CaseQAChecklist{
	/**
	 * @description This method is used to insert case checklist records
	 * No return type
	 * @param caseId
	 **/
	@AuraEnabled
	public static void createCaseChecklistrecs(String caseId){

		List<String> qnames = new List<String>{'Guarantee Number Contract Created', 'Guarantee Documents Issued', 'Collateral Captured on SMS to O status', 'CMS Limit Loaded', 'SMS CINA Journal Notes Captured (QA)', 'SMS CINA Journal Notes Captured (QC)', 'Journal Prepared', 'CMS Limit Approved', 'Status Change from U to IMG U status', 'Y status Removed', 'SMS CINA Message Captured', 'Securities Collateral on SMS Captured'};

		Case currentCase;
		List<Case> caseList = new List<Case>();
		List<Case_Checklist__c> checklistrec = new List<Case_Checklist__c>();
		Set<Id> caseIdSet = new Set<Id>();

		if (caseId != null){
			caseIdSet.add(caseId);
			//get current case record
			currentCase = new CasesSelector().caseQAChecklist(caseId);
			//get related case checklist records for case record
			caseList = new CasesSelector().selectByIdWithCaseChecklist(caseIdSet);

			if (caseList.size() > 0 && caseList != null){
				for (Case ccl : caseList){
					checklistrec.addAll(ccl.Case_Checklists__r);
				}
				if (checklistrec.IsEmpty()){
					createcasechecklist(caseId, qnames);
				}
			}
		}
	}

    /**
     * @description createcasechecklist description
     *
     * @param caseId (String): caseId
     * @param questionnames (List<String>): questionnames
     */
	@AuraEnabled
	public static void createcasechecklist(String caseId, List<String> questionnames){

		List<Case_Checklist__c> newchecklistreclist = new List<Case_Checklist__c>();

		for (String qname : questionnames){
			Case_Checklist__c newccl = new Case_Checklist__c();
			newccl.Case_checklist_question__c = qname;
			newccl.Related_Case__c = caseId;
			newchecklistreclist.add(newccl);
		}

		if (newchecklistreclist.size() > 0 && newchecklistreclist != null){
			insert newchecklistreclist;
		}
	}

/**
 * @description updatecasechecklist description
 *
 * @param caseId (String): caseId
 * @param guaranteeNoVal (Boolean): guaranteeNoVal
 * @param guaranteeDocsVal (Boolean): guaranteeDocsVal
 * @param collateralCapturedVal (Boolean): collateralCapturedVal
 * @param cmsLimitLoadedVal (Boolean): cmsLimitLoadedVal
 * @param smsCinaJournalVal (Boolean): smsCinaJournalVal
 * @param journalprepVal (Boolean): journalprepVal
 * @param cmslimitappVal (Boolean): cmslimitappVal
 * @param statuschangeVal (Boolean): statuschangeVal
 * @param ystatremoveVal (Boolean): ystatremoveVal
 * @param smsCinaMessVal (Boolean): smsCinaMessVal
 * @param secureCollatVal (Boolean): secureCollatVal
 * @param smsCinaJournalQcVal (Boolean): smsCinaJournalQcVal
 */
	@AuraEnabled
	public static void updatecasechecklist(String caseId, Boolean guaranteeNoVal, Boolean guaranteeDocsVal, Boolean collateralCapturedVal, Boolean cmsLimitLoadedVal, Boolean smsCinaJournalVal, Boolean journalprepVal, Boolean cmslimitappVal, Boolean statuschangeVal, Boolean ystatremoveVal, Boolean smsCinaMessVal, Boolean secureCollatVal, Boolean smsCinaJournalQcVal){

		guaranteeNoVal = (guaranteeNoVal != null ? guaranteeNoVal : false);
		collateralCapturedVal = (collateralCapturedVal != null ? collateralCapturedVal : false);
		cmsLimitLoadedVal = (cmsLimitLoadedVal != null ? cmsLimitLoadedVal : false);
		smsCinaJournalVal = (smsCinaJournalVal != null ? smsCinaJournalVal : false);
		journalprepVal = (journalprepVal != null ? journalprepVal : false);
		cmslimitappVal = (cmslimitappVal != null ? cmslimitappVal : false);
		statuschangeVal = (statuschangeVal != null ? statuschangeVal : false);
		ystatremoveVal = (ystatremoveVal != null ? ystatremoveVal : false);
		smsCinaMessVal = (smsCinaMessVal != null ? smsCinaMessVal : false);
		secureCollatVal = (secureCollatVal != null ? secureCollatVal : false);
		guaranteeDocsVal = (guaranteeDocsVal != null ? guaranteeDocsVal : false);
		smsCinaJournalQcVal = (smsCinaJournalQcVal != null ? smsCinaJournalQcVal : false);

		String cctId = [select Id
		                from Case_Checklist_Template__c
		                where Checklist_Name__c = :'Guarantee Fulfilment'].Id;
		List<Case_Checklist__c> checklistrec = new List<Case_Checklist__c>();
		List<Case_Checklist__c> updatechecklistrec = new List<Case_Checklist__c>();
		List<Case> caseList = new List<Case>();
		Set<Id> caseIdSet = new Set<Id>();

		if (caseId != null){
			caseIdSet.add(caseId);
			//get related case checklist records for case record
			caseList = new CasesSelector().selectByIdWithCaseChecklist(caseIdSet);

			if (caseList.size() > 0 && caseList != null){
				for (Case ccl : caseList){
					checklistrec.addAll(ccl.Case_Checklists__r);
				}
			}
			if (checklistrec.size() > 0 && checklistrec != null){
				for (Case_Checklist__c casecl : checklistrec){
					//Guarantee_Number_Contract_Created
					if (casecl.Case_checklist_question__c == 'Guarantee Number Contract Created' && casecl.Validate__c != guaranteeNoVal){
						casecl.Validate__c = guaranteeNoVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//Guarantee_Documents_Issued
					if (casecl.Case_checklist_question__c == 'Guarantee Documents Issued' && casecl.Validate__c != guaranteeDocsVal){
						casecl.Validate__c = guaranteeDocsVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//Collateral_Captured_on_SMS_to_O_status
					if (casecl.Case_checklist_question__c == 'Collateral Captured on SMS to O status' && casecl.Validate__c != collateralCapturedVal){
						casecl.Validate__c = collateralCapturedVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//CMS_Limit_Loaded
					if (casecl.Case_checklist_question__c == 'CMS Limit Loaded' && casecl.Validate__c != cmsLimitLoadedVal){
						casecl.Validate__c = cmsLimitLoadedVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//SMS_CINA_Journal_Notes_Captured (QA)
					if (casecl.Case_checklist_question__c == 'SMS CINA Journal Notes Captured (QA)' && casecl.Validate__c != smsCinaJournalVal){
						casecl.Validate__c = smsCinaJournalVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//SMS_CINA_Journal_Notes_Captured (QC)
					if (casecl.Case_checklist_question__c == 'SMS CINA Journal Notes Captured (QC)' && casecl.Validate__c != smsCinaJournalQcVal){
						casecl.Validate__c = smsCinaJournalQcVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//Journal_Prepared
					if (casecl.Case_checklist_question__c == 'Journal Prepared' && casecl.Validate__c != journalprepVal){
						casecl.Validate__c = journalprepVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//CMS_Limit_Approved
					if (casecl.Case_checklist_question__c == 'CMS Limit Approved' && casecl.Validate__c != cmslimitappVal){
						casecl.Validate__c = cmslimitappVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//Status_Change_from_U_to_IMG_U_status
					if (casecl.Case_checklist_question__c == 'Status Change from U to IMG U status' && casecl.Validate__c != statuschangeVal){
						casecl.Validate__c = statuschangeVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//Y_status_Removed
					if (casecl.Case_checklist_question__c == 'Y status Removed' && casecl.Validate__c != ystatremoveVal){
						casecl.Validate__c = ystatremoveVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//SMS_CINA_Message_Captured
					if (casecl.Case_checklist_question__c == 'SMS CINA Message Captured' && casecl.Validate__c != smsCinaMessVal){
						casecl.Validate__c = smsCinaMessVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
					//Securities_Collateral_on_SMS_Captured
					if (casecl.Case_checklist_question__c == 'Securities Collateral on SMS Captured' && casecl.Validate__c != secureCollatVal){
						casecl.Validate__c = secureCollatVal;
						casecl.Date_Submitted__c = system.today();
						casecl.Date_Validated__c = system.today();
						casecl.Case_Checklist_Template__c = (cctId != null) ? cctId : null;
						casecl.Submitted_By__c = userinfo.getUserId();
						casecl.Validated_By__c = userinfo.getUserId();
						updatechecklistrec.add(casecl);
					}
				}
				update updatechecklistrec;
			}
		}
	}
}