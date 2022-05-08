({
    hideChildCmp: function (component, event) {
        //hide all the components here
        var div1 = component.find("div1");
        $A.util.addClass(div1, "slds-hide");
        var div2 = component.find("div2");
        $A.util.addClass(div2, "slds-hide");
        var div3 = component.find("div3");
        $A.util.addClass(div3, "slds-hide");
        var div4 = component.find("div4");
        $A.util.addClass(div4, "slds-hide");
        var div5 = component.find("div5");
        $A.util.addClass(div5, "slds-hide");
        var div6 = component.find("div6");
        $A.util.addClass(div6, "slds-hide");
        var div7 = component.find("div7");
        $A.util.addClass(div7, "slds-hide");
        var div8 = component.find("div8");
        $A.util.addClass(div8, "slds-hide");
        var div9 = component.find("div9");
        $A.util.addClass(div9, "slds-hide");
        var div10 = component.find("div10");
        $A.util.addClass(div10, "slds-hide");
        var div11 = component.find("div11");
        $A.util.addClass(div11, "slds-hide");
        var div12 = component.find("div12");
        $A.util.addClass(div12, "slds-hide");
        var div12 = component.find("pricingAndFees");
        $A.util.addClass(div12, "slds-hide");
        var securityExisting = component.find("securityExisting");
        $A.util.addClass(securityExisting, "slds-hide");
        var aips = component.find("aips");
        $A.util.addClass(aips, "slds-hide");
        var creditCard = component.find("creditCard");
        $A.util.addClass(creditCard, "slds-hide");
        var commercialBureau = component.find("commercialBureau");
        $A.util.addClass(commercialBureau, "slds-hide");
        var consumerBureau = component.find("consumerBureau");
        $A.util.addClass(consumerBureau, "slds-hide");
        var div12 = component.find("termsofBusiness");
        $A.util.addClass(div12, "slds-hide");
    },

    loadPriorApplication: function (component, event, helper) {
        //var oppId 	= component.get("v.recordId");
        //editApplication : function(cmp, event, helper, recId);
    },

    fetchApplications: function (component, event, helper) {
        console.log("Init")
        var actions = helper.getRowActions.bind(this, component);
        var oppId = component.get("v.recordId");
            /*var actions = [
            { label: "Edit", name: "edit" },
            { label: "Duplicate", name: "duplicate" },
            { label: "Delete", name: "delete" }
            ];*/
            
        if(oppId.startsWith('006')){
            component.set("v.columns", [
                    { label: 'View/ Edit', type:  'button',typeAttributes: {  iconName: 'utility:edit',  label: 'View/Edit',   name: 'edit',   title: 'editTitle',   disabled: false,   value: 'test'}},
                    { label: "Application Number", fieldName: "Application_number__c", type: "text" },
                    //{ label: 'Application Number', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Application_number__c' }, target: '_blank'}},
                    { label: "Case", fieldName: "Case_Number__c", type: "text" },
                    { label: "Article Desciption", fieldName: "Article_Description__c", type: "text" },
                    { label: "Financed Amount", fieldName: "Financed_Amount__c", type: "text" },
                    { label: "Extras", fieldName: "Extras_Quantity__c", type: "text" },
                    { label: "VAPs", fieldName: "VAPs_Quantity__c", type: "text" },
                    { type: "action", typeAttributes: { rowActions: actions } }
            ]);
        }
        
        else{
         component.set("v.columns", [
               { label: "Application Number", fieldName: "Application_number__c", type: "text" },
                    //{ label: 'Application Number', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Application_number__c' }, target: '_blank'}},
                    { label: "Case", fieldName: "Case_Number__c", type: "text" },
                    { label: "Article Desciption", fieldName: "Article_Description__c", type: "text" },
                    { label: "Financed Amount", fieldName: "Financed_Amount__c", type: "text" },
                    { label: "Extras", fieldName: "Extras_Quantity__c", type: "text" },
                    { label: "VAPs", fieldName: "VAPs_Quantity__c", type: "text" }
            ]);    
            
            
        }
        component.set("v.showSpinner", true);
        
      //  var oppId = component.get("v.recordId");
        console.log("oppId  vertical tabs"+oppId);
        console.log("before appId "+component.get("v.appId"));
        console.log("before recId "+component.get("v.recId"));
        var action = component.get("c.getApplications");
        action.setParams({
            oppId: oppId
        });

        action.setCallback(this, function (response) {
            //debugger;
            var state = response.getState();
            var appls = response.getReturnValue();
         console.log("appls "+appls);
            if (state === "SUCCESS") {

                //create link here
                /*appls.forEach (function(record){
                    record.linkName = '/'+record.Application_Product_CAF__c;
                    record.CheckBool = false;
                });*/

                if (appls.length > 0) {
                    console.log("lastId "+appls.length);
                    component.set("v.extraslength", appls.length);
                    component.set("v.dataList", appls);
                    component.set("v.showAppList", true);
                    var len = appls.length - 1;
                    
                    console.log("fetchApplications Application_number__c "+appls[len].Application_number__c);
                     console.log("fetchApplications lastId "+appls[len].Application_Product_CAF__c);
                    var lastId = appls[len].Application_Product_CAF__c;
                    var recId = appls[len].Id;
                    component.set("v.appId", lastId);
                    component.set("v.recId", recId);
                    component.set("v.oppOwnerId",  appls[len].Opportunity.OwnerId);
                    if(appls[len].Opportunity.QA_Approver__c !== undefined){
                     component.set("v.oppApprover",  appls[len].Opportunity.QA_Approver__r.Id);   
                    }else{
                        component.set("v.oppApprover", null);
                    }
                    //component.set("v.oppApprover",  appls[len].Opportunity.QA_Approver__r.Id);
                    if(appls[len].Application_Product_CAF__r.Case__c != undefined){
                        component.set("v.caseOwner", appls[len].Application_Product_CAF__r.Case__r.OwnerId);}
                    console.log("fetchApplications appId "+component.get("v.appId"));
                    console.log("fetchApplications recId "+component.get("v.recId"));
                    console.log("fetchApplications oppOwnerId "+component.get("v.oppOwnerId"));
                    console.log("fetchApplications oppApprover "+component.get("v.oppApprover"));
                    console.log("fetchApplications caseOwner "+component.get("v.caseOwner"));
                    
                    component.set("v.extrasQty", appls[len].Extras_Quantity__c);
                    component.set("v.vapsQty", appls[len].VAPs_Quantity__c);
                    this.fetchApplicationToView(component, event, helper, lastId);
                    this.setIsEditable(component, event, helper);
                    
                } else {
                    console.log("fetchApplications else "+appls.length);
                    component.set("v.columns", []);
                    component.set("v.dataList", appls);
                }
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                this.errorMsg(component, "Something went wrong!");
            }

            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },   
    getRowActions: function(component, row, cb) {
        var actions = [];        
        actions.push(
            //{ label: "Edit", name: "edit" },
            { label: "Duplicate", name: "duplicate", disabled: row.Case_Number__c != null }
            //{ label: "Delete", name: "delete" }
        );
        cb(actions);        
    },
    updateApplicationsTable: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        console.log("updateApplicationsTable oppId "+oppId);
        var action = component.get("c.getApplications");
        action.setParams({
            oppId: oppId
        });

        action.setCallback(this, function (response) {
            //debugger;
            var state = response.getState();
            var appls = response.getReturnValue();
           console.log("updateApplicationsTable appls "+appls);
           console.log("updateApplicationsTable appls length "+appls.length);
            if (state === "SUCCESS") {
                if (appls.length > 0) {
                
                    var actions = helper.getRowActions.bind(this, component);
                    /*var actions = [
                        { label: "Edit", name: "edit" },
                        { label: "Duplicate", name: "duplicate" },
                        { label: "Delete", name: "delete" }
                    ];*/

                    component.set("v.columns", [
                        { label: 'View/ Edit', type:  'button',typeAttributes: {  iconName: 'utility:edit', label: 'View/Edit', name: 'edit', title: 'editTitle', disabled: false, value: 'test'}},
                        { label: "Application Number", fieldName: "Application_number__c", type: "text" },
                        { label: "Case", fieldName: "Case_Number__c", type: "text" },
                        { label: "Article Desciption", fieldName: "Article_Description__c", type: "text" },
                        { label: "Financed Amount", fieldName: "Financed_Amount__c", type: "text" },
                        { label: "Extras", fieldName: "Extras_Quantity__c", type: "text" },
                        { label: "VAPs", fieldName: "VAPs_Quantity__c", type: "text" },
                        { type: "action", typeAttributes: { rowActions: actions } }
                    ]);
                    console.log("updateApplicationsTable appls if "+appls);
                    component.set("v.extraslength", appls.length);
                    component.set("v.dataList", appls);
                    component.set("v.showAppList", true);
                    //var len = appls.length - 1;
                    //var lastId = appls[len].Application_Product_CAF__c;
                    //var recId = appls[len].Id;
                    //component.set("v.appId",lastId);
                    //component.set("v.recId",recId);
                    //this.editApplication(component, event, helper, lastId);
                    //$A.get('e.force:refreshView').fire();
                    //component.set("v.extrasQty",appls[len].Extras_Quantity__c);
                    //component.set("v.vapsQty",appls[len].VAPs_Quantity__c);
                } else {
                     console.log("updateApplicationsTable appls else "+appls);
                    component.set("v.columns", []);
                    component.set("v.dataList", appls);
                }
            } else {
                this.errorMsg(component, "Something went wrong!");
            }

            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    editApplication: function (cmp, event, helper, recId) {
        cmp.set("v.showSpinner", true);
        var action = cmp.get("c.getApplicationToEdit");
        action.setParams({
            recId: recId
        });

        action.setCallback(this, function (response) {
            //$A.get('e.force:refreshView').fire();
            var state = response.getState();
            var application = response.getReturnValue();
            console.log("ApplVal: " + JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
                var recId = application.Id;
                var appId = application.Application_Product_CAF__c;

                //check if there is a case number for selected application
                if (application.Case_Number__c != undefined){
                    cmp.set("v.caseNoExist", false);
                }
                else{
                    cmp.set("v.caseNoExist", true);
                    cmp.set("v.isReqConFromSSCBtnDisabled",true);
                }

                cmp.set("v.recId", recId);
                cmp.set("v.appId", appId);
                this.fetchApplicationToView(cmp, event, helper, appId);
            }
            cmp.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    fetchApplicationToView: function (component, event, helper, appId) {
        var action = component.get("c.getApplicationToView");
        action.setParams({
            appId: appId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var applicationData = response.getReturnValue();
            if (state === "SUCCESS") {
                component.set("v.applicationData", applicationData);
            }
        });
        $A.enqueueAction(action);
    },
    fetchAccAndOpp: function (component, event, helper) {
        
        var oppId ;
        var pageRecordId = component.get("v.recordId");
        console.log("pageRecordId in fetchAccandOpp"+pageRecordId);
        console.log("oppId in fetchAccandOpp"+component.get("v.oppId"));
        if(pageRecordId.startsWith("006")){
            console.log("in fetchAccandOpp if");
        oppId = component.get("v.recordId"); }
        else{
            console.log("in fetchAccandOpp else");
        oppId = component.get("v.oppId");     
        }
        
        //var oppId 	= component.get("v.recordId");
        var action 	= component.get("c.getAccAndOpp");
        action.setParams({
            oppId: oppId
        });

        action.setCallback(this, function (response) {
            //debugger;
            var CompanyTurnoverInteval 	= '';
            var state = response.getState();
            var accAndOppData = response.getReturnValue();
            if (state === "SUCCESS") {
                
                var results = JSON.parse(accAndOppData);
                var expected_turnover = results.annualTurnover;
                if (expected_turnover >= 0 && expected_turnover <= 10000000) {
                    CompanyTurnoverInteval = '0 - 10 000 000';
                } else if (expected_turnover >= 10000001 && expected_turnover <= 40000000) {
                    CompanyTurnoverInteval = '10 000 000 - 40 000 000';
                } else if (expected_turnover >= 40000001 && expected_turnover <= 100000000) {
                    CompanyTurnoverInteval = '40 000 001 - 100 000 000';
                } else {
                    CompanyTurnoverInteval = '100 000 000';
                }
                component.set("v.companyTurnoverCategory",CompanyTurnoverInteval);
            }else{
                console.log('ERROR 321');
            }
            //cmp.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },

    /*handleSelectOption: function (component, event, helper){

        var selectedRows = event.getParam('selectedRows'); 
        var setRows = [];
            for ( var i = 0; i < selectedRows.length; i++ ) {
                setRows.push(selectedRows[i]);
            }
            for ( var i = 0; i < setRows.length; i++ ) {
             
                alert(setRows[i].Application_Product_CAF__c);
                setRows[i].CheckBool = false;    
            }
    },*/

    successMsg: function (component, msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "success",
            title: "Success!",
            message: msg
        });
        toastEvent.fire();
    },

    errorMsg: function (msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "error",
            title: "Error!",
            message: msg
        });
        toastEvent.fire();
    },
    
    helperToggleClass: function (component, event, helper) {
        helper.hideChildCmp(component, event); // Hide all components and show only selected child component
        var selectedvalue = component.get("v.selectedItem");
        console.log("value is" + selectedvalue);
        if (selectedvalue == "TabOne") {
            var divChild = component.find("div1");
            $A.util.removeClass(divChild, "slds-hide");
        } else if (selectedvalue == "creditCard") {
            var divChild = component.find("creditCard");
            $A.util.removeClass(divChild, "slds-hide");
        } else {
            //  block of code to be executed if the condition1 is false and condition2 is false
        }
    },
    
     setIsEditable: function (component, event, helper) {
         var pageRecordId = component.get("v.recordId");
         var currentUser = $A.get("$SObjectType.CurrentUser.Id");
         var oppOwnerId = component.get("v.oppOwnerId");
         var oppApprover = component.get("v.oppApprover");
         var caseOwner = component.get("v.caseOwner");
         console.log("setIsEditable pageRecordId "+pageRecordId);
          console.log("setIsEditable currentUser "+currentUser);
         console.log("setIsEditable oppOwnerId "+component.get("v.oppOwnerId"));
         console.log("setIsEditable oppApprover "+component.get("v.oppApprover"));
         console.log("setIsEditable caseOwner "+component.get("v.caseOwner"));
         
        if(pageRecordId.startsWith('006')){
             console.log("setIsEditable In starts with 006 ");
            if(currentUser != oppOwnerId && currentUser != oppApprover ){
                console.log("currentUser != oppOwnerId || currentUser != oppApprover");
            component.set("v.isEditable", true);
            component.set("v.isEditableHasRun", true);
            
            }
            else{
                
             component.set("v.isEditableHasRun", true);   
            }
        }else if(pageRecordId.startsWith('500')){
            console.log("setIsEditable In starts with 500 ");
         if(currentUser != caseOwner){
            console.log("currentUser != caseOwner");  
            component.set("v.isEditable", true);
             component.set("v.isEditableHasRun", true);
         } 
          else{
                
                 component.set("v.isEditableHasRun", true);
            }
        } else {
            component.set("v.isEditableHasRun", true);
            //  block of code to be executed if the condition1 is false and condition2 is false
        }
          console.log("setIsEditable isEditable "+component.get("v.isEditable"));
         console.log("setIsEditable isEditableHasRun "+component.get("v.isEditableHasRun"));
         //$A.get('e.force:refreshView').fire();
    },
});