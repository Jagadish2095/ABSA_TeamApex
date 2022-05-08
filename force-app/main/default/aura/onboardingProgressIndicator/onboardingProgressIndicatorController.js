/****************@ Author: Chandra****************************************
 ****************@ Date: 2019-12-02***************************************
 ****************@ Description: Method to call init to show progress Steps*/

({
	init: function (cmp) {
        cmp.set('v.steps', [
            { label: 'Complete Client Details', value: 'Complete Client Details' },
            { label: 'Create CASA', value: 'Create CASA' },
            { label: 'Run Risk Profile', value: 'Run Risk Profile' },
            { label: 'Generate CIF', value: 'Generate CIF' }
        ]);
    }
})