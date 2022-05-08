/**
 * @description Integration Handler  Bean for bcmssavecase
 * @author Jaco de Lange
 * @created 2021-03-26
 
 */
public class CAFUpdateCase_IU_v1 {
    /**
 * @description Integration Handler  Bean for bcmssavecase
 * @author Jaco de Lange
 * @created 2021-03-26
 * @param xmlData
 * @param businessOriginatorRef
 * @return 
 
 */
    
    public static CAFUpdateCase_Req_IB_v1 mapRequestFields(String xmlData, String businessOriginatorRef) {
        //function to create a Date format for "Updated" field that matches the bcmssavecase Service
        //any format other that this turn to cause a request to fail
        Datetime dt = datetime.now();
        String day = String.valueOf(dt.format('dd'));
        String month = String.valueOf(dt.format('MM'));
        String year = String.valueOf(dt.Year());
        String hour = String.valueOf(dt.format('hh'));
        String min = String.valueOf(dt.format('mm'));
        String sec = String.valueOf(dt.format('ss'));
        String millisecond = String.valueOf(dt.millisecond());
        String dateForm = year + '-' + month + '-' + day + 'T' + hour + ':' + min + ':' + sec + '.' + millisecond;

        Datetime createdDate = Datetime.now();
        String createdDateValue = String.valueOf(DateTime.newInstance(createdDate.year(), createdDate.month(), createdDate.day()));
        CAFUpdateCase_Req_IB_v1 requestBean = new CAFUpdateCase_Req_IB_v1();
        requestBean.SaveCase = new CAFUpdateCase_Req_IB_v1.SaveCase();
        requestBean.SaveCase.TheCase = new CAFUpdateCase_Req_IB_v1.TheCase();
        requestBean.SaveCase.TheCase.ReferenceNumber = businessOriginatorRef;//'Salesforce';
        requestBean.SaveCase.TheCase.DefinitionId = 'FE968521-6B2E-4AC4-8673-F54F26C94507';
        requestBean.SaveCase.TheCase.DefinitionVersion = '1';
        requestBean.SaveCase.TheCase.Data = String.valueOf(xmlData);
        requestBean.SaveCase.TheCase.Status = 'QueuedForProcessing';
        requestBean.SaveCase.TheCase.Created = String.valueOf(createdDateValue).replace('00:00:00', '');
        requestBean.SaveCase.TheCase.Updated = dateForm;
        requestBean.SaveCase.TheCase.DisplayName = '';
        requestBean.SaveCase.TheCase.FreeTextTag = '';
        requestBean.SaveCase.savedBy = 'Salesforce';

        return requestBean;
    }
}