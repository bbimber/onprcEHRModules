package org.labkey.GeneticsCore.notification;

import org.apache.log4j.Logger;
import org.labkey.GeneticsCore.GeneticsCoreManager;
import org.labkey.GeneticsCore.GeneticsCoreModule;
import org.labkey.api.data.CompareType;
import org.labkey.api.data.Container;
import org.labkey.api.data.SimpleFilter;
import org.labkey.api.data.TableInfo;
import org.labkey.api.data.TableSelector;
import org.labkey.api.ldk.notification.Notification;
import org.labkey.api.ldk.notification.NotificationService;
import org.labkey.api.module.ModuleLoader;
import org.labkey.api.query.FieldKey;
import org.labkey.api.query.QueryAction;
import org.labkey.api.query.QueryService;
import org.labkey.api.security.User;
import org.labkey.api.util.PageFlowUtil;
import org.labkey.api.view.ActionURL;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * User: bimber
 * Date: 6/29/13
 * Time: 8:23 AM
 */
public class GeneticsCoreNotification implements Notification
{
    protected final static Logger _log = Logger.getLogger(GeneticsCoreNotification.class);
    protected final static SimpleDateFormat _dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd kk:mm");
    protected final static SimpleDateFormat _dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    protected NotificationService _ns = NotificationService.get();

    public GeneticsCoreNotification()
    {

    }

    @Override
    public String getName()
    {
        return "Genetics Core Notification";
    }

    @Override
    public String getEmailSubject()
    {
        return "Genetics Core Alerts: " + _dateTimeFormat.format(new Date());
    }

    public boolean isAvailable(Container c)
    {
        if (!c.getActiveModules().contains(ModuleLoader.getInstance().getModule(GeneticsCoreModule.class)))
            return false;

        return true;
    }

    public String getCategory()
    {
        return "Genetics";
    }

    @Override
    public String getCronString()
    {
        return "0 30 5 ? * WED";
    }

    @Override
    public String getScheduleDescription()
    {
        return "every Wednesday at 5:30AM";
    }

    @Override
    public String getDescription()
    {
        return "The report is designed provide a summary of animals requiring blood draws for genetics services, or animals that have been tagged as having blood drawn, but lack data.";
    }

    public String getMessage(Container c, User u)
    {
        StringBuilder msg = new StringBuilder();

        getMHCDiscrepancies(c, u, msg);
        getMHCConflictingFlags(c, u, msg);
        getActiveExclusions(c, u, msg, GeneticsCoreManager.MHC_DRAW_NEEDED);

        getDNADiscrepancies(c, u, msg);
        getDNAConflictingFlags(c, u, msg);
        getActiveExclusions(c, u, msg, GeneticsCoreManager.DNA_DRAW_NEEDED);

        getParentageDiscrepancies(c, u, msg);
        getParentageConflictingFlags(c, u, msg);
        getActiveExclusions(c, u, msg, GeneticsCoreManager.PARENTAGE_DRAW_NEEDED);

        return msg.toString();
    }

    public void getActiveExclusions(Container c, User u, StringBuilder msg, String flag)
    {
        SimpleFilter filter = new SimpleFilter();
        filter.addCondition(FieldKey.fromString("isActive"), true, CompareType.EQUAL);
        filter.addCondition(FieldKey.fromString("flag"), flag, CompareType.EQUAL);

        TableInfo ti = QueryService.get().getUserSchema(u, c, "study").getTable("Animal Record Flags");
        TableSelector ts = new TableSelector(ti, PageFlowUtil.set("Id"), filter, null);
        long count = ts.getRowCount();
        if (count > 0)
        {
            ActionURL url = QueryService.get().urlFor(u, c, QueryAction.executeQuery, "study", "processingGeneticsBloodDraws");
            url.addParameter("query.flags~contains", flag);

            msg.append("<b>WARNING: There are " + count + " animals actively flagged as '" + flag + "'.  If these animals have been drawn, this flag should be removed to avoid confusion.</b>  <a href='" + url.toString() + "'>Click here to view these animals</a><hr>");
        }
    }

    public void getMHCDiscrepancies(Container c, User u, StringBuilder msg)
    {
        String queryName = "mhcFlagSummary";

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.DATE, -180);

        SimpleFilter filter = new SimpleFilter();
        filter.addCondition(FieldKey.fromString("hasMhcDrawnFlag"), true, CompareType.EQUAL);
        filter.addCondition(FieldKey.fromString("drawnFlagDateAdded"), cal.getTime(), CompareType.DATE_LTE);
        filter.addCondition(FieldKey.fromString("hasMHCData"), false, CompareType.EQUAL);

