# Matlab_BatchRunner
A universal tool which runs a batch of scripts or functions and notifies the user per E-Mail when the job is finished.
Any errors and exceptions are caught, saved and the user is notified in the report E-Mail.
This is especially useful, as the execution of all iterations is independent and is not stopped if an error occurs in one iteration.

## Usage
  1. Set up the mail server configuration in lines 60-63.
  2. Initialize the job:
    a) `jobName`: Any name for the current job.
    b) `email`: The E-Mail address to send the report to.
    c) `n`: Which numbers to iterate through.
    d) `fcn`: A function handle which will be executed.
    e) `args`: All arguments to the function handle. The function call will be `fcn(args)`.
        Any parameter with the content `$$RUNVAR$$` will be replaced with an integer containing
        the current iteration number.
  3. Run the script.

## License
"THE BEER-WARE LICENSE" (Revision 42):
Hannes Badertscher (hbaderts@hsr.ch) wrote this software. As long as you retain 
this notice you can do whatever you want with this stuff. If we meet some day, 
and you think this stuff is worth it, you can buy me a beer in return. 
- Hannes Badertscher