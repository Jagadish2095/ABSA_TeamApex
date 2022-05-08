({
    doInit: function (component, event, helper) {
        //get data

        helper.loadData(component, event);
        //helper.loadData(component,event);
    },

    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");
        console.log("ConsumerBurea: Source is: " + sourceComponent + " should be: Validation03");

        // Condition to not handle self raised event
        if (sourceComponent == 'Validation03') {
            //calling Init on App Event
            component.set("v.showSpinner", true);

            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },

    /** on change event calculate gross income */
    calculateGross: function (component, event, helper) {
        var applicantgross = 0;
        component.find("grossappValue").forEach(appval => {
            var applicantValue = appval.get("v.value");
            applicantgross = applicantgross + parseFloat(applicantValue);
            console.log("applicantValue---", applicantValue);
        });

        console.log("applicantgross---", applicantgross);
        component.set("v.grossMonthlyIncome", applicantgross);

        //spouse gross
        //
        var spousegross = 0;
        component.find("grosspouseValue").forEach(spval => {
            var spouseValue = spval.get("v.value");
            spousegross = spousegross + parseFloat(spouseValue);
            console.log("applicantValue---", spouseValue);

        });

        console.log("spousegross---", spousegross);
        component.set("v.SgrossMonthlyIncome", spousegross);

        var applicantnet = 0;
        component.find("netappValue").forEach(appval => {
            var applicantValue = appval.get("v.value");
            applicantnet = applicantnet + parseFloat(applicantValue);
            console.log("applicantValue---", applicantValue);

        });

        var spousenet = 0;
        component.find("netspouseValue").forEach(spval => {
            var spouseValue = spval.get("v.value");
            spousenet = spousenet + parseFloat(spouseValue);
            console.log("applicantValue---", spouseValue);

        });

        var finalnetApplicant = applicantgross - applicantnet;


        component.set("v.netMonthlyIncome", finalnetApplicant);

        var finalnetSpouse = spousegross - spousenet;

        component.set("v.SnetMonthlyIncome", finalnetSpouse);
        var totalhouse = finalnetApplicant + finalnetSpouse;
        component.set("v.nethouseIncome", totalhouse);

    },
    /** on change event calculate net income */
    calculateNet: function (component, event, helper) {
        var applicantnet = 0;
        component.find("netappValue").forEach(appval => {
            var applicantValue = appval.get("v.value");
            applicantnet = applicantnet + parseFloat(applicantValue);
            console.log("applicantValue---", applicantValue);

        });

        var grossApplicant = component.get("v.grossMonthlyIncome");
        var finalnetApplicant = parseFloat(grossApplicant) - applicantnet;
        console.log("finalnetApplicant---", finalnetApplicant);
        component.set("v.netMonthlyIncome", finalnetApplicant);

        //spouse net

        var spousenet = 0;
        component.find("netspouseValue").forEach(spval => {
            var spouseValue = spval.get("v.value");
            spousenet = spousenet + parseFloat(spouseValue);
            console.log("applicantValue---", spouseValue);

        });

        var grossSpouse = component.get("v.SgrossMonthlyIncome");
        var finalnetSpouse = parseFloat(grossSpouse) - spousenet;
        console.log("spousenet---", finalnetSpouse);
        component.set("v.SnetMonthlyIncome", finalnetSpouse);

        var totalhouse = finalnetApplicant + finalnetSpouse;
        component.set("v.nethouseIncome", totalhouse);

    },

    /** on change event calculate external installment total */
    calculateExtSpouseTotal: function (component, event, helper) {
        var extSpouseValue = 0;
        component.find("extSpouseVal").forEach(appval => {
            var spouseValue = appval.get("v.value");
            extSpouseValue = extSpouseValue + parseFloat(spouseValue);
            console.log("spouseValue---", spouseValue);

        });

        component.set("v.extSpousetotal", extSpouseValue);

    },
    /** on change event calculate house hold and Business hold expenses*/
    calculateHoldTotal: function (component, event, helper) {
        var householdtotal = 0;
        component.find("householdVal").forEach(appval => {
            var houseValue = appval.get("v.value");
            householdtotal = householdtotal + parseFloat(houseValue);
            console.log("houseValue---", houseValue);

        });

        console.log("householdtotal---", householdtotal);
        component.set("v.householdtotal", householdtotal);

        //
        var businessholdtotal = 0;
        component.find("businessholdVal").forEach(spval => {
            var businessValue = spval.get("v.value");
            businessholdtotal = businessholdtotal + parseFloat(businessValue);
            console.log("businessValue---", businessValue);

        });

        console.log("businessholdtotal---", businessholdtotal);
        component.set("v.businessholdtotal", businessholdtotal);
    },

    /* save all and display disposal section */
    saveAll: function (component, event, helper) {
        helper.saveAllIncomeExpenses(component, event);
    },
})