({
    doInit: function(component, event, helper) {
    var getRequestJSONAction = component.get('c.getKofaxScanningRequestMetadata')
    var RecordId  = component.get('v.recordId');
    var comments  = component.get('v.comments');
    var applicationNumber  = component.get('v.ccApplicationNumber');
    getRequestJSONAction.setParams({
      'accountID' : RecordId,
      'comments' : comments,
      'ccApplicationNumber' : applicationNumber,
   });
   getRequestJSONAction.setCallback(this, function(response) {
       var RequestMetadata = response.getReturnValue();
      var RequestMetadataObject = JSON.parse(RequestMetadata);
      component.set('v.CustomerId',RequestMetadataObject.CustomerID)
      component.set('v.RequestJSON',RequestMetadata)
  });
  $A.enqueueAction(getRequestJSONAction);
  },
  HandleResponse : function(component, event, helper)
  {
    var ResponseMetadata = event.getParam('responseMetadata');
    component.set('v.KofaxResponse',ResponseMetadata) ;
  },
  });