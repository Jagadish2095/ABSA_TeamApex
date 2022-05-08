({
    helperMethod : function() {

    },

 //Search for Client in Salesforce ONLY if Search Type selectes is "Search Salesforce"
 searchInSalesforceOnly: function(component, event) {

  system.debug('Enter searchInSalesforceOnly....');

    this.showSpinner(component);

    var toastEvent;
    var selectedSearchType = component.get("v.searchTypeSelected");
    var selectedSearchValue = component.find("iSearchValue").get("v.value");

    //Action to search in Salesforce
    var action = component.get("c.searchClientLogic");

    action.setParams({
      searchValue: selectedSearchValue,
      searchType: selectedSearchType
    });

    action.setCallback(this, function(response) {
      var state = response.getState();

      if (component.isValid() && state === "SUCCESS") {
        var accountList = response.getReturnValue();

        System.log('Size of List'+accountList.size());

        if (accountList != null) {
          accountList.forEach(function(record) {
            if (record.Name == null) {
              if (record.Salutation != null && record.Salutation != "") {
                record.Name =
                  record.Salutation +
                  " " +
                  record.FirstName +
                  " " +
                  record.LastName;
              } else if (
                record.PersonTitle != null &&
                record.PersonTitle != ""
              ) {
                record.Name =
                  record.PersonTitle +
                  " " +
                  record.FirstName +
                  " " +
                  record.LastName;
              } else {
                record.Name = record.FirstName + " " + record.LastName;
              }
            }
          });
          component.set("v.accountsReturned", accountList);
          this.hideSpinner(component);

          //Disable Add Signatory button.
          if(accountList.size()==1)
          {
            $A.util.addClass(component.find("addSignatoryBtn"), "slds-hide");
          }

          //Show Client Search Table Results
          $A.util.removeClass(component.find("ClientResultTable"), "slds-hide");
        } else {
          this.hideSpinner(component);

          //Hide Client Search Table Results
          $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
          toastEvent = this.getToast(
            "No Results!",
            "No Client found in Salesforce",
            "Warning"
          );
          toastEvent.fire();
        }
      } else if (state === "ERROR") {
        //Hide Client Search Table Results
        $A.util.addClass(component.find("ClientResultTable"), "slds-hide");

        var message = "";
        var errors = response.getError();
        if (errors) {
          for (var i = 0; i < errors.length; i++) {
            for (
              var j = 0;
              errors[i].pageErrors && j < errors[i].pageErrors.length;
              j++
            ) {
              message +=
                (message.length > 0 ? "\n" : "") +
                errors[i].pageErrors[j].message;
            }
            if (errors[i].fieldErrors) {
              for (var fieldError in errors[i].fieldErrors) {
                var thisFieldError = errors[i].fieldErrors[fieldError];
                for (var j = 0; j < thisFieldError.length; j++) {
                  message +=
                    (message.length > 0 ? "\n" : "") +
                    thisFieldError[j].message;
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
        var toastEvent = this.getToast("Error!", message, "Error");
        toastEvent.fire();
        this.hideSpinner(component);
      } else {
        //Hide search table
        $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
        this.hideSpinner(component);
      }
    });

    // Send action off to be executed
    $A.enqueueAction(action);
  },





});