({
    //Function for getting data from the apex controller
	preScreenCustomer: function(component, event) {
		var action = component.get("c.getPreScreenResult");
        
        action.setParams({
            applicationType:"P",
            channelCode:"T",
            corpCode:"ABSA",
            customerType:"001",
            customerId:"8210077042197",
            customerSourceCode:"VSF",
            customerSourceReferenceNumber:"This is a test3",
            isInBusinessRescueAffectedParty:"false",
            casaClauseRead:"true",
            curatorship:"true",
            marketingSiteId:"4512",
            productGroupId:"1",
            idOrRegistrationNo:"8210077042197",
            identificationType:"01",
            dateOfBirth:"1982-10-07",
            idIssuedDate:"1996-12-28",
            firstNames:"JOHN",
            initials:"J",
            surname:"MAYOR",
            titleType:"01",
            placeOfResidence:"01",
            number:"0834086492",
            employeeNumber:"9019050",
            messageLanguage:"E",
            siteId:"4512",
            systemName:"VSF",
            userId:"ABAJ013",
            validateDetails:"true"
        });
        action.setcallback(this,function(response){
            var state = response.getState();
        });
        $A.enqueueAction(action);
	}
})