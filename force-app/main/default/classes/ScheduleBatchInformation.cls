global class ScheduleBatchInformation implements Schedulable{
    global void execute(SchedulableContext sc) {
        InformationBatch ib = new InformationBatch(); 
        Database.executeBatch(ib);
     }

}