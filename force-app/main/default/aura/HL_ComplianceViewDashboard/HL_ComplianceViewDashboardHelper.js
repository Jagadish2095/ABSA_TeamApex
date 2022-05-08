({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb

    callCIFService: function (component) {
       component.set("v.showConflictSpinner", true);
        var objectId = component.get("v.recordId");
        var CIFAddress = component.get("v.selectedCIFAddress");
        var gsAddress = component.get("v.selectedGoldenSourceAddress");

        if( CIFAddress != null ){
            var address1 = component.get("v.addressName1");
            var address2 = component.get("v.addressName2");
            var suburbName = component.get("v.suburbName");
            var cityName = component.get("v.cityName");
            var countryName = component.get("v.countryName");
            var postalCode = component.get("v.postalCode");
            var indicator = 'Y';
        }else if( gsAddress != null ){
            var address1 = component.get("v.gAddressName1");
            var address2 = component.get("v.gAddressName2");
            var suburbName = component.get("v.gSuburbName");
            var cityName = component.get("v.gCityName");
            var countryName = component.get("v.gCountryName");
            var postalCode = component.get("v.gPostalCode");
            var indicator = 'U';
        }
        var action = component.get("c.updateCIF");
        action.setParams({
            "objectId": objectId,
            "address1": address1,
            "address2": address2,
            "suburbName": suburbName,
            "cityName": cityName,
            "countryName": countryName,
            "postalCode": postalCode,
            "indicator": indicator
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(respObj != null && respObj != undefined &&  respObj !=''){
                    component.set("v.showConflictSpinner", false);
                    var message = respObj.CIupdClientAttestationV20Response.outputArea.message;
                    var type= 'success';
                    this.showToast(component, event, message, type);
                    component.set('v.isModalOpen',false);
                }else if(data == null){
                    component.set("v.showConflictSpinner", false);
                    var message = 'CIF Update Service Failed!';
                    var type= 'error';
                    this.showToast(component, event, message, type);
                }
            }else{
                console.log("Failed with state: " +state);
                component.set("v.showConflictSpinner", false);
                var errors = response.getError();
                var message = errors[0].message;
                var type= 'error';
                this.showToast(component, event, message, type);
            }
        });
         $A.enqueueAction(action);

    },


//helper method which will call the compliance pack service and gets the compliance information
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        var objectId = component.get("v.recordId");
        var action = component.get("c.getData");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.message == null){
                    component.set("v.sbuSegment",  data.sbuSegment);
                    component.set("v.idNum", data.IDNum);
                    component.set("v.healthStatus", data.complianceStatus);
                    component.set("v.riskRating", data.riskRating);
                    component.set("v.fullName", data.fullName);
                    component.set("v.IDNumber", data.IDNumber);
                    component.set("v.partyType", data.partyType);
                    component.set("v.partySubType", data.partySubType);
                    component.set("v.Title", data.titleMap[data.fullName]);
                    component.set("v.nextRefreshDate", data.nextRefreshDate);
                    component.set("v.FICLockStatus", data.FICLockStatus);
                    component.set("v.missingData", data.missingData);
                    component.set("v.missingDocuments", data.MissingDocuments);
                    component.set("v.FICAAddressAttestedDate", data.FICAAddressAttestedDate);
                    component.set("v.IdentificationAttestedDate", data.IdentificationAttestedDate);
                    if(data.FICAAddressAttestedDate >= data.IdentificationAttestedDate){
                        component.set("v.lastRefreshDate",  data.IdentificationAttestedDate )
                    }  else{
                        component.set("v.lastRefreshDate",  data.FICAAddressAttestedDate)
                    }
                    component.set("v.PEPStatus", data.PEPStatus);
                    component.set("v.partyRelationship", data.partyRelationship);
                    component.set("v.occupation", data.occupation);
                    component.set("v.purposeOfAccount", data.purposeOfAccount);
                    component.set("v.sourceOfFunds", data.sourceOfFunds);
                    component.set("v.notificationSent", data.notificationSent);
                    component.set("v.daysDue", data.daysDue);
                    component.set("v.expectedTransactionActivity", data.expectedTransactionActivity);
                    component.set("v.addressName1", data.addressName1);
                    component.set("v.addressName2", data.addressName2);
                    component.set("v.suburbName", data.suburbName);
                    component.set("v.cityName", data.cityName);
                    component.set("v.countryName", data.countryName);
                    component.set("v.postalCode", data.postalCode);
                    var cifAddress = [];
                    cifAddress.push({
                        label: data.cifAddress,
                        value: 'CIF'
                    });
                    component.set("v.cifAddresses", cifAddress);
                    component.set("v.clientSearchResultColumns", data.DataLightning);
                    component.set("v.IsRBBBanker", data.IsRBBBanker);
                    component.set("v.gAddressName1", data.gAddressName1);
                    component.set("v.gAddressName2", data.gAddressName2);
                    component.set("v.gSuburbName", data.gSuburbName);
                    component.set("v.gCityName", data.gCityName);
                    component.set("v.gCountryName", data.gCountryName);
                    component.set("v.gPostalCode", data.gPostalCode);
                    var goldenSourceAddress = [];
                    goldenSourceAddress.push({
                        label: data.goldenSourceAddress,
                        value: 'goldenSource'
                    });
                    component.set("v.goldenSourceAddresses", goldenSourceAddress);

        			this.getImageInfo(component);
                }else if(data != null && data.message != null){
                    component.set("v.dataFound", false);
                    var errors = data.message;
                    component.set("v.showSpinner", false);
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors);
                }else{
                    component.set("v.dataFound", false);
                    var errors = 'There is no data found for this Account';
                    component.set("v.showSpinner", false);
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors);
                }
            }
            else{
                console.log("Failed with state: " +state);
                component.set("v.dataFound", false);
                component.set("v.showSpinner", false);
                component.set("v.showError",true);
                var errors = response.getError();
                component.set("v.errorMessage",errors[0].message);
            }
        });
        $A.enqueueAction(action);

    },

