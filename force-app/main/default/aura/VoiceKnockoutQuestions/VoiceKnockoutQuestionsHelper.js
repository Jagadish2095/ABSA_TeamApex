/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 06-05-2022
 * @last modified by  : Mradul Maheshwari
 * @Work Id           :
 **/
({
  knockoutHelper: function (component, templateName) {
    // call the apex class method
    var action = component.get("c.fetchKnockoutQuestions");
    // set param to method
    action.setParams({
      templateName: templateName
    });
    // set a callBack
    action.setCallback(this, function (response) {
      $A.util.removeClass(component.find("mySpinner"), "slds-show");
      var state = response.getState();
      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();
        // set questionList with return value from server.
        component.set("v.questionList", storeResponse);
      } else {
        response.getError();
        var errorTxt;
        console.log("errors", errors);
        if (errors) {
          var errorMsgs = [];
          for (var index in errors) {
            errorMsgs.push(errors[index].message);
          }
          errorTxt = errorMsgs.join("<br/>");
        } else {
          errorTxt = "Something went wrong!";
        }
        component.set("v.Message", errorTxt);
      }
    });
    // enqueue the Action
    $A.enqueueAction(action);
  },

  SelectionCallback: function (component, event) {
    var compEvent = component.getEvent("branchProductSelectionEventcmp");
    var AttestationsValid = "reject";
    if (
      component.get("v.requireIDPORChecked") &&
      component.get("v.casaClauseChecked")
    ) {
      AttestationsValid = "accept";
      component.set("v.isAllClausesSet", true);
    } else {
      component.set("v.isAllClausesSet", false);
    }
    compEvent.setParams({
      QuestionResponse: AttestationsValid
    });
    compEvent.fire();
  },

  callPreScreen: function (component) {
    this.showSpinner(component);
    var action = component.get("c.getPreScreenResult");

    let preScreenParams = new Map();
    preScreenParams["channelCode"] = "T";
    preScreenParams["idNumber"] = component.get(
      "v.opportunityRecord.ID_Number__c"
    );
    preScreenParams["sourceSystem"] = "VSF";
    preScreenParams["applicationNumber"] = "Voice Salesforce";
    preScreenParams["casaClauseRead"] = "true";
    preScreenParams["curatorship"] = "true";
    preScreenParams["identificationType"] = component.get(
      "v.opportunityRecord.Account.ID_Type__pc"
    );
    preScreenParams["dateOfBirth"] = component.get(
      "v.opportunityRecord.PersonBirthdate"
    );
    preScreenParams["idIssuedDate"] = component.get(
      "v.opportunityRecord.Date_Issued__pc"
    );
    preScreenParams["firstNames"] = component.get(
      "v.opportunityRecord.Account.FirstName"
    );
    preScreenParams["initials"] = component.get(
      "v.opportunityRecord.Account.Initials__pc"
    );
    preScreenParams["surname"] = component.get(
      "v.opportunityRecord.Account.LastName"
    );
    preScreenParams["titleType"] = component.get(
      "v.opportunityRecord.Account.Salutation"
    );
    preScreenParams["cellPhoneNumber"] = component.get(
      "v.opportunityRecord.Account.Phone"
    );

    action.setParams({
      preScreenParamsMap: preScreenParams
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var responseData = JSON.parse(response.getReturnValue());
      console.log(responseData);
      if (state === "SUCCESS") {
        console.log("state" + state);
        if ($A.util.isUndefinedOrNull(responseData)) {
          this.fireToastEvent(
            "Error",
            "Server returned blank response:",
            "error",
            "sticky"
          );
          this.hideSpinner(component);
        }
        if (responseData.statusCode != 200) {
          this.fireToastEvent(
            "Error",
            "Server error occurred",
            "error",
            "sticky"
          );
          this.hideSpinner(component);
        }
        if (
          responseData.applyResponse.return_Z.responseCommons.success === "TRUE"
        ) {
          this.fireToast(
            "Success",
            JSON.stringify(
              responseData.applyResponse.return_Z.application.creditStatus
                .description
            ),
            "success"
          );
          component.set("v.canSave", false);
          component.find("branchFlowFooter").set("v.nextDisabled", false);

          this.fireToast(
            "Success",
            "User answers saved! Please click Next button continue.",
            "success"
          );
          component
            .find("applicationNumberField")
            .set(
              "v.value",
              String(
                responseData.applyResponse.return_Z.application
                  .applicationNumber
              )
            );
          component
            .find("descriptionField")
            .set(
              "v.value",
              "applicationLockVersionId:" +
                responseData.applyResponse.return_Z.application.lockVersionId +";"
            );
          component.find("opportunityCloseEditForm").submit();
          console.log(
            responseData.applyResponse.return_Z.application.applicationNumber
          );
          this.fireToast(
            "Success",
            responseData.applyResponse.return_Z.application.applicationNumber,
            "success"
          );

          this.hideSpinner(component);
        } else {
          this.fireToastEvent(
            "Application Denied",
            JSON.stringify(
              responseData.applyResponse.return_Z.responseCommons
                .responseMessages[0].message
            ),
            "Error",
            "sticky"
          );
          component.set("v.canSave", false);
          component.find("statusField").set("v.value", "Declined");
          component.find("opportunityCloseEditForm").submit();
          //$A.get("e.force:refreshView").fire();
          //remove the next line when testing done
          component.find("branchFlowFooter").set("v.nextDisabled", false);
          this.hideSpinner(component);
        }

        this.hideSpinner(component);
      }
      this.hideSpinner(component);
    });
    $A.enqueueAction(action);
  },

  //Show lightning spinner
  showSpinner: function (component) {
    console.log("inside showSpinner");
    var spinner = component.find("TheSpinner");
    $A.util.removeClass(spinner, "slds-hide");
  },

  //Hide lightning spinner
  hideSpinner: function (component) {
    console.log("inside hideSpinner");
    var spinner = component.find("TheSpinner");
    $A.util.addClass(spinner, "slds-hide");
  },

  //Lightning toastie
  fireToast: function (title, msg, type) {
    var toastEvent = $A.get("e.force:showToast");

    toastEvent.setParams({
      title: title,
      message: msg,
      type: type
    });

    toastEvent.fire();
    console.log(`${type} toast: ${msg}`);
  },
  fireToastEvent: function (title, msg, type, mode) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: title,
      message: msg,
      type: type,
      mode: mode
    });
    toastEvent.fire();
  }
});