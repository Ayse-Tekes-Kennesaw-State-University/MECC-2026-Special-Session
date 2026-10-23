function port = findArduinoPort()
% Finds the Arduino's serial port, whichever USB socket the cable is plugged into.
ports = serialportlist("all");
fprintf('Serial ports seen: %s\n', strjoin(ports, ', '));
if ismac
    cand = ports(startsWith(ports, "/dev/tty.") & contains(ports, ["usbmodem", "usbserial"]));
elseif ispc
    cand = ports(startsWith(ports, "COM"));
else
    cand = ports(contains(ports, ["ttyACM", "ttyUSB"]));
end
if isempty(cand)
    error(['No Arduino port found. Unplug and replug the USB cable, close the Arduino IDE, ' ...
           'and run this section again.']);
end
if numel(cand) > 1
    warning('Several possible ports (%s). Using %s. If it fails, set PORT by hand.', ...
            strjoin(cand, ', '), cand(1));
end
port = cand(1);
end
