public class ScheduleTest implements Schedulable{
    public ScheduleTest(){}
    
    public void execute(SchedulableContext sc){
        if(true){
            ScheduleTest m = new ScheduleTest();
            String sch = Datetime.now().addSeconds(5).format('s m H d M ? yyyy');
            String jobID = system.schedule('test ' + sch, sch, m);
            for(CronTrigger job : getJobs()){
                system.debug('::'+job.State + '::'+job.CronJobDetail.Name);
                if(job.state == 'DELETED' || job.state == 'EXECUTING')
                    system.abortJob(job.Id);
            }
        }
        else{
            for(CronTrigger job : getJobs()){
                system.debug('::'+job.State + '::'+job.CronJobDetail.Name);
                if(job.state == 'DELETED' || job.state == 'EXECUTING')
                    system.abortJob(job.Id);
        }
    }
    }
    
    List<CronTrigger> getJobs(){
        return [SELECT Id, CronJobDetail.Name, State
        FROM CronTrigger];
    }
}