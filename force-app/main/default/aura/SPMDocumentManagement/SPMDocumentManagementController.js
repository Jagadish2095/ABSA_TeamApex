({
    doInit: function(component, event, helper) {
          
        //Added By Rajesh START
		var applicationRecordArray = component.get("v.applicationRecordArray");
		var appRec = {
            rowNumber : '1',
            firstName : "",
            sirName :"",
            idNumber:"",
            email:"",
            phone:"",
            capacity:"",
            selectedAcc:null,
            initial1:"",
            surname1:"",
            initial2:"",
            surname2:""            
        };
        applicationRecordArray.push(appRec);
        component.set("v.applicationRecordArray",applicationRecordArray);
        
         component.set('v.policyColumns', [
            { label: 'Select', fieldName: 'None', type: 'none'},
            { label: 'Account', fieldName: 'Name', type: 'text'}]);
        //Added By Rajesh END
        var actions = [
            { label: 'Download', name: 'download' }
        ];
        
        component.set('v.mycolumns', [
            {label: 'Authorise', fieldName: 'None', type: 'text'},
            {label: 'Signatory', fieldName: 'Name', type: 'Text'},
            {label: 'Operational Role', fieldName: 'Roles', type: 'text', wrapText: true}]);
        
        component.set('v.AccountSelect', [
            {label: 'Available Accounts', fieldName: 'None', type: 'text'}]);
        
        component.set('v.columnsAudit', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'User', fieldName: 'ownerName', type: 'text'},
            { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: {day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true} },
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]
                      
                      
         );
        
        
        helper.fetchAuditData(component);
        helper.fetchTemplateTypesPickListVal(component);
        
        helper.fetchPersonAccs(component, event, helper);
        //Added by Diksha for Document Prepopulation 
        helper.getAppId(component, event, helper);
        helper.getAppRecorddetails(component, event, helper);
        helper.getPrimayClientMandatoryDocs(component);
        helper.fetchAccountContactRelation(component, event, helper);
        helper.getOppAcc(component, event, helper);
    },

	/**
    * @description download function to download file from ECM.
    **/
    download: function(cmp, event, helper) {
        var row = event.getParam('row');
        var actionName = event.getParam('action').name;
        helper.download(cmp, row);
    }, 
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'download':
                helper.download(component, row);
                break
        }
    },
    
    doGenerate: function(component, event, helper) {
        
        console.log('signatureRequest : ' + component.get("v.signatureRequestRecords"));
        
        if (component.get("v.fileType") == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "To generate a document please select the type of document to generate.",
                "type": "error"
            });
            toastEvent.fire();
        } else {
            console.log("doGenerate");
            //alert('Generate document code here');
            helper.generateDocument(component, event, helper);
        }
    },
    
    // Tinashe
    doNewGenerate: function(component, event, helper) {
        
        console.log('signatureRequest : ' + component.get("v.signatureRequestRecords"));
        
        if (component.get("v.fileType") == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "To generate a document please select the type of document to generate.",
                "type": "error"
            });
            toastEvent.fire();
        } else {
            console.log("doGenerate");
            //alert('Generate document code here');
            helper.generateNewDocument(component, event, helper);
        }
    },
    // end Tinashe
    
    refreshDocuments : function(component, event, helper) {
        helper.fetchAuditData(component);
        helper.checkStage(component);
    },
    
    handleClickCancel: function(component, event, helper) {
        for(var i in  component.find("allFieldId")){
            var eachField = component.find("allFieldId")[i];
            eachField.set("v.value",null);
        }
        /*component.find("lastName").set("v.value",null);
        component.find("idNuber").set("v.value",null);
        component.find("emailId").set("v.value",null);
        component.find("phoneNumber").set("v.value",null);
        component.set("v.selectedFirstName",'');*/
        var applicationRecordArray = [];
        var appRec = {
            rowNumber : '1',
            firstName : "",
            sirName :"",
            idNumber:"",
            email:"",
            phone:"",
            capacity:"",
            selectedAcc:null,
            initial1:"",
            surname1:"",
            initial2:"",
            surname2:""               
        };
        applicationRecordArray.push(appRec);
        component.set("v.applicationRecordArray",applicationRecordArray);
        
    },
    handleClickAdd: function(component, event, helper) {
        //component.set("v.show2Initials",!component.get("v.show2Initials"));
        
        var applicationRecordArray = component.get("v.applicationRecordArray");
        var rowNum = applicationRecordArray.length + 1;
        var appRec = {
            rowNumber : rowNum,
            firstName : "",
            sirName :"",
            idNumber:"",
            email:"",
            phone:"",
            capacity:"",
            selectedAcc:null,
            initial1:"",
            surname1:"",
            initial2:"",
            surname2:""   
        };
        applicationRecordArray.push(appRec);
        component.set("v.applicationRecordArray",applicationRecordArray);
        
    },
    handleRemoveApp: function(component, event, helper) {
        
    },
    handleSelectFirstName: function(component, event, helper) {
        
        var changedRow = event.getSource().get("v.class");
        /* component.find("lastName").set("v.value",null);
        component.find("idNuber").set("v.value",null);
        component.find("emailId").set("v.value",null);
        component.find("phoneNumber").set("v.value",null);*/
        
        var selectedFirstName = event.getSource().get("v.value");
        //helper.fetchRoles(component, event, selectedFirstName,changedRow);
        //alert(selectedFirstName+' == '+changedRow);
        var accList = component.get("v.personAccList");
        console.log('accList '+JSON.stringify(accList));
        var firstName ='';
        var lastName ='';
        var idNumber ='';
        var phone ='';
        var email = '';
        var capacity = '';
        for(var i in accList){
            console.log(accList[i].Id +' == '+selectedFirstName);
            if(accList[i].Id == selectedFirstName){
                console.log('accList[i] '+JSON.stringify(accList[i])); 
                firstName = accList[i].Contact.FirstName;
                lastName = accList[i].Contact.LastName;
                idNumber = accList[i].Contact.ID_Number__c;
                email = accList[i].Contact.Email;
                phone = accList[i].Contact.Phone;
                capacity = accList[i].Roles;
            }
        }
        console.log('firstName '+firstName);
        console.log('lastName '+lastName);
        console.log('idNumber '+idNumber);
        console.log('email '+email);
        console.log('phone '+phone);
        var applicationRecordArray = component.get("v.applicationRecordArray");
        console.log('applicationRecordArray '+JSON.stringify(applicationRecordArray));
        for(var i in applicationRecordArray){
            if(applicationRecordArray[i].rowNumber == changedRow){
                applicationRecordArray[i].firstName = firstName;
                applicationRecordArray[i].sirName = lastName;
                applicationRecordArray[i].idNumber = idNumber != undefined ? idNumber : '';
                applicationRecordArray[i].email = email != undefined ? email : '';
                applicationRecordArray[i].phone = phone != undefined ? phone : '';
                applicationRecordArray[i].capacity = capacity;
            }
        }
        console.log('applicationRecordArray AFTER'+JSON.stringify(applicationRecordArray));
        component.set("v.applicationRecordArray",applicationRecordArray);
        
    },
    handleClickSave: function(component, event, helper) {
        var applicationRec = component.get("v.applicationRec");
        console.log('applicationRec '+JSON.stringify(applicationRec));
    },
    handleSubmitApp: function(component, event, helper) {
        
        event.preventDefault();       // stop the form from submittin
        var isValid = true;
        
        var applicationRecordArray = component.get("v.applicationRecordArray");
        for(var i in applicationRecordArray){
            if(applicationRecordArray[i].initial1 == undefined || applicationRecordArray[i].initial1 == '' || applicationRecordArray[i].initial1 == null
               || applicationRecordArray[i].surname1 == undefined || applicationRecordArray[i].surname1 == '' || applicationRecordArray[i].surname1 == null
               ||applicationRecordArray[i].initial2 == undefined || applicationRecordArray[i].initial1initial2 == '' || applicationRecordArray[i].initial2 == null
               || applicationRecordArray[i].surname2 == undefined || applicationRecordArray[i].surname2 == '' || applicationRecordArray[i].surname2 == null){
                
                isValid = false;
            }
        }
        if(isValid){
            var editForms = component.find("applicationRecForm");        
            var forms = [].concat(editForms || []);
            //alert(forms.length);
            for(var i in forms){
                var subForm = forms[i];
                subForm.submit();
            }
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "Please fill all required fields",
                "type": "error"
            });
            toastEvent.fire();
        }
        
        /*
        var show2Initials = component.get("v.show2Initials");
        var flag = true;
        for(var i in  component.find("allFieldId")){
            var eachField = component.find("allFieldId")[i];
            if(eachField.get("v.fieldName") == 'Witness_1_initials__c' || eachField.get("v.fieldName") == 'Witness_1_surname__c'){
                if(eachField.get("v.value") == '' || eachField.get("v.value") == undefined || eachField.get("v.value") == null){
                    flag = false;
                }
            }
            if(eachField.get("v.fieldName") == 'Witness_2_initials__c' || eachField.get("v.fieldName") == 'Witness_2_surname__c'){
                if(show2Initials && (eachField.get("v.value") == '' || eachField.get("v.value") == undefined || eachField.get("v.value") == null)){
                    flag = false;
                }
            }
        }
        if(flag){
            component.find('applicationRecForm').submit();
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "Please fill all required fields",
                "type": "error"
            });
            toastEvent.fire();
            
        }*/
    },
    handleSuccessApp: function(component, event) {
        var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
        console.log('onsuccess: ', updatedRecord);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams ({
            "title": "Success!",
            "message": "Sign document has submitted.",
            "type": "success"
        });
        toastEvent.fire();
        for(var i in  component.find("allFieldId")){
            var eachField = component.find("allFieldId")[i];
            eachField.set("v.value",null);
        }
        var applicationRecordArray = [];
        var appRec = {
            rowNumber : '1',
            firstName : "",
            sirName :"",
            idNumber:"",
            email:"",
            phone:"",
            capacity:"",
            selectedAcc:null,
            initial1:"",
            surname1:"",
            initial2:"",
            surname2:""               
        };
        applicationRecordArray.push(appRec);
        component.set("v.applicationRecordArray",applicationRecordArray);
        /*component.find("lastName").set("v.value",null);
        component.find("idNuber").set("v.value",null);
        component.find("emailId").set("v.value",null);
        component.find("phoneNumber").set("v.value",null);
        component.set("v.selectedFirstName",'');*/
        
    },
    
    //Tdb - Show or Hide Signatories based on Document Type 
    setDocumentTemplate: function(component, event, helper) {    
        helper.getSelectDocumentTemplateRecord(component, event, helper);        
    },
    
    setSelectedSignatoreRequests : function(component, event, helper) {
        
        var eventAccountValue= event.getParam("signatureRequests");
        console.log('DocumentManagement - signatureRequests ; ' + eventAccountValue);
        component.set("v.signatureRequestRecords",eventAccountValue);
        
    },
    
    submit : function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        helper.getAppDetails(component, event, helper);
    },
    
    showSiteVisit: function(component, event, helper) {
        var sitevisit = component.find("StandardAbsasitevisitforyou").get("v.value");
        console.log(sitevisit);
        if (sitevisit == "YES" ){
            component.set("v.showsitevisit", true);
        }   
        else{
            component.set("v.showsitevisit", false);
        }
    },  
    showTelephonicEngagement: function (component, event, helper) {
		var tel_engagement = component.get("v.showTelephonicEngagementBlock");
		console.log("Tel Engagement :" + tel_engagement);
		if (tel_engagement) {
			component.set("v.showTelephonicEngagementBlock", false);
		} else {
			component.set("v.showTelephonicEngagementBlock", true);
		}
	},
