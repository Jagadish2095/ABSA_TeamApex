({
    /****************@ Author: Chandra**********************************
     ****************@ Date: 20/10/2020*********************************
     ****************@ Work Id: W-006280,006901,007778,007783***********
     ***@ Description: Method Added by chandra to handle init function*/
    doInit: function (component, event, helper) {
        var selectedProductType = component.get("v.selectedProductType");
        if (selectedProductType != "LX") {
            var relationshipOptions = [
                { value: "", label: "--None--" },
                { value: "Ext Fam - Aunt", label: "Ext Fam - Aunt" },
                { value: "Child - Education Protector", label: "Child - Education Protector" },
                { value: "Son - Education Protector", label: "Son - Education Protector" },
                { value: "Child", label: "Child" },
                { value: "Ext Fam - Cousin", label: "Ext Fam - Cousin" },
                { value: "Ext Fam - Sister", label: "Ext Fam - Sister" },
                { value: "Daughter - Education Protector", label: "Daughter - Education Protector" },
                { value: "Father", label: "Father" },
                { value: "FMI- Daughter", label: "FMI- Daughter" },
                { value: "Daughter", label: "Daughter" },
                { value: "Ext Fam - Brother", label: "Ext Fam - Brother" },
                { value: "Ext Fam - Other", label: "Ext Fam - Other" },
                { value: "Father-in-law", label: "Father-in-law" },
                { value: "Stepmother", label: "Stepmother" },
                { value: "Mother-in-law", label: "Mother-in-law" },
                { value: "Mother", label: "Mother" },
                { value: "Stepfather", label: "Stepfather" },
                { value: "Ext Fam - Nephew", label: "Ext Fam - Nephew" },
                { value: "Ext Fam - Niece", label: "Ext Fam - Niece" },
                { value: "Other", label: "Other" },
                { value: "FMI- Step Daughter", label: "FMI- Step Daughter" },
                { value: "Son", label: "Son" },
                { value: "FMI- Son", label: "FMI- Son" },
                { value: "Special Child", label: "Special Child" },
                { value: "Spouse", label: "Spouse" },
                { value: "FMI- Step Son", label: "FMI- Step Son" },
                { value: "Ext Fam - Uncle", label: "Ext Fam - Uncle" },
                { value: "Student", label: "Student" }
            ];
            component.set("v.relationshipOptions", relationshipOptions);

            var idTypeOptions = [
                { value: "", label: "--None--" },
                { value: "SA Identity Document", label: "SA Identity Document" },
                { value: "Passport", label: "Passport" },
                { value: "Registration No", label: "Registration No" }
            ];
            component.set("v.idTypeOptions", idTypeOptions);

            var titleOptions = [
                { value: "", label: "--None--" },
                { value: "Mr.", label: "Mr." },
                { value: "Mrs.", label: "Mrs." },
                { value: "Mej.", label: "Mej." },
                { value: "Professor.", label: "Professor." },
                { value: "Dr.", label: "Dr." },
                { value: "Dominees.", label: "Dominees." }
            ];
            component.set("v.titleOptions", titleOptions);
        } else {
            //Added by chandra dated 12/02/2021
            var contactTypeIDOptions = [
                { value: "", label: "--None--" },
                { value: "Unknown", label: "Unknown" },
                { value: "Telephone Home", label: "Telephone Home" },
                { value: "Telephone Business", label: "Telephone Business" },
                { value: "Fax Home", label: "Fax Home" },
                { value: "Cell Number", label: "Cell Number" },
                { value: "Postal Address", label: "Postal Address" },
                { value: "Street Address", label: "Street Address" },
                { value: "Work Address", label: "Work Address" },
                { value: "E-Mail Address", label: "E-Mail Address" },
                { value: "Web Address", label: "Web Address" },
                { value: "Fax Work", label: "Fax Work" },
                { value: "Skype", label: "Skype" },
                { value: "Pager", label: "Pager" },
                { value: "Preferred Cell Number", label: "Preferred Cell Number" }
            ];
            component.set("v.contactTypeIDOptions", contactTypeIDOptions);

            var relationshipOptions = [
                { value: "", label: "--None--" },
                { value: "Unknown", label: "Unknown" },
                { value: "No relation on application", label: "No relation on application" },
                { value: "Spouse / 2nd spouse", label: "Spouse / 2nd spouse" },
                { value: "Child", label: "Child" },
                { value: "Grandfather", label: "Grandfather" },
                { value: "Grandmother", label: "Grandmother" },
                { value: "Uncle", label: "Uncle" },
                { value: "Aunt", label: "Aunt" },
                { value: "Cousin", label: "Cousin" },
                { value: "Nephew", label: "Nephew" },
                { value: "Niece", label: "Niece" },
                { value: "Mother", label: "Mother" },
                { value: "Father", label: "Father" },
                { value: "Sister", label: "Sister" },
                { value: "Brother", label: "Brother" },
                { value: "Son", label: "Son" },
                { value: "Daughter", label: "Daughter" },
                { value: "Stepfather", label: "Stepfather" },
                { value: "Mother-in-law", label: "Mother-in-law" },
                { value: "Stepmother", label: "Stepmother" },
                { value: "Ex-husband", label: "Ex-husband" },
                { value: "Ex-wife", label: "Ex-wife" },
                { value: "Grandson", label: "Grandson" },
                { value: "Granddaughter", label: "Granddaughter" },
                { value: "Grandchild", label: "Grandchild" },
                { value: "Stepson", label: "Stepson" },
                { value: "Stepdaughter", label: "Stepdaughter" },
                { value: "Father in-law", label: "Father in-law" },
                { value: "Sister in-law", label: "Sister in-law" },
                { value: "Brother in-law", label: "Brother in-law" },
                { value: "Fiance", label: "Fiance" },
                { value: "Stepbrother", label: "Stepbrother" },
                { value: "Stepsister", label: "Stepsister" },
                { value: "Husband", label: "Husband" },
                { value: "Son in law", label: "Son in law" },
                { value: "Daughter in law", label: "Daughter in law" },
                { value: "Child", label: "Child" },
                { value: "Wife", label: "Wife" },
                { value: "Grandfather in-law", label: "Grandfather in-law" },
                { value: "Grandmother-in-law", label: "Grandmother-in-law" },
                { value: "Godfather", label: "Godfather" },
                { value: "Godmother", label: "Godmother" },
                { value: "Aunt-in-law", label: "Aunt-in-law" },
                { value: "Surety", label: "Surety" },
                { value: "Business partner", label: "Business partner" },
                { value: "Student", label: "Student" },
                { value: "Housemaid", label: "Housemaid" },
                { value: "Gardener or Caretaker ", label: "Gardener or Caretaker " },
                { value: "Chauffer", label: "Chauffer" },
                { value: "SChild Minder", label: "Child Minder" }
            ];
            component.set("v.relationshipOptions", relationshipOptions);

            var idTypeOptions = [
                { value: "", label: "--None--" },
                { value: "SA Identity Document", label: "SA Identity Document" },
                { value: "Passport", label: "Passport" },
                { value: "CIF Number", label: "CIF Number" }
            ];
            component.set("v.idTypeOptions", idTypeOptions);

            var titleOptions = [
                { value: "", label: "--None--" },
                { value: "Mr", label: "Mr" },
                { value: "Mrs", label: "Mrs" },
                { value: "Miss", label: "Miss" },
                { value: "Ms", label: "Ms" },
                { value: "Doctor", label: "Doctor" },
                { value: "Admiral", label: "Admiral" },
                { value: "Advocate", label: "Advocate" },
                { value: "Brigadier", label: "Brigadier" },
                { value: "Brigadier-General", label: "Brigadier-General" },
                { value: "Captain", label: "Captain" },
                { value: "Chief", label: "Chief" },
                { value: "Colonel", label: "Colonel" },
                { value: "Commissioner", label: "Commissioner" },
                { value: "Constable", label: "Constable" },
                { value: "Director", label: "Director" },
                { value: "Estate Late", label: "Estate Late" },
                { value: "Eerwaarde", label: "Eerwaarde" },
                { value: "Father", label: "Father" },
                { value: "General", label: "General" },
                { value: "Insolvent Estate", label: "Insolvent Estate" },
                { value: "Inspector", label: "Inspector" },
                { value: "Judge", label: "Judge" },
                { value: "Lady", label: "Lady" },
                { value: "Lieutenant", label: "Lieutenant" },
                { value: "Lieutenant Colonel", label: "Lieutenant Colonel" },
                { value: "Lieutenant General", label: "Lieutenant General" },
                { value: "Lord", label: "Lord" },
                { value: "Major", label: "Major" },
                { value: "Major General", label: "Major General" },
                { value: "Minister", label: "Minister" },
                { value: "Paramount Chief", label: "Paramount Chief" },
                { value: "Pastor", label: "Pastor" },
                { value: "President", label: "President" },
                { value: "Professor", label: "Professor" },
                { value: "Rabbi", label: "Rabbi" },
                { value: "Reverend", label: "Reverend" },
                { value: "Sergeant", label: "Sergeant" },
                { value: "Sergeant Major", label: "Sergeant Major" },
                { value: "Sir", label: "Sir" },
                { value: "Sister", label: "Sister" },
                { value: "The Honourable", label: "The Honourable" },
                { value: "Warrant Officer", label: "Warrant Officer" },
                { value: "Superintendent/Senior Su", label: "Superintendent/Senior Su" }
            ];
            component.set("v.titleOptions", titleOptions);
        }

        var idNumber = component.get("v.idNumber");
        if (component.get("v.actionType") == "Edit" && (idNumber == undefined || idNumber == "" || idNumber == null)) {
            component.find("idNumberEdit").set("v.readonly", false);
        }
    },

    /****************@ Author: Chandra***********************************
     ****************@ Date: 20/10/2020**********************************
     ****************@ Work Id: W-006280,006901,007778,007783************
     ***@ Description: Method Added by chandra to handle Cancel function*/
    handleCancel: function (component, event, helper) {
        component.find("overlayLib").notifyClose();
    },

    /****************@ Author: Chandra**********************************
     ****************@ Date: 20/10/2020*********************************
     ****************@ Work Id: W-006280,006901,007778,007783************
     ***@ Description: Method Added by chandra to handle update function*/
    handleUpdate: function (component, event, helper) {
        helper.checkRequiredValidation(component, event, helper);
        if (component.get("v.isRequiredValidationNotPassed") == false) {
            helper.SetDataToPassParentComp(component, event, helper);
        }
    },

    /****************@ Author: Chandra**********************************
     ****************@ Date: 20/10/2020*********************************
     ****************@ Work Id: W-006280,006901,007778,007783************
     ***@ Description: Method Added by chandra to handle update function*/
    handleAdd: function (component, event, helper) {
        helper.checkRequiredValidation(component, event, helper);
        if (component.get("v.isRequiredValidationNotPassed") == false) {
            helper.SetDataToPassParentComp(component, event, helper);
        }
    },

    /****************@ Author: Chandra**********************************
     ****************@ Date: 20/10/2020*********************************
     ****************@ Work Id: W-006280,006901,007778,007783***********
     ***@ Description: Method Added by chandra to set Selected Client**/
    handleApplicationEvent: function (component, event, helper) {
        var selectedAccount = event.getParam("accountValue");
        var isIndivClient = event.getParam("isIndivClient");
        if (isIndivClient == true && selectedAccount != "") {
            component.set("v.showNonIndividualWarning", false);
            component.set("v.firstName", selectedAccount.FirstName);
            component.set("v.surName", selectedAccount.LastName);
            component.set("v.idType", selectedAccount.ID_Type__pc);
            component.set("v.idNumber", selectedAccount.ID_Number__pc);
            component.set("v.emailAddress", selectedAccount.PersonEmail);
            component.set("v.contactTelephoneNumber", selectedAccount.PersonMobilePhone);
            component.set("v.dateOfBirth", selectedAccount.PersonBirthdate);
            component.set("v.addressLine1", selectedAccount.BillingStreet);
            component.set("v.city", selectedAccount.BillingCity);
            component.set("v.postalCode", selectedAccount.BillingPostalCode);
        } else if (isIndivClient == false && selectedAccount != "") {
            component.set("v.showNonIndividualWarning", true);
            component.set("v.firstName", "");
            component.set("v.surName", "");
            component.set("v.idType", "");
            component.set("v.idNumber", "");
            component.set("v.emailAddress", "");
            component.set("v.contactTelephoneNumber", "");
            component.set("v.dateOfBirth", "");
            component.set("v.addressLine1", "");
            component.set("v.city", "");
            component.set("v.postalCode", "");
        }
    }
});