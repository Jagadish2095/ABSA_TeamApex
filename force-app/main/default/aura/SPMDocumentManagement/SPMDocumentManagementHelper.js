({
    
    /**
    * @description function to show spinner.
    **/
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    /**
    * @description function to hide spinner.
    **/   
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    getOppAcc: function(component, event, helper){
        var action = component.get("c.findOppData");
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.mydata', response.getReturnValue());
                console.log("Found Opp Response: "+ response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                console.log("It's a No for me");
            }
        }));
        $A.enqueueAction(action);
        
    },
    
    fetchAuditData: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocAuditHistoryEmail");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                //console.log('data:' + data);
                
                data.forEach(function(data){
                    data.ownerName = data.Owner.Name;
                });
                component.set("v.dataAudit", data);
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    /**
    * @description download function to download file from ECM.
    **/  
    download: function (cmp, row) {
        cmp.set('v.showSpinner', true);
        var action = cmp.get('c.getDocumentContent');
        action.setParams({
            "documentId": row.Id 
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var element = document.createElement('a');
                element.setAttribute('href', 'data:application/octet-stream;content-disposition:attachment;base64,' + data);
                element.setAttribute('download', row.Name);
                element.style.display = 'none';
                document.body.appendChild(element);		
                element.click();		
                document.body.removeChild(element);
            } else {
                console.log("Download failed ...");
            }
            cmp.set('v.showSpinner', false);
        }));
        $A.enqueueAction(action);
    },
    
    generateDocument: function(component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("doGenerate3");
        console.log("GenerateDocument : " + component.get("v.signatureRequestRecords"));
        
        var action = component.get("c.generateDocument");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "templateName": component.get("v.fileType"),
            "signatureRequests": component.get("v.signatureRequestRecords")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            var res = response.getReturnValue();
            console.log("Response from generate document : " + JSON.stringify(res));
            if (state === "SUCCESS" && res.success === 'true') {                
                toastEvent.setParams({
                    "title": "Success!",
                    "message": component.get("v.fileType") + " document successfully generated.",
                    "type":"success"
                });
                toastEvent.fire();
            } else {
                console.log("Failed with state: " + JSON.stringify(response));
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Failed to generate document " + component.get("v.fileType") ,
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    // Tinashe
    generateNewDocument: function(component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("doGenerate3");
        console.log("GenerateDocument : " + component.get("v.signatureRequestRecords"));
        
        var action = component.get("c.generateNewDocument");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "templateName": component.get("v.fileType"),
            "signatureRequests": component.get("v.signatureRequestRecords")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            var res = response.getReturnValue();
            console.log("Response from generate document : " + JSON.stringify(res));
            if (state === "SUCCESS" && res.success === 'true') {                
                toastEvent.setParams({
                    "title": "Success!",
                    "message": component.get("v.fileType") + " document successfully generated.",
                    "type":"success"
                });
                toastEvent.fire();
            } else {
                console.log("Failed with state: " + JSON.stringify(response));
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Failed to generate document " + component.get("v.fileType") ,
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    // end Tinashe
    
    fetchFileTypesPickListVal: function(component) {
        var action = component.get("c.getDocumentTemplatesNamePickList");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        });
        $A.enqueueAction(action);
    },
    
    fetchTemplateTypesPickListVal: function(component, event, helper) {
        var action = component.get("c.getDocumentTemplatesNamePickList");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        });
        $A.enqueueAction(action);
    },
    
    fetchPersonAccs : function(component, event, helper){
        var action = component.get("c.fetchPersonAccList");
        action.setParams({"oppid":component.get("v.recordId")});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationRecordDetail = response.getReturnValue();
                console.log("applicationRecordDetail"+JSON.stringify(applicationRecordDetail));
                component.set("v.personAccList",applicationRecordDetail);
            }  
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //Start changes for W-004683 By Himani
    
    
    checkStage: function (component, event, helper) {
        
        var action = component.get("c.getDocs");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var responsevalue1=response.getReturnValue();
                component.set("v.documentsUploaded",responsevalue1);
                //this.getMandatoryDocs(component);//w-005661
                this.getPrimayClientMandatoryDocs(component);
            }
            else {
                console.log("Failed with state: " + state);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    /*
    getMandatoryDocs : function (component){
        var Entitytype = component.get("v.opportunityRecord.Entity_Type__c");
        var action = component.get("c.getAllMandatoryDocuments"); 
        action.setParams({
            "Entitytype": Entitytype
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var responsevalue=response.getReturnValue();
                console.log("responsevalue"+responsevalue);
                component.set('v.Mandatorydocuments',responsevalue);
                
                var Mandatorydocuments=component.get("v.Mandatorydocuments");
                var documentsUploaded=component.get("v.documentsUploaded");
                var DocFlag;
                var checkFlag;
                var nonMandFlag='F';
                for(var i in Mandatorydocuments)
                {
                    
                    DocFlag='F';
                    for(var j in documentsUploaded)
                    {
                        if(documentsUploaded[j]===Mandatorydocuments[i].ECM_Type__c)
                        {
                            console.log("Mandatorydocuments Mach 184 " + Mandatorydocuments[i].ECM_Type__c);
                            DocFlag='T';
                        }
                    }
                    if (DocFlag==='F')
                    { 
                        console.log("bb");
                        nonMandFlag='T'
                    } 
                }
                
                if (nonMandFlag==='T')
                {
                    console.log("non mand");
                    this.setOpportunityVal(component, event, true);
                    
                }
                else
                {  
                    console.log("mand");
                    this.setOpportunityVal(component, event, false);
                }
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    setOpportunityVal : function(component, event, checkFlag) 
    {
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateOpportunity");
        action.setParams({
            recordId: recordId,
            docFlag: checkFlag
        });
        action.setCallback(this, function(data) {
            var response = data.getReturnValue();
            console.log("Response 238 " + response);
        });
        $A.enqueueAction(action); 
        
    },*/
    
    getSelectDocumentTemplateRecord : function (component, event, helper) {
        
        component.set("v.showSpinner", true);
        var ftype = component.find('generateFileType').get('v.value');
        var action = component.get("c.getSelectedDocumentTemplate");
        action.setParams({
            "documentTemplateName": ftype
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                
                var documentTemplateRecord = response.getReturnValue();
                
                if(documentTemplateRecord != null && documentTemplateRecord.Signature_Required__c == true) {
                    component.set("v.showSignatoriesCmp",true);
                    var signatoriesCmp = component.find('documentSignatoriesCmp');
                    signatoriesCmp.getDocumentType(ftype);
                    console.log('DocumntManagement:setDocumentTemplate:fileType - ' + ftype);
                    component.set("v.fileType",ftype);
                } else {
                    component.set("v.showSignatoriesCmp",false);
                }
                
            }else if(state === "ERROR"){
                
                var errors = response.getError();
                this.this('Error', errors, 'error');
                component.set("v.showSignatoriesCmp",false);
                
            } else {
                this.this('Document Template Error', 'Unable to find selected Document Template: Please contact your System Administrator', 'Error');
                component.set("v.showSignatoriesCmp",false);
            }
            
            component.set("v.showSpinner", false);
            
        });    
        
        $A.enqueueAction(action);
        
    },
    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    },
    //Added by Diksha for W-4255   
    getAppRecordTypeId : function(component, event, helper){
        var action = component.get("c.getApplicationrecordtypeId");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationRecordTypeId = response.getReturnValue();
                console.log("applicationRecordTypeId"+JSON.stringify(applicationRecordTypeId));
                if(applicationRecordTypeId != null ){
                    component.set("v.recordTypeId",applicationRecordTypeId);
                }
            }  
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    
    //Added by Diksha for W-4255   
    
    getAppId : function(component, event, helper){
        var action = component.get("c.getApplicationId");
        action.setParams({ oppId : component.get("v.recordId")});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationId = response.getReturnValue();
                console.log("applicationId"+JSON.stringify(applicationId));
                if(applicationId != null ){
                    component.set("v.applicationRecordId",applicationId);
                }
            }  
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    
    
    //Added by Diksha for W-4255   
    
    getAppDetails : function(component, event, helper){
        var action = component.get("c.saveAppDetails");
        var applicationRecid  = component.get("v.applicationRecordId");
        
        action.setParams({ 
            "Signedat" : component.find("Signedat").get("v.value"),
            "Signedon" : component.find("Signedon").get("v.value"),
            "globalapplicationform" : component.find("globalapplicationform").get("v.value"),
            "StandardAbsaresolutionforyou" : component.find("StandardAbsaresolutionforyou").get("v.value"),
            "Absamandateandindemnity" : component.find("Absamandateandindemnity").get("v.value"),
            "StandardAbsasitevisitforyou" : component.find("StandardAbsasitevisitforyou").get("v.value"),
            "StandardAbsapowerofattorneyforyou" : component.find("StandardAbsapowerofattorneyforyou").get("v.value"),
            "Recordoftelephonicengagement" : component.find("Recordoftelephonicengagement").get("v.value"),
            "Arealltherelatedparties" : component.find("Arealltherelatedparties").get("v.value"),
            "Istheremorethanonenaturalperson" : component.find("Istheremorethanonenaturalperson").get("v.value"),
            "ForeignExchangeAuthorityFormforyou" : component.find("ForeignExchangeAuthorityFormforyou").get("v.value"),
            "applicationId" : applicationRecid
            
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationDetails = response.getReturnValue();
                console.log("applicationdetails"+JSON.stringify(applicationDetails));
                // component.set("v.applicationRecordId",applicationDetails.id );
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "The Record Saved Successfully"
                });
                toastEvent.fire();
                
            }
            else if (state === "INCOMPLETE") {
                console.log("Error message: " +errors[0].message);
                //cmp.set('v.showSpinner', true);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }else{
                        console.log("Unknown error");
                    }
                }
            
        });
        
        $A.enqueueAction(action);
    },
    
    //Added by Diksha for W-4257  
    getsitevisitDetails : function(component, event, helper){
        var action = component.get("c.saveSiteVisitDetails");
        var applicationRecid  = component.get("v.applicationRecordId");
        
        action.setParams({ 
            "settlementtype" : component.find("settlementtype").get("v.value"),
            "sitevisitdate" : component.find("sitevisitdate").get("v.value"),
            "addresstype" : component.find("addresstype").get("v.value"),
            "firstname" : component.find("firstname").get("v.value"),
            "surname" : component.find("surname").get("v.value"),
            "completedby" : component.find("completedby").get("v.value"),
            "applicationId" : applicationRecid
            
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var sitevisitDetails = response.getReturnValue();
                console.log("sitevisitDetails"+JSON.stringify(sitevisitDetails));
                component.set("v.applicationRecordId",sitevisitDetails.Id );
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "The Record Saved Successfully"
                });
                toastEvent.fire();
                
            }
            else if (state === "INCOMPLETE") {
                console.log("Error message: " +errors[0].message);
                //cmp.set('v.showSpinner', true);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }else{
                        console.log("Unknown error");
                    }
                }
            
        });
        
        $A.enqueueAction(action);
    },
    
    getIndemnityDetails : function(component, event, helper){
        var action = component.get("c.saveIndemnityDetails");
        var applicationRecid  = component.get("v.applicationRecordId");
        
        action.setParams({ 
            "medium" : component.find("medium").get("v.value"),
            "instructionType" : component.find("instructionType").get("v.value")
 
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var indemnityDetails = response.getReturnValue();
                console.log("indemnityDetails"+JSON.stringify(indemnityDetails));
                component.set("v.applicationRecordId",indemnityDetails.Id );
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "The Record Saved Successfully"
                });
                toastEvent.fire();
                
            }
            else if (state === "INCOMPLETE") {
                console.log("Error message: " +errors[0].message);
                //cmp.set('v.showSpinner', true);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }else{
                        console.log("Unknown error");
                    }
                }
            
        });
        
        $A.enqueueAction(action);
    },   
    getResolutionDetails: function(component, event, helper){
        var action = component.get("c.saveResolutionDetails");
        var applicationRecid  = component.get("v.applicationRecordId");
        
        action.setParams({ 
            "individualsisareauthorisedtoact" : component.find("individualsisareauthorisedtoact").get("v.value"),
            "applicationId" : applicationRecid
            
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resolutionDetails = response.getReturnValue();
                console.log("resolutionDetails"+JSON.stringify(resolutionDetails));
                component.set("v.applicationRecordId",resolutionDetails.Id );
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "The Record Saved Successfully"
                });
                toastEvent.fire();
                
            }
            else if (state === "INCOMPLETE") {
                console.log("Error message: " +errors[0].message);
                //cmp.set('v.showSpinner', true);
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }else{
                        console.log("Unknown error");
                    }
                }
            
        });
        
        $A.enqueueAction(action);
    },
    
    
    getAppRecorddetails : function(component, event, helper){
        
        var action = component.get("c.getApplicationRecordDetails");
        action.setParams({ oppId : component.get("v.recordId")});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationRecordDetail = response.getReturnValue();
                console.log("applicationRecordDetail"+JSON.stringify(applicationRecordDetail));
                if(applicationRecordDetail!=null && applicationRecordDetail!=''){
                    component.set("v.applicationRecordDetail",applicationRecordDetail);
                    var sitevisitvalue = component.get("v.applicationRecordDetail.Standard_Absa_site_visit_for_you__c");
                    console.log(sitevisitvalue);
                    var resolutionvalue = component.get("v.applicationRecordDetail.Standard_Absa_resolution_for_you__c");
                    console.log(resolutionvalue);
                    if (sitevisitvalue == "YES" || resolutionvalue =="YES" ){
                        component.set("v.showsitevisit", true);
                        component.set("v.showResolution", true);
                        
                    }   
                    else{
                        component.set("v.showsitevisit", false);
                        component.set("v.showResolution", false);
                        
                    }    
                    
                    if(applicationRecordDetail.Completed_By__r!=null && applicationRecordDetail.Completed_By__r!='')
                        component.set("v.employeenumber",applicationRecordDetail.Completed_By__r.EmployeeNumber);
                    
                    /* console.log(showvalue);
                console.log("showvalue"+JSON.stringify(showvalue));*/
                }
                
                
            }  
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    //W-005661 - Anka Ganta - 2020-09-19
     getPrimayClientMandatoryDocs : function (component){
      
       var Entitytype = component.get("v.opportunityRecord.Entity_Type__c");
       var OppId = component.get("v.recordId");
       var documentsUploaded=component.get("v.documentsUploaded");
       console.log("documentsUploaded"+documentsUploaded);
        console.log("Entitytype"+Entitytype);
        console.log("OppId"+OppId);
       
       var action = component.get("c.getPrimaryClientMandatoryDocuments"); 
       action.setParams({
             "Entitytype": Entitytype,
             "OppId": OppId
        });
       action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
            var responsevalue = response.getReturnValue();
            component.set("v.PrimaryClientMandDocs",responsevalue);
            console.log("PrimaryClientMandDocs+++"+component.get("v.PrimaryClientMandDocs"));
            }
           else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }}
        });
        $A.enqueueAction(action);
    },
    
    // Added by Yongama, Copied from ProductOnboardingAuthSignatureHelper
    
        fetchAccountContactRelation: function(component, event, helper) {
        var recordid = component.get("v.recordId");
        var action = component.get("c.getAccountContactRelation");
        action.setParams({
            "oppId": recordid
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                console.log("Document Mgt Response :" + responseValue);
                component.set("v.appProdMerchList", response.getReturnValue());
                if (responseValue != null) {
                    var options = [];
                    var emailMap = new Map();
                    var mobileMap = new Map();
                    for (var i = 0; i<responseValue.length; i++){
                        if (responseValue[i].Roles != null) {
                            if ((responseValue[i].Roles.indexOf('Individual with Authority to Act') > -1)
                               || (responseValue[i].Roles.indexOf('Managing Director') > -1)
                               || (responseValue[i].Roles.indexOf('Shareholder/Controller') > -1)) {
                                options.push({Id: responseValue[i].Id, Name: responseValue[i].Contact.Name, Roles: responseValue[i].Roles});
                                emailMap.set(responseValue[i].Id, responseValue[i].Contact.Email);
                                mobileMap.set(responseValue[i].Id, responseValue[i].Contact.MobilePhone);
                            }
                        }
                    }
                    component.set("v.options", options);
                    component.set("v.emailMap", emailMap);
                    component.set("v.mobileMap", mobileMap);
                    component.set('v.isButtonActive',false);
                    if (options == null) {
                        component.set('v.optionsNotEmpty',false);
                    } else {
                        component.set('v.optionsNotEmpty',true);
                    }
                }
            } else if(state === "ERROR"){
                var errors = response.getError();
                console.log('Callback to getApplicationProductMerchant Failed. Error : [' + JSON.stringify(errors) + ']');
                component.set('v.isButtonActive',true);
                component.set('v.optionsNotEmpty',false);
            } else {
                console.log('Callback to getApplicationProductMerchant Failed.');
                component.set('v.isButtonActive',true);
                component.set('v.optionsNotEmpty',false);
            }
        });
        $A.enqueueAction(action);
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
})
/*****************************************************************************************************************************************/