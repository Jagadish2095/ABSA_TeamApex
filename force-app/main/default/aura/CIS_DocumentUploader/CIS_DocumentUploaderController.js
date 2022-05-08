({
    //Controller Class
    closeAll:function (component, event, helper) {
        component.set('v.isUpload',false);
        component.set('v.isUploadInit',false);
    },
    doInit: function(component, event, helper) {
        helper.fetchChildDocumentPickListVal(component);
    },
    //To handle the file change in the upload missing/reusable/refreshable document section
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    //To save the uploaded missing/reusable/refreshable document
    doSave: function(component, event, helper) {
        if(component.get("v.documentSubType") != 'Choose one...'){
            component.set('v.showError',false);
            component.set('v.documentSType',component.get("v.documentSubType"));
            if(component.find("fileId").get("v.files") != null){
                if (component.find("fileId").get("v.files").length > 0) {
                    component.set('v.isUploading',false);
                    helper.uploadHelper(component, event);
                } else {
                    component.set("v.fileName", 'No File Selected..');
                } }
        }else{
            component.set('v.showError',true);
        }
    },
    
    populateDetails: function(component, event, helper) {
        var success = false;
        var hanisResponse = component.get("v.hanisResponse");
        var accRec = component.get("v.accRec");
        component.set('v.isUploading',false);
        component.set('v.showSpinner',true);
        component.set('v.goldenSourceButton',true);
        if (accRec.Client_Type__c == 'Individual' || accRec.Client_Type__c =='Individual - Minor' || accRec.Client_Type__c == 'Non - Resident Entity' || accRec.Client_Type__c == 'Private Individual' || accRec.Client_Type__c == 'Staff' || accRec.Client_Type__c == 'Staff Joint and Several'){
            if(component.get("v.parentDocumentType") == 'ProofOfId'){
                if(hanisResponse.statusCode == 200 ){
                    if( hanisResponse.Cert != null &&  hanisResponse.Cert != ''){
                        var actionGoldenService = component.get("c.goldenSourceUpload");
                        actionGoldenService.setParams({
                            hanisResponse : JSON.stringify(hanisResponse),
                            cpbResponse : '',
                            experianResponse : '',
                            documentType : component.get("v.parentDocumentType"),
                            subDocumentType : "HANISCertificate",
                            accountId : accRec.Id
                        });
                        actionGoldenService.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state === "SUCCESS"){
                                var pId = response.getReturnValue(); 
                                if(pId != null && pId != ''){
                                    component.set("v.isUploading", true);
                                    component.set("v.showSpinner", false);
                                    var msg = 'The File Has Been Uploaded Successfully !!!';
                                    var type = 'success';
                                    helper.showSuccessToast(component, event, msg);
                                    component.set("v.isUpload", false);
                                    component.set("v.isUploadInit", false);
                                }
                                else{
                                    component.set("v.isUploading", true);
                                    component.set("v.showSpinner", false);
                                    var msg = 'Failed To Upload the document in Amber';
                                    var type = 'error';
                                    helper.showToast(component, event, msg, type);
                                }
                            }else{
                                component.set("v.isUploading", true);
                                component.set("v.showSpinner", false);
                                var errors = response.getError();
                                var msg = errors[0].message;
                                var type = 'error';
                                helper.showToast(component, event, msg, type);
                            }
                        });
                        $A.enqueueAction(actionGoldenService);
                    }else{
                        var message = "Hanis Service didn't contain the Certificate metadata upload the document manually"
                        var type = 'error';
                        helper.showToast(component, event, message, type);
                        component.set("v.isUploading", true);
                        component.set("v.showSpinner", false);
                    }
                }else if(hanisResponse.statusCode==404){
                    var message = "Hanis Service Error! " +respObj.message;
                    var type = 'error';
                    component.set("v.isUploading", true);
                    component.set("v.showSpinner", false);
                    helper.showToast(component, event, message, type);
                }else{
                    console.log('HANIS SERVICE ERROR OCCURRED');  
                    var message = "Hanis Service Error! We cannot complete the request now, please try again if error persist contact administrator."
                    var type = 'error';
                    component.set("v.isUploading", true);
                    component.set("v.showSpinner", false);
                    helper.showToast(component, event, message, type);
                }
            }else if(component.get("v.parentDocumentType") == 'ProofOfAddress'){
                if((hanisResponse.surname != null && hanisResponse.surname != '') || (accRec.LastName != null && accRec.LastName != '' )){
                    var actionCPBservice = component.get("c.callCPBService");
                    var surNameCPB = (hanisResponse.surname != null && hanisResponse.surname != '' ? hanisResponse.surname : accRec.LastName);
                    actionCPBservice.setParams({
                        "idNumber" : accRec.ID_Number__pc,
                        "lastName" : surNameCPB
                    });
                    actionCPBservice.setCallback(this, function(response) {
                        var state = response.getState();
                        if (component.isValid() && state === "SUCCESS") {
                            var respObj = JSON.parse(response.getReturnValue());
                            if(respObj.statusCode == 200){
                                if(respObj.Person != null && respObj.Person.AddressInformation.ResidentialAddress.AddCert != null &&  respObj.Person.AddressInformation.ResidentialAddress.AddCert != ''){
                                    var actionGoldenService = component.get("c.goldenSourceUpload");
                                    actionGoldenService.setParams({
                                        hanisResponse : '',
                                        cpbResponse : JSON.stringify(respObj),
                                        experianResponse : '',
                                        documentType : component.get("v.parentDocumentType"),
                                        subDocumentType : "CPBCertificate",
                                        accountId : accRec.Id
                                    });
                                    actionGoldenService.setCallback(this, function(response) {
                                        var state = response.getState();
                                        if (state === "SUCCESS"){
                                            var pId = response.getReturnValue(); 
                                            if(pId != null && pId != ''){
                                                component.set("v.isUploading", true);
                                                component.set("v.showSpinner", false);
                                                var msg = 'The File Has Been Uploaded Successfully !!!';
                                                var type = 'success';
                                                helper.showSuccessToast(component, event, msg);
                                                component.set("v.isUpload", false);
                                                component.set("v.isUploadInit", false);
                                            }
                                            else{
                                                component.set("v.isUploading", true);
                                                component.set("v.showSpinner", false);
                                                var msg = 'Failed To Upload the document in Amber';
                                                var type = 'error';
                                                helper.showToast(component, event, msg, type);
                                            }
                                        }else{
                                            var errors = response.getError();
                                            var msg = errors[0].message;
                                            var type = 'error';
                                            component.set("v.isUploading", true);
                                            component.set("v.showSpinner", false);
                                            helper.showToast(component, event, msg, type);
                                        }
                                    });
                                    $A.enqueueAction(actionGoldenService);
                                }else{
                                    var message = "CPB Service didn't contain the Certificate metadata upload the document manually"
                                    var type = 'error';
                        			helper.showToast(component, event, message, type);
                                    component.set("v.isUploading", true);
                                    component.set("v.showSpinner", false);
                                }
                                
                            }else if(respObj.statusCode==404){
                                var message = "CPB Service Error! "+respObj.message;
                                var type = 'error';
                                component.set("v.isUploading", true);
                                component.set("v.showSpinner", false);
                                helper.showToast(component, event, message, type);
                            }else{
                                var message = "CPB Service Error! We cannot complete the request now, please try again if error persist contact administrator.";
                                var type = 'error';
                                component.set("v.isUploading", true);
                                component.set("v.showSpinner", false);
                                helper.showToast(component, event, message, type);
                            }
                        }else{
                            var errors = response.getError();
                            var message = errors[0].message;
                            var type = 'error';
                            component.set("v.isUploading", true);
                            component.set("v.showSpinner", false);
                            helper.showToast(component, event, message, type);
                        }
                    });
                    $A.enqueueAction(actionCPBservice);
                }else{
                    var message = "No lastName found for this record, Please update the record";
                    var type = 'error';
                    component.set("v.isUploading", true);
                    component.set("v.showSpinner", false);
                    helper.showToast(component, event, message, type);
                }
            }
        }else{
            var experianaction = component.get("c.callExperianHandler");
            var registrationNumber;
            if(accRec.Registration_Number__c != null){
                registrationNumber = accRec.Registration_Number__c;
            }else if(accRec.ID_Number__pc != null){
                registrationNumber = accRec.ID_Number__pc;
            }
            experianaction.setParams({"registrationNumber" : registrationNumber});
            experianaction.setCallback(this, function(response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    var respObj = JSON.parse(response.getReturnValue());
                    component.set('v.experianResponse',respObj);
                    if(respObj.statusCode==200 && respObj.message==null){
                        if( respObj.pdf != null &&  respObj.pdf != ''){
                            var actionGoldenService = component.get("c.goldenSourceUpload");
                            actionGoldenService.setParams({
                                hanisResponse : '',
                                cpbResponse : '',
                                experianResponse : JSON.stringify(respObj),
                                documentType : component.get("v.parentDocumentType"),
                                subDocumentType : "Experian Certificate",
                                accountId : accRec.Id
                            });
                            actionGoldenService.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS"){
                                    var pId = response.getReturnValue(); 
                                    if(pId != null && pId != ''){
                                        component.set("v.isUploading", true);
                                        component.set("v.showSpinner", false);
                                        var msg = 'The File Has Been Uploaded Successfully !!!';
                                        var type = 'success';
                                        helper.showSuccessToast(component, event, msg);
                                        component.set("v.isUpload", false);
                                        component.set("v.isUploadInit", false);
                                    }
                                    else{
                                        component.set("v.isUploading", true);
                                        component.set("v.showSpinner", false);
                                        var msg = 'Failed To Upload the document in Amber';
                                        var type = 'error';
                                        helper.showToast(component, event, msg, type);
                                    }
                                }else{
                                    var errors = response.getError();
                                    var msg = errors[0].message;
                                    var type = 'error';
                                    component.set("v.isUploading", true);
                                    component.set("v.showSpinner", false);
                                    helper.showToast(component, event, msg, type);
                                }
                            });
                            $A.enqueueAction(actionGoldenService);
                        }else{
                            var message = "Experian Service didn't contain the Certificate metadata upload the document manually"
                            var type = 'error';
                        	helper.showToast(component, event, message, type);
                            component.set("v.isUploading", true);
                            component.set("v.showSpinner", false);
                        }
                    }else if(respObj.statusCode > 399 || respObj.statusCode < 500){
                        var message = 'Experian Service Error! '+respObj.message;
                        var type = 'error';
                        component.set("v.isUploading", true);
                        component.set("v.showSpinner", false);
                        helper.showToast(component, event, message, type);
                    }else{
                        var message = "Experian Service Error! We cannot complete the request now, please try again if error persist contact administrator.";
                        var type = 'error';
                        component.set("v.isUploading", true);
                        component.set("v.showSpinner", false);
                        helper.showToast(component, event, message, type);
                    }
                }else{
                    var errors = response.getError();
                    var message = errors[0].message;
                    var type = 'error';
                    component.set("v.isUploading", true);
                    component.set("v.showSpinner", false);
                    helper.showToast(component, event, message, type);
                }
            });
            $A.enqueueAction(experianaction);
        }  
    }
})