// Added by Yongama Dayeni
        submitIndemnityDetails : function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        helper.getIndemnityDetails(component, event, helper);
    },
	showIdentificationOfGrantor: function (component, event, helper) {
		var powerOfAttorneyVal = component.find("StandardAbsapowerofattorneyforyou").get("v.value");
		console.log("powerOfAttorneyVal :" + powerOfAttorneyVal);
		if (powerOfAttorneyVal == "YES") {
			component.set("v.showIdentificationOfGrantorField", true);
		} else {
			component.set("v.showIdentificationOfGrantorField", false);
		}
	},
	submitSiteVisitDetails : function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        helper.getsitevisitDetails(component, event, helper);
     },
     
    
    showResolution: function(component, event, helper) {
        var resoultion = component.find("StandardAbsaresolutionforyou").get("v.value");
        console.log(resoultion);
        if (resoultion == "YES" ){
            component.set("v.showResolution", true);
        }   
        else{
            component.set("v.showResolution", false);
        }
    },  
    
    submitResolutionDetails : function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
        helper.getResolutionDetails(component, event, helper);
    },
    showIndemnity: function(component, event, helper) {
        var mandate = component.find("Absamandateandindemnity").get("v.value");
        if (mandate == "YES" ){
            component.set("v.showIndemnity", true);
        }   
        else{
            component.set("v.showIndemnity", false);
        }
    },
    mediumChosen : function(component, event, helper)
    {
        var mediumChosen = component.get("v.mediumChosen") 
        if(mediumChosen == 'E'){
            component.set("v.mediumChosen", 'E');
            component.set("v.isEmailChosen", true);
        }
        
        else if (mediumChosen == 'SE'){
            component.set("v.mediumChosen", 'SE');
            component.set("v.isScanAndEmail", true);
        }
         else  if(mediumChosen == 'F'){
            component.set("v.mediumChosen", 'F');
            component.set("v.isFasimileChosen", true);
        }
         else  if(mediumChosen == 'T'){
            component.set("v.mediumChosen", 'T');
            component.set("v.isTelephone", true);
        }
        
        else{
            component.set("v.adviseGiven", 'N');
            component.set("v.isAdviceGiven", true);
        }
    },
    UpdateSelectedRows: function (component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        var selectedValue = selectedRows[0].Id;
        var selectedSignatory = selectedRows[0].Name;
        var emailMap = component.get("v.emailMap");
        var mobileMap = component.get("v.mobileMap");
        console.log('the list is selectedValue a butted ' + selectedValue + ' keys ' + emailMap.keys());
        console.log('Selected person is :'+selectedSignatory);
        component.set('v.selectedSignatoryName',selectedSignatory);
        component.set('v.selectedRecordRelationshipId',selectedValue);

        if (emailMap.get(selectedValue) != null && emailMap.get(selectedValue) != ""
           && mobileMap.get(selectedValue) != null && mobileMap.get(selectedValue) != "") {
            component.set('v.isButtonActive',false);
            if (selectedValue != component.find('authorisedSignatory').get('v.value')) {
                //component.find('authorisedSignatory').set('v.value', selectedValue);
                component.set('v.selectedSignatoryName',selectedSignatory);
                component.set('v.selectedRecordRelationshipId',selectedValue);
            }
        } else {
            component.set('v.isButtonActive',false);//testing false
        }

    },
	showAnnualCreditLimitIncrease: function (component) {
		var debtCounselling = component.find("AnnualCreditLimitIncreaseForYou").get("v.value");
		console.log(debtCounselling);
		if (debtCounselling == "YES") {
			component.set("v.showAnnualCreditLimitIncrease", true);
		} else {
			component.set("v.showAnnualCreditLimitIncrease", false);
		}
	},
	onloadAnnualCreditLimitIncrease: function (component, event, helper) {},
	handleAnnualCreditLimitIncreaseSuccess: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			type: "success",
			message: "Annual Credit Limit Increases details Saved Successfully!"
		});
		toastEvent.fire();
	},

	handleAnnualCreditLimitIncreaseError: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Error!",
			type: "error",
			message: "Annual Credit Limit Increases details Save failed!"
		});
		toastEvent.fire();
	},

	showDebtCounselling: function (component) {
		var debtCounselling = component.find("debtCounsellingforyou").get("v.value");
		console.log(debtCounselling);
		if (debtCounselling == "YES") {
			component.set("v.showDebtCounselling", true);
		} else {
			component.set("v.showDebtCounselling", false);
		}
	},
	onloadDebtCounselling: function (component, event, helper) {},
	handleDebtCounsellingSuccess: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			type: "success",
			message: "Debt Counselling details Saved Successfully!"
		});
		toastEvent.fire();
	},

	handleDebtCounsellingError: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Error!",
			type: "error",
			message: "Debt Counselling details Save failed!"
		});
		toastEvent.fire();
	},

	showUSPersons: function (component) {
		var usPersons = component.find("USPersonsInfoforyou").get("v.value");
		console.log(usPersons);
		if (usPersons == "YES") {
			component.set("v.showUSPersons", true);
		} else {
			component.set("v.showUSPersons", false);
		}
	},

	onloadUSPersons: function (component, event, helper) {
		var usOtherPersons = component.find("USPerson").get("v.value");
		console.log(usOtherPersons);
		if (usOtherPersons == true) {
			component.set("v.showOtherUSPersons", true);
		} else {
			component.set("v.showOtherUSPersons", false);
		}
	},

	showOtherUSPersons: function (component) {
		var usOtherPersons = component.find("USPerson").get("v.value");
		console.log(usOtherPersons);
		if (usOtherPersons == true) {
			component.set("v.showOtherUSPersons", true);
		} else {
			component.set("v.showOtherUSPersons", false);
		}
	},

	handleUSPersonsSuccess: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			type: "success",
			message: "US Persons details Saved Successfully!"
		});
		toastEvent.fire();
	},

	handleUSPersonsError: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Error!",
			type: "error",
			message: "US Persons details Save failed!"
		});
		toastEvent.fire();
	}
});