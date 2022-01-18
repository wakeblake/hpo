public class AddBenefitPickVal {
    public static void AddBenefitPickVal(String newPickVal) {
        /*
        String apiFieldName = 'Benefit__c.Type__c';

        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();

        MetadataService.CustomField customField = (MetadataService.CustomField) service.readMetadata(
                'CustomField', new String[] { apiFieldName }
            ).getRecords()[0];

        // For each on: customField > Get valueset > Get valueSetDefinition > get values
        for (MetadataService.CustomValue customValue : customField.valueSet.valueSetDefinition.value){
            if (customValue.label == newPickVal) { // API Name
                // TODO
                //objCustomValue.fullName = 'Close'; // New API Value
                //objCustomValue.label = 'Close'; // New Label value
            }
            customValue.fullName = newPickVal;
            customValue.label = newPickVal;
        }

        // Update 
        List<MetadataService.SaveResult> results = service.updateMetadata( new MetadataService.Metadata[] { customField });

        for (MetadataService.SaveResult r : results) {
            if (r.success) {
                System.debug('Successfully updated');
            }
            else {                       
                if (r.errors.size() > 0){
                System.debug('eror : ' + r.errors[0].message);
                }
            }
        }  
        */      
    }
}
