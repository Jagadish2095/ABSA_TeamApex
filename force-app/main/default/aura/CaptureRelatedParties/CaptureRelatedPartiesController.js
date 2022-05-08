({
    doInit : function(component, event, helper) {
        helper.showSpinner(component);
	},
    //Load
	handleLoad : function(component, event, helper) {
             var searchType = component.get("v.searchTypeSelected");
        var searchValue = component.get("v.searchValue");
        if(searchType == "Search Salesforce" || searchType == "Name"){
            var letters = /^[A-Za-z ]+$/;
            //Regex test to make sure searchValue only contains Alphabetical Characters and / or Spaces (Name)
            if(letters.test(searchValue)){
                var nameList = searchValue.split(" ");
                //If there was a Space in the search, then use the first part for FirstName and the next part for LastName
                if(nameList.length >= 2){
                    component.find("firstNameField").set("v.value", nameList[0]);
                    component.find("lastNameField").set("v.value", nameList[1]);
                }else{
                    //No Spaces in searchValue. Just assign to FirstName
                    component.find("firstNameField").set("v.value", searchValue);
                }
            }else{
                //Has numbers (probably an ID Number)
                component.find("idNumberField").set("v.value", searchValue);
            }
        }else if(searchType == "ID Number"){
            //Is ID Number
            component.find("idNumberField").set("v.value", searchValue);
        }
        helper.hideSpinner(component);
	},

    //Agreement Check Box Select
	handleAgreement : function(component, event, helper) {
        //Show or Hide Next Button
        if(component.get("v.agreeValue").length == 1){
            component.set("v.showNextBtn", true);
        }else{
            component.set("v.showNextBtn", false);
        }
	},

    //Save
	saveNewRelatedParty : function(component, event, helper) {
        debugger;
      var validatebypass =  component.find("iValidateByPass").set("v.value", true);
      
        helper.validateIdNumber(component);
        if(   component.get("v.isIdNumberValid") == false)
        {
            component.set("v.errorMessage", "Please enter valid ID number.");
          return;  
        }
       // helper.showSpinner(component);
        if($A.util.isEmpty(component.find("firstNameField").get("v.value"))
     
        || $A.util.isEmpty(component.find("lastNameField").get("v.value"))
        || $A.util.isEmpty(component.find("idNumberField").get("v.value"))){ //|| $A.util.isEmpty(component.find("mobilePhoneField").get("v.value"))

            helper.fireToast("Error", "Please complete the required fields. ", "error");
        }else{

       
           
            component.find("newAccountForm").submit();
           // helper.hideSpinner(component);
           
        }
	},

    //Submit
	handleSubmit : function(component, event, helper) {
      
        helper.showSpinner(component);
	},

    //Success Account
	handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log("New Account Created: " + payload.id);
        component.set("v.relatedPartyRecordId", payload.id);
        console.log("relatedPartyRecordId: " + component.get("v.relatedPartyRecordId"));
		helper.fireToast("Success", "Account saved successfully", "success");
   
        var selectedAccount =payload.id;
	
		
				let Ipromise = helper.UpdateRelatedPartiesGender(component, helper, selectedAccount).then(
					$A.getCallback(function (result) {
                        //helper.fireToast("Success!", "The Related Party was Successfully linked to the Main Stokvel Account. ", "success");
                        //Navigate
                        var parentCmp = component.get("v.parent");
                        parentCmp.navigateNextScreen();
						debugger;
						resolve("success");
					}),
					$A.getCallback(function (error) {
						component.set("v.errorMessage", "There was an error while trying to link RelatedParty" + JSON.stringify(error));
					})
				);        
	},

	//Error
	handleError : function(component, event, helper) {
        helper.hideSpinner(component);
		var errorMessage = event.getParam("message");
		console.log("Error: " + errorMessage + ". " + JSON.stringify(event.getParams()));
		helper.fireToast("Error", errorMessage, "error");
	},

    //Toggle between This Form and the Client Finder
	cancelNewRelatedParty : function(component, event, helper) {
        component.set("v.createNewRelatedParty", false);
	},

    handleChangeIdValue : function (component, event, helper) {
        helper.validateIdNumber(component);
    }
})