        TableInfo ti = QueryService.get().getUserSchema(u, c, "study").getTable(queryName);
        TableSelector ts = new TableSelector(ti, PageFlowUtil.set("Id"), filter, null);
        long count = ts.getRowCount();
        if (count > 0)
        {
            ActionURL url = QueryService.get().urlFor(u, c, QueryAction.executeQuery, "study", queryName);
            url.addParameter("query.hasMhcDrawnFlag~eq", true);
            url.addParameter("query.drawnFlagDateAdded~datelte", "-180d");
            url.addParameter("query.hasMHCData~eq", false);

            msg.append("<b>WARNING: There are " + count + " animals that have been flagged as drawn for MHC typing more than 6 months ago that lack MHC data.</b>  <a href='" + url.toString() + "'>Click here to view these animals</a><hr>");
        }
    }

    public void getDNAConflictingFlags(Container c, User u, StringBuilder msg)
    {
        getConflictingFlags(c, u, msg, "DNA Bank", GeneticsCoreManager.DNA_DRAW_NEEDED, GeneticsCoreManager.DNA_DRAW_COLLECTED);
    }

    public void getMHCConflictingFlags(Container c, User u, StringBuilder msg)
    {
        getConflictingFlags(c, u, msg, "MHC Typing", GeneticsCoreManager.MHC_DRAW_NEEDED, GeneticsCoreManager.MHC_DRAW_COLLECTED);
    }

    public void getParentageConflictingFlags(Container c, User u, StringBuilder msg)
    {
        getConflictingFlags(c, u, msg, "Parentage", GeneticsCoreManager.PARENTAGE_DRAW_NEEDED, GeneticsCoreManager.PARENTAGE_DRAW_COLLECTED);
    }

    public void getConflictingFlags(Container c, User u, StringBuilder msg, String noun, String flag1, String flag2)
    {
        String queryName = "processingGeneticsBloodDraws";
        SimpleFilter filter = new SimpleFilter();
        filter.addCondition(FieldKey.fromString("flags"), flag1, CompareType.CONTAINS);
        filter.addCondition(FieldKey.fromString("flags"), flag2, CompareType.CONTAINS);

        TableInfo ti = QueryService.get().getUserSchema(u, c, "study").getTable(queryName);
        TableSelector ts = new TableSelector(ti, PageFlowUtil.set("Id"), filter, null);
        long count = ts.getRowCount();
        if (count > 0)
        {
            ActionURL url = QueryService.get().urlFor(u, c, QueryAction.executeQuery, "study", queryName);
            url.addParameter("query.flags~contains", flag1);
            url.addParameter("query.flags~contains", flag2);

            msg.append("<b>WARNING: There are " + count + " animals that have been flagged as drawn for " + noun + " and needing blood draw for " + noun + ".  One of these conflicting flags should be removed</b>  <a href='" + url.toString() + "'>Click here to view these animals</a><hr>");
        }
    }

    public void getDNADiscrepancies(Container c, User u, StringBuilder msg)
    {
//        String queryName = "dnaFlagSummary";
//

    }

    public void getParentageDiscrepancies(Container c, User u, StringBuilder msg)
    {
        String queryName = "parentageFlagSummary";
        SimpleFilter filter = new SimpleFilter();

        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.DATE, -180);

        filter.addCondition(FieldKey.fromString("hasParentageDrawnFlag"), true, CompareType.EQUAL);
        filter.addCondition(FieldKey.fromString("drawnFlagDateAdded"), cal.getTime(), CompareType.DATE_LTE);
        filter.addCondition(FieldKey.fromString("hasParentageData"), false, CompareType.EQUAL);

        TableInfo ti = QueryService.get().getUserSchema(u, c, "study").getTable(queryName);
        TableSelector ts = new TableSelector(ti, PageFlowUtil.set("Id"), filter, null);
        long count = ts.getRowCount();
        if (count > 0)
        {
            ActionURL url = QueryService.get().urlFor(u, c, QueryAction.executeQuery, "study", queryName);
            url.addParameter("query.hasParentageDrawnFlag~eq", true);
            url.addParameter("query.drawnFlagDateAdded~datelte", "-180d");
            url.addParameter("query.hasParentageData~eq", false);

            msg.append("<b>WARNING: There are " + count + " animals that have been flagged as drawn for Parentage more than 6 months ago that lack Parentage data.</b>  <a href='" + url.toString() + "'>Click here to view these animals</a><hr>");
        }
    }
}
