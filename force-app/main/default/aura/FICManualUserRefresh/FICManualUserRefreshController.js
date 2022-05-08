({
    //Controller class
    doInit: function(component, event, helper) {
        var controllingFieldAPI = component.get("v.controllingFieldAPI"); 
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var clientGrpFieldAPI = component.get("v.clientGrpFieldAPI");
        var objDetails = component.get("v.objDetail");
        
        
        
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI,clientGrpFieldAPI);
        helper.fetchData(component); 
        helper.fetchCompliancePackResponse(component);
       
    },
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var dependentFieldMap = component.get("v.dependentFieldMap"); 
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = dependentFieldMap[controllerValueKey]; 
            
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    expandClientInfo:function (component, event, helper) {  
        if(component.get('v.isexpandedclInfo')) {
            component.set('v.isexpandedclInfo',false);
        }
        else {
            component.set('v.isexpandedclInfo', true);
        }
    },
    expandClientProd:function (component, event, helper) {  
        if(component.get('v.isexpandedclProd')) {
            component.set('v.isexpandedclProd',false);
        }
        else {
            component.set('v.isexpandedclProd', true);
        }
    },
    expandAttStatus:function (component, event, helper) {  
        if(component.get('v.isexpandedattstatus')) {
            component.set('v.isexpandedattstatus',false);
        }
        else {
            component.set('v.isexpandedattstatus', true);
        }
    },
    Proceed:function (component, event, helper) {  
            component.set('v.isAttSuccess',true);
        component.set('v.isClientInfo',false);
        
        },
    closeAttDoc :function (component, event, helper) { 
            component.set('v.isAttSuccess',false);
            component.set('v.fToFCInt','No');
            component.set('v.cltInfoAcc','No');
            component.set('v.cltProdAcc','No');
            component.set('v.cltPartAcc','No');
            component.set('v.isClientInfo',true);
        },
    DeclineAtt:function (component, event, helper) { 
            component.set('v.isAttSuccess',false);
            component.set('v.isClientInfo',false); 
            component.set('v.isDeclineAtt',true);
        },
    GenerateAtt:function (component, event, helper) {
        var actions = [ 
                       { label: "Download", name: "download" }];

        component.set("v.columnsAudit", [
            { label: "Name", fieldName: "Name", type: "text" },
            { label: "User", fieldName: "ownerName", type: "text" },
            { label: "Document Uploaded For", fieldName: "Account__c", type: "text" },
            {
                label: "Created Date",
                fieldName: "CreatedDate",
                type: "date",
                typeAttributes: { day: "numeric", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: true }
            },
            { type: "action", typeAttributes: { rowActions: actions } } 
        ]);
        helper.generateAttdoc(component);
        },
    
     /**
     * @description download function to download file from ECM.
     **/
    download: function (component, event, helper) {
        var row = event.getParam("row");
        alert('rowvalue'+JSON.stringify(row))
        var actionName = event.getParam("action").name;
        helper.downloadDoc(component, row);
    },
    
     handleRowAction: function (component, event, helper) {
        var action = event.getParam("action");
        var row = event.getParam("row");
         component.set("v.rowValue",row);
         // alert('rowvalue1'+JSON.stringify(row))
        switch (action.name) {
            case "download":
                helper.downloadDoc(component, row);
                break;
              /*  case "email":
                component.set("v.isemailShare", true);
                component.set("v.isAttSuccess", false);
                break; */
                
        }
    },
    
  /*  emailShare : function (component, event, helper) {
        var row = component.get("v.rowValue");
        var clientemail =  component.get("v.emailid");
        //alert('rowvalue'+JSON.stringify(row.Id))
        //alert('clientemail'+JSON.stringify(clientemail))
        helper.emailSharing(component,component.get("v.emailid"),row); 
        component.set("v.isemailShare", false);
        component.set("v.isAttSuccess", true);
    }, */
    
    CompAttProc :function (component, event, helper) { 
            component.set('v.isAttSuccess',false);
        //helper.riskRatingCal(component);
            component.set('v.isCompAttDocProc',true);
        
     },
    
    closeModel:function (component, event, helper) {
       component.set('v.isShowInit',false); 
    },
    
    closeAll:function (component, event, helper) {
        component.set('v.isClientInfo',false);
        component.set('v.isAttSuccess',false);
        component.set('v.isCompAttDocProc',false);
        component.set('v.isShowInit',false);
       
    },
    
    closeproceedOnboard : function (component, event, helper) {
        component.set('v.isShowInit',false);
    },
    
    closeEmailShare : function (component, event, helper) {
        component.set('v.isemailShare',false);
        component.set("v.isAttSuccess", true);
    },
    
    uploadDoc : function (component, event, helper) {
        component.set('v.isShowUpload',true);
         component.set('v.isOpen',true);
    },
     refreshDocuments: function (component, event, helper) {
       // helper.fetchAuditData(component);
        
     },
    
    onchecked : function (component, event, helper) { 
        var tocheck = event.getSource().get("v.checked");  
        if(tocheck == true){
            component.set('v.ischeckedValue',true);
            
        }else {
            component.set('v.ischeckedValue',false);
        }
     },
    
      button1 : function(component, event, helper) {
         var getValue1 = component.find("btngp1").get("v.value");
         component.set('v.fToFCInt',getValue1);
         var btnval1 = component.get("v.fToFCInt"); 
            
        },
      button2 : function(component, event, helper) {
        var getValue2 = component.find("btngp2").get("v.value");
        component.set('v.cltInfoAcc',getValue2);
          var btnval2 = component.get("v.cltInfoAcc");
            
        },
      button3 : function(component, event, helper) {
        var getValue3 = event.getSource().get("v.value");
        component.set('v.cltPartAcc',getValue3);
          var btnval3 = component.get("v.cltPartAcc");
            
        },
      button4 : function(component, event, helper) {
        var getValue4 = event.getSource().get("v.value");
        component.set('v.cltProdAcc',getValue4);
          var btnval4 = component.get("v.cltProdAcc"); 
            
        },
      handleComponentEvent : function(component, event,helper) {
        var message = event.getParam("message");
        var ischeck = event.getParam("uploadcheck")
        component.set("v.isShowUpload", message);
         
         if(ischeck == true){
         helper.fetchAuditData(component,event,helper);
         }
              
    },
    
    expandClientParties:function (component, event, helper) {  
        if(component.get('v.expandClientPartiesStatus')) {
            component.set('v.expandClientPartiesStatus',false);
        }
        else {
            component.set('v.expandClientPartiesStatus', true);
        }
    },

})