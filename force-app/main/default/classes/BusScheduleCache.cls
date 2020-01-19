public with sharing class BusScheduleCache
{
    private Cache.OrgPartition part;

    public BusScheduleCache()
    {
        part = new Cache.OrgPartition('local.BusSchedule');
    }

    public void putSchedule(String busLine, Time[] schedule)
    {
        part.put(busLine, schedule);
    }

    public Time[] getSchedule(String busLine)
    {
        Time[] schedule = new List<Time>();
        Object value = part.get(busLine);
        if(value != null)
        {
            Time result = (Time)value;
            schedule.add(result);
            return schedule;
        }
        schedule.add(Time.newInstance(8,0,0,0));
        schedule.add(Time.newInstance(17,0,0,0));
        return schedule;
    }
}