/**
 * Lightning Component Helper for Client Finder
 *
 * @author  Tracy de Bruin : CloudSmiths
 * @version v1.0
 * @since   2018-07-20
 *
 **/
({
  //Function to show spinner when loading
  showSpinner: function(component) {
    var spinner = component.find("TheSpinner");
    $A.util.removeClass(spinner, "slds-hide");
  },

  //Function to hide spinner after loading
  hideSpinner: function(component) {
    var spinner = component.find("TheSpinner");
    $A.util.addClass(spinner, "slds-hide");
  },

  //Function to show toast for Errors/Warning/Success
  getToast: function(title, msg, type) {
    var toastEvent = $A.get("e.force:showToast");

    toastEvent.setParams({
      title: title,
      message: msg,
      type: type
    });

    return toastEvent;
  },

  //Used to get the Account Field Set to determine which Client results columns to display
  getAccountRecordType: function(component) {
    var action = component.get("c.getClientRecordTypeByName");
    //Set the Object parameters and Field Set name
    action.setParams({
      recordTypeName: "Prospect"
    });

    action.setCallback(this, function(response) {
      var state = response.getState();

      if (state === "SUCCESS") {
        component.set(
          "v.businessProspectRecordTypeId",
          response.getReturnValue()
        );
      } else if (state === "ERROR") {
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
      }
    });
    $A.enqueueAction(action);
  },

  //TdB - Set Individual Prospect Record Type Id
  getIndividualProspectRecordType: function(component) {
    var action = component.get("c.getClientRecordTypeByName");
    //Set the Object parameters and Field Set name
    action.setParams({
      recordTypeName: "Individual_Prospect"
    });

    action.setCallback(this, function(response) {
      var state = response.getState();

      if (state === "SUCCESS") {
        component.set(
          "v.individualProspectRecordTypeId",
          response.getReturnValue()
        );
      } else if (state === "ERROR") {
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
      }
    });
    $A.enqueueAction(action);
  },


  //Search for Client in Salesforce ONLY if Search Type selectes is "Search Salesforce"
  searchInSalesforceOnly: function(component, event) {
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

    //TdB - Search by Name in CIF, add values returned to picklist
    searchCifByName: function(component, event) {
        this.showSpinner(component);
        
        var toastEvent;
        var selectedSearchValue = component.find("iSearchValue").get("v.value");

        //Action to search in Salesforce
        var action = component.get("c.callCIFSearchByName");
        
        action.setParams({
            "searchValue" : selectedSearchValue
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var accountList = response.getReturnValue();
                
                if (accountList != null) {
                    var searchByNameLst = [];

                    accountList.forEach(function(record) {

                        //Create concatenated name for display
                        if (record.Name == null) {
                            if (record.Salutation != null && record.Salutation != "") {
                                record.Name = record.Salutation + " " + record.FirstName + " " + record.LastName;
                            } else if ( record.PersonTitle != null && record.PersonTitle != "" ) {
                                record.Name = record.PersonTitle + " " + record.FirstName + " " + record.LastName;
                            } else {
                                record.Name = record.FirstName + " " + record.LastName;
                            }
                        }
                        
                        searchByNameLst.push({
                            class: "optionClass",
                            label: record.CIF__c + ' - ' + record.Name + ' - ' + record.Registration_Number__c,
                            value: record.CIF__c
                        })
                        
                    });
                    component.set("v.searchByNameResultOption", searchByNameLst);
                    component.set("v.showSearchByNameCIFSection", true);
                    this.hideSpinner(component);

                } else {
                    this.hideSpinner(component);
                    
                    //Hide Client Search Table Results
                    $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
                    toastEvent = this.getToast(
                        "No Results!",
                        "No Client found in CIF ",
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
    
  //Used to get the Account Field Set to determine which Client results columns to display
  getClientFieldSet: function(component, event) {
    //get Compact indicator value
    var compactIndicator = component.get("v.isCompactView");
    var fieldSetName;

    if (compactIndicator == true) {
      fieldSetName = "Client_Finder_Compact_View";
    } else {
      fieldSetName = "Client_Finder_Full_View";
    }

    var action = component.get("c.getClientResultTableFields");
    //Set the Object parameters and Field Set name
    action.setParams({
      strObjectName: "Account",
      strFieldSetName: fieldSetName
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.clientSearchResultColumns", response.getReturnValue());
      } else if (state === "ERROR") {
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
      }
    });
    $A.enqueueAction(action);
  },

  //Retrieve the client details bean for processing to the relevant data tables
  retrieveClientDetailsBean: function(component) {
    this.showSpinner(component);

    //Get Search Type and Search Value
    var selectedSearchType = component.get("v.searchTypeSelected");
    var selectedSearchValue = component.get("v.searchTypeValue");

    var action = component.get("c.getClientDetailsBean");

    action.setParams({
      searchType: selectedSearchType,
      searchValue: selectedSearchValue
    });

    //Callback that is executed after the server-side action returns
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();

        //Display Error Message if no results are returned
        if (storeResponse != null) {
          if (storeResponse.length == 0) {
            //Set MDM Client Bean
            this.retrieveMDMClient(component);

            //this.getClientFromJSONBean(component);
          } else {
            //Set Adapt360 Client Bean
            component.set("v.clientDetailsBean", JSON.parse(storeResponse));

            //Set MDM Client Bean
            this.retrieveMDMClient(component);
            //this.getClientFromJSONBean(component);
          }
        } else {
          //Set MDM Client Bean
          this.retrieveMDMClient(component);
          //this.getClientFromJSONBean(component);
        }
      } else if (state === "ERROR") {
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
      }
    });

    //Add the server-side action to the queue.
    $A.enqueueAction(action);
  },

  // Retrieve the client participants for joint and several account types
  getParticipantsBean: function(component) {
    this.showSpinner(component);

    var action = component.get("c.getParticipantsBean");

    action.setParams({
      cifNumber: component.get("v.accountSelected").CIF__c
    });

    //Callback that is executed after the server-side action returns
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();

        //Display Error Message if no results are returned
        if (storeResponse != null) {
          component.set("v.clientParticipantsBean", JSON.parse(storeResponse));

          //Generate Client Account Information using the response bean
          var clientParticipantsBean = component.get(
            "v.clientParticipantsBean"
          );
          var action = component.get("c.generateBeanClientParticipantInfo");

          action.setParams({
            clientParticipantsBeanText: JSON.stringify(clientParticipantsBean)
          });

          action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
              var storeResponse = response.getReturnValue();
              //2019-04-03 Derek Hughes - handle null or empty participant lists
              //START CHANGE
              if (storeResponse == null) {
                storeResponse = "";
              }
              //Display Error Message if no results are returned
              //    if (storeResponse.length == 0) {

              //    } else {
              //END CHANGE

              //Process results
              storeResponse.forEach(function(record) {
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

              //Set datatable data and select the first result
              component.set("v.participantData", storeResponse);

              var setEvent = $A.get("e.c:setClientInfo");
              setEvent.setParams({
                accountValue: component.get("v.accountSelected")
              });
              setEvent.setParams({ isIndivClient: "false" });
              setEvent.setParams({ jointParticipants: storeResponse });
              setEvent.fire();

              this.hideSpinner(component);
            } else if (state === "ERROR") {
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
                    message +=
                      (message.length > 0 ? "\n" : "") + errors[i].message;
                  }
                }
              } else {
                message += (message.length > 0 ? "\n" : "") + "Unknown error";
              }

              this.hideSpinner(component);

              var setEvent = $A.get("e.c:setClientInfo");
              setEvent.setParams({ jointParticipants: "" });
              setEvent.fire();

              // show error notification
              var toastEvent = this.getToast("Error!", message, "Error");
              toastEvent.fire();
            }
          });

          //Add the server-side action to the queue.
          $A.enqueueAction(action);
        }
      } else if (state === "ERROR") {
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

        this.hideSpinner(component);

        // show error notification
        var toastEvent = this.getToast("Error!", message, "Error");
        toastEvent.fire();
      }
    });

    //Add the server-side action to the queue.
    $A.enqueueAction(action);
  },

  //Retrieve the products associated with the client
  getClientProducts: function(component) {
    this.showSpinner(component);
    var clientDetails = component.get("v.clientDetailsBean");
    var selectedCIFNo = component.get("v.accountSelected").CIF__c;
    var productList = [];

    clientDetails.ClientDetails.forEach(function(record) {
      if (
        record.identifications != null &&
        selectedCIFNo == record.identifications[0].numbers
      ) {
        if (record.account != null) {
          record.account.forEach(function(record) {
            productList.push(record);
          });
        } else {
          productList.clear;
          component.set("v.productData", null);
          component.set("v.productColumns", null);
        }
      }
    });

    if (productList.length != 0) {
      productList.forEach(function(record) {
        record.Account = record.accountNumber.value;
        record.Status = record.accountStatus.value;
        record.Product = record.product.value;
      });
      component.set("v.productData", productList);

      var pageSize = component.get("v.productPageSize");
      // get size of all the records and then hold into an attribute "totalRecords"
      component.set(
        "v.productTotalRecords",
        component.get("v.productData").length
      );
      // set star as 0
      component.set("v.productStartPage", 0);

      component.set("v.productEndPage", pageSize - 1);
      var PaginationList = [];
      for (var i = 0; i < pageSize; i++) {
        if (component.get("v.productData").length > i)
          PaginationList.push(productList[i]);
      }
      component.set("v.productPaginationList", PaginationList);
    }

    this.hideSpinner(component);
  },

  //Retrieve Client from MDM
  retrieveMDMClient: function(component) {
    this.showSpinner(component);
    //Get Search Type and Search Value
    var selectedSearchType = component.get("v.searchTypeSelected");
    var selectedSearchValue = component.get("v.searchTypeValue");

    var action = component.get("c.getMDMClientDetailsBean");

    action.setParams({
      searchType: selectedSearchType,
      searchValue: selectedSearchValue
    });

    //Callback that is executed after the server-side action returns
    action.setCallback(this, function(response) {
      var state = response.getState();

      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();

        //Display Error Message if no results are returned
        if (storeResponse != null) {
          if (storeResponse.length == 0) {
            this.getClientFromJSONBean(component);
          } else {
            component.set("v.MDMclientDetailsBean", JSON.parse(storeResponse));
            this.getClientFromJSONBean(component);
          }
        } else {
          this.getClientFromJSONBean(component);
        }
      } else if (state === "ERROR") {
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
      }
    });

    //Add the server-side action to the queue.
    $A.enqueueAction(action);
  },

  getClientFromJSONBean: function(component) {
    this.showSpinner(component);
    //Generate Client Account Information using the response bean
    ////Get Search Type and Search Value
    var selectedSearchType = component.get("v.searchTypeSelected");
    var selectedSearchValue = component.get("v.searchTypeValue");
    var clientDetailsBean = component.get("v.clientDetailsBean");
    var clientMDMDetailsBean = component.get("v.MDMclientDetailsBean");

    var action = component.get("c.searchClientLogic");
    action.setParams({
      searchType: selectedSearchType,
      searchValue: selectedSearchValue,
      clientAdapt360BeanText: JSON.stringify(clientDetailsBean),
      clientMDMBeanText: JSON.stringify(clientMDMDetailsBean)
    });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var storeResponse = response.getReturnValue();

        //Display Error Message if no results are returned
        if (storeResponse != null) {
          if (storeResponse.length == 0) {
            $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
            toastEvent = this.getToast(
              "No Results!",
              "No Client found in CIF and MDM",
              "Warning"
            );
            toastEvent.fire();
            this.hideSpinner(component);
          } else {
            //Process results
            storeResponse.forEach(function(record) {
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

            //Set datatable data and select the first result
            component.set("v.accountsReturned", storeResponse);

            //Show search table
            $A.util.removeClass(
              component.find("ClientResultTable"),
              "slds-hide"
            );

            this.hideSpinner(component);
          }
        } else {
          $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
          toastEvent = this.getToast(
            "No Results!",
            "No Client found in CIF and MDM",
            "Warning"
          );
          toastEvent.fire();
          this.hideSpinner(component);
        }
      } else if (state === "ERROR") {
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
      }
    });

    //Add the server-side action to the queue.
    $A.enqueueAction(action);
  },

  //Method to get next set of Products to display on Product data table
  nextProductSet: function(component, event) {
    var sObjectList = component.get("v.productData");
    var end = component.get("v.productEndPage");
    var start = component.get("v.productStartPage");
    var pageSize = component.get("v.productPageSize");
    var Paginationlist = [];
    var counter = 0;
    for (var i = end + 1; i < end + pageSize + 1; i++) {
      if (sObjectList.length > i) {
        Paginationlist.push(sObjectList[i]);
      }
      counter++;
    }
    start = start + counter;
    end = end + counter;
    component.set("v.productStartPage", start);
    component.set("v.productEndPage", end);
    component.set("v.productPaginationList", Paginationlist);
  },

  //Method to get prev set of Products to display on Product data table
  previousProductSet: function(component, event) {
    var sObjectList = component.get("v.productData");
    var end = component.get("v.productEndPage");
    var start = component.get("v.productStartPage");
    var pageSize = component.get("v.productPageSize");
    var Paginationlist = [];
    var counter = 0;
    for (var i = start - pageSize; i < start; i++) {
      if (i > -1) {
        Paginationlist.push(sObjectList[i]);
        counter++;
      } else {
        start++;
      }
    }
    start = start - counter;
    end = end - counter;
    component.set("v.productStartPage", start);
    component.set("v.productEndPage", end);
    component.set("v.productPaginationList", Paginationlist);
  },

  getContactData: function(component) {
    //Set Contact columns
    component.set("v.contactColumns", [
      { label: "Name", fieldName: "Name", type: "text" },
      { label: "Email", fieldName: "Email", type: "text" },
      { label: "Phone", fieldName: "Phone", type: "text" }
    ]);

    //Get related Contacts
    var actionGetContacts = component.get("c.getContactsLinkedToClient");
    actionGetContacts.setParams({
      newAccountId: component.get("v.accountSelected.Id")
    });

    actionGetContacts.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var records = response.getReturnValue();
        records.forEach(function(record) {
          record.linkName = "/" + record.Id;
        });
        component.set("v.contactData", records);
        component.set("v.contactFilteredData", records);
      }
    });

    $A.enqueueAction(actionGetContacts);
  },

  // Apply filter to the list of all items
  filterContacts: function(component) {
    var data = component.get("v.contactData"),
      term = component.get("v.contactFilterValue"),
      results = data,
      regex;
    try {
      regex = new RegExp(term, "i");
      // filter checks each row, constructs new array where function returns true
      results = data.filter(
        row =>
          regex.test(row.Name) || regex.test(row.Phone) || regex.test(row.Email)
      );
    } catch (e) {
      // invalid regex, use full list
      console.log("In filterContacts Exception : " + e);
    }
    component.set("v.contactFilteredData", results);
  },

  getRecordTypeId: function(component) {
    var action = component.get("c.getRecordTypeId");

    action.setParams({
      developerName: component.get("v.developerName"),
      sobjectName: component.get("v.sObjectName")
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var serviceRequestRecordTypeId = response.getReturnValue();
        component.set(
          "v.serviceRequestRecordTypeId",
          serviceRequestRecordTypeId
        );
      }
    });
    $A.enqueueAction(action);
  },

  closeFocusedTab: function(component) {
    var workspaceAPI = component.find("workspace");

    workspaceAPI
      .getFocusedTabInfo()
      .then(function(response) {
        var focusedTabId = response.tabId;
        workspaceAPI.closeTab({ tabId: focusedTabId });
      })
      .catch(function(error) {
        console.log(error);
      });
  },
  closeFocusedTabAndOpenNewTab: function(component, caseId) {
    var workspaceAPI = component.find("workspace");

    workspaceAPI
      .getFocusedTabInfo()
      .then(function(response) {
        var focusedTabId = response.tabId;

        console.log(focusedTabId);

        //Opening New Tab
        workspaceAPI
          .openTab({
            url: "#/sObject/" + caseId + "/view"
          })
          .then(function(response) {
            workspaceAPI.focusTab({ tabId: response });
          })
          .catch(function(error) {
            console.log(error);
          });

        //Closing old tab
        workspaceAPI.closeTab({ tabId: focusedTabId });
      })
      .catch(function(error) {
        console.log(error); 
      });
  },

  createAccountContactRelationship : function(component, accountRecordId, parentRecordId, role, shareholderPercentage, designation) {
        var rolesList = JSON.stringify(role);
        var ubo = component.find("uboFld").get("v.value");
        var parentRelationshipId = component.get("v.parentRelationshipId");
        //primaryEntityId parameter Added by Chandra
        var action = component.get("c.createRelationship");
        action.setParams({
            "relAccId" : accountRecordId,
            "parentAccId" : parentRecordId,
            "roles" : rolesList,
            "sharePercentage" : shareholderPercentage,
            "designation" :designation,
            "ubo":ubo,
            "primaryEntityId" :component.get("v.primaryEntityId"),
            "parentRelationshipId" : component.get("v.parentRelationshipId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                console.log('SUCCESS');
            }
        });
        $A.enqueueAction(action);
    },
    callHanisService  : function(component, event){
        var action = component.get("c.callHanisService");
        var prospectRecord = component.get("v.newIndivProspect");
        var idNumber = component.find("iSearchValue").get("v.value");
        action.setParams({
            "idNumber" : idNumber
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(respObj.statusCode != 200){
					console.log('HANIS SERVICE ERROR OCCURRED');  
                    console.log('STATUS CODE:'+respObj.statusCode+'MESSAGE:'+respObj.message);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Hanis Service Error!",
                        "message": "STATUS CODE:"+respObj.statusCode+" MESSAGE:"+respObj.message
                    });
                } else { 
                    console.log('HANIS SERVICE SUCCESS'); 
                    component.set('v.hanisResponse',respObj);
                    component.set('v.newIndivProspect.LastName',respObj.surname);
                    component.set('v.newIndivProspect.ID_Number__pc',respObj.idNumber);
                    this.callCPBService(component, event);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    callCPBService  : function(component, event){
        this.showSpinner(component);
        var action = component.get("c.callCPBService");
        var prospectRecord = component.get("v.newIndivProspect"); 
        var idNumber = prospectRecord.ID_Number__pc;
        var hanisResponseValues = prospectRecord.LastName;
        action.setParams({
                "idNumber" : idNumber,
                "lastName" : hanisResponseValues
            });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(respObj.statusCode != 200){
					console.log('CPB SERVICE ERROR OCCURRED');  
                    console.log('STATUS CODE:'+respObj.statusCode+'MESSAGE:'+respObj.message);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "CPB Service Error!",
                        "message": "STATUS CODE:"+respObj.statusCode+" MESSAGE:"+respObj.message
                    });
                } else {
                    console.log('CPB SERVICE SUCCESS');       
                    component.set('v.CPBResponse',respObj);
                }
                this.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.accountContactRelation"),
            "fld": fieldName
        });
        var opts = [];
         var clientType = component.get("v.accountParentRecord.Client_Type__c");
        console.log('clientType'+clientType);
        
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //Condition Added by chandra for Trusts and Close Corporation against 4746, 5410
                var allValues;
                if(component.get("v.clientTypeVal") == 'Trusts' && elementId == 'Roles'){
       				let trustRoleString= $A.get("$Label.c.Roles_For_Trust");
                    let trustRoleList = trustRoleString.split(';');
                     allValues = trustRoleList;
                }
                else if(component.get("v.clientTypeVal") == 'Close Corporation' && elementId == 'Roles'){
              		let ccRoleString= $A.get("$Label.c.Roles_For_CC");
                    let ccRoleList = ccRoleString.split(';');
                    allValues = ccRoleList;
                }else if(component.get("v.clientTypeVal") == 'Private Company' && elementId == 'Roles'){
               		let pcRoleString= $A.get("$Label.c.Roles_For_PC");
                    let pcRoleList = pcRoleString.split(';');
                    allValues = pcRoleList;
                }else if(component.get("v.clientTypeVal") == 'Co-operative' && elementId == 'Roles'){
                    let cooperativesRoleString = $A.get("$Label.c.Roles_for_Co_operatives");
                    let cooperativesRoleList = cooperativesRoleString.split(';');
                    allValues = cooperativesRoleList;
                } else if(component.get("v.clientTypeVal") == 'Foreign Company' && elementId == 'Roles'){
                    let foreignCompaniesRoleString = $A.get("$Label.c.Roles_For_Foreign_Companies");
                    let foreignCompaniesRoleList = foreignCompaniesRoleString.split(';');
                    allValues = foreignCompaniesRoleList;
                } else if(component.get("v.clientTypeVal") == 'Foreign Listed Company' && elementId == 'Roles'){
                    let foreignListedCompaniesRoleString = $A.get("$Label.c.Roles_For_Foreign_Companies");
                    let foreignListedCompaniesRoleList = foreignListedCompaniesRoleString.split(';');
                    allValues = foreignListedCompaniesRoleList;
                } else if(component.get("v.clientTypeVal") == 'Foreign Trust' && elementId == 'Roles'){
                    let foreignTrustRoleString = $A.get("$Label.c.Roles_For_Foreign_Trust");
                    let foreignTrustRoleList = foreignTrustRoleString.split(';');
                    allValues = foreignTrustRoleList;
                } else if(component.get("v.clientTypeVal") == 'Public Listed Company' && elementId == 'Roles'){
                    let publicListedCompanyRoleString = $A.get("$Label.c.Roles_For_Public_Listed_Company");
                    let publicListedCompanyRoleList = publicListedCompanyRoleString.split(';');
                    allValues = publicListedCompanyRoleList;
                } else if(component.get("v.clientTypeVal") == 'Clubs/Societies/Associations/Other Informal Bodies' && elementId == 'Roles'){
                    let pcRoleString= $A.get("$Label.c.Roles_for_Clubs_Societies_Associations_Other_Informal_Bodies");
                    let pcRoleList = pcRoleString.split(';');
                    allValues = pcRoleList;
                } else if(component.get("v.clientTypeVal") == 'Incorporated Company' && elementId == 'Roles'){
                    let pcRoleString= $A.get("$Label.c.Roles_for_Incorporated_Companies");
                    let pcRoleList = pcRoleString.split(';');
                    allValues = pcRoleList;
                } else if(component.get("v.clientTypeVal") == 'Not for Profit Companies' && elementId == 'Roles'){
                    let pcRoleString= $A.get("$Label.c.Roles_for_Not_for_Profit_Companies");
                    let pcRoleList = pcRoleString.split(';');
                    allValues = pcRoleList;
                } else if(component.get("v.clientTypeVal") == 'Not for Profit Organizations (NGO)' && elementId == 'Roles'){
                    let pcRoleString= $A.get("$Label.c.Roles_for_Not_for_Profit_Organizations");
                    let pcRoleList = pcRoleString.split(';');
                    allValues = pcRoleList;
                }else{
                    allValues = response.getReturnValue();
                }
                console.log('allValues: '+JSON.stringify(allValues));
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                if(elementId == 'Roles') {
                    console.log('optsRoles: '+JSON.stringify(opts));
                    component.set("v.roleOptions", opts); 
                }
                if(elementId == 'Designation__c') {
                    component.set("v.designationOptions", allValues); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateAccAndCreateAccConRelation: function(component,editedAccount,parentId) {
        console.log('@@@@primaryEntityId: '+component.get("v.primaryEntityId"));
        console.log('@@@@roles: '+component.get("v.selectedRole"));
        console.log('@@@@sharePercentage: '+component.find("editSharePercent").get("v.value"));
        console.log('@@@@parentRelationshiId: '+ component.get("v.parentRelationshipId"));

        var roles = component.get("v.selectedRole");
        sharePercentage = component.find("editSharePercent").get("v.value");
        //primaryEntityId parameter added by chandra dated 02/08/2020 
        var action = component.get("c.updateAccAndCreateAccConReln");
        action.setParams({
            "account":editedAccount,
            "parentId":parentId,
            "roles":roles,
            "sharePercentage":sharePercentage,
            "primaryEntityId":component.get("v.primaryEntityId"),
            "parentRelationshipId":component.get("v.parentRelationshipId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var editedAccount = response.getReturnValue();
                console.log("editedAccount "+JSON.stringify(editedAccount));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
                component.set("v.isUpdateRelatedParty",false);
            }else{
                var errors = response.getError();
                var errorMsg = '';
                console.log(' errors '+JSON.stringify(errors));
                if(errors != null &&  errors != undefined){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        errorMsg = errors[0].message;
                    }else{
                    errorMsg = 'Given details is incorrect, Please try again.';
                }
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errorMsg//"Something went wrong, Please try again."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    fetchAccDetails: function(component, elementId) {
        var action = component.get("c.fetchPersonAccDetails");
        action.setParams({
            "accId":elementId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var editedAccount = response.getReturnValue();
               console.log("editedAccount "+JSON.stringify(editedAccount));
                component.set("v.editedAccount",editedAccount);
                var countryOfCitizenShip = []; 
                if(editedAccount.Country_of_Citizenship__c != null && editedAccount.Country_of_Citizenship__c !='' && editedAccount.Country_of_Citizenship__c != undefined){
                    if(editedAccount.Country_of_Citizenship__c.includes(';')){
                        countryOfCitizenShip = editedAccount.Country_of_Citizenship__c.split(';');
                    }else{
                        countryOfCitizenShip.push(editedAccount.Country_of_Citizenship__c);
                    }
                }
                component.set("v.countryOfCitizenShip",countryOfCitizenShip);
                
            }
        });
        $A.enqueueAction(action);
    },
    fetchCountryValues: function(component, fieldName, elementId) {
        var action = component.get("c.getPickListValues");
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log('allValues '+JSON.stringify(allValues));
                component.set("v.countryValuesArray_NEW",allValues);
            }
        });
        $A.enqueueAction(action);
    },
    updateAccAndCreateAccConRelation: function(component,editedAccount,parentId) {
        console.log('@@@@primaryEntityId: '+component.get("v.primaryEntityId"));
        console.log('@@@@roles: '+component.get("v.selectedRole"));
        console.log('@@@@sharePercentage: '+component.find("editSharePercent").get("v.value"));
        console.log('@@@@parentRelationshipId: '+component.get("v.parentRelationshipId"));
        var roles = component.get("v.selectedRole");
        var sharePercentage = component.find("editSharePercent").get("v.value");
        //primaryEntityId parameter added by chandra dated 02/08/2020 
        var action = component.get("c.updateAccAndCreateAccConReln");
        action.setParams({
            "account":editedAccount,
            "parentId":parentId,
            "roles":roles,
            "sharePercentage":sharePercentage,
            "primaryEntityId":component.get("v.primaryEntityId"),
            "parentRelationshipId":component.get("v.parentRelationshipId")
            
        });
        action.setCallback(this, function(response) {
            //alert(response.getState());
            if (response.getState() == "SUCCESS") {
                var editedAccount = response.getReturnValue();
                console.log("editedAccount "+JSON.stringify(editedAccount));
                //helper.hideSpinner(component);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
                component.set("v.isUpdateRelatedParty",false);
            }else{
                //this.hideSpinner(component);
                var errors = response.getError();
                var errorMsg = '';
                console.log(' errors '+JSON.stringify(errors));
                if(errors != null &&  errors != undefined){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        errorMsg = errors[0].message;
                    }else{
                        errorMsg = 'Given details is incorrect, Please try again.';
                    }
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errorMsg//"Something went wrong, Please try again."
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    fetchAccDetails: function(component, elementId) {
        var action = component.get("c.fetchPersonAccDetails");
        action.setParams({
            "accId":elementId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var editedAccount = response.getReturnValue();
               console.log("editedAccount "+JSON.stringify(editedAccount));
                component.set("v.editedAccount",editedAccount);
                var countryOfCitizenShip = []; 
                if(editedAccount.Country_of_Citizenship__c != null && editedAccount.Country_of_Citizenship__c !='' && editedAccount.Country_of_Citizenship__c != undefined){
                    if(editedAccount.Country_of_Citizenship__c.includes(';')){
                        countryOfCitizenShip = editedAccount.Country_of_Citizenship__c.split(';');
                    }else{
                        countryOfCitizenShip.push(editedAccount.Country_of_Citizenship__c);
                    }
                }
                component.set("v.countryOfCitizenShip",countryOfCitizenShip);
                
            }
        });
        $A.enqueueAction(action);
    },
    //Added by Diksha for SPM 
    showPmuserlist : function(component, event, helper) {
        var action = component.get("c.getPortfolioManagerlist");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var ttt = response.getReturnValue();
                
                component.set('v.pmList',response.getReturnValue());
                var portManger = component.get("v.pmList");
                var selScheme = component.get("v.selectedPm");
                component.set("v.selectedPm", selScheme);
                // this.creatingSPMOpp(component, event, helper);
            }else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    getloggedinUserProfileName : function(component, event, helper) {
        var action = component.get("c.getloggedinUserProfileName");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var loggedinProfile = response.getReturnValue();
                
                component.set('v.loggedinUserProfile',response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    creatingSPMOpp : function(component, event, helper) {
        helper.showSpinner(component);
        var selectedPm ;
        var userId = $A.get("$SObjectType.CurrentUser.Name");
        if(component.get("v.selectedPm") == undefined){
            selectedPm=userId;
        }else{
            selectedPm = component.get("v.selectedPm");
        }
        //Get logged in User details
        var action = component.get("c.createNewSPMOpportunity");
        
        action.setParams({
            "accRecord" : component.get("v.accountSelected"),
            "selectedPm": selectedPm
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var message;
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var oppId = response.getReturnValue();
                //Navigate to Opportunity
                if(oppId != null) {
                    console.log('opportunityRecordId : ' + oppId);
                    helper.closeFocusedTabAndOpenNewTab(component, oppId);
                } 
                //Error when inserting Opportunity
                else {
                    var toast = helper.getToast("Error", 'SPM Opportunity could not be created. Please contact your Salesforce Admin', "error");
                    toast.fire();
                }
                helper.hideSpinner(component);
                
            }else if(state === "ERROR"){
                var toast = helper.getToast("Error", 'SPM Opportunity could not be created. Please contact your Salesforce Admin', "error");
                toast.fire();
                helper.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },
});