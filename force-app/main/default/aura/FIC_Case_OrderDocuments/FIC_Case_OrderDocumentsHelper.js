({
    setTitle: function(ShowResultValue, component) {
        ShowResultValue = JSON.stringify(ShowResultValue);
        if (ShowResultValue === '"Account application"') {
            component.set("v.labelForButton", 'Consent');
        }
        if (ShowResultValue === '"Proof of Address"') {
            component.set("v.labelForButton", 'Proof of residential address');
        }
        if (ShowResultValue === '"Proof of identification"') {
            component.set("v.labelForButton", 'ID verification');
        }
        if (ShowResultValue === '"Signing instructions"') {
            component.set("v.labelForButton", 'Signature or mandate instruction');
        }
        if (ShowResultValue === '"Credit card quotation"') {
            component.set("v.labelForButton", 'Credit card quotation');
        }
        if (ShowResultValue === '"Proof of income"') {
            component.set("v.labelForButton", 'Proof of income (latest 3 months)');
        }
        if (ShowResultValue === '"Green barcoded ID"') {
            component.set("v.labelForButton", 'Green barcoded ID');
        }
    },

    setDocument: function (component, docId , helper) {
        let caseDocuments = {};
        caseDocuments = component.get("v.caseDocuments");
        for (let i = 0; i < caseDocuments.length; i++) {
            if (caseDocuments[i].Id === docId) {
                component.set("v.document", caseDocuments[i]);
            }
        }
        let fieldValue = component.get("v.document.Is_Fic_Document_Consent__c");
        let consentReason = component.get("v.document.Fic_Document_No_Consent_Reason__c");
        let documentType = component.get("v.document.Type__c");

        if(fieldValue != null && consentReason != null && documentType != null){
            component.set("v.inOrder", fieldValue.toString());
            if(fieldValue.toString() == 'false' && consentReason.toString() != ''){
                 component.set("v.reasonValue",consentReason.toString());
            }else if(fieldValue.toString() == 'false' && consentReason.toString() == ''){
                 component.set("v.reasonValue",'');
            }else{
                component.set("v.reasonValue",consentReason.toString());
            }
        }else if(fieldValue != null){
            component.set("v.inOrder", fieldValue.toString());
        }
        component.set("v.typeValue", this.translateDocumetTypes(documentType.toString()));
        component.set("v.docName", component.get("v.document.Name"));
        var temeReasons = helper.getReasonsList(component, event, helper,component.get("v.document.Type__c"));
        //var temeReasons = this.getReasonsList(component.get("v.typeValue"));    
        component.set("v.reasons" ,temeReasons);
        this.setReasons(component, component.get("v.inOrder"));
    },
    
    translateDocumetTypes : function(docType){
        if(docType == 'ProofOfId'){
            return 'Proof of identification';
        }else if(docType == 'ProofOfAddress'){
            return 'Proof of Address';    
        }else{
            return docType; 
        }
    },

    updateInOrder: function(component, changeValue) {
        let action = component.get("c.updateInOrder");
        action.setParams({
            "id": component.get("v.recordId"),
            "whichTab": this.getType(component),
            "choosenValue": changeValue,
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                this.getDocuments(component);
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    isUnassignedQueue: function (component) {
        let action = component.get("c.isUnassignedQueue");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.isUnassignQueue', responseData);
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getDocuments: function (component) {
        let action = component.get("c.getDocuments");
        action.setParams({
            "caseId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.caseDocuments', responseData);
                    console.log('case documents', responseData)
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getCase: function(component, event, helper, ShowResultValue) {
        let action = component.get("c.getCase");
        var caseId = component.get("v.recordId");
        action.setParams({
            "caseId": caseId,
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.case', responseData);
                    this.getFailReasons(component);
                    component.set('v.caseType',component.get('v.case.Type'));
                    let ownerQueue = component.get('v.case.Owner_Queue_Name__c');

                    let docId = component.get("v.documentId");
                    this.setDocument(component, docId , helper);
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    setReasons: function(component, hide) {
        if (hide === 'false') {
            component.set("v.ReasonIsMandatory", false);
        } else {
            component.set("v.ReasonIsMandatory", true);
        }
    },

    submitChanges: function(component, event, helper) {
		//let reason = component.find("select2").get("v.value");
		this.showSpinner(component);
        let reason = component.get("v.reasonValue");
        if(reason == '' || reason == undefined){
            reason = component.get("v.reasons")[0];
            console.log(reason);
        }
        let order = component.get("v.inOrder");
        let type = this.translateForDocumentUpload(component.find("select1").get("v.value"));
        let action = component.get("c.updateDocument");

        action.setParams({
            "docId": component.get("v.documentId"),
            "reason": reason,
            "order": order,
            "type": type
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
      
            if (state === "SUCCESS") {
                this.hideSpinner(component);
                var str = responseData;
               if (!$A.util.isEmpty(responseData)) {
                 var myArr = str.split(":");
                /*
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.case', responseData);
                }*/
               
                component.set('v.editMode', false);
                component.set('v.isAllDocs', true);
                this.getDocuments(component);
                if(myArr[0] == 'Success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    type : 'Success',
                    title: 'Success',
                    message: responseData
                    });
                    toastEvent.fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                    type : 'Error',
                    title: 'Error',
                    message: responseData
                    });
                    toastEvent.fire();
                }
            }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                type : 'Success',
                title: 'Success',
                message: 'Document updated successfully'
                });
                toastEvent.fire();
            }
            } else if (state === "ERROR") {
                this.hideSpinner(component);
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							type : 'error',
							mode: 'sticky',
							title: 'Error:'  + errors[0].message,
							message: 'Please Fill all value.'
						});
						toastEvent.fire();
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getFailReasons: function(component) {
        let action = component.get("c.getPickListValuesIntoList");
        action.setParams({
            "docName": component.get('v.labelForButton'),
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.reasons', responseData);
                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getType: function(component) {
       let tab =  component.get("v.labelForButton")
       if(tab === 'Consent'){
        return 'Account application'
       }
       if(tab === 'Proof of residential address'){
        return 'Proof of Address'
       }
       if(tab === 'ID verification'){
            return 'Proof of identification'
       }
       if(tab === 'Signature or mandate instruction'){
        return 'Signing instructions'
       }
        if(tab === 'Credit card quotation'){
            return 'Quotation'
        }
        if(tab === 'Proof of income (latest 3 months)'){
            return 'Proof of income'
        }
        if(tab === 'Green barcoded ID'){
            return 'Green barcoded ID'
        }
    },
    getReasonsList : function(component, event, helper,docType){
        /*
        var temeReasons = [
                            "Permit not certified",
                            "No reason for using secondary means of Identification",
                            "Surname on ID does not correspond with cif- different surnames/ spelling error",
                            "Smart card id 1 side attached",
                            "No death certificate and id of the executor- split",
                            "Birth certificate outstanding",
                            "Birth Certificate not certified",
                            "Birth Certificate not certified",
                            "Guardian ID unclear",
                            "Date of birth unclear on id document",
                            "Certification stamp on id not dated",
                            "Guardian's id outstanding",
                            "ID is unclear",
                            "ID not certified- COR",
                            "Work permit outstanding",
                            "Identification documents certification stamp has no employee/AB number",
                            "Signing instruction is not in the pack.",
                            "Resolution outstanding",
                            "Documents belong to different clients",
                            "Absa stamp on declaration of foreign national outstanding",
                            "Declaration of foreign national not certified",
                            "Clients full names of client not annotated on application",
                            "Clients full names spelt incorrectly",
                            "Customer agreement outstanding",
                            "Customer signature outstanding	",
                            "Signing instruction is not in the pack",
                            "Proof of address does not correspond with CIF",
                            "Proof of address is not clear",
                            "Primary customer Proof of address is non-conforming",
                            "Lease agreement expired",
                            "Guardians Proof of address unclear.",
                            "Guardians option7 date identified not updated.",
                            "CCV not acceptable as a Proof of address",
                            "Proof of address not in client's name",
                            "Absa 3121 Formal or informal is not ticked",
                            "Absa 3121 has no date(out dated form)",
                            "Absa 3121 incomplete ( not signed) and dated",
                            "Absa 3121 is incomplete on option 5",
                            "Absa 3121 is not completed on option 4",
                            "Absa 3121 residential/business address not circled",
                            "ABSA 3122 client`s name captured incorrectly",
                            "Absa 3122 clients names are outstanding on option2",
                            "Absa 3122 commissioner full names outstanding",
                            "Absa 3122 commissioner of oath designation is outstanding",
                            "Absa 3122 Commissioner of oath signature outstanding",
                            "Absa 3122 commissioner of oath area of designation outstanding",
                            "Absa 3122 Commissioner of oath stamp unclear",
                            "Absa 3122 Primary customers details incorrectly completed",
                            "Absa 3122 is incomplete",
                            "Absa 3122 is incomplete or not ticked option 1 or 2",
                            "ABSA 3122 is not in Executor`s names",
                            "Absa 3122 nature of relationship not ticked",
                            "Absa 3122 proof of address does not correspond with CIF",
                            "ABSA 3874 does not correspond with cif",
                            "Absa 3874 has no address on option 1 or 2",
                            "Absa 3874 incomplete",
                            "Guardian proof of address outstanding",
                            "Minor Proof of address outstanding",
                            "Minor cannot confirm Proof of address for parent",
                            "Lease agreement does not belong to the client",
                            "Lease agreement pages outstanding",
                            "Secondary customers Proof of address outstanding",
                            "Proof of address provided is not an acceptable means of verification",
                            "Proof of address for declarant (Absa 3874)outstanding",
                            "Proof of address does not state client is working there",
                            "Date verified not updated",
                            "Exempted date not on cif",
                            "Source of income does not correspond to Employment status",
                            "Source of funds not declared",
                            "Document scanned under incorrect tab.",
                            "Reason for using cosmetic change not acceptable",
                            "Sanctions fail CASA screening incorrect.",
                            "Resolution incomplete/outstanding",
                            "Constitution incomplete/ outstanding",
                            "Participants supporting documents outstanding.",
                            "Independent official signature outstanding.",
                            "Please note id doc is not validated- Remote Opening",
                            "Date issue on ID does not correspond with CIF",
                            "All blocks not ticked on validated passport- Remote Opening",
                            "Date issue outstanding on Identification document",
                            "Date of issue on id does not correspond with cif",
                            "Temp res declaration outstanding",
                            "Application form is not signed (Fail Customer agreement form)",
                            "Application form not signed by two witnesses (illiterate)",
                            "Incorrect documents acknowledged on CASA",
                            "Date Identify and verified id not updated",
                            "Remote opening documents are outstanding (Application Pages)",
                            "Declaration of marriage status not signed",
                            "Document not signed at amendment",
                            "Absa Form amendment not signed",
                            "Primary Customer ID Document Unclear"    
                        ];
                        */
        
        var temeReasons;
        if(docType == 'Proof of identification'){
            temeReasons = [ '','Primary Customer ID Document Unclear' , 'Primary Customer ID Not Certified',
                           'Primary Customer ID Photo Unclear' ,  'Primary Customer ID Outstanding', 'Primary Customer ID Doc Not Barcoded',              
                           'Primary Customer Passport Photo Unclear' , 'Primary Customer Passport Expired', 'Primary Customer Passport Has No Expiry Date',
                           'Id Required If Client Older Than 18 Years','ID Document not compliant','Commissioner Of Oaths Designation Not Stated',
                           'No Documents To Be Acknowledged',                  
                           'Name On Id Does Not Correspond With Cif',           
						   'Related Party/s ID Outstanding',
                           'No Client information on HANIS',
                           'Marriage/ Divorce Certificate Outstanding',    
                           'Reason For Accept Secondary Means Of Id Not Recorded',    
                           'Birth Certificate Outstanding',                     
                           'The Date Of Issue On The I.D. Does Not Correspond', 
                           'Secondary Proof Of Identification Used - No Reason',
                           'Executor Id Outstanding',                          
                           'Executor Id Non Conforming',                        
                           'Documents Not Signed At Amendments',                
                           'Guardians Id Outstanding',                          
                           'Not Parent Or Guardian That Opened The Account'];
        }else if(docType == 'Proof of Address'){
            temeReasons = [ '','Absa 3121 Incomplete / Completed Incorrectly', 'Absa 3122 Incomplete / Completed Incorrectly',
                            'Absa 3122 Relationship Not Completed' ,
                            'Absa 3122 Not Certified By Commissioner Of Oath',   
                            'Absa 3122 Not Signed By Client',                    
                            'Absa 3122 Not Signed By Third Party Declarant',     
                            'Absa 3874 Incomplete / Completed Incorrectly',
                            'Application Form Not Accepted As Prf Of Add',       
                            'Cert Of Ownership Not Accepted As Prf Of Add',      
                            'Cif Printout Not Acceptable As Proof Of Address',   
                            'Commissioner Of Oaths Address Not Stated',          
                            'Commissioner Of Oaths Designation Not Stated',      
                            'Delivery Note Not Accepted As Prf Of Add',          
                            'Documents Not Signed At Amendments',                
                            'Executors Proof Of Address Non Conforming',         
                            'Executors Proof Of Address Oustanding',             
                            'Guardians Prf Of Add Outstanding',                  
                            'Lease Agreement - All Pages Not Received',      
                            'Lease Agreement - Has No Residential Address Verified',   
                            'Lease Agreement - Has No Termination Date',           
                            'Lease Agreement - Not Certified On All Pages',        
                            'Lease Agreement Expired',                           
                            'Letter From Employer Non-Compliant',     
                            'Letter From Est Agent Non-Compliant',        
                            'Letter From Municipality Non-Compliant',
                            'Medical Account Not Accepted As Prf Of Add',      
                            'No Documents To Be Acknowledged',                   
                            'No Fsp Number On Prf Of Add',
                            'No Name On Proof Of Address To Verify Client',      
                            'No Ncr Number On Prf Of Add',   
                            'Occupation Letter Not Accepted As Prf Of Add',      
                            'Po Box Not Accepted As Prf Of Add',                    
                            'Postdated Prf Of Add Not Accept', 
                            'Prf Of Add For All Trustees Oustanding',            
                            'Prf Of Add For Declarant (Absa3874) Outstanding',   
                            'Prf Of Add For Executor Outstanding',               
                            'Prf Of Add Not In Business Name',                   
                            'Prf Of Add Not In Guardians Name',                  
                            'Prf Of Add Not In Primary Customers Name',          
                            'Prf Of Add Only In One Clients Name',               
                            'Prim Cust Prf Of Add Not Correspond To Cif',        
                            'Primary Cust Payslip Not Accept As Prf Of Add',        
                            'Primary Customer Prf Of Add Has No Dates To Verify',
                            'Primary Customer Prf Of Add Non Conforming',        
                            'Primary Customer Prf Of Add Not Certified',         
                            'Primary Customer Prf Of Add Older Than 3 Months',   
                            'Primary Customer Prf Of Add Unclear',               
                            'Proof Of Address For Minor Outstanding',            
                            'Proof Of Address For Parent And Minor Non Conformi',
                            'Proof of Address Provided Non-Compliant',
                            'Secondary Prf Of Add Outstanding',
                            'Self Affidavit Not Accepted As Prf Of Add',         
                            'Title Deed Not Accept As Prf Of Add',
                            'Tribal Letter Not Stamped'];
        }else{
            temeReasons = [
                            '','Trust Deed Not Certified', 'Documents Not Applicable For Fic Centre',           
                            'Certification Stamp Not According Bus Rules',       
                            'Business Documents Not Certified',                  
                            'Proof Of Student Registration Outstanding',         
                            'Proof Of Student Registration Unacceptable Not',    
                            'Cost Of Course Fees Statement Outstanding',         
                            'Cost Of Course Fees Statement Unacceptable Not',    
                            'Academic Records Results Outstanding',              
                            'Academic Records Results Unacceptable Not Clear',   
                            'Lastest Payslip Is Required',
                            'Employment Confirmation Outstanding',               
                            'Declaration Of Marriage Status Outstanding',        
                            'Application Form Not Signed By Customer',           
                            'Application From Not Signed By Witnesses',
                            'Proof Of Income Is Post Dated',                     
                            'Bank Statement Outstanding',                        
                            'Bank Statement Unacceptable Not Clear',             
                            'Proof Of Income Outstanding',                       
                            'Proof Of Income Unacceptable Not Clear',            
                            'SOF Not Recorded / Recorded Incorrectly',                        
                            'Id & v dated not updated after 29/08/2009 of the fire.',
                            'The wording on the credit card quote is unclear.',
                            'Consultants signature & employee number outstanding on the credit card quote.',
                            'Witness signature & id number outstanding on the credit card quote.',
                            'Credit card quote is incomplete.',
                            'clients still on FIC control listing on option 7',
                            'clients still on FIC control listing on option 7 and soft lock not removed',
                            'latest 3 months proof of  income  not attached.',
                            'Credit card quotation form not attached',
                            'Credit card quotation form not signed', 
                            'Date identified not updated',
                            'Date verified not updated',
                            'client name not on bank statement', 
                            'Clients id number outstanding on the credit card quote'        
                         ];
        } 
        return temeReasons; 
    },
    
      //Function to show spinner when loading
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
    ,
    
    translateForDocumentUpload : function(docType){
        if(docType == 'Proof of identification'){
            return 'ProofOfId';
        }else if(docType == 'Proof of Address'){
            return 'ProofOfAddress';    
        }else if(docType = 'Proof of Income'){
            return 'ProofOfIncome';
        }else if(docType = 'Account application'){
            return 'AccountApplication';
        }else if(docType = 'Signing instructions'){
            return 'SigningInstructions';
        }else if(docType = 'Green barcoded ID'){
            return 'ProofOfId';
        }else {
            return docType; 
        }
    }
})