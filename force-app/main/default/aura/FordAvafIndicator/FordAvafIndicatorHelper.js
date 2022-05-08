/**
 * @description       : FordAvafIndicator
 * @author            : Mradul Maheshwari
 * @last modified on  : 16-11-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-014878
 **/
({
  updateAttributes: function (component, event, helper) {
    if (
      component.get("v.caseRecord.Subtype__c") != "AVAF" &&
      component.get("v.caseRecord.Subtype__c") != "FORD"
    ) {
      if (
        (component.get("v.caseRecord.sd_Service_Group__c") == "AVAF Queries" &&
          component
            .get("v.AVAFQueriesList")
            .includes(component.get("v.caseRecord.Type__c"))) ||
        (component.get("v.caseRecord.sd_Service_Group__c") ==
          "AVAF Collections" &&
          component
            .get("v.AVAFCollectionsList")
            .includes(component.get("v.caseRecord.Type__c")))
      ) {
        var action = component.get("c.getContractDetailsfromServer");
        action.setParams({ iAccount: component.get("v.accountNumber") });
        action.setCallback(this, function (response) {
          var state = response.getState();
          if (state === "SUCCESS") {
            var responseValue = response.getReturnValue();
            if (responseValue.startsWith("Error: ")) {
              var now = new Date();
          
                component
                .find("subType")
                .set(
                  "v.value",
                  "Error received at " +
                    $A.localizationService.formatDate(now, "MMMM dd yyyy, hh:mm:ss a") +
                    " for FordAvafIndicatorCntr.getContractDetailsfromServer"
                );
              component.find("caseUpdateServiceSubtype").submit();
            } else {
              var respObj = JSON.parse(responseValue);
              var corpCode = respObj[0].E_CONTR_DETAILS.CORP_CODE;
              if (corpCode === "AVF") {
                corpCode = "AVAF";
              } else if (corpCode === "FSA") {
                corpCode = "Ford";
              }
              component.set("v.corporateCode", corpCode);

              component
                .find("subType")
                .set("v.value", component.get("v.corporateCode"));
              component.find("caseUpdateServiceSubtype").submit();

              $A.get("e.force:refreshView").fire();
            }
          } else {
              var now = new Date();
          	
            component
              .find("subType")
              .set(
                "v.value",
                "Error received at "+
                $A.localizationService.formatDate(now, "MMMM dd yyyy, hh:mm:ss a")+
                " for FordAvafIndicatorCntr.getContractDetailsfromServer"
              );
            component.find("caseUpdateServiceSubtype").submit();
          }
        });

        $A.enqueueAction(action);
      }
    }
  }
});