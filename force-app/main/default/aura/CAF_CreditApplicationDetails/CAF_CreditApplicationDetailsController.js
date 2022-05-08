({
    doInit : function(component, event, helper) {
        
       //var credit_Line = component.get("v.creditLineHolder");
        //console.log('Credit_Line>>'+credit_Line);
    }, 
	yesORno : function(component, event, helper) {
		var creditLine = component.get("v.creditLineVal");
        component.find("IdcreditLine").set("v.value",creditLine);
	},
	isSanctioningYesORno : function(component, event, helper) {
		var sanctioningRequiredValue = component.get("v.SanctioningRequiredValue");
        console.log('sanctioningRequiredValue'+ sanctioningRequiredValue);
        component.find("IdIs_sanctioning").set("v.value",sanctioningRequiredValue);
	},    
	articleSecureYesOrNo : function(component, event, helper) {
		var articleSecureValue = component.get("v.ArticleSecureValue");
        component.find("IdArticleSecure").set("v.value",articleSecureValue);
	},    
	indicatorInsolventYesOrNo : function(component, event, helper) {
		var indicatorInsolventValue = component.get("v.indicatorInsolventValue");
        component.find("IdindicatorInsolvent").set("v.value",indicatorInsolventValue);
	},  
	indicatorITCConsentYesOrNo : function(component, event, helper) {
		var indicatorITCConsentValue = component.get("v.indicatorITCConsentValue");
        component.find("IdIndicatorITCConsent").set("v.value",indicatorITCConsentValue);
	},    
	enterpriseCustomerYesOrNo : function(component, event, helper) {
		var enterpriseCustomerValue = component.get("v.EnterpriseCustomerValue");
        component.find("IdEnterpriseCustomer").set("v.value",enterpriseCustomerValue);
	}, 
	principalsClearBureauDataYesOrNo : function(component, event, helper) {
		var principalsClearBureauDataValue = component.get("v.principalsClearBureauDataValue");
        component.find("IdprincipalsClearBureauData").set("v.value",principalsClearBureauDataValue);
	}, 
	customerClearBureauDataYesOrNo : function(component, event, helper) {
		var customerClearBureauDataValue = component.get("v.BusinessClearBureauValue");
        component.find("IdcustomerClearBureauData").set("v.value",customerClearBureauDataValue);
	},     
 	principalsFavourableYesOrNo : function(component, event, helper) {
		var principalsFavourableValue = component.get("v.principalsFavourableValue");
        component.find("IdprincipalsFavourable").set("v.value",principalsFavourableValue);
	},
	customerFavourableYesOrNo : function(component, event, helper) {
		var customerFavourableValue = component.get("v.customerFavourableValue");
        component.find("IdcustomerFavourable").set("v.value",customerFavourableValue);
	}, 
	loanLessThan110YesOrNo : function(component, event, helper) {
		var loanLessThan110Value = component.get("v.loanLessThan110Value");
        component.find("IdloanLessThan110").set("v.value",loanLessThan110Value);
	},    
	ageOfArticleLessThan10yrEndYesOrNo : function(component, event, helper) {
		var ageOfArticleLessThan10yrEndValue = component.get("v.ageOfArticleLessThan10yrEndValue");
        component.find("IdageOfArticleLessThan10yrEnd").set("v.value",ageOfArticleLessThan10yrEndValue);
	},  
	totalPotentialExposureLessThan1_5YesOrNo : function(component, event, helper) {
		var totalPotentialExposureLessThan1_5Value = component.get("v.totalPotentialExposureLessThan1_5Value");
        component.find("IdtotalPotentialExposureLessThan1_5").set("v.value",totalPotentialExposureLessThan1_5Value);
	},    
	applAmountLessThan15TurnoverYesOrNo : function(component, event, helper) {
		var applAmountLessThan15TurnoverValue = component.get("v.applAmountLessThan15TurnoverValue");
        component.find("IdapplAmountLessThan15Turnover").set("v.value",applAmountLessThan15TurnoverValue);
	}, 
	calculateCreditApp : function(component, event, helper) {
        //$A.enqueueAction(component.get("c.updateTermMonths"));
        //alert('Test calculateCreditApp');
		var term_less_than_72_months 				= component.get("v.applicationData.Term_less_than_72_months__c");
        var loanLessThan110Value 					= component.get("v.loanLessThan110Value");
        var ageOfArticleLessThan10yrEndValue 		= component.get("v.ageOfArticleLessThan10yrEndValue");
        var totalPotentialExposureLessThan1_5Value 	= component.get("v.totalPotentialExposureLessThan1_5Value");
        var applAmountLessThan15TurnoverValue 		= component.get("v.applAmountLessThan15TurnoverValue");
        var calculateCreditAppResult				= 'No';
        
        calculateCreditAppResult = ((term_less_than_72_months == 'Yes') && (loanLessThan110Value == 'Yes') && (ageOfArticleLessThan10yrEndValue == 'Yes') && (totalPotentialExposureLessThan1_5Value == 'Yes') && (applAmountLessThan15TurnoverValue == 'Yes'))? 'Yes':'No'    

        component.set("v.calculateCreditAppResult",calculateCreditAppResult);
        //alert('Credit Application has calculated successfully'+calculateCreditAppResult);
	},     
    
    
})