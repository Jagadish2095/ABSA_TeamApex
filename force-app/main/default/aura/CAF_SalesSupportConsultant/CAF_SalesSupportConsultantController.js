({
	init: function (component,evt,helper) {
    console.log('recordId##' + component.get("v.recordId"));
      var queueName = 'Securities_Preparations';
      var caseStatus = 'Complete Securities';
      var decision = 'Submitted';
      var details = 'Submitted';
      var comments = 'Submitted for Securities Completion'; 
      var processName = 'Securities_Preparations';
      var infoSource = '';
      var isInsert = ''; 
     
    console.log('queueName##' + queueName);
     helper.refreshData(component, event, helper,isInsert,queueName,caseStatus,decision,details,comments,infoSource);
     // helper.refreshData(component, event, helper, false,''); 
    },
onAttestSecurities: function(component, event, helper) {
    var attestSecurities = component.find("attestSecurities").get("v.checked");
    console.log('attestSecurities##' + attestSecurities);
    if (attestSecurities == true) {
        component.set("v.isAttestSecurities", "true");
    } else {
        component.set("v.isAttestSecurities", "false");
    }

},

handleAttestSecurities: function(component, event, helper) {
     console.log('in handleAttestSecurities##');
      var queueName = 'Securities Preparations';
      var caseStatus = 'Complete Securities';
      var decision = 'Submitted';
      var details = 'Submitted';
      var comments = 'Submitted for Securities Completion'; 
      var processName = 'Securities Preparations';
      var infoSource = '';
      var isInsert = 'true';
    console.log('queueName##' + queueName);
     helper.refreshData(component, event, helper,isInsert,queueName,caseStatus,decision,details,comments,infoSource);
    //helper.refreshData(component, event, helper,isInsert,queueName);
     helper.changeOwner(component, event, helper, queueName,caseStatus,infoSource); 
    component.set("v.attestSecurities","false");
    component.set("v.isAttestSecurities", "false");

},

onAttestContract: function(component, event, helper) {
    var attestContract = component.find("attestContract").get("v.checked");
    console.log('attestContract##' + attestContract);
    if (attestContract == true) {
        component.set("v.isAttestedContract", "true");
    } else {
        component.set("v.isAttestedContract", "false");
    }

},

handleAttestContract: function(component, event, helper) {
  var queueName = '';  
  var caseStatus = 'Get Contracts Signed'; 
    helper.changeOwner(component, event, helper, queueName,caseStatus,true);
    component.set("v.isAttestedContract", "false");

},
     onAttestDecision : function(component, event, helper) { 
     var attestDecision = component.find("attestDecision").get("v.checked");
    console.log('attestDecision##' + attestDecision);
    if (attestDecision == true) {
        component.set("v.isSubmitDecision", "true");
    } else {
        component.set("v.isSubmitDecision", "false");
    }  
   }, 
    
   submitDecision : function(component, event, helper) {    
   var queueName = 'Payout Validation';
   var caseStatus = 'Validate Payout';
   var decision = component.get("v.approvalStatus");
   var details ;
        if(decision == 'Approved'){
         details = 'Approved As Is';}
        else if(decision == 'Requested More Information'){
         details = 'More Info Requested'; }
   var comments = component.get("v.commentTextArea");
   var isInsert = true;  
   var infoSource;
         if(decision == 'Approved'){
         infoSource = '';}
        else if(decision == 'Requested More Information'){
         infoSource = component.find("informationSource").get("v.value");}
         console.log('decision@@@ '+decision);
        console.log('infoSource@@@ '+infoSource);
        
   helper.refreshData(component, event, helper, decision,details,comments,isInsert,infoSource);
         
   }, 
})