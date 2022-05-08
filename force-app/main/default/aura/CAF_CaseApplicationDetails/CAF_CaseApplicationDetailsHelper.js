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
	fetchApplications : function(component, event, helper) {
       
        component.set("v.showSpinner",true);
        var oppId 	= component.get("v.oppId");
        var action 	= component.get("c.getApplications");
        action.setParams({
            "oppId":oppId
        });
        
        action.setCallback(this, function (response) {
          //debugger;
            var state 	= response.getState();
            var appls 	= response.getReturnValue();
           
            if (state === "SUCCESS") {
                
                if(appls.length > 0){
                    var actions = [
                        { label: 'Edit', name: 'edit' },
                        { label: 'Duplicate', name: 'duplicate' },
                        { label: 'Delete', name: 'delete' } ];
                    
                    component.set('v.columns', [
                        {label: 'Application Id', fieldName: 'Id', type: 'text'},
                        {label: 'Article Desciption', fieldName: 'Article_Description__c', type: 'text'},
                        {label: 'Financed Amount', fieldName: 'Financed_Amount__c', type: 'text'},
                        {label: 'Extras', fieldName: 'Extras_Quantity__c', type: 'text'},
                        {label: 'VAPs', fieldName: 'VAPs_Quantity__c', type: 'text'},
                        { type: 'action', typeAttributes: { rowActions: actions } } 
                    ]);
                    
                    component.set('v.extraslength', appls.length);
                    component.set('v.dataList', appls);
                    component.set('v.showAppList', true);
                    var len = appls.length - 1;
                    var lastId = appls[len].Application_Product_CAF__c;
                    var recId = appls[len].Id;
                    //component.set("v.appId",lastId);
                    //component.set("v.recId",recId);
                    //this.editApplication(component, event, helper, lastId);
                    //$A.get('e.force:refreshView').fire();
                    component.set("v.extrasQty",appls[len].Extras_Quantity__c);
                    component.set("v.vapsQty",appls[len].VAPs_Quantity__c);
                    this.fetchApplicationToView(component, event, helper, component.get("v.appId"));
                   
                   
                }else{
                    component.set('v.columns', []);
                    component.set('v.dataList', appls);
                }
           
            }else{
                this.errorMsg(component,'Something went wrong!');
            }
            
            component.set("v.showSpinner",false);
            
        });  
        $A.enqueueAction(action);
        
		
	},
   updateApplicationsTable : function(component, event, helper) {
       
        component.set("v.showSpinner",true);
        component.set("v.fieldsData",fields);
        var fields = event.getParams('recordUi').recordUi.record.fields;
        var oppId 	= component.get("v.oppId");
        var action 	= component.get("c.getApplications");
        action.setParams({
            "oppId":oppId
        });
        
        action.setCallback(this, function (response) {
          //debugger;
            var state 	= response.getState();
            var appls 	= response.getReturnValue();
           
            if (state === "SUCCESS") {
                
                if(appls.length > 0){
                    var actions = [
                        { label: 'Edit', name: 'edit' },
                        { label: 'Duplicate', name: 'duplicate' },
                        { label: 'Delete', name: 'delete' } ];
                    
                    component.set('v.columns', [
                        {label: 'Application Id', fieldName: 'Id', type: 'text'},
                        {label: 'Article Desciption', fieldName: 'Article_Description__c', type: 'text'},
                        {label: 'Financed Amount', fieldName: 'Financed_Amount__c', type: 'text'},
                        {label: 'Extras', fieldName: 'Extras_Quantity__c', type: 'text'},
                        {label: 'VAPs', fieldName: 'VAPs_Quantity__c', type: 'text'},
                        { type: 'action', typeAttributes: { rowActions: actions } } 
                    ]);
                    
                    component.set('v.extraslength', appls.length);
                    component.set('v.dataList', appls);
                    component.set('v.showAppList', true);
                    //var len = appls.length - 1;
                    //var lastId = appls[len].Application_Product_CAF__c;
                    //var recId = appls[len].Id;
                    //component.set("v.appId",lastId);
                    //component.set("v.recId",recId);
                    //this.editApplication(component, event, helper, lastId);
                    //$A.get('e.force:refreshView').fire();
                    //component.set("v.extrasQty",appls[len].Extras_Quantity__c);
                    //component.set("v.vapsQty",appls[len].VAPs_Quantity__c);
                }else{
                    component.set('v.columns', []);
                    component.set('v.dataList', appls);
                }
           
            }else{
                this.errorMsg(component,'Something went wrong!');
            }
            
            component.set("v.showSpinner",false);
            
        });  
        $A.enqueueAction(action);
        
		
	},
    editApplication : function(cmp, event, helper, recId){
        
       	cmp.set("v.showSpinner",true);
        var action = cmp.get("c.getApplicationToEdit");
        action.setParams({
            "recId":recId
        });
        
        action.setCallback(this, function (response) {
         	//$A.get('e.force:refreshView').fire();
            var state 		= response.getState();
            var application	= response.getReturnValue();
            console.log('ApplVal: '+JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
				               
                var recId = application.Id;
                var appId = application.Application_Product_CAF__c;
               // cmp.set("v.recId",recId);
               // cmp.set("v.appId",appId);
				this.fetchApplicationToView(cmp, event, helper,appId);
            } 
            cmp.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },
    fetchApplicationToView : function(component, event, helper,appId){
      console.log('appId '+appId);
        component.set("v.showSpinner",true);
       	var action 	= component.get("c.getApplicationToView");
        action.setParams({
            "appId":appId        
        });
        
        action.setCallback(this, function (response) {

            var state 			= response.getState();
            var applicationData	= response.getReturnValue();
            if (state === "SUCCESS") {
				component.set("v.applicationData",applicationData);
                console.log('applicationData '+ component.get("v.applicationData"));
                //this.callAuraMethod(component, event, helper);
            } 
            component.set("v.showSpinner",false);
            component.set("v.loadTable",true);
        });
        $A.enqueueAction(action);        
        
    },  
    
    
    
    successMsg : function(component, msg) {
     
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": msg
        });
        toastEvent.fire();		
    },
    errorMsg : function(msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": msg
    	});
    	toastEvent.fire();
	},
        
      loadApplicationDetails : function(component, event, helper){
        
       	component.set("v.showSpinner",true);
        var caseId = component.get("v.recordId");
         console.log('caseId: '+caseId); 
        var action = component.get("c.getApplicationId");
        action.setParams({
            "caseId":caseId
        });
        
        action.setCallback(this, function (response) {
         	//$A.get('e.force:refreshView').fire();
            var state 		= response.getState();
            var application	= response.getReturnValue();
            console.log('ApplVal: '+JSON.stringify(response.getReturnValue()));
            if (state === "SUCCESS") {
				               
                var recId = application.Id;
                var appId = application.Application_Product_CAF__c;
                var oppId = application.OpportunityId;
                component.set("v.recId",recId);
                component.set("v.appId",appId);
                component.set("v.oppId",oppId);
                console.log('recId: '+component.get("v.recId"));
                console.log('appId: '+component.get("v.appId"));
                console.log('oppId: '+component.get("v.oppId"));
                
			this.fetchApplications(component, event, helper);
            } 
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
          
    },
    
     callAuraMethod : function(component, event, helper) {
            var childCmp = component.find("AssetDetailsCAF");
            var retnMsg = childCmp.reInit();
     },
    
})