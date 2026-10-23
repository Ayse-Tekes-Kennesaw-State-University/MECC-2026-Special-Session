clear all; 

 

SERIAL_PORT = '/dev/tty.usbserial-1130';  % For Mac Laptops 
% for mac, go to terminal and type   ls /dev/tty.*   if a usb is plugged
% in, it will return a usbserial with a number. use this.

% SERIAL_PORT = 'COM3';  % For Windows Laptops 

 

% Define parameters 

sampleTime = 20e-3;  % set sampling time to 20ms 

duration = 10;      % total data collection time in seconds 

i = 1; 

 

% Connect to Arduino 

a = arduino(SERIAL_PORT,'Uno','Libraries','rotaryEncoder'); 

 

% Initialize the rotary encoder 

encoder = rotaryEncoder(a, 'D2', 'D3', 400);   

resetCount(encoder); 

 

 

disp('Start moving the pendulum...'); 

 

% Data Acquisition from encoder 

tic;  % start timer 

 

while toc <= duration  % record the data until duration time 

    time(i) = toc; 

    count = readCount(encoder); 

    theta(i) = (count / 2400) * 360;  % Convert encoder counts to degrees 

     

    while toc <= (i * sampleTime)  % record every sampling time 

    end 

    i = i + 1; 

end 

 

% Plot 

figure; 

plot(time, theta, 'LineWidth', 2); 

xlabel('Time (s)'); 

ylabel('Angular Displacement (deg)'); 

title('Free Pendulum Angular Displacement vs Time'); 

grid on; 
