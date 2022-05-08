({
  doInit: function (component, event, helper) {
      // { label: "ECM Item Type", fieldName: "ECM_Type__c", type: "Text" },
    component.set("v.docListColumns", [
      { label: "Document Type Requested", fieldName: "Type__c", type: "Text",wrapText: true }, 
      { label: "Document Selected", fieldName: "linkName", type: "url",typeAttributes: {label: { fieldName: 'Type__c' }, target: '_blank'},wrapText: true },  
      { label: "Required", fieldName: "Required__c", type: "Text" },
      {
        label: "Source System",
        fieldName: "Source_System__c",
        type: "text",
        wrapText: true
      },
      {
        label: "Status",
        fieldName: "Document_Status__c",
        type: "text",
        wrapText: true
      },
      { label: "History", fieldName: "LastModifiedDate", type: "date",
        typeAttributes:{
            year: "numeric",
            month: "long",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit"
        }}
    ]);
	component.set("v.realetedPartydocListColumns", [
      { label: "Document Type Requested", fieldName: "Type__c", type: "text", wrapText: true },
      { label: "ECM Item Type", fieldName: "ECM_Type__c", type: "Text" },
      { label: "Required", fieldName: "Required__c", type: "Text" },
      {
        label: "Source System",
        fieldName: "Source_System__c",
        type: "text",
        wrapText: true
      },
      {
        label: "Status",
        fieldName: "Document_Status__c",
        type: "text",
        wrapText: true
      },
      { label: "History", fieldName: "LastModifiedDate", type: "date" }
    ]);
    helper.getMainEntityMandatoryDocs(component, event, helper);
   // helper.getRelatedEntityMandatoryDocs(component, event, helper);
   // helper.getRelatedEntityMandatoryDocsforAccount(component, event, helper);
   //	helper.getRelatedEntityMandatoryDocsforCase(component, event, helper);
  },

  UpdateSelectedRows: function (component, event, helper) {
    var selectedRows = event.getParam("selectedRows");
    if (selectedRows.length > 1) {
      component.set(
        "v.docsSelected",
        selectedRows.length + " documents selected"
      );
      component.set("v.displayDocsListFooter", true);
    } else if (selectedRows.length == 1) {
      component.set(
        "v.docsSelected",
        selectedRows.length + " document selected"
      );
      component.set("v.displayDocsListFooter", true);
    } else {
      component.set("v.displayDocsListFooter", false);
    }
  },

  selectedRows: function (component, event, helper) {},

  sendForSignature: function (component, event, helper) {},

  clearSelected: function (component, event, helper) {
      //clear selection
      var clearRows =[];
      component.set("v.selectedRows",clearRows);
      component.set("v.docsSelected",'');
  },

  shareDocuments: function (component, event, helper) {},

  refreshDocumentsList: function (component, event, helper) {
    helper.getMainEntityMandatoryDocs(component, event, helper);
   // helper.getRelatedEntityMandatoryDocsforAccount(component, event, helper);
    //helper.getRelatedEntityMandatoryDocsforCase(component, event, helper);
  },
    refreshDocuments: function(component, event, helper) {
        
        helper.getRelatedEntityMandatoryDocs(component);
       // helper.refresh(component);
        
    },


});