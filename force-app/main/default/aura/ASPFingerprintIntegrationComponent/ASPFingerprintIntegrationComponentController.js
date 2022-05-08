({
  doInit: function(component, event, helper) {
      var getRequestJSONAction = component.get('c.GetCustomerVerificationRequestMetadata')
      var RecordId  = component.get('v.recordId');
      var IDNumber  = component.get('v.IDNumber');
      var cifCode  = component.get('v.CifCode');
      var lastName  = component.get('v.LastName');
      var cellNumber  = component.get('v.CellNumber');
      if(RecordId == null){
          RecordId = '';
      }
      getRequestJSONAction.setParams({
          'accountID' : RecordId,   
          'IDNumber' :IDNumber,
          'cifCode' :cifCode,
          'lastName': lastName,
          'cellNumber':cellNumber
         
      });
      getRequestJSONAction.setCallback(this, function(response) {
          var RequestMetadata = response.getReturnValue() ;
          var RequestMetadataObject = JSON.parse(RequestMetadata);
          component.set('v.CustomerId',RequestMetadataObject.IDNumber);
          component.set('v.IsNewToBank',RequestMetadataObject.IsNewtoBank);
          component.set('v.RequestJSON',RequestMetadata);
      });
     
      $A.enqueueAction(getRequestJSONAction);
  },
 

HandleResponse : function(component, event, helper) 
{
var Status = event.getParam('status');
var ResponseMetadata = event.getParam('responseMetadata');
var toastEvent = $A.get("e.force:showToast");
component.set('v.CustomerVerificationData',ResponseMetadata);  
var responseObject = JSON.parse(ResponseMetadata);
if(responseObject && responseObject.OverallVerificationResult){
  var getRequestJSONAction = component.get('c.SetDataFromDHACPB');
  var RecordId  = component.get('v.recordId');
  getRequestJSONAction.setParams({
      'accountID' : RecordId,
      'ResponseJson' : ResponseMetadata,             
  });
  getRequestJSONAction.setCallback(this, function(response) {
      //var RequestMetadata = response.getReturnValue();  
      var RequestMetadataObject = JSON.parse(response.getReturnValue());  
      component.set('v.dhaAttestation',RequestMetadataObject);
      var navigate = component.get("v.navigateFlow");
      navigate("NEXT");
  });
  if(RecordId != null){
   $A.enqueueAction(getRequestJSONAction);
  }else{
    var navigate = component.get("v.navigateFlow");
    navigate("NEXT");
  }
    
}else{
    console.log('customer verification failed, stay on same page');  
    toastEvent.setParams({
    title: 'Failed Error!',
    message: 'customer verification failed, stay on same page',
    type: 'Error'
  });
   toastEvent.fire();
}              
},
 
});