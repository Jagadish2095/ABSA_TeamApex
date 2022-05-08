({
    populateChequeDetails: function (component) {
        var chqAccs = component.get("v.chequeAccData");
        var recordId = component.get("v.recordId");

        console.log("recordId: " + recordId + " chqAccs: " + JSON.stringify(chqAccs));

        for (var i = 0; i < chqAccs.length; i++) {
            var chqAcc = chqAccs[i];

            if (recordId == chqAcc.SevAccountNameNumber) {
                console.log("found recordId: " + recordId + " matches chqAccs[i].ItemId: " + chqAcc.SevAccountNameNumber);
                component.set("{!v.accountNameNumber}", chqAcc.SevAccountNameNumber);
                component.set("{!v.chequeProductType}", chqAcc.SevAccountType);
                component.set("{!v.accountBalance}", chqAcc.SevAccountBalance);
                component.set("{!v.currentOverdraftLimit}", chqAcc.SevCurrentODLimit);
                component.set("{!v.expiryDate}", chqAcc.SevExpiryDate);
                component.set("{!v.facilityReviewDate}", chqAcc.SevFacilityReviewDate);
                component.set("{!v.alternativeFundIndicator}", chqAcc.SevAlternativeFundIndicator);
                component.set("{!v.alternativeFundCode}", chqAcc.SevAlternativeFundCode);
                component.set("{!v.restrictiveHold}", chqAcc.SevRestrictiveHold);
            }
        }
    },

    toggleModal: function (component) {
        $A.util.toggleClass(component.find("modal"), "slds-fade-in-open");
        $A.util.toggleClass(component.find("backdrop"), "slds-backdrop_open");
    }
});