function sendemial_whendone

mail = 'zmin8684@gmail.com';
password = 'Zmmin617714';

% Set up the preferences
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

% The following is necessary only if you are using GMail as
% your SMTP server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

subject = 'experiment finished';
message = 'experiment finished';

sendmail(mail,subject,message)


end

