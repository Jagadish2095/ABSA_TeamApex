/**
 * @description Extension Controller for QAChecklist  Component for credit Fullfilment
 *
 * @author  Haritha P : Absa
 * @version v1.0
 * @since   2021-02-26
 *
 */
public class CreditFulfillmentQAChecklistCon{
/**
 * @description createcasechecklist description
 *
 * @param caseId (String): caseId
 * @param Q1 (Boolean): Q1
 * @param Q2 (Boolean): Q2
 * @param Q3 (Boolean): Q3
 * @param Q4 (Boolean): Q4
 * @param Q5 (Boolean): Q5
 * @param Q6 (Boolean): Q6
 * @param Q7 (Boolean): Q7
 * @param Q8 (Boolean): Q8
 * @param Q9 (Boolean): Q9
 * @param Q10 (Boolean): Q10
 * @param Q11 (Boolean): Q11
 * @return List<Case_Checklist__c>: Return description
 */
    @AuraEnabled
	public static List<Case_Checklist__c> createcasechecklist(String caseId, Boolean Q1, Boolean Q2, Boolean Q3, Boolean Q4, Boolean Q5, Boolean Q6, Boolean Q7, Boolean Q8, Boolean Q9, Boolean Q10, Boolean Q11){
		Q1 = (Q1 != null ? Q1 : false);
		Q2 = (Q2 != null ? Q2 : false);
		Q3 = (Q3 != null ? Q3 : false);
		Q4 = (Q4 != null ? Q4 : false);
		Q5 = (Q5 != null ? Q5 : false);
		Q6 = (Q6 != null ? Q6 : false);
		Q7 = (Q7 != null ? Q7 : false);
		Q8 = (Q8 != null ? Q8 : false);
		Q9 = (Q9 != null ? Q9 : false);
		Q10 = (Q10 != null ? Q10 : false);
		Q11 = (Q11 != null ? Q11 : false);
		List<Case_Checklist_Question__c> questionnames = [select Id, Name, Checklist_Template__c, Heading__c, Question__c
		                                                  from Case_Checklist_Question__c
		                                                  where Checklist_Template__r.Checklist_Name__c = 'Credit Fulfillment'];
		List<Case_Checklist__c> newchecklistreclist = new List<Case_Checklist__c>();
		List<Case_Checklist__c> oldchecklistreclist = [select id, Related_Case__c, Case_checklist_question__c, Case_Checklist_Template__c
		                                               from Case_Checklist__c
		                                               where Related_Case__c = :caseId AND ( NOT Case_checklist_question__c like '%(QA)%')];
		if (!oldchecklistreclist.isEmpty()){
			delete oldchecklistreclist;
		}
		for (Case_Checklist_Question__c qname : questionnames){
			Case_Checklist__c newccl = new Case_Checklist__c();
			IF (!qname.Question__c.contains('QA')){
				newccl.Case_checklist_question__c = qname.Question__c;
				newccl.Case_Checklist_Template__c = qname.Checklist_Template__c;
				newccl.Related_Case__c = caseId;
				newccl.Date_Submitted__c = system.today();
				newccl.Date_Validated__c = system.today();
				newccl.Submitted_By__c = userinfo.getUserId();
				newccl.Validated_By__c = userinfo.getUserId();

				system.debug('qname.Question__c' + qname.Question__c);
				if (qname.Question__c == 'Is the Name of the of the Application the same as what is on the CIF'){
					newccl.Validate__c = Q1;
				}
				if (qname.Question__c == 'Was the Card type captured correctly'){
					newccl.Validate__c = Q2;
				}
				if (qname.Question__c == 'Was the embossed line for the Control Account captured correctly'){
					newccl.Validate__c = Q3;
				}
				if (qname.Question__c == 'Was the embossed line for the User Account captured correctly'){
					newccl.Validate__c = Q4;
				}
				if (qname.Question__c == 'Was the statement delivery option captured correctly on CAMN'){
					newccl.Validate__c = Q5;
				}
				if (qname.Question__c == 'The additional user card is linked to the correct control/main account'){
					newccl.Validate__c = Q6;
				}
				if (qname.Question__c == 'Was the debit order captured correctly'){
					newccl.Validate__c = Q7;
				}
				if (qname.Question__c == 'Is the delivery instruction correct'){
					newccl.Validate__c = Q8;
				}
				if (qname.Question__c == 'Were the limits captured correctly'){
					newccl.Validate__c = Q9;
				}
				if (qname.Question__c == 'Was memolines placed where applicable'){
					newccl.Validate__c = Q10;
				}
				if (qname.Question__c == 'Is the credit approval correct'){
					newccl.Validate__c = Q11;
				}
				newchecklistreclist.add(newccl);
			}
		}
		insert newchecklistreclist;
		return newchecklistreclist;
	}

