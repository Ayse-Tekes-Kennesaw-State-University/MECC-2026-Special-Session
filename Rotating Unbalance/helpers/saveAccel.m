function saveAccel(data)
% Saves one run as a CSV file in the current folder, e.g. Setup_B_accel.csv.
name = regexprep(char(data.label), '[^A-Za-z0-9]', '');
file = sprintf('Setup_%s_accel.csv', name);
T = table(data.t, data.acc, data.volt, data.motorOn, data.speedSetting, 'VariableNames', ...
          ["Time_s", "Accel_m_per_s2", "Voltage_V", "MotorOn", "SpeedSetting"]);
writetable(T, file);
fprintf('Saved %s\n', fullfile(pwd, file));
end
