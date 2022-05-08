({
    doInit: function(component, event, helper) {
       
        console.log('processType : ' + component.get("v.processType"));
        console.log('processType : ' + component.get("v.processType"));
        console.log('parentId : ' + component.get("v.parentId"));
        
        component.set("v.showRecordEditForm", true);
        
                var selectedAccountRecordId =component.get("v.selectedAccountRecordId");
        if(selectedAccountRecordId!=null){
            component.set("v.accrecordId",selectedAccountRecordId);
            component.set("v.showAccRecordId",true);   //  
            // this.openLimitedAccDetailsModal(component);
            component.find("clientType").set("v.disabled", true); 
            component.find("clientGroup").set("v.disabled", true); 
 
          var entityType = component.get("v.clienttype");
          if(entityType=='Private Company' || entityType=='Close Corporation'){

            component.set("v.accountRecord.Registration_Number__c",  component.find("regNumberC").get("v.value"));
            component.set("v.showLimitedAccountInfoModal",true);
            component.set("v.hideGoldenSourceForm",false);
            component.set("v.showRecordEditForm", true);
            component.set("v.showConsent",false);
          }
            
            var tradingasname = component.find('tradingAsNameComp');
            if(tradingasname != undefined){
                tradingasname.getAccountId(component.get('v.accrecordId'));
            }
            
            //To call Address component
            var addresscomp = component.find('addressComp');
            if(addresscomp != undefined){
                addresscomp.getAccountId(component.get('v.accrecordId'));
                addresscomp.getAccountClientType(component.get('v.accrecordId.Client_Type__c'));
            }
            
        }

        
        //Account records
        var accId = component.get("v.accountRecordId");
        if(!accId) {
            helper.populateBusinessProspectRecordTypeId(component);
        } else {
            component.set("v.showRecordEditForm", true);
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
        }
        
        //handle consent checkbox
        var entityType = component.get("v.clienttype");
        if(entityType=='Private Company' || entityType=='Close Corporation'){
            component.set("v.disableConsentCheckbox", false);
        } else{
            component.set("v.disableConsentCheckbox", true);
        }
        
        //To get FinServ_Role id 
        var finserverole=$A.get("$Label.c.FinServ_Role");
        if(finserverole!=null && finserverole!=''){
            component.set("v.finserverole",finserverole);
        }
        
    },
    
    selectRole:function(component, event, helper) {
        
        var selectedRole=component.find("roles").get("v.value");
        if(selectedRole.includes("Shareholder/Controller") || selectedRole.includes("Members/Controllers") ||
          selectedRole.includes("Named Beneficiaries") || selectedRole.includes("Trustees") || selectedRole.includes("Partner/Controller")){
            if(component.find("shareholdingpercentage") != undefined){
                component.find("shareholdingpercentage").set("v.disabled", false);
            }
            if(component.find("dateMonthsShareholding") != undefined){
                component.find("dateMonthsShareholding").set("v.disabled", false);
            }
        }
        else{
            if(component.find("shareholdingpercentage") != undefined){
                component.find("shareholdingpercentage").set("v.value", "");
                component.find("shareholdingpercentage").set("v.disabled", true);
            }
            if(component.find("dateMonthsShareholding") != undefined){
                component.find("dateMonthsShareholding").set("v.value", "");
                component.find("dateMonthsShareholding").set("v.disabled", true); 
            }
        }
    },  
    
    handleCancel : function(component, event, helper) {
        component.set("v.showRecordEditForm",false);
        component.find("popuplib").notifyClose();
        
    },
    
      handleOnAcctSubmit :function(component, event, helper) {
        event.preventDefault();            
        var showValidationError = false;
        var vaildationFailReason = '';
        console.log('going inside handleOnAcctSubmit');    
        
        var entityType = component.get("v.clienttype");
        if(entityType == 'Trusts'){
            var trustnumber=component.find("trustnumber").get("v.value");
            var trustNumberNewformat=component.find("trustNumberNewformat").get("v.value");
            console.log('value of trust'+trustNumberNewformat + trustnumber);    
            if( !trustNumberNewformat && !trustnumber ){ 
                console.log('value of trust'+trustNumberNewformat + trustnumber);    
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Atleast Trust Number New Format has to be filled.",
                    "type":"error"
                });
                
                toastEvent.fire(); 
                return null;    
            }
        }
        
        if (!showValidationError ) {  
            component.find("editForm").submit();
        }else {
            component.find('acctacctError').setError(vaildationFailReason);
        }        
        
    },
    
    
    
    closeExperianModal : function(component, event, helper){
        component.set("v.isExperianModalOpen",false);
    },
    
    closeRecordEditModal : function(component, event, helper){
        component.set("v.showRecordEditForm",false);
    },
    
    //Button method to create Business Prospect Account
    proceedExperian : function(component, event, helper){
        helper.CreateBusinessAccount(component, event, helper);
    },
    
    
    populateDetails : function(component, event, helper){
        if(!$A.util.isEmpty(component.find("regNumberC").get("v.value"))){
            var cmpTarget = component.find('regNumberError');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
            
            var regNumber = component.find("regNumberC").get("v.value");
            var regNumberValue = regNumber.trim();
            
            var clientGrp = component.find("clientGroup1") != undefined ? component.find("clientGroup1").get("v.value") : '';
            component.set("v.clientGroup",clientGrp );
            component.set("v.clientType", component.find("idClientType2").get("v.value"));
            component.set("v.placeOfResidence", component.find("placeOfResidence").get("v.value"));
            var clientTyp = component.find("idClientType2").get("v.value");
            if(clientTyp != 'Private Company' && clientTyp != 'Close Corporation'){
                helper.showPrivateCompanyValidation(component, event, helper);
            } else{
                if(regNumberValue != null && (clientTyp =='Private Company' && regNumberValue.endsWith("07")) || (clientTyp =='Close Corporation' && regNumberValue.endsWith("23"))) {
                    
                    helper.callExperianService(component, event, helper);
                    
                    //$A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
                    component.set('v.columns',[
                        {label: 'Document Type', fieldName: 'documentType', type: 'text'},
                        {label: 'Required', fieldName: 'required', type: 'text'},
                        {label: 'Status', fieldName: 'status', type: 'text'},
                        {label: 'Version', fieldName: 'version', type: 'text'},
                        {label: 'Last Updated', fieldName: 'lastUpdated', type: 'text'},
                        {label: 'Updated By', fieldName: 'updatedBy', type: 'text'}
                    ]);
                    
                }
                else {
                    if(clientTyp =='Private Company'){
                        var toastEvent = helper.getToast("Onboarding Exception", "You are only allowed to Onboard Pty Ltd", "error");
                        toastEvent.fire();
                    }else{
                        var toastEvent = helper.getToast("Onboarding Exception", "You are only allowed to Onboard Close Corporations", "error");
                        toastEvent.fire();   
                    }
                }
            }
            
        } else {
            var cmpTarget = component.find('regNumberError');
            $A.util.addClass(cmpTarget, 'slds-has-error');
        }
    },
    
    
    //Toggle Populate button
    showPopulateDetailsButton : function(component, event, helper){
        if (component.find('agreed').get('v.checked')) {
            component.set("v.goldenSourceConsentGiven", false);
        }
        else {
            component.set("v.goldenSourceConsentGiven", true);
        }
    },
    
    //Handle manual capture functionality on from the Golden source.
    openLimitedAccDetailsModal : function(component, event, helper){
        component.set("v.accountRecord.Registration_Number__c",  component.find("regNumberC").get("v.value"));
        component.set("v.showLimitedAccountInfoModal",true);
        component.set("v.hideGoldenSourceForm",false);
        component.set("v.showRecordEditForm", true);
        component.set("v.showConsent",false);
        
        
    },
    
    //handle the consent checkbox on the golden source screen.
    handleConsent: function (component, event, helper) {
        var entityType = event.getSource().get('v.value');
        if(entityType=='Private Company' || entityType=='Close Corporation'){
            component.set("v.disableConsentCheckbox", false);
        } else{
            component.set("v.disableConsentCheckbox", true);
        }
    },
    
    //Button method to create Business Prospect Account
    proceedExperian : function(component, event, helper){
        component.set("v.isExperianModalOpen",false);  
    },
    
    setClientTypeValue: function(component, event, helper) {
        
        component.set('v.clientType', component.find('clientType').get('v.value'));
    },
    
    handleOnSuccess : function(component, event, helper) {
        var params = event.getParams(); //get event params
     
        var selectedAccountRecordId =component.get("v.selectedAccountRecordId");
        if(selectedAccountRecordId!=null){
            component.set("v.accrecordId",selectedAccountRecordId);
            component.set("v.showAccRecordId",true);    
        }
        else{
            var recordId = params.response.id; //get record id
            component.set("v.accrecordId",recordId);
            component.set("v.showAccRecordId",true);
            console.log(params+' : '+recordId+' : ');
        }
        
        if(component.find("shareholdingpercentage") != undefined){
            component.find("shareholdingpercentage").set("v.disabled", true); 
        }
        if(component.find("dateMonthsShareholding") != undefined){
            component.find("dateMonthsShareholding").set("v.disabled", true);
        }
        //To call Address component
        var tradingasname = component.find('tradingAsNameComp');
        if(tradingasname != undefined){
            tradingasname.getAccountId(component.get('v.accrecordId'));
        }
        
        //To call Address component
        var addresscomp = component.find('addressComp');
        if(addresscomp != undefined){
            addresscomp.getAccountId(component.get('v.accrecordId'));
            //alert(component.get("v.clienttype")+' == '+component.get('v.accrecordId.Client_Type__c'));
            //addresscomp.getAccountClientType(component.get('v.accrecordId.Client_Type__c'));
            addresscomp.getAccountClientType(component.get("v.clienttype"));
        }
        
        
    },
    
    handleOnError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error",
            "message": "Something went wrong Please contact Administrator."
        });
        toastEvent.fire();
    },
    
    handleOnSubmit : function(component, event, helper) {
        console.log('coming here in handleonsubmit');
        var showValidationError = false;
        var vaildationFailReason = '';
        
        var selectedRole=component.find("roles").get("v.value");
        var shareholdingpercentage=component.find("shareholdingpercentage").get("v.value");
        //var dateMonthsShareholdingField = component.find("dateMonthsShareholding");
        //var sicCodeField = component.find("iSicCode");
        
        
        if( $A.util.isEmpty(selectedRole)){
            showValidationError = true;
            vaildationFailReason = "Roles has to be selected";
        }else if ((selectedRole.includes("Shareholder/Controller") || selectedRole.includes("Members/Controllers") || selectedRole.includes("Partner/Controller")) && 
                  (shareholdingpercentage==null ||shareholdingpercentage=='') ) { 
            showValidationError = true;
            vaildationFailReason = "Shareholding Percentage fields needs to be completed!";
        }
        
       /* if(dateMonthsShareholdingField != null) {
            var dateMonthsShareholdingValue = component.find("dateMonthsShareholding").get("v.value"); 
            if(dateMonthsShareholdingValue == null || dateMonthsShareholdingValue == '' || dateMonthsShareholdingValue == undefined) {
                showValidationError = true;
                vaildationFailReason = "Shareholding Percentage fields needs to be completed!";
            }
        }
        
        if(sicCodeField != null) {
            var sicCodeValue = component.find("iSicCode").get("v.value"); 
            if(sicCodeValue == null || sicCodeValue == '' || sicCodeValue == undefined) {
                showValidationError = true;
                vaildationFailReason = "Sic Code is required";
            }
        }*/

        if (!showValidationError ) {  
            
            //Added by chandra against W-004945 dated 16/07/2020
            helper.calculateControllingPercentageAccAccRel(component, event, helper);
            
        } else {
            component.find('acctacctError').setError(vaildationFailReason);
        }
        
        
        
        //  component.find("popuplib").notifyClose();
    },
    
    //TdB - W-004831 - Regulary Subsection for Q4
    regulatoryQ4SubSection: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ4SubSection", true); 
        }else{    
            component.set("v.showRegulatoryQ4SubSection", false); 
        }
    },
    //TdB - W-004831 - Regulary Subsection for Q4d
    regulatoryQ4SubSection2: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ4SubSection2", true); 
        }else{    
            component.set("v.showRegulatoryQ4SubSection2", false); 
        }
    },
    
})