({
    /**
 * @description Set file size attributes.
 **/
  MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB
  CHUNK_SIZE: 750000, //Chunk Max size 750Kb
  /**
 * @description 
 * 
 *  function.
 **/
  upload: function(component, event, helper) {
      component.set("v.showLoadingSpinner", true);
      var fileInput = component.find("fileId").get("v.files");
      var file = fileInput[0];
      var self = this;
      if (file.size > self.MAX_FILE_SIZE) {
          component.set("v.showLoadingSpinner", false);
          component.set(
              "v.fileName",
              "Alert : File size cannot exceed " +
              self.MAX_FILE_SIZE +
              " bytes.\n" +
              " Selected file size: " +
              file.size
          );
          return;
      }
      var objFileReader = new FileReader();
      objFileReader.onload = $A.getCallback(function() {
          var fileContents = objFileReader.result;
          var base64 = "base64,";
          var dataStart = fileContents.indexOf(base64) + base64.length;
          fileContents = fileContents.substring(dataStart);
          self.uploadProcess(component, file, fileContents, helper);
      });
      objFileReader.readAsDataURL(file);
  },
  loadInfo : function(component, helper) {       
      this.showSpinner(component);
      
      var actionDocWrapper = component.get("c.getAccDocumentWrapper");
      actionDocWrapper.setParams({
          oppId: component.get("v.recordId")
      });

      actionDocWrapper.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS") {
              this.hideSpinner(component);
              var accDocWrapper = response.getReturnValue();
              component.set("v.accDocWrapper", response.getReturnValue());
              
              //Set EDD indicators
              var eddDocs = [];
              var isSeniorManagementSignOff;
              var isAdverseMediaReport;
              var isSourceOfFundsWealth;
              var isLicence;
              var documentWrapperData = []; // Added by Muvhuso
              var count = 0;
              
              for(var eachWrap in accDocWrapper) {
                  var data = []; // Added by Muvhuso
                  var tempWrapper = [];
                  var placeHolderWrapper = [];
                  
                  tempWrapper.Id = accDocWrapper[eachWrap].accName;
                  tempWrapper.Type__c = accDocWrapper[eachWrap].accName;
                  tempWrapper.isbutton = "slds-hide";
                  
                  if(accDocWrapper[eachWrap].isPrimary == true) {
                      if(accDocWrapper[eachWrap].docPlaceholderEddWrappers != null){
                         eddDocs =  accDocWrapper[eachWrap].docPlaceholderEddWrappers;
                         placeHolderWrapper = accDocWrapper[eachWrap].docPlaceholderWrappers.concat(eddDocs);
                      }else{
                         placeHolderWrapper = accDocWrapper[eachWrap].docPlaceholderWrappers; 
                      }
                     //break;
                  }else{
                     placeHolderWrapper = accDocWrapper[eachWrap].docPlaceholderWrappers;
                  } 
                  
                  //alert('Palce holder --->' + JSON.stringify(placeHolderWrapper));

                  var docMap = new Map();
                  console.log('Length --> ' + JSON.stringify(accDocWrapper[eachWrap].docPlaceholderWrappers.length));
                  for(var i = 0; i < placeHolderWrapper.length; i++){
                      //console.log('rec'+JSON.stringify(placeHolderWrapper[i].docPlaceholder));
                      if(placeHolderWrapper[i].docPlaceholder  != 'undefined' && placeHolderWrapper[i].docPlaceholder != undefined && placeHolderWrapper[i].docPlaceholder != null && placeHolderWrapper[i].docPlaceholder != ''){
                          //console.log('Inside ' + JSON.stringify(placeHolderWrapper[i].docPlaceholder));
                             if(placeHolderWrapper[i].docPlaceholder.Type__c != null){
                             //console.log('docMap '+docMap.get(placeHolderWrapper[i].docPlaceholder.Type__c) + '---' + placeHolderWrapper[i].docPlaceholder.Type__c + '-----' + placeHolderWrapper[i].docPlaceholder.Name);
                              if(docMap.get(placeHolderWrapper[i].docPlaceholder.Type__c) != placeHolderWrapper[i].docPlaceholder.Type__c){
                                  //console.log('docPlaceholder '+ JSON.stringify(placeHolderWrapper[i].docPlaceholder));
                                  //alert('placeHolderWrapper[i].docPlaceholder.Type__c '+placeHolderWrapper[i].docPlaceholder.Type__c + '' +  placeHolderWrapper[i].docPlaceholder.Reference__c);
                                  var tempData = [];
                                  tempData.Id = placeHolderWrapper[i].docPlaceholder.Id;
                                  tempData.Type__c = placeHolderWrapper[i].docPlaceholder.Type__c;
                                  tempData.Reference__c  = placeHolderWrapper[i].docPlaceholder.Reference__c;
                                  tempData.Account__c = placeHolderWrapper[i].docPlaceholder.Account__c;
                                  tempData.Contact__c = placeHolderWrapper[i].docPlaceholder.Contact__c;
                                  tempData.upload_disabled = placeHolderWrapper[i].docPlaceholder.Reference__c != undefined && placeHolderWrapper[i].docPlaceholder.Generated_Uploaded__c == 'Uploaded' ? true : false;
                                  tempData.generate_disabled = (placeHolderWrapper[i].docPlaceholder.Reference__c != undefined && (placeHolderWrapper[i].docPlaceholder.Generated_Uploaded__c == 'Generated' || placeHolderWrapper[i].docPlaceholder.Generated_Uploaded__c == 'Uploaded') || !placeHolderWrapper[i].docPlaceholder.Generate_Document__c) ? true : false;
                                  tempData.view_disabled = placeHolderWrapper[i].docPlaceholder.Reference__c != undefined ? false : true;
                                  tempData.delete_disabled = placeHolderWrapper[i].docPlaceholder.Reference__c != undefined ? false : true;
                                  data.push(tempData);
                               }
                              else if(docMap.get(placeHolderWrapper[i].docPlaceholder.Type__c) == placeHolderWrapper[i].docPlaceholder.Type__c && placeHolderWrapper[i].docPlaceholder.Generated_Uploaded__c == 'Generated' && placeHolderWrapper[i].docPlaceholder.Reference__c != undefined && data.length > 0){
                                  data.forEach(doc=>{
                                      if(doc.Type__c == placeHolderWrapper[i].docPlaceholder.Type__c){
                                      doc.generate_disabled = true;
                                      }
                                  });
                              }
                              docMap.set(placeHolderWrapper[i].docPlaceholder.Type__c , placeHolderWrapper[i].docPlaceholder.Type__c);

                             }  
                        }
                   }
                   tempWrapper._children = data;
                   documentWrapperData.push(tempWrapper); 
                   //documentWrapperData._children = data;
                   
                  //Flag EDD Docuemnts
                  if(accDocWrapper[eachWrap].isEddCase == true) {
                      component.set("v.isSeniorManagementSignOff",true);
                      component.set("v.isAdverseMediaReport",true);
                      component.set("v.isSourceOfFundsWealth",true);
                      component.set("v.eddSelection",'Y');
                      component.set("v.showEddSection", true);
                  }
                  
              }
              component.set("v.docData" , documentWrapperData);
              
           } else {
              var errors = response.getError();
              var toast = helper.getToast("Error", errors, "error");
              toast.fire();
              this.hideSpinner(component);
          }
      });
      $A.enqueueAction(actionDocWrapper);
  },
  
  getOppDetails : function(component, helper) {
      
      var actionDocWrapper = component.get("c.getOppRecord");
      actionDocWrapper.setParams({
          oppId: component.get("v.recordId")
      });

      actionDocWrapper.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS") {
              var oppRec = response.getReturnValue();
              if( oppRec.Account.The_Client_is_involved_in_High_Risk_Indu__c == 'CASINO\'S, GAMBLING BUSINESSES (INCLUDING INTERNET GAMBLING/BETTING/GAMING)' 
                 || oppRec.Account.The_Client_is_involved_in_High_Risk_Indu__c == 'MICRO FINANCE INSTITUTION (MFI)') {
                  component.set("v.eddSelection", 'Y');
                  component.set("v.showEddSection", true);
                  component.set("v.isLicence",true);
                  component.set("v.isSeniorManagementSignOff",true);
                  component.set("v.isAdverseMediaReport",true);
                  component.set("v.isSourceOfFundsWealth",true);
              }
           } else {
              var errors = response.getError();
              var toast = helper.getToast("Error", errors, "error");
              toast.fire();
              this.hideSpinner(component);
          }
      });
      $A.enqueueAction(actionDocWrapper);
  },
  
  saveInfo : function(component, helper) {
      helper.showSpinner(component);
      
      var seniorManagementSignOffVal = component.get("v.isSeniorManagementSignOff");
      var adverseMediaReportVal = component.get("v.isAdverseMediaReport");;
      var sourceOfFundsWealthVal = component.get("v.isSourceOfFundsWealth");; 
      var licenceVal = component.get("v.isLicence");;
      
      var action = component.get("c.updateDocuments");
      action.setParams({
          accDocWrapper: component.get("v.accDocWrapper"),
          oppId : component.get("v.recordId"),
          seniorManagementSignOff: seniorManagementSignOffVal,
          adverseMediaReport: adverseMediaReportVal,
          sourceOfFundsWealth: sourceOfFundsWealthVal,
          licence: licenceVal
      });

      action.setCallback(this, function(response){
          var state = response.getState();
          if (state === "SUCCESS") {
              var resultVal = response.getReturnValue();
              
              if(resultVal == 'SUCCESS') {
                  var toast = helper.getToast("Success", 'Documents updated!', "success");
                  toast.fire();
                  helper.loadInfo(component, helper); 
              } else {
                  var toast = helper.getToast("Error", 'An error occured: ' + resultVal, "error");
                  toast.fire();
              }
              this.hideSpinner(component);
           } else {
              var errors = response.getError();
              var toast = helper.getToast("Error", response, "error");
              toast.fire();
              this.hideSpinner(component);
          }
          
      });
      $A.enqueueAction(action);
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
  },
  
  //Lightning toastie
  getToast : function(title, msg, type) {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
          "title":title,
          "message":msg,
          "type":type
      });
      return toastEvent;
  },
  
    /**
 * @description upload files function.
 **/
  uploadProcess: function(component, file, fileContents, helper) {
      var startPosition = 0;
      var relatedPartyId = component.get("v.relatedPartyID");
      console.log("51 relatedPartyId " + relatedPartyId);
      // calculate the end size or endPostion using Math.min() function which is return the min. value
      var endPosition = Math.min(
          fileContents.length,
          startPosition + this.CHUNK_SIZE
      );
      // start with the initial chunk, and set the attachId(last parameter)is null in begin
      this.uploadInChunk(
          component,
          file,
          fileContents,
          startPosition,
          endPosition,
          "",
          startPosition + this.CHUNK_SIZE > fileContents.length,
          relatedPartyId,
          helper
      );
  },
  /**
 * @description upload chunks function.
 * Modied by Prashanth Boeni
 **/
  
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, isDone, event, relatedPartyId, helper) {
      var getchunk = fileContents.substring(startPosition, endPosition);
      var signedManually = false;

      var appOppId = component.get("v.applicationId");
      var recId = component.get("v.recordId");
        //if(isCAFApplication == true ){
        /*  if(component.get("v.applicationId").length > 0){  */
          var action = component.get("c.saveChunk");
          action.setParams({
              parentId: component.get("v.recordId"),
              oppApplicationId: appOppId,
              fileName: file.name,
              base64Data: encodeURIComponent(getchunk),
              contentType: file.type,
              fileId: attachId,
              done: isDone,
              documentType: component.get("v.fileType"),
              signedManually: signedManually,
              relatedPartyId: component.get("v.relatedPartyID"),
              fExt: component.get("v.fileExtension"),
              documentId : component.get("v.docId"),
              accountId : component.get("v.accountId") != undefined ? component.get("v.accountId") : null,
              contactId : component.get("v.contactId") != undefined ? component.get("v.contactId") : null,
          });
          action.setCallback(this, function(response) {
              attachId = response.getReturnValue();
              var state = response.getState();
              if (state === "SUCCESS") {
                  startPosition = endPosition;
                  endPosition = Math.min(
                      fileContents.length,
                      startPosition + this.CHUNK_SIZE
                  );
                  // check if the start position is still less then end position
                  // then call again 'uploadInChunk' method ,
                  // else, display alert msg and hide the loading spinner
                  if (startPosition < endPosition) {
                      this.uploadInChunk(
                          component,
                          file,
                          fileContents,
                          startPosition,
                          endPosition,
                          attachId,
                          startPosition + this.CHUNK_SIZE > fileContents.length,
                          relatedPartyId,
                          helper
                      );
                  } else {
                      component.set("v.fileName", "File is uploaded successfully");
                      component.set("v.showLoadingSpinner", false);
                      /*var compEvent = component.getEvent("refreshListEvent");
                  compEvent.fire();*/
                     //this.upload(component,helper);
                    /* var toastEvent = $A.get("e.force:showToast");
                          toastEvent.setParams({
                               "title": "Success!",
                               "message": component.get("v.fileType") + "is uploaded successfully.",
                               "type":"success"
                        });
                     toastEvent.fire();*/
                     this.loadInfo(component,helper);
                  }
                  // handle the response errors
              } else if (state === "INCOMPLETE") {
                  alert("From server: " + response.getReturnValue());
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
          $A.enqueueAction(action);
  },
    // Tinashe - New Document Generation
  generateNewDocument: function(component, event, helper , documentType, accountId, contactId,docId) {
      this.showSpinner(component);
      console.log("generateNewDocument");
      var action = component.get("c.generateNewDocument");
      action.setParams({
          "opportunityId": component.get("v.recordId"),
          "templateName": documentType, //component.get("v.fileType") // I have an issue with this template name use - Tinashe
          "accountId" : accountId != undefined ? accountId : null,
          "contactId" : contactId != undefined ? contactId : null,
          "documentId" : docId
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var result = response.getReturnValue();
              console.log("Response from generate document : " + JSON.stringify(result));
              if(result.success == "true")
              {
                  this.loadInfo(component,helper);
                  this.hideSpinner(component);
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      "title": "Success!",
                      "message": component.get("v.fileType") + " document successfully generated.",
                      "type":"success"
                  });
                  toastEvent.fire();
              } else {
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      "title": "Error!",
                      "message": "Error generating document " + component.get("v.fileType"),
                      "type":"error"
                  });
                  toastEvent.fire();
              }
          }
          else {
              console.log("Failed with state: " + state);
          }
      this.hideSpinner(component);
      });
      $A.enqueueAction(action);
  },
  getDocumentData : function (component, event,helper, docId)  {
     // alert(docId);
      this.showSpinner(component);
      var action = component.get("c.getDocumentContent");
      action.setParams({
          "docId": docId
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var data = response.getReturnValue();
              console.log('PDF DATA '+data);
              component.set("v.pdfData", data);
              component.set("v.isShowPreview",true);
          }
          else {
              console.log("Failed with state: " + state);
              var errors = response.getError();
              console.log('errors '+JSON.stringify(errors));
          }
      this.hideSpinner(component);
      });
      $A.enqueueAction(action);
  }
  ,
  restrictSystemDocs : function(component, event,helper,docId) {
      var action = component.get("c.restrictSystemDocs");  
      action.setParams({  
          "recordId":component.get("v.recordId"),
          "docId" : docId
      });      
      action.setCallback(this,function(response){  
          var state = response.getState();  
          if(state=='SUCCESS'){  
              var result = response.getReturnValue();  
              component.set("v.documentGenerated",result);
              
              if(result == 'System Generated'){
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      "title": "Error!",
                      "message": "Could not delete the system generated documents ",
                      "type":"error"
                  });
                  toastEvent.fire();
              }else{
                  this.deleteDocument(component, event,helper,docId);
              }
              
          }else {
              console.log("Failed with state: " + state);
              var errors = response.getError();
              console.log('errors '+JSON.stringify(errors));
          }
      });  
      $A.enqueueAction(action);  
  },
  deleteDocument : function(component, event,helper,docId) {  
      this.showSpinner(component);
      var action = component.get("c.deleteDocument");  
      action.setParams({  
          "recordId":component.get("v.recordId"),
          "docId" : docId
      });      
      action.setCallback(this,function(response){  
          var state = response.getState();  
          if(state=='SUCCESS'){  
              this.hideSpinner(component);
              var result = response.getReturnValue(); 
             // component.set("v.deleteDocument",result);
              var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      "title": "Success!",
                      "message": component.get("v.fileType") + " deleted successfully.",
                      "type":"success"
                  });
                  toastEvent.fire();
                  this.loadInfo(component,helper);
          }
          else {
              this.hideSpinner(component);  
              console.log("Failed with state: " + state);
              var errors = response.getError();
              console.log('errors '+JSON.stringify(errors));
          }
          
      });
      $A.enqueueAction(action);  
  }
  ,

  checkIfDocumentRestricted: function(component, event, helper, method, signatories , docId) {
      //component.set("v.showSpinner", true);
      console.log('inside537');   
      console.log('documentId-518'+component.get("v.documentId"));
      var action = component.get("c.documentRestricted");
      action.setParams({
          "opportunityId": component.get("v.recordId"),
          "documentId": docId //component.get("v.documentId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS" ) {
              if(response.getReturnValue()) {
                  component.set("v.inProgressOrSignedRequestExists", true);
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams ({
                      "title": "Error!",
                      "message": "This document cannot be submitted to Impression for E-Signature.",
                      "type": "error"
                  });
                  toastEvent.fire();
              }else if (method == 'sign') {
                  component.set("v.showESignatureDataTable", true);
                  this.fetchSignatories(component);
                  console.log('inside sign 540');
                  debugger;
              } else if (method == 'sendForSignature') {
                  console.log('ready to set signature 544');
                  debugger;
                  this.sendForSignature(component, signatories);
                  component.set("v.showESignatureDataTable", false);
                  debugger;
                  this.fetchImpressionRequest(component);
                  debugger;
              }
         }
          //component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
  },
  sendForSignature: function (component, signatoriesOutput) {
      component.set("v.showSpinner", true);
      var action = component.get("c.sendForImpressionSignature");
      action.setParams({
          "documentId": component.get("v.documentId"),
          "signatories": signatoriesOutput
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              //component.set("v.workflowId" , response.getReturnValue());
              var toastEvent = $A.get("e.force:showToast");
              toastEvent.setParams({
                  "title": "Success!",
                  "message": "Document sent to Impression for signing.",
                  "type":"success"
              });
              toastEvent.fire();
          }
          else {
              console.log("Failed with state: " + state);
          }
          component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
  },
  
  fetchSignatories: function (component , docId) {
      component.set("v.showSpinner", true);
      var action = component.get("c.getSignatoriesData");
      action.setParams({
          "documentId": component.get("v.documentId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var data = response.getReturnValue();
              console.log('data 538-'+data);
               debugger;
              if (data != null) { // Tinashe - W-005660 - Handle the error gracefully so it does not popup a Component error to user
                  component.set("v.signatoriesOutput", data);
                  console.log('data 542-'+component.get("v.signatoriesOutput"));
                  debugger;
                  for (var i = 0; i < data.length; i++) {
                      if (data[i].Mobile_Phone == '' || data[i].Email == '' || data[i].Title == '') {
                          // Tinashe - further coding downstream will fail if any one of these values is null
                          component.set("v.isButtonSignatureDisabled", true);
                      }  else {
                          if (component.get("v.isButtonSignatureDisabled") != true) {
                              component.set("v.isButtonSignatureDisabled", false);
                          }
                      }
                  }
              } else {
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      "title": "Error!",
                      "message": "Unable to sign the document - No signatory data found.",
                      "type":"error"
                  });
                  toastEvent.fire();
              }
          }
          else {
              console.log("Failed with state: " + state);
          }
          component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
  },
  fetchAllClientEmailsSignature: function (component) {
      var action = component.get("c.getAllClientEmailsSignature");
      action.setParams({
          "opportunityId": component.get("v.recordId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var data = response.getReturnValue();
              var opts = [];
              //Set first list value
              component.set("v.selectedEmail", data[0]);
              for (var i = 0; i < data.length; i++) {
                   opts.push({
                      class: "optionClass",
                      label: data[i],
                      value: data[i]
                  });
              }
              component.set("v.emailOptions", opts);
          }
      });
      $A.enqueueAction(action);
  },

  getMobile: function (component) {
      var action = component.get("c.getMobileDetails");
      action.setParams({
          "opportunityId": component.get("v.recordId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var data = response.getReturnValue();
              var opts = [];
              //Set first list value
              if (data.length > 0) {
                  component.set("v.selectedMobile", data[0]);
              }

              for (var i = 0; i < data.length; i++) {
                   opts.push({
                      class: "optionClass",
                      label: data[i],
                      value: data[i]
                  });
              }
              component.set("v.mobileOptions", opts);
          }
      });
      $A.enqueueAction(action);
  },
  
  fetchMethodPickListVal : function(component, fieldName, row) {
      var action = component.get("c.getDigitalSignatorySelectOptions");
          action.setParams({
          "fld": fieldName
      });

      var opts = [];
      action.setCallback(this, function(response) {
          if (response.getState() === "SUCCESS") {
              var data = response.getReturnValue();
              if (data != undefined && data.length > 0) {
                  opts.push({class: "optionClass", label: row.Method, value: row.Method});
                  for (var i = 0; i < data.length; i++) {
                      if(row.Method != data[i]) {
                          opts.push({class: "optionClass", label: data[i], value: data[i]});
                      }
                  }
              }
              component.set("v.methodOptions", opts);
          }
      });
      $A.enqueueAction(action);
  },
  fetchImpressionRequest: function (component) {

      var action = component.get("c.fetchImpressionRequest");
      action.setParams({
          "opportunityId": component.get("v.recordId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var records = response.getReturnValue();
              records.forEach(function(record){
                  record.linkName = '/'+record.Id;
              });
              component.set("v.data1", records);

          }
          else {
              console.log("Failed with state: " + state);
          }
          //component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
  },

  updateImpressionRequest: function (component) {

      var action = component.get("c.updateImpressionRequests");
      action.setParams({
          "opportunityId": component.get("v.recordId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
         
      });
      $A.enqueueAction(action);
  },
  //W-012954 - ANKA
  fetchSignatoriesSelected: function (component) {
      component.set("v.showSpinner", true);
      console.log('documentId-692-'+component.get("v.documentId"));
      console.log('selectedRowsIdsList-692-'+component.get("v.selectedRowsIdsList"));
      var action = component.get("c.getSignatoriesDataSelected");
      action.setParams({
          "documentId": component.get("v.documentId"),
          "acrRecs": component.get("v.selectedRowsIdsList")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state == "SUCCESS") {
              console.log('date 223'+response.getReturnValue());
              debugger;
              var data = response.getReturnValue();
              if (data != null) { // Tinashe - W-005660 - Handle the error gracefully so it does not popup a Component error to user
                  component.set("v.signatoriesOutputSelected", data);
                  console.log('signatoriesOutputSelected224'+component.get("v.signatoriesOutputSelected"));
                  debugger;
                  for (var i = 0; i < data.length; i++) {
                      if (data[i].Mobile_Phone == '' || data[i].Email == '' || data[i].Title == '') {
                          // Tinashe - further coding downstream will fail if any one of these values is null
                          component.set("v.isButtonSignatureDisabled", true);
                      }  else {
                          if (component.get("v.isButtonSignatureDisabled") != true) {
                              component.set("v.isButtonSignatureDisabled", false);
                          }
                      }
                  }
                  this.checkIfDocumentRestricted(component, event, this.helper, 'sendForSignature', JSON.stringify(component.get("v.signatoriesOutputSelected")),component.get("v.documentId"));
              } else {
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      "title": "Error!",
                      "message": "Unable to sign the document - No signatory data found.",
                      "type":"error"
                  });
                  toastEvent.fire();
              }
          }
          else {
              console.log("Failed with state: " + state);
          }
          component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
  },
  refreshSignatories: function (component) {
      component.set("v.showSpinner", true);
      var action = component.get("c.getSignatoriesData");
      action.setParams({
          "documentId": component.get("v.documentId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var data = response.getReturnValue();
              if(data != null){
              component.set("v.signatoriesOutput", data);
              for (var i = 0; i < data.length; i++) {
                  if (data[i].Mobile_Phone == '' || data[i].Email == '' || data[i].Title == '') {
                      // Tinashe - further coding downstream will fail if any one of these values is null
                      component.set("v.isButtonSignatureDisabled", true);
                  } else {
                      if (component.get("v.isButtonSignatureDisabled") != true) {
                          component.set("v.isButtonSignatureDisabled", false);
                      }
                  }
              }
              }else{
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      "title": "Error!",
                      "message": "Unable to refresh signatories - No signatory data found.",
                      "type":"error"
                  });
                  toastEvent.fire();
              }
          }
          else {
              console.log("Failed with state: " + state);
          }
          component.set("v.showSpinner", false);
      });
      $A.enqueueAction(action);
  },
  updateSignatories: function (component, signatoriesOutput) {
      component.set("v.showSpinner", true);
      console.log('documentId-518'+component.get("v.documentId"));
      debugger;
      var action = component.get("c.getUpdatedSignatoriesDataSelected"); //W-12954
      action.setParams({
          "opportunityId": component.get("v.recordId"),
          "documentId": component.get("v.documentId"),
          "signatoryId": component.get("v.signatoryId"),
          "signatoriesInput": signatoriesOutput,
          "method": component.get("v.selectedMethod"),
          "mobile": component.get("v.selectedMobileSignatory"),
          "email": component.get("v.selectedEmailSignatory"),
          "order": component.get("v.alternativeOrder") //W-12954
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var data = response.getReturnValue();
              component.set("v.signatoriesOutput", data);
              for (var i = 0; i < data.length; i++) {
                  if (data[i].Mobile_Phone == '' || data[i].Email == '' | data[i].Title == '') {
                      component.set("v.isButtonSignatureDisabled", true);
                  }  else {
                      if (component.get("v.isButtonSignatureDisabled") != true) {
                          component.set("v.isButtonSignatureDisabled", false);
                      }
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
  refreshDoc: function (component, helper) {
      this.loadInfo(component, helper);
  },
  
   //W-005661 - Anka Ganta - 2020-09-19
  getPrimayClientMandatoryDocs: function (component) {
      var OppId = component.get("v.recordId");

      var action = component.get("c.getPrimaryClientMandatoryDocuments");
      action.setParams({
          OppId: OppId
      });
      action.setCallback(this, function (response) {
          var state = response.getState();
          if (state === "SUCCESS") {
              var respmsg = response.getReturnValue();
              component.set("v.PrimaryClientMandDocs", respmsg);
              console.log("respmsg " + JSON.stringify(respmsg));
              console.log("length " + respmsg.length);
              if ((respmsg != null) & (respmsg.length >= 1)) {
                  var errormsgs = "";
                  var i;
                  for (i in respmsg) {
                      errormsgs += respmsg[i] + ";";
                  }
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      type: "error",
                      title: "",
                      message: errormsgs
                  });
                  //toastEvent.fire();
              } else {
                  var toastEvent = $A.get("e.force:showToast");
                  toastEvent.setParams({
                      title: "Success!",
                      message: "Primary Client mandatory Documents has been uploaded successfully.",
                      type: "success"
                  });
                  //toastEvent.fire();
              }
          } else if (state === "ERROR") {
              var errors = response.getError();
              if (errors) {
                  if (errors[0] && errors[0].message) {
                      console.log("Error message: " + errors[0].message);
                  }
              }
          }
      });
      $A.enqueueAction(action);
  },
})