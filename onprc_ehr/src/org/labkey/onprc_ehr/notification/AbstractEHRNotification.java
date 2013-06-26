/*
 * Copyright (c) 2012-2013 LabKey Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.labkey.onprc_ehr.notification;

import org.apache.log4j.Logger;
import org.jetbrains.annotations.Nullable;
import org.labkey.api.data.Container;
import org.labkey.api.data.Results;
import org.labkey.api.ldk.notification.Notification;
import org.labkey.api.ldk.notification.NotificationService;
import org.labkey.api.module.ModuleLoader;
import org.labkey.api.query.DetailsURL;
import org.labkey.api.query.FieldKey;
import org.labkey.api.query.QueryService;
import org.labkey.api.query.UserSchema;
import org.labkey.api.security.User;
import org.labkey.api.settings.AppProps;
import org.labkey.api.study.Study;
import org.labkey.api.study.StudyService;
import org.labkey.onprc_ehr.ONPRC_EHRModule;

import java.sql.SQLException;
import java.text.SimpleDateFormat;

/**
 * User: bimber
 * Date: 12/19/12
 * Time: 7:32 PM
 */
abstract public class AbstractEHRNotification implements Notification
{
    protected final static Logger log = Logger.getLogger(AbstractEHRNotification.class);
    protected final static SimpleDateFormat _dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd kk:mm");
    protected final static SimpleDateFormat _dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    protected final static SimpleDateFormat _timeFormat = new SimpleDateFormat("kk:mm");

    protected NotificationService _ns = NotificationService.get();

    public boolean isAvailable(Container c)
    {
        if (!c.getActiveModules().contains(ModuleLoader.getInstance().getModule(ONPRC_EHRModule.class)))
            return false;

        if (StudyService.get().getStudy(c) == null)
            return false;

        return true;
    }

    protected UserSchema getStudySchema(Container c, User u)
    {
        return QueryService.get().getUserSchema(u, c, "study");
    }

    protected UserSchema getEHRSchema(Container c, User u)
    {
        return QueryService.get().getUserSchema(u, c, "ehr");
    }

    protected UserSchema getEHRLookupsSchema(Container c, User u)
    {
        return QueryService.get().getUserSchema(u, c, "ehr_lookups");
    }

    protected Study getStudy(Container c)
    {
        return StudyService.get().getStudy(c);
    }

    public String getCategory()
    {
        return "EHR";
    }

    protected String appendField(String name, Results rs) throws SQLException
    {
        return rs.getString(FieldKey.fromString(name)) == null ? "" : rs.getString(FieldKey.fromString(name));
    }

    public String getCronString()
    {
        return null;//"0 0/5 * * * ?";
    }

    /**
     * This should really be using URLHelpers better, but there is a lot of legacy URL strings
     * migrated into java and its not worth changing all of it at this point
     */
    protected String getExecuteQueryUrl(Container c, String schemaName, String queryName, @Nullable String viewName)
    {
        DetailsURL url = DetailsURL.fromString("/query/executeQuery.view", c);
        String ret = AppProps.getInstance().getBaseServerUrl() + url.getActionURL().toString();
        ret += "schemaName=" + schemaName + "&query.queryName=" + queryName;
        if (viewName != null)
            ret += "&query.viewName=" + viewName;

        return ret;
    }
}
