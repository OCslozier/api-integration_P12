public class ContractService {
    public static void updateUuid(List<Contract> contracts) {
        
        for (Contract contract : contracts) {
            UUID randomUuid = UUID.randomUUID();
            String uuidStr = randomUUID.toString();
            contract.UUID__c = uuidStr;
        }
    }
}