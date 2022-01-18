public class CreateUpdateMetadataUtils implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(' success : '+ result);
        } else {
            System.debug(' fail : '+ result);
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static void createUpdateMetadata(String wrapperJSON) {
        CMDWrapper wrapper = (CMDWrapper) JSON.deserializeStrict(wrapperJSON, CMDWrapper.class);
        String fullName = wrapper.fullName;
        String label = wrapper.label;
        Map<String,Object> fieldWithValuesMap = new Map<String,Object>{ 
            'isActive__c' => wrapper.isActive,
            'Number__c' => wrapper.numberRecords,
            'DollarValue__c' => wrapper.dollarValue,
            'DonationAmount__c' => wrapper.donationAmount
        };

        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();

        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = fullName;
        customMetadata.label = label;
            
        for(String key : fieldWithValuesMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = fieldWithValuesMap.get(key); 
            customMetadata.values.add(customField);
        }
            
        mdContainer.addMetadata(customMetadata);

        CreateUpdateMetadataUtils callback = new CreateUpdateMetadataUtils();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);

        system.debug(jobId);
    }

    @AuraEnabled(cacheable=true)
    public static Benefit_Setting__mdt[] fetchBenefitSettings() {
        Benefit_Setting__mdt[] allbs = [
                SELECT Id, MasterLabel, DonationAmount__c, isActive__c, Number__c, DollarValue__c
                FROM Benefit_Setting__mdt ORDER BY DonationAmount__c ASC];

        return allbs;
    }
}

