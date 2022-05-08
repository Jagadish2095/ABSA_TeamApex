({
	/*
	doInit : function(component, event, helper) {
        
       var action = component.get("c.generateProdWrapper");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.set("v.prodWrap",results);
                helper.returnProductId(component, event, helper);
            }
        });
        $A.enqueueAction(action);
        
      
    },
   */ 
    
    
    saveProduct : function(component, event, helper) {
        var prodWrap = component.get("v.prodWrap");
        console.log("save Quote---"+JSON.stringify(prodWrap));
		var action = component.get("c.saveBGProduct");
        action.setParams({
            "prodWrap": JSON.stringify(prodWrap),
            "appProdId": component.get("v.appProdId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('results quote generation---'+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---'+JSON.stringify(results));
                 var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Quote Data Saved Successfully"
                });
                toastEvent.fire();
                //component.set("v.quoteWrap",results);
            }
        });
        $A.enqueueAction(action);
    },
    
    addNewBeneficiary: function (component,event,helper) {
         var newWitnesses=component.get("v.newWitnesses");
         newWitnesses++;
         component.set('v.newWitnesses',newWitnesses);
            
        if(newWitnesses=='1'){
            var prodWrap = component.get("v.prodWrap");
            console.log('Beneficiaryresults1---'+JSON.stringify(prodWrap));
            var action = component.get("c.addNewProduct");
        action.setParams({
            "prodWrap": JSON.stringify(prodWrap),
            "newWitnesses": component.get("v.newWitnesses"),
            "appProdId": component.get("v.appProdId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('results quote generation---'+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('Beneficiaryresults2---'+JSON.stringify(results));
                component.set("v.prodWrap",results);
            }
        });
        $A.enqueueAction(action);
        }
        else{
         var prodWrapVariable =[];
         prodWrapVariable=component.get("v.prodWrap.variablemap");
         console.log("save Quote---"+JSON.stringify(prodWrapVariable));
         prodWrapVariable.push({
             beneficiaryName:null,
             clearingCode:null,
             addressLine1:null,
             town:null,
             country:null,
             accountNo:null,
             accountType:null,
             suburb:null,
             postalCode:null
         });
         component.set('v.prodWrap.variablemap',prodWrapVariable);
        }
        
    },
    addNewFields: function (component,event,helper) {
         var newFields=component.get("v.newFields");
         newFields++;
         component.set('v.newFields',newFields);
            
        if(newFields=='1'){
            var prodWrap = component.get("v.prodWrap");
            var action = component.get("c.addAdditionalFields");
        action.setParams({
            "prodWrap": JSON.stringify(prodWrap),
            "newFields": component.get("v.newFields"),
            "appProdId": component.get("v.appProdId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.set("v.prodWrap",results);
            }
        });
        $A.enqueueAction(action);
        }
        else{
         var prodWrapVariable =[];
         prodWrapVariable=component.get("v.prodWrap.additionalFields");
         prodWrapVariable.push({
             minAmount:null,
             establishmentAmount:null,
             dueFeesSecondSixMonths:null,
             dueFeesFirstSixMonths:null,
             
         });
         component.set('v.prodWrap.additionalFields',prodWrapVariable);
        }
        
    },
    
    handleChange : function (component,event,helper) {
        var radioGrpValue = component.get("v.radioGrpValue");
        if(radioGrpValue=='option1'){
            component.set('v.yesChecked',true);
            component.set('v.noChecked',false);
        }
        else{
           component.set('v.noChecked',true); 
           component.set('v.yesChecked',false);
        
        }
    },
    onGuaranteeTypeChange : function (component,event,helper) {
    var selectedValue=component.find('select').get('v.value');
    if(selectedValue=='JBCC CONSTRUCTION GUARANTEE'){
      component.set('v.JBCCChecked',true);
      //component.set('v.BIDChecked',false);
      //component.set('v.PERFORMANCEChecked',false);
      component.set('v.PROPERTYChecked',false);
      component.set('v.OTHERChecked',false); 
    }
    else if(selectedValue=='BID BOND/TENDER GUARANTEE'){
         //component.set('v.BIDChecked',true);
         component.set('v.JBCCChecked',true);
         //component.set('v.PERFORMANCEChecked',false);
         component.set('v.PROPERTYChecked',false);
         component.set('v.OTHERChecked',false); 
    }
    else if(selectedValue=='PERFORMANCE GUARANTEE'){
        //component.set('v.PERFORMANCEChecked',true);
        component.set('v.JBCCChecked',true);
        //component.set('v.BIDChecked',false);
        component.set('v.PROPERTYChecked',false);
        component.set('v.OTHERChecked',false); 
    }
    else if(selectedValue=='PROPERTY GUARANTEE'){
        component.set('v.PROPERTYChecked',true);
        component.set('v.JBCCChecked',false);
        //component.set('v.BIDChecked',false);
        //component.set('v.PERFORMANCEChecked',false);
        component.set('v.OTHERChecked',false); 
    }
    else{
       component.set('v.OTHERChecked',true); 
       component.set('v.JBCCChecked',false); 
       //component.set('v.BIDChecked',false);
       //component.set('v.PERFORMANCEChecked',false);
       component.set('v.PROPERTYChecked',false);
    }
    },
    onCompletedTransactions : function (component,event,helper) {
        component.set('v.displayDescription',true);
    },
    onAgreementCompleteChange : function (component,event,helper) {
        var selectedValue=component.find('selected').get('v.value');
        console.log('selectedValue'+selectedValue);
        if(selectedValue=='Absa 4012'){
            component.set('v.fieldsFor4012',true);
            component.set('v.fieldsFor4013',false);
            }
        else{
            component.set('v.fieldsFor4012',false);
            component.set('v.fieldsFor4013',true);
            
        }
        var action = component.get("c.generateProdWrapper");
        action.setParams({
            "oppId" : component.get("v.recordId"),
            "selectedValue" : selectedValue
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.set("v.prodWrap",results);
                component.set("v.prodWrap.agreementCompletion",selectedValue);
                //helper.getList(component,event,helper);
                helper.returnProductId(component, event, helper,selectedValue);
            }
        });
        $A.enqueueAction(action);
        
    },
    click402 : function (component,event,helper) {
      var action = component.get("c.generate4012");
        console.log('appProdId'+component.get("v.appProdId"));
        action.setParams({
            "oppId" : component.get("v.recordId"),
            "appProdId" : component.get("v.appProdId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('doc'+results);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "Document generated Successfully"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);  
    },
    download: function (component, event,helper) {
        
        var action = component.get("c.getDocumentContent");
        action.setParams({
            documentId: 'a0z5r000000fX1i'
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    var element = document.createElement("a");
                    element.setAttribute("href", "data:application/octet-stream;content-disposition:attachment;base64," + data);
                    element.setAttribute("download",'ABSA 4012 - Application for the Issuance of a Local Guarantee.pdf');
                    element.style.display = "none";
                    document.body.appendChild(element);
                    element.click();
                    document.body.removeChild(element);
                } else {
                    console.log("Download failed ...");
                }
            })
        );
        $A.enqueueAction(action);
    },
})