//Helper function that will get us the profile pic that is to be displayed on the dashboard.
    getImageInfo: function(component) {
        var action = component.get("c.callHanisService");
        var idNo = component.get("v.idNum");
        action.setParams({
            idNumber: idNo
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var message = "";
            if (component.isValid() && state === "SUCCESS") {
                var respObjHanis = JSON.parse(response.getReturnValue());
                if (respObjHanis.statusCode == 200) {
                    var src = "data:image/png;base64, ";
					src += respObjHanis.image;
                    component.set("v.image", src);
                }else{
                    var msg = 'Profile Picture Download Failed! ';
                	var type= 'error';
                    this.showToast(component, event, msg, type);
                }
            }else{
                var errors = response.getError();
                component.set("v.errorMessage",errors[0].message);
                var msg = 'The image download failed as, '+errors[0].message;
                var type= 'error';
                this.showToast(component, event, msg, type );
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);

    },

//Used to get the Account Field Set to determine which Client results columns to display
//We are already getting the Fica Requirements details from FetchData helper method so we have commented the aura handler
    getClientFieldSet: function(component, event) {
        var objectId = component.get("v.recordId");
        var action = component.get("c.getTableFields");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.clientSearchResultColumns", response.getReturnValue());
            } else if (state === "ERROR") {
                var msg = 'There was an error while fetching FICA Requirements';
                var type = 'error';
                this.showToast(component, event, msg, type );
            }

        });
        $A.enqueueAction(action);
    },

//Function which calls the big form to update the missing data
    callSaveComp : function(component, event, helper){
        var recId = component.get("v.recordId");
        var evt = $A.get("e.force:navigateToComponent");
        console.log('Event '+evt);
        evt.setParams({
            componentDef : "c:ContinueWithOnboarding" ,
            componentAttributes : {
                recordId : recId
            }
        });
        evt.fire();
    },


