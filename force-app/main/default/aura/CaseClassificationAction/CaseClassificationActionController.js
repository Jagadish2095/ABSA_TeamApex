/**
* Type ahead functionallity and auto classification for Cases
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-06-14
*
**/
({
    doInit : function(component, event, helper) {

        //Smanga- Starts
        var serviceGroupLookupCondition = ' AND (NOT Name  LIKE \'IB -%\') AND Active__c=true AND Assign_Record_Type__c IN (\'Complaint\', \'Life Complaint\',\'ATM\',\'Short Term Complaint\')';
        component.set('v.serviceGroupLookupCondition', serviceGroupLookupCondition);
        //Smanga -End
        
        var action = component.get("c.getCaseInfo");
        
         action.setParams({
            "recId" : component.get("v.recordId"),
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var caseData =  response.getReturnValue();
                console.log('caseData:',caseData);
                component.set("v.caseRecordType", caseData[3]);
                component.set("v.serviceGroupName", caseData[4]);
                
                //Check to see if Original Service Group is CEO and set identifier (CEO should not route to diffrent queue)
                if(caseData[2] == 'True' && caseData[3] != 'NBFS Dispute Resolution') {
                    component.set("v.isClassifyServiceGroup", true);
                }else{
                    component.set("v.isClassifyServiceGroup", false);
                }
                
                component.set("v.serviceGroupId", caseData[1]);
                
                //Koketso - get all products associated with a case service group
                if(caseData[1] != null) {

                    var action = component.get("c.findProductsByServiceGroup");

                    action.setParams({
                        serviceGroupId : caseData[1]
                    });    

                    action.setCallback(this, function(response) {

                        var state = response.getState();  

                        if (state === "SUCCESS") {

                            var productOptions = response.getReturnValue();
                            console.log("productOptions:", productOptions);
                            
                            if(productOptions.length > 0){
                                component.set("v.productOptions", productOptions);
                                console.log("productOptions found:", productOptions[1]);
                            }
                        }            
                    });

                    $A.enqueueAction(action);
                }
                
                helper.hideSpinner(component);
            }
        });

        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    
	onUpdate : function(component, event, helper) {
    	
        helper.showSpinner(component);
        
        var action = component.get("c.updateCase");
        var serviceType = component.get("v.objTypes");
		var serviceGroupId = component.get("v.serviceGroupId");
        console.log('serviceType',serviceType);
        console.log('serviceGroupId',serviceGroupId);
        var subTypeSearch;
        var servicetype = '';
        var serviceSubType = '';
        var caseRecordTypeVal = component.get("v.caseRecordType");
        var isNBFSServiceGroup = component.get("v.isNBFSServiceGroup");
        var product;
        var subProduct;
        var classification;
        var subclassification = null;

        if(component.get("v.showSubClassification") == true){
            subclassification = component.find("subclassification").get("v.value");
        }
        
        if(caseRecordTypeVal == 'Complaint' || caseRecordTypeVal =='Life Complaint' || caseRecordTypeVal == 'ATM'){
            subTypeSearch = component.get("v.subTypeSearchGroupSearchId");//component.find("iSubTypeSearch").get("v.value");
            if(isNBFSServiceGroup){
                servicetype = component.find("iType").get("v.value");
        		serviceSubType = component.find("iSubType").get("v.value");
            }
        }
        // fetch the Type and sub type for NBFS Case record type
        else if(caseRecordTypeVal == 'NBFS Dispute Resolution'){
        	servicetype = component.find("iType").get("v.value");
        	serviceSubType = component.find("iSubType").get("v.value");
            
            //get the type and sub type for Short Term Complaint record type
        }else if(caseRecordTypeVal == 'Short Term Complaint'){
            servicetype = component.find("stype").get("v.value");
            serviceSubType = component.find("sSubType").get("v.value");
            product = component.find("sproduct").get("v.value");
            subProduct = component.find("ssubproduct").get("v.value");
            classification = component.find("sticlassification").get("v.value");
        }
        else{
            subTypeSearch ="Test"
        }
        
       
        action.setParams({
            "recId" : component.get("v.recordId"),
            "serviceTypeRec" : serviceType,
            "serviceGroupId" : serviceGroupId, 
            "servicetype" : servicetype,
            "serviceSubType" : serviceSubType,
            "subTypeSearch" : subTypeSearch,
            "product" : product,
            "subProduct" : subProduct,
            "classification" : classification,
            "subclassification" : subclassification
        });
      

        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        	var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {

                // show success notification
                var toastEvent = helper.getToast("Success!", "Case Updated", "Success");
   				toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
                
            }else if(state === "ERROR"){
                
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
       });

        if(serviceType || servicetype){
            // Added to make Service Sub Type mandatory only for NBFS Service Groups:
            if(!serviceSubType && (caseRecordTypeVal === 'NBFS Dispute Resolution' || isNBFSServiceGroup == true ||caseRecordTypeVal === 'Short Term Complaint')){
                var toastEvent = helper.getToast("Warning!", "You have to select a Service Sub Type if you want to classify this case", "warning");
                toastEvent.fire();
                helper.hideSpinner(component);
                //added for Short term insurance
            }else if(caseRecordTypeVal === 'Short Term Complaint' && !product){
                var toastEvent = helper.getToast("Warning!", "You have to select a Product Area if you want to classify this case", "warning");
                toastEvent.fire();
                helper.hideSpinner(component);
            }else if(caseRecordTypeVal === 'Short Term Complaint' && !subProduct){
                var toastEvent = helper.getToast("Warning!", "You have to select a Sub Product Area if you want to classify this case", "warning");
                toastEvent.fire();
                helper.hideSpinner(component);
            }else{
                // Send action off to be executed
                $A.enqueueAction(action);
            }
            
        }else{
            
            var toastEvent = helper.getToast("Warning!", "You have to select a Service Type if you want to classify this case", "warning");
            toastEvent.fire();
            
            helper.hideSpinner(component);
        }
        
        /**if(!subTypeSearch){
            var toastEvent = helper.getToast("Warning!", "You have to select a Service Type if you want to classify this case", "warning");
            toastEvent.fire();

            helper.hideSpinner(component);
        }*/
        
    },
    
    reLoad : function(component, event, helper) {
    	
        helper.showSpinner(component);

        var action = component.get("c.findRecord");
        //var serviceId = component.find("lookupSearch").get("v.value");
        
        var serviceId = component.get("v.serviceTypeId");
        console.log("###serviceId : "+ serviceId);
        var caseRecordTypeVal = component.get("v.caseRecordType");
        console.log("###caseRecordTypeVal : "+ caseRecordTypeVal);
        
        // Added for NBFS Case Record Type to fetch record based on Service Type Name
        var serviceName;
        if(caseRecordTypeVal =='Short Term Complaint'){
            serviceName =  component.find("stype").get("v.value");
        }else{
            serviceName = component.find("iType").get("v.value"); 
        }
        console.log('###serviceName: '+serviceName);

		var isNBFSServiceGroup = component.get("v.isNBFSServiceGroup");
       	console.log("###isNBFSServiceGroup : "+ isNBFSServiceGroup);
        
        //Smanga Start 9 Sept
        var caseType = component.get("v.caseRecordType");
        console.log("###caseType : "+ caseType);
        if(caseType =='Complaint' || caseType =='Life Complaint'  || caseType =='ATM'){
            var selectedServiceType = serviceId;//component.get("v.serviceTypeId");
        	var subTypeSearchLookupConditionVar = " AND Service_Type__c =" + " '"+ selectedServiceType + "' " ;
        	component.set('v.subTypeSearchLookupCondition', subTypeSearchLookupConditionVar);
        	var childCmp = component.find("customLookAuraId2");
        
        	childCmp.clearSelectionMethod(component, event, helper);
		}
        //Smanga -End
        
        
        action.setParams({
            "recId":serviceId,
            "recName":serviceName
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {

                component.set("v.objTypes", response.getReturnValue());
                console.log("Data returned from Apex : "+ component.get("v.objTypes"));// added by Mbuyiseni for testing purposes.
                var primary = component.find("iPrimary");
                var secondary = component.find("iSecond");
                var prod = component.find("iProduct");
                var classification = component.find("sticlassification");
                primary.set("v.value", component.get("v.objTypes.Type__c"));
                //Added for NBFS Case Record Type
                 if(caseRecordTypeVal == 'NBFS Dispute Resolution' || isNBFSServiceGroup == true ||caseRecordTypeVal =='Short Term Complaint'){
                	prod.set("v.value", component.get("v.serviceGroupName"));
                     //added for short term insurance
                     if(caseRecordTypeVal =='Short Term Complaint'){
                         classification.set("v.value", component.get("v.objTypes.Classification__c"));
                         
                         if(serviceName == "Giving Poor Financial Advice"){
                             component.set("v.showSubClassification",true);
                         } else{
                             component.set("v.showSubClassification",false);
                         }
                     }
                }
                else{
                	secondary.set("v.value", component.get("v.objTypes.Subtype__c"));
                	prod.set("v.value", component.get("v.objTypes.Product__c"));
                }
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                //$A.get("e.force:refreshView").fire();
                
           }else if(state === "ERROR"){
                
                var message = '';
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                //$A.get("e.force:refreshView").fire();
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
    }, 
    
    getServiceGroup : function(component, event, helper) {
    	
        //var serviceGroupId = component.find("serviceGroupLookupSearch").get("v.value"); //commented out by Smanga
        console.log('customServiceGroupSearchId ==> '+ component.get("v.customServiceGroupSearchId")); //Smanga custom lookup
        var serviceGroupId = component.get("v.customServiceGroupSearchId");
         var caseRecordType = component.get("v.caseRecordType");
        
        
        component.set("v.productOptions", []);
        component.set("v.productId", null);
        component.set("v.serviceTypeOptions", []);
        component.set("v.serviceTypeId", null);
        // Added to remove the existing for NBFS Service Group
        component.set("v.isNBFSServiceGroup", false);
        component.find("iPrimary").set("v.value", '');
        component.find("iProduct").set("v.value", '');
        component.find("iSecond").set("v.value", '');
        
        helper.showSpinner(component);
        //Koketso - get all products associated with service group selected for complaint cases
        if(serviceGroupId != null && serviceGroupId != '') {
            var action = component.get("c.findProductsByServiceGroup");
            action.setParams({
                serviceGroupId : serviceGroupId
            });        
            action.setCallback(this, function(response) {
                var state = response.getState();            
                if (state === "SUCCESS") {
                    var productOptions = response.getReturnValue();
                    console.log("productOptions:", productOptions);
                    
                    if(productOptions.length > 0){
                        console.log('Id',productOptions[0].id);
                        // Added to show the Service Type same as NBFS Service Group
                        if(productOptions[0].id == 'NBFSServiceGroup'){
                            component.set("v.isNBFSServiceGroup", true);
                            //component.find('iNBFSProduct').set('v.disabled',true);
                        }
                        else
                        	component.set("v.productOptions", productOptions);
                    }
                }            
            });
            $A.enqueueAction(action);
        }
        
      	  var action = component.get("c.findServiceGroupRecord");
        
        action.setParams({
            "serviceGroupId" :serviceGroupId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {

                component.set("v.serviceGroupRecord", response.getReturnValue());
                
                //var queueName = component.find("serviceGroupLookupSearch");
                //var serviceGroupName = component.find("serviceGroupLookupSearch");
                //var serviceGroupId = component.find("serviceGroupLookupSearch");
                console.log('customServiceGroupSearchId ==> '+ component.get("v.customServiceGroupSearchId")); //Smanga custom lookup
                serviceGroupId = component.get("v.customServiceGroupSearchId"); //Smanga custom lookup

                //queueName.set("v.value", component.get("v.serviceGroupRecord.Queue__c")); 
                //serviceGroupName.set("v.value", component.get("v.serviceGroupRecord.Name"));
                //serviceGroupId.set("v.value", component.get("v.serviceGroupRecord.Id"));
                
               component.set("v.serviceGroupId", component.get("v.serviceGroupRecord.Id")); //logic Needs relooking - Smanga
               component.set("v.serviceGroupName", component.get("v.serviceGroupRecord.Name"));
                
                helper.hideSpinner(component);
                
            }else{
                
                // show error notification
                var toastEvent = helper.getToast("Error", "There was an error searching for the relevant Service Group", "error");
   				toastEvent.fire();
                
                helper.hideSpinner(component);
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
       
    },
    
    //Koketso - get all Service Types linked to a selected product by Product ID
    getServiceTypesByProduct : function(component, event, helper) {
        
        var serviceGroupId;
        
        //var serviceGroupSearch = component.find("serviceGroupLookupSearch"); commented out by Smanga
        console.log('customServiceGroupSearchId ==> '+ component.get("v.customServiceGroupSearchId")); //Smanga custom lookup
        var serviceGroupSearch = component.get("v.customServiceGroupRecordSearch"); //Smanga custom lookup
        
        var productId = component.get("v.productId");
        
        if(serviceGroupSearch != null){
            //serviceGroupId = serviceGroupSearch.get("v.value"); commented out by Smanga
            serviceGroupId = component.get("v.customServiceGroupSearchId"); //Smanga custom lookup
        }else{
            serviceGroupId = null;
        }

        component.set("v.serviceTypeOptions", []);
        component.set("v.serviceTypeId", null);
        
        var action = component.get("c.findServiceTypesByProductAndServiceGroup");
        
        action.setParams({
            "caseId": component.get("v.recordId"),
            "productId": productId,
            "serviceGroupId": serviceGroupId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var serviceTypeOptions = response.getReturnValue();
                var complimentServiceTypeOptions = [];
                var otherServiceTypeOptions = [];
                console.log("serviceTypeOptions:", serviceTypeOptions);
                
                if(serviceTypeOptions.length > 0){
                    for(var i = 0; i < serviceTypeOptions.length; i++){
                        if(serviceTypeOptions[i].recordtype == 'Compliment'){
                            complimentServiceTypeOptions.push(serviceTypeOptions[i]);
                        }else{
                            otherServiceTypeOptions.push(serviceTypeOptions[i]);
                        }
                    }
                    component.set("v.complimentServiceTypeOptions", complimentServiceTypeOptions);
                    component.set("v.serviceTypeOptions", otherServiceTypeOptions);
                }
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
})