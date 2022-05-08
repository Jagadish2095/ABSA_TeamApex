({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Application Number', fieldName: 'applicationNumber', type: 'text'},
            {label: 'Article Desciption', fieldName: 'articleDesciption', type: 'text'},
            {label: 'Financed Amount', fieldName: 'financedAmount', type: 'text'},
            {label: 'Extras', fieldName: 'extras', type: 'text'},
            {label: 'VAPs', fieldName: 'vaps', type: 'text'},
            {label: 'Case Number', fieldName: 'caseNumber', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'},
            {label: 'Last Updated', fieldName: 'lastUpdated', type: 'text'}
        ]);



        //helper.fetchData(cmp, fetchData, 10);
    }
});