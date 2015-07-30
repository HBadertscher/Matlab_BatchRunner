%BATCHRUNNER Runs a batch of scripts / functions and notifies the user 
% per E-Mail on finish. Errors are caught and the batchRunner continues
% with the next iteration.
% Important: The Mail-Server configuration has to be done manually! (see
% script lines 60-63)
% All arguments to the function shall be put into the 'args' cell array.
% Any entry in args with the content '%%RUNVAR%%' will be replaced by the
% current value of the iteration.
%
% "THE BEER-WARE LICENSE" (Revision 42):
% Hannes Badertscher (hbaderts@hsr.ch) wrote this software. As long as you 
% retain this notice you can do whatever you want with this stuff. If we 
% meet some day, and you think this stuff is worth it, you can buy me a 
% beer in return. 
% - Hannes Badertscher

%% Initialize Job

% A name for the job. This is only used in the E-Mail report
jobName = 'A name for the job';

% The E-Mail address to send the report to
email = 'email@domain.com';

% Which numbers to iterate through
n = 1:100;

% The function to be executed. 
fcn = @(x) functionToBeExcecuted(x{:});

% Function arguments
args = {    'argument1', ...
            'parameter1','%%RUNVAR%%' ...
       };


%% Run

% Preallocate error stuff
errors = cell(0);
nErr = 0;

% Locate all occurrences of %%RUNVAR%%
runVar = cellfun(@(x)strcmp(x,'%%RUNVAR%%'),args);

tic;
for k=n
    % Replace %%RUNVAR%% by the current k
    args{runVar} = k;
    try
        % Execute function
        fcn(args);
        fprintf('Iteration %d completed successfully\n',k);
    catch err
        % Save all errors in a cell and continue with next iteration
        nErr = nErr + 1;
        errors{nErr} = struct('nr',k,'ErrMsg',err.message );
        fprintf('Error in iteration %d: %s\n',k,err.message);
    end
end
elTime = toc;

%% Finished

% Setup mail server
setpref('Internet','SMTP_Server','')                        % TODO
setpref('Internet','E_mail','')                             % TODO
setpref('Internet','SMTP_Username','')                      % TODO
setpref('Internet','SMTP_Password','')                      % TODO

% Setup server to use SSL authentification. Change if needed.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');		  
props.setProperty('mail.smtp.socketFactory.port','465');

% Setup Mail + text
[~,pcName] = system('hostname');
pcName = strtrim(pcName);

subject = sprintf('Job ''%s'' finished on %s',jobName,pcName);
text = sprintf('The job ''%s'' on %s is finished.\n',jobName,pcName);
text = sprintf('%sElapsed time: %.2f sec\n',text,elTime);

% Write all errors to string
if nErr
    text = sprintf('%s\n%%%%%% \n',text); 
    for k=1:nErr
        text = sprintf('%sError in Nr. %d: %s\n',text,errors{k}.nr,errors{k}.ErrMsg);
    end
else
    text = sprintf('%s\nNo errors occurred.\n',text);
end

% And send!
sendmail(email,subject,text);

