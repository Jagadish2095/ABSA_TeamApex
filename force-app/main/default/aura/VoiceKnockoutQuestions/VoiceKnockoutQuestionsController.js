/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 05-05-2022
 * @last modified by  : Mradul Maheshwari
 * @Work Id           :
 **/
({
  init: function (component, event, helper) {
    var templateName = component.get("v.questionnaireTemplateName");
    helper.knockoutHelper(component, templateName);
    let cifDataMap = new Map();
    let ccApplicationDataMap = new Map();

    cifDataMap["Name"] = "Name test";
    cifDataMap["LastName"] = "Last name test";
    cifDataMap["KnockOutAnswer"] = "DEFAULT ANSWER";
    ccApplicationDataMap["casaClauseRead"] = false;
    ccApplicationDataMap["curatorship"] = false;

    component.set("v.cifDataMap", JSON.stringify(cifDataMap));
    component.set(
      "v.ccApplicationDataMap",
      JSON.stringify(ccApplicationDataMap)
    );
    console.log(`app: ${JSON.stringify(ccApplicationDataMap)}`);

    component.find("branchFlowFooter").set("v.canPause", false);
    $A.util.addClass(component.find("rgAttestation"), "slds-has-error");
  },

  atestationChange: function (component, event) {
    var result = event.getParam("value");
    var ccApplicationDataMap = component.get("v.ccApplicationDataMap");
    ccApplicationDataMap = JSON.parse(ccApplicationDataMap);
    var attest = component.get("v.atestationValue")[0];
    console.log(`atestationValue: ${JSON.stringify(attest)}`);
    if (result == "accept") {
      component.set("v.knockoutQuestionResult", true);
      component.set("v.knockoutQuestionResultAccept", true);
      component.set("v.isCheckBoxOn", true);
      component.set("v.canSave", false);
      ccApplicationDataMap["curatorship"] = true;
    } else {
      component.set("v.knockoutQuestionResult", false);
      component.set("v.knockoutQuestionResultAccept", false);
      component.set("v.isAllClausesSet", false);
      component.set("v.isCheckBoxOn", false);
    }

    console.log(
      `Change Update cc app : ${JSON.stringify(ccApplicationDataMap)}`
    );
    component.set(
      "v.ccApplicationDataMap",
      JSON.stringify(ccApplicationDataMap)
    );

    var validity = component.find("rgAttestation").get("v.validity");
    console.log(`validity change: ${JSON.stringify(validity)}`);
  },

  RequireIDPORChange: function (component, event, helper) {
    var globalId = component.getGlobalId();
    var requireIDPOR = document.getElementById(globalId + "_RequireIDPOR");
    component.set(" v.requireIDPORChecked ", requireIDPOR.checked);
    helper.SelectionCallback(component, event);
  },

  CasaClauseChange: function (component, event, helper) {
    var ccApplicationDataMap = component.get("v.ccApplicationDataMap");
    ccApplicationDataMap = JSON.parse(ccApplicationDataMap);
    var globalId = component.getGlobalId();
    var casaClause = document.getElementById(globalId + "_CasaClause");
    component.set(" v.casaClauseChecked ", casaClause.checked);
    component.set(" v.canSave ", casaClause.checked);
    ccApplicationDataMap["casaClauseRead"] = casaClause.checked;
    helper.SelectionCallback(component, event);
    component.find("branchFlowFooter").set("v.nextDisabled", true);

    console.log(`CASA Update cc app : ${JSON.stringify(ccApplicationDataMap)}`);
    component.set(
      "v.ccApplicationDataMap",
      JSON.stringify(ccApplicationDataMap)
    );
  },

  ReadCasaClause: function (component, event, helper) {
    component.set("v.isCheckBoxOn", false);
  },

  save: function (component, event, helper) {
    var result = component.get("v.knockoutQuestionResult");

    var dataMap = JSON.parse(component.get("v.cifDataMap"));

    if (result) {
      var action = component.get("c.submitKnockoutQuestions");
      // set param to method
      action.setParams({
        templateName: component.get("v.questionnaireTemplateName"),
        opportunityId: component.get("v.recordId"),
        hasClientAgreed: result
      });
      // set a callBack
      action.setCallback(this, function (response) {
        //$A.util.removeClass(component.find("mySpinner"), "slds-show");
        var state = response.getState();
        if (state === "SUCCESS") {
          // calling pre screen service
          helper.callPreScreen(component);

          // these functionalities moved to helper.callPreScreen
          //   component.set("v.canSave", false);
          //   component.find("branchFlowFooter").set("v.nextDisabled", false);
          //   console.log(`DONE... with a result of ${result}`);
          //   helper.fireToast(
          //     "Success",
          //     "User answers saved! Please click Next button continue.",
          //     "success"
          //   );
        } else {
          console.error(`ERROR...`);
          helper.fireToast("Error", "Something went wrong.", "error");
        }
        //helper.hideSpinner(component);
      });

      dataMap["KnockOutAnswer"] = result;
      component.set("v.cifDataMap", JSON.stringify(dataMap));

      //enqueue the Action
      $A.enqueueAction(action);
      console.log(`CONTINUING...`);
      helper.showSpinner(component);
    } else {
      component.set("v.canSave", false);
      console.warn(`STOP THE BUS`);
      helper.fireToast("Flow exiting", "Not all terms were met.", "warning");
    }
  },

  handleNavigate: function (component, event, helper) {
    var navigate = component.get("v.navigateFlow");
    var actionClicked = event.getParam("action");
    component.set("v.updating", true);
    var attest = component.get("v.atestationValue")[0];
    var radios = component.find("rgAttestation");

    switch (actionClicked) {
      case "NEXT":
      case "FINISH": {
        if (attest == undefined) {
          $A.util.addClass(radios, "slds-has-error");
        } else if (
          attest != "decline" &&
          !component.get("v.casaClauseChecked")
        ) {
          console.log(`not ready, need casa`);
        } else {
          navigate(actionClicked);
        }
        break;
      }
      case "BACK": {
        navigate(actionClicked);
        break;
      }
      case "PAUSE": {
        navigate(actionClicked);
        break;
      }
    }
  },
  handleError: function (component, event, helper) {
    helper.hideSpinner(component);
    var error = event.getParam("error");
    helper.fireToastEvent("Error!", JSON.stringify(error), "Error");
    console.log(error);
  }
});