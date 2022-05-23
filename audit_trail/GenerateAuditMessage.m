function msg = GenerateAuditMessage(app, event, srcName)

    dateStr = datestr(now);
    userName = 'Admin';
    srcType = event.Source.Type;
    remarks = '';    
    
    switch srcType
        case 'uibuttongroup'
            remarks = sprintf('"%s" -> "%s"', event.OldValue.Text, event.NewValue.Text);
        case {'uinumericeditfield', 'uispinner', 'uicheckbox', 'uilistbox', 'uidropdown', 'uieditfield'}
            if ischar(event.PreviousValue) || isstring(event.PreviousValue)
                remarks = sprintf('"%s" -> "%s"', event.PreviousValue, event.Value);
            else
                remarks = sprintf('"%d" -> "%d"', event.PreviousValue, event.Value);
            end
        case 'uitable'
            if ischar(event.PreviousData) || isstring(event.PreviousData)
                changedString = sprintf('"%s" -> "%s"', event.PreviousData, event.NewData);
            else
                changedString = sprintf('"%d" -> "%d"', event.PreviousData, event.NewData);
            end
            remarks = sprintf('%s (indices : [%d, %d])', changedString, event.Indices(1, 1), event.Indices(1, 2));
    end

    eventName = event.EventName;    
    msg = sprintf('[%s] "%s" (%s/%s/%s) %s\n', dateStr, userName, srcName, srcType, eventName, remarks);
    msg = EncrypteAuditMessage(msg);

    fprintf(app.FileId, msg);

end