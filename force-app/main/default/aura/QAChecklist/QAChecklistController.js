({
	doInit : function(component, event, helper) {
       helper.fetchCaseChecklistRec(component); 
    },
    handleSubmit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        helper.createCaseChecklist(component);
    },
    handleQASubmit : function(component, event, helper) {
       component.set("v.showSpinner", true);
        helper.createCaseQAchecklist(component);
    },
    Checkboxesvalues : function(component, event, helper) {
        var Q1 = component.find("NameofAppWhatisonTheCIFId").get("v.checked");var Q2 = component.find("cardtypecapturedcorrectlyId").get("v.checked");
        var Q3 = component.find("embossedlineId").get("v.checked");var Q4 = component.find("userembossedlineId").get("v.checked");
        var Q5 = component.find("CAMNId").get("v.checked");var Q6 = component.find("linkedaccountId").get("v.checked");
        var Q7 = component.find("debitorderId").get("v.checked"); var Q8 = component.find("deliveryinsId").get("v.checked");
        var Q9 = component.find("limitsId").get("v.checked");var Q10 = component.find("memolineId").get("v.checked");
        var Q11 = component.find("creditapprovalId").get("v.checked");
        
        var QAQ1 = component.find("QANameofAppWhatisonTheCIFId").get("v.checked");var QAQ2 = component.find("QAcardtypecapturedcorrectlyId").get("v.checked");
        var QAQ3 = component.find("QAembossedlineId").get("v.checked");var QAQ4 = component.find("QAuserembossedlineId").get("v.checked");
        var QAQ5 = component.find("QACAMNId").get("v.checked");var QAQ6 = component.find("QAlinkedaccountId").get("v.checked");
        var QAQ7 = component.find("QAdebitorderId").get("v.checked"); var QAQ8 = component.find("QAdeliveryinsId").get("v.checked");
        var QAQ9 = component.find("QAlimitsId").get("v.checked");var QAQ10 = component.find("QAmemolineId").get("v.checked");
        var QAQ11 = component.find("QAcreditapprovalId").get("v.checked");
        component.set('v.preissueq1',Q1);component.set('v.preissueq2',Q2);component.set('v.preissueq3',Q3); 
        component.set('v.preissueq4',Q4);component.set('v.preissueq5',Q5);component.set('v.preissueq6',Q6); 
        component.set('v.preissueq7',Q7);component.set('v.preissueq8',Q8);component.set('v.preissueq9',Q9);
        component.set('v.preissueq10',Q10);component.set('v.preissueq11',Q11); 
        
        component.set('v.QAcheckq1',QAQ1);component.set('v.QAcheckq2',QAQ2);component.set('v.QAcheckq3',QAQ3); 
        component.set('v.QAcheckq4',QAQ4);component.set('v.QAcheckq5',QAQ5);component.set('v.QAcheckq6',QAQ6); 
        component.set('v.QAcheckq7',QAQ7);component.set('v.QAcheckq8',QAQ8);component.set('v.QAcheckq9',QAQ9);
        component.set('v.QAcheckq10',QAQ10);component.set('v.QAcheckq11',QAQ11); 
    },
})