    /**
     * @description CreateCaseQAChecklist description
     *
     * @param caseId (String): caseId
     * @param Q1 (Boolean): Q1
     * @param Q2 (Boolean): Q2
     * @param Q3 (Boolean): Q3
     * @param Q4 (Boolean): Q4
     * @param Q5 (Boolean): Q5
     * @param Q6 (Boolean): Q6
     * @param Q7 (Boolean): Q7
     * @param Q8 (Boolean): Q8
     * @param Q9 (Boolean): Q9
     * @param Q10 (Boolean): Q10
     * @param Q11 (Boolean): Q11
     * @return List<Case_Checklist__c>: Return description
     */
	@AuraEnabled
	public static List<Case_Checklist__c> CreateCaseQAChecklist(String caseId, Boolean Q1, Boolean Q2, Boolean Q3, Boolean Q4, Boolean Q5, Boolean Q6, Boolean Q7, Boolean Q8, Boolean Q9, Boolean Q10, Boolean Q11){
		Q1 = (Q1 != null ? Q1 : false);
		Q2 = (Q2 != null ? Q2 : false);
		Q3 = (Q3 != null ? Q3 : false);
		Q4 = (Q4 != null ? Q4 : false);
		Q5 = (Q5 != null ? Q5 : false);
		Q6 = (Q6 != null ? Q6 : false);
		Q7 = (Q7 != null ? Q7 : false);
		Q8 = (Q8 != null ? Q8 : false);
		Q9 = (Q9 != null ? Q9 : false);
		Q10 = (Q10 != null ? Q10 : false);
		Q11 = (Q11 != null ? Q11 : false);
		List<Case_Checklist_Question__c> questionnames = [select Id, Name, Checklist_Template__c, Heading__c, Question__c
		                                                  from Case_Checklist_Question__c
		                                                  where Checklist_Template__r.Checklist_Name__c = 'Credit Fulfillment'];
		List<Case_Checklist__c> newchecklistreclist = new List<Case_Checklist__c>();
		List<Case_Checklist__c> oldchecklistreclist = [select id, Related_Case__c, Case_checklist_question__c, Case_Checklist_Template__c
		                                               from Case_Checklist__c
		                                               where Related_Case__c = :caseId and Case_checklist_question__c LIKE '%(QA)%'];
		if (!oldchecklistreclist.isEmpty()){
			delete oldchecklistreclist;
		}
		for (Case_Checklist_Question__c qname : questionnames){
			Case_Checklist__c newccl = new Case_Checklist__c();
			IF (qname.Question__c.contains('QA')){
				newccl.Case_checklist_question__c = qname.Question__c;
				newccl.Case_Checklist_Template__c = qname.Checklist_Template__c;
				newccl.Related_Case__c = caseId;
				newccl.Date_Submitted__c = system.today();
				newccl.Date_Validated__c = system.today();
				newccl.Submitted_By__c = userinfo.getUserId();
				newccl.Validated_By__c = userinfo.getUserId();

				system.debug('qname.Question__c' + qname.Question__c);
				if (qname.Question__c == 'Is the Name of the of the Application the same as what is on the CIF(QA)'){
					newccl.Validate__c = Q1;
				}
				if (qname.Question__c == 'Was the Card type captured correctly(QA)'){
					newccl.Validate__c = Q2;
				}
				if (qname.Question__c == 'Was the embossed line for the Control Account captured correctly(QA)'){
					newccl.Validate__c = Q3;
				}
				if (qname.Question__c == 'Was the embossed line for the User Account captured correctly(QA)'){
					newccl.Validate__c = Q4;
				}
				if (qname.Question__c == 'Was the statement delivery option captured correctly on CAMN(QA)'){
					newccl.Validate__c = Q5;
				}
				if (qname.Question__c == 'The additional user card is linked to the correct control/main account(QA)'){
					newccl.Validate__c = Q6;
				}
				if (qname.Question__c == 'Was the debit order captured correctly(QA)'){
					newccl.Validate__c = Q7;
				}
				if (qname.Question__c == 'Is the delivery instruction correct(QA)'){
					newccl.Validate__c = Q8;
				}
				if (qname.Question__c == 'Were the limits captured correctly(QA)'){
					newccl.Validate__c = Q9;
				}
				if (qname.Question__c == 'Was memolines placed where applicable(QA)'){
					newccl.Validate__c = Q10;
				}
				if (qname.Question__c == 'Is the credit approval correct(QA)'){
					newccl.Validate__c = Q11;
				}
				newchecklistreclist.add(newccl);
			}
		}
		insert newchecklistreclist;
		return newchecklistreclist;
	}

    /**
     * @description getcasechecklistRecords description
     *
     * @param caseId (Id): caseId
     * @return LIST<Case_Checklist__c>: Return description
     */
	@AuraEnabled
	public static LIST<Case_Checklist__c> getcasechecklistRecords(Id caseId){
		List<Case_Checklist_Question__c> questionnames = [select Id, Name, Checklist_Template__c, Heading__c, Question__c
		                                                  from Case_Checklist_Question__c
		                                                  where Checklist_Template__r.Checklist_Name__c = 'Credit Fulfillment'];
		List<Case_Checklist__c> checklistreclist = [select id, Related_Case__c, Validate__c, Date_Submitted__c, Submitted_By__c, Validated_By__c, Case_checklist_question__c, Case_Checklist_Template__c
		                                            from Case_Checklist__c
		                                            where Related_Case__c = :caseId And Case_Checklist_Template__r.Checklist_Name__c = 'Credit Fulfillment'];
		return checklistreclist;
	}
}