//function which will upload the document from the dashboard to AMBER
     uploadHelper: function(component, event) {
        component.set("v.showSmallSpinner", true);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showSmallSpinner", false);
            component.set("v.fileName", 'Alert : File Size Cannot Exceed ' + self.MAX_FILE_SIZE + ' Bytes.\n' + ' Selected File Size: ' + file.size);
            return;
        }
        var objFileReader = new FileReader();

        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
    },

    uploadProcess: function(component, file, fileContents) {
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '', (startPosition + this.CHUNK_SIZE) > fileContents.length);
    },

    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, isDone) {
        // call the apex method 'saveInChunk'
        //alert('inside upload chunk, isdone value is --> '+isDone);
        //alert('inside upload chunk, attachid value is --> '+attachId);
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveInChunk");
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            done: isDone,
            documentType: component.get("v.fileType")
        });

        // set call back
        action.setCallback(this, function(response) {
            // store the response/Attachment Id
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion
                // then call again 'uploadInChunk' method ,
                // else, display alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId, startPosition + this.CHUNK_SIZE > fileContents.length);
                } else {
                    var msg = 'The File Has Been Uploaded Successfully !!!';
                    this.showSuccessToast(component, event, msg);
                    component.set("v.isTrue",false);
                    component.set("v.showSmallSpinner", false);
        			component.set("v.fileName", 'No File Selected..');
                }
                // handle the response errors
            } else if (state === "INCOMPLETE") {
                alert("From Server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },

    showSuccessToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": message
        });
        toastEvent.fire();
    },

    showToast : function(component, event, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "message": message
        });
        toastEvent.fire();
    },

/**
* @description download function to download file from AMBER.
**/
    download: function (cmp, row) {
        var objectId = cmp.get("v.recordId");
        var action = cmp.get("c.getUploadedDoc");
        cmp.set("v.showSmallSpinner", true);

        action.setParams({
            parentId : objectId,
            documentType : row.missingDoc
        });
        action.setCallback(
            this,
            $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var msg = 'File Is Downloaded Succesfully !!!';
                   /* var jObj = JSON.stringify(response.getReturnValue());
                    console.log(jObj);
                    var obj = JSON.parse(jObj);
                    console.log(obj);
                    var data = obj.Data;
                    var fileName = obj.FileName; */
                    var obj = response.getReturnValue();
                    console.log('The data is : '+ obj['Data'] );
                    var element = document.createElement("a");
                    element.setAttribute("href", "data:application/octet-stream;content-disposition:attachment;base64," + obj['Data']);
                    element.setAttribute("download", obj['FileName']);
                    element.style.display = "none";
                    document.body.appendChild(element);
                    element.click();
                    document.body.removeChild(element);
                    cmp.set("v.showSmallSpinner", false);
      				this.showSuccessToast(cmp, event, msg);
                } else {
                    var errors = response.getError();
                	cmp.set("v.errorMessage",errors[0].message);
                    cmp.set("v.showSmallSpinner", false);
                    var msg = 'The download failed as, '+errors[0].message;
                    var type = 'error';
                    this.showToast(cmp, event, msg, type);
                }
            })
        );
        $A.enqueueAction(action);
    },

//redirect to Hl_clinetAttestation
    attestCustomer : function(component, event, helper){
          var recId = component.get("v.recordId");
          var navigateEvent = $A.get("e.force:navigateToComponent");

          navigateEvent.setParams({
              componentDef: "c:HL_ClientAttestation",
              componentAttributes : {
                    recordId : recId,
                    missingDocuments :component.get("v.missingDocuments"),
                    missingData :component.get("v.missingData"),
                    healthStatus :component.get("v.healthStatus"),
                    daysDue :component.get("v.daysDue")
               }

          });
          navigateEvent.fire();
      },
})