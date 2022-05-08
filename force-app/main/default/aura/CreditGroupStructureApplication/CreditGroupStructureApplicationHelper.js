({
  getAccount: function (component, event, helper) {
    var oppId = component.get("v.recordId");
    var action = component.get("c.getAccounts");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var accResp = response.getReturnValue();
      component.set("v.accRecord", accResp);
    });

    $A.enqueueAction(action);
  },
  getAppRec: function (component, event) {
    var oppId = component.get("v.recordId");
    var action = component.get("c.GetApplication");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var appRec = response.getReturnValue();
      if (state == "SUCCESS") {
        component.set("v.application", appRec);
        if (appRec.EntityHierarchyCreate__c == true) {
          //component.set("v.disableSubmitBtn", true);
        }
      }
    });
    $A.enqueueAction(action);
  },

  getCreditGrpVw: function (component, event, helper) {
    component.set("v.showSpinner", true);
    var actions = this.getRowActions.bind(this, component);
    var columns = [
      {
        type: "text",
        fieldName: "PrimaryClient",
        label: "Primary Client",
        initialWidth: 200
      },
      {
        type: "text",
        fieldName: "GroupMember",
        label: "Group Member"
      },
      {
        type: "text",
        fieldName: "ClientCode",
        label: "Client Code"
      },
      {
        type: "text",
        fieldName: "StatusIndicator",
        label: "Status Indicator"
      },
      {
        type: "action",
        typeAttributes: { rowActions: actions }
      }
    ];

    component.set("v.gridColumns", columns);

    var oppId = component.get("v.recordId");
    var action = component.get("c.GetCreditGroupView");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var creditGrpResp = response.getReturnValue();
      var creditGrpResp = JSON.parse(JSON.stringify(creditGrpResp).split("childGrpMemList").join("_children"));

      if (state === "SUCCESS") {
        if (creditGrpResp != null && creditGrpResp.length > 0) {
          component.set("v.gridData", creditGrpResp);
          component.set("v.ultimateClient", creditGrpResp[0].UltimateClient);
          component.set("v.showData", true);
          component.set("v.noData", false);

          var toastEvent = this.getToast("Success:  ", "Account Credit Group View Fetched Successfully", "Success");
          toastEvent.fire();
        } else {
          component.set("v.noData", true);
          component.set("v.showData", false);

          var toastEvent = this.getToast("Error!", "Client is not Part of a Credit Group", "Error");
          toastEvent.fire();
        }
      } else {
        this.showError(response, "getCreditGrpVw");
      }
      component.set("v.showSpinner", false);
    });

    $A.enqueueAction(action);
  },
  refreshCreditGrpVw: function (component, event, helper) {
    component.set("v.showSpinner", true);
    var oppId = component.get("v.recordId");
    var action = component.get("c.RefreshCreditGroupView");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var creditGrpResp = response.getReturnValue();
      var creditGrpResp = JSON.parse(JSON.stringify(creditGrpResp).split("childGrpMemList").join("_children"));

      if (state === "SUCCESS") {
        if (creditGrpResp != null && creditGrpResp.length > 0) {
          component.set("v.gridData", creditGrpResp);
          component.set("v.ultimateClient", creditGrpResp[0].UltimateClient);
          component.set("v.showData", true);
          component.set("v.noData", false);

          var toastEvent = this.getToast("Success:  ", "Account Credit Group View Fetched Successfully", "Success");
          toastEvent.fire();
        } else {
          component.set("v.noData", true);
          component.set("v.showData", false);

          var toastEvent = this.getToast("Error!", "Client is not Part of a Credit Group", "Error");
          toastEvent.fire();
        }
      } else {
        this.showError(response, "getCreditGrpVw");
      }
      component.set("v.showSpinner", false);
    });

    $A.enqueueAction(action);
  },

  showError: function (response, errorMethod) {
    var message = "";
    var errors = response.getError();
    if (errors) {
      for (var i = 0; i < errors.length; i++) {
        for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
          message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
        }
        if (errors[i].fieldErrors) {
          for (var fieldError in errors[i].fieldErrors) {
            var thisFieldError = errors[i].fieldErrors[fieldError];
            for (var j = 0; j < thisFieldError.length; j++) {
              message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
            }
          }
        }
        if (errors[i].message) {
          message += (message.length > 0 ? "\n" : "") + errors[i].message;
        }
      }
    } else {
      message += (message.length > 0 ? "\n" : "") + "Unknown error";
    }

    // show error notification
    var toastEvent = this.getToast("GroupGrpView " + errorMethod + "! ", message, "Error");
    toastEvent.fire();
  },

  getToast: function (title, msg, type) {
    var toastEvent = $A.get("e.force:showToast");

    toastEvent.setParams({
      title: title,
      message: msg,
      type: type
    });

    return toastEvent;
  },

  getRowActions: function (component, row, doneCallback) {
    var actions = [];
    if (row.Type == "P") {
      actions.push({
        label: "Add Group Member",
        iconName: "utility:add",
        name: "Add Group Member"
      });
    }
    if (row.Type == "G") {
      actions.push({
        label: "Add This Client As Group",
        iconName: "utility:add",
        name: "Add This Client As Group"
      });
    }
    if (row.StatusIndicator == "Interim Group Member" || row.StatusIndicator == "Interim Group") {
      actions.push({
        label: "Delink",
        iconName: "utility:close",
        name: "Delink"
      });
    }

    setTimeout(
      $A.getCallback(function () {
        doneCallback(actions);
      }),
      200
    );
  },

  showSpinner: function (component) {
    var spinner = component.find("TheSpinner");
    $A.util.removeClass(spinner, "slds-hide");
  },

  hideSpinner: function (component) {
    var spinner = component.find("TheSpinner");
    $A.util.addClass(spinner, "slds-hide");
  },

  //Creates the selected client with a CIF number
  createClientCIF: function (component) {
    component.set("v.showSpinner", true);
    var action = component.get("c.createClient");

    action.setParams({
      accountData: component.get("v.accountData")
    });

    action.setCallback(this, function (response) {
      var resp = response.getReturnValue();

      var state = response.getState();
      if (state === "SUCCESS") {
        if (resp.includes("Success")) {
          // show success notification
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            title: "Success!",
            message: "Client has been selected successfully",
            type: "success"
          });
          toastEvent.fire();
        } else {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            title: "Error!",
            message: resp,
            type: "error"
          });
          toastEvent.fire();
        }
      } else {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: "Error!",
          message: "An unknow error has occured, please contact an administrator",
          type: "error"
        });
        toastEvent.fire();
      }
      component.set("v.showSpinner", false);
    });

    $A.enqueueAction(action);
  },

  addGroupToStructure: function (component, event, helper, row) {
    component.set("v.showSpinner", true);
    var ClientCode = row.ClientCode;
    var oppId = component.get("v.recordId");
    var ExistingCrdGrpStruct = component.get("v.gridData");

    var isCreated = false;
    var listlength = ExistingCrdGrpStruct.length;
    for (var i = 0; i < listlength; i++) {
      if (ClientCode === ExistingCrdGrpStruct[i].ClientCode && ExistingCrdGrpStruct[i].Type == "P") {
        isCreated = true;
      }
    }

    if (isCreated) {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        title: "Error!",
        message: "Group already Exist",
        type: "error"
      });
      toastEvent.fire();
      component.set("v.showSpinner", false);
    } else {
      var action = component.get("c.addGroupToStructure");
      action.setParams({
        oppId: oppId,
        ClientCode: ClientCode
      });
      action.setCallback(this, function (response) {
        var state = response.getState();
        var addedcreditGrpResp = response.getReturnValue();
        var addedcreditGrpResp = JSON.parse(
          JSON.stringify(addedcreditGrpResp).split("childGrpMemList").join("_children")
        );

        if (state === "SUCCESS") {
          if (addedcreditGrpResp != null && addedcreditGrpResp.length > 0) {
            component.set("v.gridData", addedcreditGrpResp);

            var toastEvent = this.getToast("Success:  ", "Group added Successfully", "Success");
            toastEvent.fire();
          }
        }
        component.set("v.showSpinner", false);
      });

      $A.enqueueAction(action);
    }
  },

  addGroupMemberToGroup: function (component, event, helper, row) {
    component.set("v.showSpinner", true);
    var addGroupMember = component.get("v.accountDataFrmCltFinder");
    // console.log(' @@@ addGroupMember' + JSON.stringify(addGroupMember));
    var grpNumber = component.get("v.grpMemberKey");
    var oppId = component.get("v.recordId");

    //Adding Validations
    var ExistingCrdGrpStruct = component.get("v.gridData");
    // console.log(' @@@ ExistingCrdGrpStruct' +  JSON.stringify(ExistingCrdGrpStruct));
    var isCreated = false;
    var listlength = ExistingCrdGrpStruct.length;
    var ClientCode = addGroupMember.CIF__c;
    var grpClientCode = component.get("v.rowGrpClientCode");
    //  console.log(' @@@ ClientCode' +  JSON.stringify(ClientCode));
    console.log(" @@@ grpClientCode" + JSON.stringify(grpClientCode));

    //Parent cannot come under same group as member
    if (ClientCode === grpClientCode) {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        title: "Error!",
        message: "You cannot add Group Member to same Group",
        type: "error"
      });
      toastEvent.fire();
      component.set("v.showSpinner", false);
    } else {
      for (var i = 0; i < listlength; i++) {
        if (grpClientCode === ExistingCrdGrpStruct[i].ClientCode && ExistingCrdGrpStruct[i].Type == "P") {
          console.log(" @@@ Group Code got selected" + JSON.stringify(ExistingCrdGrpStruct[i].ClientCode));
          var listChildlength = ExistingCrdGrpStruct[i]._children.length;
          var ChildStruct = ExistingCrdGrpStruct[i]._children;
          console.log(" @@@ listChildlength" + JSON.stringify(listChildlength));
          console.log(" @@@ ChildStruct" + JSON.stringify(ChildStruct));
          for (var j = 0; j < listChildlength; j++) {
            if (ClientCode === ChildStruct[j].ClientCode && ChildStruct[j].Type == "G") {
              isCreated = true;
            }
          }
        }
      }

      console.log(" @@@ isCreated" + JSON.stringify(isCreated));

      if (isCreated) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: "Error!",
          message: "Group Member already Exist",
          type: "error"
        });
        toastEvent.fire();
        component.set("v.showSpinner", false);
      } else {
        var action = component.get("c.addGrpMemberToGroup");
        action.setParams({
          oppId: oppId,
          clientCode: addGroupMember.CIF__c,
          grpNumberP: grpNumber
        });
        action.setCallback(this, function (response) {
          var state = response.getState();
          var addedcreditGrpResp = response.getReturnValue();
          var addedcreditGrpResp = JSON.parse(
            JSON.stringify(addedcreditGrpResp).split("childGrpMemList").join("_children")
          );

          if (state === "SUCCESS") {
            if (addedcreditGrpResp != null && addedcreditGrpResp.length > 0) {
              component.set("v.gridData", addedcreditGrpResp);

              var toastEvent = this.getToast("Success:  ", "Group Member added To the Group Successfully", "Success");
              toastEvent.fire();
            }
          }
          component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
      }
    }
  },

  delinkGroupMembers: function (component, event, helper, row) {
    component.set("v.showSpinner", true);

    var oppId = component.get("v.recordId");
    var action = component.get("c.delinkGroupMember");

    action.setParams({
      oppId: oppId,
      clientCDToDelete: row.ClientCode,
      GrpTypeP: row.Type
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      var dltGrpResp = response.getReturnValue();
      var dltGrpResp = JSON.parse(JSON.stringify(dltGrpResp).split("childGrpMemList").join("_children"));

      if (state === "SUCCESS") {
        if (dltGrpResp != null && dltGrpResp.length > 0) {
          component.set("v.gridData", dltGrpResp);

          var toastEvent = this.getToast("Success:  ", "Delink Group/Member Successfully", "Success");
          toastEvent.fire();
        }
      } else {
        this.showError(response, "delinkGroupMembers");
      }
      component.set("v.showSpinner", false);
    });

    $A.enqueueAction(action);
  },

  startCreditLens: function (component) {
    component.set("v.showSpinner", true);
    this.searchCreditLensEntity(component)
      .then((val) => {
        var toastEvent = this.getToast("Processing", "Entity Search Completed. Creating entities...", "info");
        toastEvent.fire();
        this.createCreditLensEntity(component)
          .then((createVal) => {
            var toastEvent = this.getToast("Processing", "Entity Creation Completed. Creating hierarchy...", "info");
            toastEvent.fire();
            this.createCreditLensHierarchy(component)
              .then((createHierachyVal) => {
                var toastEvent = this.getToast("Success", "Entity Hierarchy Has Been Created", "success");
                toastEvent.fire();
                component.set("v.showSpinner", false);
              })
              .catch((createHierachyReason) => {
                component.set("v.showSpinner", false);
                var toastEvent = this.getToast("Entity Creation Failed", createHierachyReason, "error");
                toastEvent.fire();
              });
          })
          .catch((createReason) => {
            component.set("v.showSpinner", false);
            var toastEvent = this.getToast("Entity Creation Failed", createReason, "error");
            toastEvent.fire();
          });
      })
      .catch((reason) => {
        component.set("v.showSpinner", false);
        var toastEvent = this.getToast("Entity Search Failed", reason, "error");
        toastEvent.fire();
      });
  },

  //Recursive JS to redo if nextPage comes in as true
  searchCreditLensEntity: function (component) {
    return new Promise((resolve, reject) => {
      var creditGrpResp = component.get("v.gridData");
      var action = component.get("c.searchCL");
      action.setParams({
        formData: JSON.stringify(creditGrpResp)
      });
      action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var responseData = JSON.parse(response.getReturnValue());
          component.set("v.gridData", responseData.data);
          if (responseData.nextPage) {
            var toastEvent = this.getToast("Processing", "Entity Search : 5 Searches Complete...", "info");
            toastEvent.fire();
            this.searchCreditLensEntity(component)
              .then((val) => {
                return resolve("");
              })
              .catch((err) => {
                return reject(err);
              });
          } else {
            return resolve("");
          }
        } else if (state === "ERROR") {
          var errors = response.getError();
          if (errors) {
            if (errors[0] && errors[0].message) {
              return reject(errors[0].message);
            }
          } else {
            return reject("Entity Search Failed");
          }
        }
      });
      $A.enqueueAction(action);
    });
  },

  //Recursive JS to redo if nextPage comes in as true
  createCreditLensEntity: function (component) {
    return new Promise((resolve, reject) => {
      var creditGrpResp = component.get("v.gridData");
      var action = component.get("c.createCL");
      action.setParams({
        formData: JSON.stringify(creditGrpResp)
      });
      action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var responseData = JSON.parse(response.getReturnValue());
          component.set("v.gridData", responseData.data);
          if (responseData.nextPage) {
            var toastEvent = this.getToast("Processing", "Entity Create : 5 Entities Created...", "info");
            toastEvent.fire();
            this.createCreditLensEntity(component)
              .then((val) => {
                return resolve("");
              })
              .catch((err) => {
                return reject(err);
              });
          } else {
            return resolve("");
          }
        } else if (state === "ERROR") {
          var errors = response.getError();
          if (errors) {
            if (errors[0] && errors[0].message) {
              return reject(errors[0].message);
            }
          } else {
            return reject("Entity Creation Failed");
          }
        }
      });
      $A.enqueueAction(action);
    });
  },

  createCreditLensHierarchy: function (component) {
    return new Promise((resolve, reject) => {
      var creditGrpResp = component.get("v.gridData");
      var oppId = component.get("v.recordId");
      var action = component.get("c.createCLHierarchy");
      action.setParams({
        formData: JSON.stringify(creditGrpResp),
        oppId: oppId
      });
      action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          return resolve("");
        } else if (state === "ERROR") {
          var errors = response.getError();
          if (errors) {
            if (errors[0] && errors[0].message) {
              return reject(errors[0].message);
            }
          } else {
            return reject("Entity Hierarchy Creation Failed");
          }
        }
      });
      $A.enqueueAction(action);
    });
  },

  submitToCreditLensHelper: function (component) {}
});