({
    //Helper Class
    fetchCompliancePackResponse: function (component) {
         var objectId = component.get("v.recordId");
        var action = component.get("c.getcomplianceData");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.message == null){
                    component.set("v.CompliancenxtRefreshDate", data.nextRefreshDate);
                    var obj = data.NADashboardValues;
                    component.set("v.NANextRefreshDate", obj['Next Refresh Date'] );          
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        var objectId = component.get("v.recordId");
        //var objectId = "0017Z00001K2fLNQAZ";
        
        var tdydt = new Date();
        var dateStp = $A.localizationService.formatDate(tdydt,"yyyy/MM/dd, hh:mm:ss a"); 
        component.set("v.dateStamp",dateStp);
        
        this.refreshData(component);
        
        var action = component.get("c.getData"); 
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                    component.set("v.clientAcctInfo",data.clientAcc); 
                    component.set("v.clientAcctAddrs",data.clientAccAddr);
                    component.set("v.clientProdInfo",data.clientProd);
                    //component.set("v.riskRatingVal",data.riskRating); 
                    component.set("v.clientRelatedData",data.relatedParties);
                    
                    var addr = component.get("v.clientAcctAddrs");
                    var busAddr = true, postalAddr = true, regAddr = true ,headOfcAddr = true ,employersAddr = true, physicalAddr = true ,residentialAddr = true;
                    for(var i=0; i<addr.length;i++){
                        if(addr[i].Address_Type__c == 'Business Address' && busAddr){
                            this.populateAddress(component,event,addr[i]);
                            component.set("v.busAddr",component.get("v.commonAddress"));
                            busAddr = false;
                        }
                        if(addr[i].Address_Type__c == 'Postal' && postalAddr){
                            this.populateAddress(component,event,addr[i]);
                            component.set("v.postalAddr",component.get("v.commonAddress"));
                            postalAddr = false;
                        }
                        if(addr[i].Address_Type__c == 'Registered' && regAddr){
                            this.populateAddress(component,event,addr[i]);
                            component.set("v.regAddr",component.get("v.commonAddress"));
                            regAddr = false;
                        }
                        if(addr[i].Address_Type__c == 'Head Office' && headOfcAddr){
                            this.populateAddress(component,event,addr[i]);
                            component.set("v.headOfcAddr",component.get("v.commonAddress"));
                            headOfcAddr = false;
                        }
                        if(addr[i].Address_Type__c == 'Employers' && employersAddr){
                            this.populateAddress(component,event,addr[i]);
                            component.set("v.employersAddr",component.get("v.commonAddress"));
                            employersAddr = false;
                        }
                        if(addr[i].Address_Type__c == 'Physical Address' && physicalAddr){
                            this.populateAddress(component,event,addr[i]);
                            component.set("v.physicalAddr",component.get("v.commonAddress"));
                            physicalAddr = false;
                        }
                        if(addr[i].Address_Type__c == 'Residential' && residentialAddr){
                            this.populateAddress(component,event,addr[i]);
                            component.set("v.residentialAddr",component.get("v.commonAddress"));
                            residentialAddr = false;
                        }
                    }
                    component.set('v.clientRelatedColumns', [               
                        { label: 'First Name', fieldName: 'FirstName', type: 'text' },
                        { label: 'Last Name', fieldName: 'LastName', type: 'text' },
                        { label: 'ID Number', fieldName: 'IDNumber', type: 'text' },
                        { label: 'Share Percentage', fieldName: 'SharePercentage', type: 'text' },
                        { label: 'Roles', fieldName: 'Roles', type: 'text' },
                    ]);
                    var accRec = component.get("v.clientAcctInfo");
                    if (accRec.Client_Type__c == 'Individual' || accRec.Client_Type__c =='Individual - Minor' || accRec.Client_Type__c == 'Non - Resident Entity' || accRec.Client_Type__c == 'Private Individual' || accRec.Client_Type__c == 'Staff' || accRec.Client_Type__c == 'Staff Joint and Several'){
                        component.set("v.cltPartAcc",'Yes');
                        component.set("v.isIndividual",true);
                    }else if(accRec.Client_Type__c == 'Joint & Several'){
                        component.set("v.isJointEntity",true);
                    }else{
                        component.set("v.isNonIndividual",true);
                    }
                }
          }
          else {
               console.log("Failed with state: " + state);
          }
          component.set("v.showSpinner", false);
     });
     $A.enqueueAction(action);
 },
                        
   	refreshData: function(component, event, helper) {
		
        var accId;
		accId = component.get("v.recordId") //when the component is on the Account form
		var UBOdetails;
		var action = component.get("c.getRelatedParties");
		action.setParams({"accountId" : accId});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state == "SUCCESS")
			{
			
				var data = response.getReturnValue();
				var temojson1 = JSON.parse(JSON.stringify(data).split('Accwrplist').join('_children').split('childwrplist').join('_children'));
				component.set('v.gridData',  JSON.parse(temojson1)); 
				this.sortData(component);
				console.log('The Related Part data :'+temojson1);
			}else {
			console.log ('error');
			}
			
			var columns = [
			{
			type: 'text',
			fieldName: 'Shareholder',
			label: 'Shareholder',
			initialWidth: 200
			},
			{
			type: 'text',
			fieldName: 'Type',
			label: 'Type'
			},
			{
			type: 'number',
			fieldName: 'ShareholderCount',
			label: 'Shareholder Count'
			},
			{
			type: 'decimal',
			fieldName: 'ParentShareholding',
			label: 'Parent Shareholding',
			sortable: true
			},
			{
			type: 'decimal',
			fieldName: 'Controllinginterest',
			label: 'Controlling interest'
			},
			{
			type: 'text',
			fieldName: 'UBO',
			label: 'UBO'
			}
			];
					  
			component.set('v.gridColumns', columns);
		
		});
	
		$A.enqueueAction(action);
	},
        sortData: function (component, fieldName, sortDirection) {
            var data = component.get("v.gridData");
            var reverse = sortDirection !== 'desc';
            data.sort(this.sortBy(fieldName, reverse));
            component.set("v.gridData", data);
        },
        sortBy: function (field, reverse, primer) {
            var key = primer ?
                function(x) {return primer(x[field])} :
            function(x) {return x[field]};
            reverse = !reverse ? 1 : -1;
            return function (a, b) {
                return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
            }
        },
                        
                        
                        
        fetchPicklistValues: function(component,objDetails,controllerField, dependentField,clientGrpFieldAPI) {
            var action = component.get("c.getDependentMap");
            action.setParams({
                'objDetail' : objDetails,
                'contrfieldApiName': controllerField,
                'depfieldApiName': dependentField,
                'cltGrpfieldApiName':clientGrpFieldAPI
            });
            action.setCallback(this, function(response) {
                if (response.getState() == "SUCCESS") {
                    var opts = [];
                    var allValues = response.getReturnValue().clientGrp;
                    if (allValues != undefined && allValues.length > 0) {
                        opts.push('--- None ---');
                    }
                    for (var i = 0; i < allValues.length; i++) {
                        opts.push(allValues[i]);
                    }
                    component.set("v.listClientGrpValues", opts);
                    
                    var StoreResponse = response.getReturnValue().ctrldepdt;
                    component.set("v.dependentFieldMap",StoreResponse);
                    
                    var listOfkeys = []; 
                    var ControllerField = [];
                    
                    for (var singlekey in StoreResponse) {
                        listOfkeys.push(singlekey);
                    }
                    
                    if (listOfkeys != undefined && listOfkeys.length > 0) {
                        ControllerField.push('--- None ---');
                    }
                    
                    for (var i = 0; i < listOfkeys.length; i++) {
                        ControllerField.push(listOfkeys[i]);
                    }  
                    component.set("v.listControllingValues", ControllerField);
                }
                
                else{
                    alert('Something went wrong..');
                }
            });
            $A.enqueueAction(action);
        },
                            
        fetchDepValues: function(component, ListOfDependentFields) {
            var dependentFields = [];
            dependentFields.push('--- None ---');
            for (var i = 0; i < ListOfDependentFields.length; i++) {
                dependentFields.push(ListOfDependentFields[i]);
            }
            component.set("v.listDependingValues", dependentFields);
            
        },
        generateAttdoc: function (component) {
            component.set("v.showSpinner", true);
            var objectId = component.get("v.recordId"); 
            // var objectId = "0017Z00001K2fLNQAZ";
            // var tempName = component.get("v.documenttemplate");
            var tempName="Attestation";
            var action = component.get("c.attDocument"); 
            action.setParams({
                "accountId": objectId,
                "templateName": tempName
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    data.forEach(function (data) {
                        data.ownerName = data.Owner.Name;
                        data.Account__c = data.Account__r.Name;
                    });
                    
                    
                    component.set("v.dataAudit", data);
                    console.log("Success with state: " + state);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Document Generated Successfully",
                        "type":"success"
                    });
                    toastEvent.fire();
                    component.set("v.isShowUploadBtn", true);
                    component.set("v.isGenerateButton", true);
                    component.set("v.isCheckedButton", true);
                    
                    component.set("v.isShowDocuments", true);
                    // alert('GeneratedData-->'+JSON.stringify(component.get("v.dataAudit")));
                    
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error with Generating the Document",
                        "type":"error"
                    });
                    toastEvent.fire();
                    component.set("v.errorMessageViewDocuments", "Error in fetchAuditData method. Error message: " + JSON.stringify(errors));
                } else {
                    component.set("v.errorMessageViewDocuments", "Unknown error in fetchAuditData method. State: " + state);
                }
                component.set("v.showSpinner", false);
                
            });
            $A.enqueueAction(action); 
        },
                                    
        downloadDoc: function (component,row) {
            component.set("v.showSpinner", true);
            var action = component.get("c.getDocContent");
            var doctId = component.get("v.docId");
            action.setParams({
                documentId: row.Id
            });
            action.setCallback(
                this,
                $A.getCallback(function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var data = response.getReturnValue();
                        //alert('data'+JSON.stringify(data))
                        var element = document.createElement("a");
                        element.setAttribute("href", "data:application/octet-stream;content-disposition:attachment;base64," + data);
                        element.setAttribute("download",row.Name);
                        element.style.display = "none";
                        document.body.appendChild(element);
                        element.click();
                        document.body.removeChild(element);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": "Document Downloaded Successfully",
                            "type":"success"
                        });
                        toastEvent.fire();
                    } else {
                        console.log("Download failed ...");
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Error with Downloading the Document",
                            "type":"error"
                        });
                        toastEvent.fire();
                    }
                    component.set("v.showSpinner", false);
                })
            );
            $A.enqueueAction(action);
        },
                                        
        fetchAuditData: function (component,event,helper) {
            component.set("v.showSpinner", true);
            var action = component.get("c.getdocuments");
            var fetchdatavalues=[];
            action.setParams({
                accountId: component.get("v.recordId") 
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var data = response.getReturnValue();
                    
                    //alert('Uploaded Data-->'+JSON.stringify(data));
                    
                    data.forEach(function (data) {
                        data.ownerName = data.Owner.Name;
                        data.Account__c = data.Account__r.Name;
                    });
                    console.log("Success with state: " + state);
                    fetchdatavalues = component.get("v.dataAudit"); // Generated Document content
                    for (var i = 0; i < data.length; i++) {
                        fetchdatavalues.push(data[i]);                // Uploaded Document content 
                    }
                    
                    component.set("v.dataAudit", fetchdatavalues);
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Document Uploaded Successfully",
                        "type":"success"
                    });
                    toastEvent.fire();
                    component.set("v.isUploadButton", true);
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    component.set("v.errorMessageViewDocuments", "Error in fetchAuditData method. Error message: " + JSON.stringify(errors));
                } else {
                    component.set("v.errorMessageViewDocuments", "Unknown error in fetchAuditData method. State: " + state);
                }
                component.set("v.showSpinner", false);
                
            });
            $A.enqueueAction(action); 
        }, 
    /*  emailSharing: function (component,clientemail,row) {
        component.set("v.showSpinner", true);
        // alert('RecordId'+JSON.stringify(component.get("v.recordId")));
        var rows = component.get('v.data');
        var action = component.get("c.DocumentSharingEmail");
        action.setParams({
            "accountId": component.get("v.recordId"),
            "clientEmail": clientemail,
            "idListJSON": row.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Document Successfully Emailed to the Client.",
                    "type":"success"
                });
                toastEvent.fire();
            component.set('v.isemailShare',false);
            component.set("v.isAttSuccess", true);
            }
            else {
                console.log("Failed with state: " + state);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error with Emailing Documents to the Client.",
                    "type":"error"
                });
                toastEvent.fire();
            }
             
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    }, */
            populateAddress : function(component, event, address) {
                var addressString;
                component.set("v.commonAddress",'');
                if(address.Shipping_Street__c != null && address.Shipping_Street__c != ''){
                    addressString = address.Shipping_Street__c+', ';
                }
                if(address.Shipping_Suburb__c != null && address.Shipping_Suburb__c != ''){
                    addressString = addressString + address.Shipping_Suburb__c+', ';
                }
                if(address.Shipping_City__c != null && address.Shipping_City__c != ''){
                    addressString = addressString + address.Shipping_City__c +', ';
                }
                if(address.Shipping_Country__c != null && address.Shipping_Country__c != ''){
                    addressString = addressString + address.Shipping_Country__c+', ';
                }
                if(address.Shipping_Zip_Postal_Code__c != null && address.Shipping_Zip_Postal_Code__c != ''){
                    addressString = addressString + address.Shipping_Zip_Postal_Code__c+', ';
                }
                addressString = addressString.replace(/,\s*$/, "");
                component.set("v.commonAddress",addressString);
            },
                            
 })