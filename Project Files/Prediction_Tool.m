
% Specify the path to the Excel file
filePath = 'C:\Users\asuli\OneDrive\שולחן העבודה\פרוייקט גמר\angle_rate_data.xlsx';

% Read the data from the Excel file using readtable
dataTable = readtable(filePath);

% Extract the columns of data
timeColumn = dataTable{:, 4}; % Assuming the times are in the fifth column
x = 0:numel(timeColumn)-1; % Time vector running from 0 to the end

% Other data columns
y1 = dataTable{:, 1}; % Assuming the y1 values are in the first column
y2 = dataTable{:, 2}; % Assuming the y2 values are in the second column
y3 = dataTable{:, 3}; % Assuming the y3 values are in the third column

% Specify the thresholds for excluding points
threshold1 = 0.3; % First threshold
threshold2 = 5; % Second threshold

% Find logical indices for times corresponding to angle rates meeting the criteria for any Y with threshold2
validIndices2 = (abs(y1) > threshold2) ;

% Find logical indices for times corresponding to angle rates meeting the criteria for any Y with threshold1
validIndices1 = (abs(y1) > threshold1 & abs(y1) < threshold2);
%{
%Write the valid times and corresponding x positions to text files
outputFilePath1 = 'C:\Users\asuli\OneDrive\שולחן העבודה\פרוייקט גמר\midrate_encoding.txt';
outputFilePath2 = 'C:\Users\asuli\OneDrive\שולחן העבודה\פרוייקט גמר\highrate_encoding.txt';


% Open and write to the first file
fid1 = fopen(outputFilePath1, 'w');
fprintf(fid1, 'mid rate of encoding with absolute value greater than %f and less than %f):\n', threshold1, threshold2);

% Open and write to the second file
fid2 = fopen(outputFilePath2, 'w');
fprintf(fid2, 'high rate of encoding points with absolute value greater than %f :\n',threshold2);
%}
% Create a vector to store the values to print
values_to_print = zeros(size(y1));

% Assign values based on logical indices
values_to_print(validIndices1) = 3;
values_to_print(validIndices2) = 4;
values_to_print(~(validIndices1 | validIndices2)) = 2;

% Open a file for writing
fileID = fopen('C:\Users\asuli\OneDrive\שולחן העבודה\final_project_c\encoder_rates.txt', 'w');%write it in the directory of you c project

% Print the values to the file
fprintf(fileID, '%d\n', values_to_print);

% Close the file
fclose(fileID);

% Truncate the vector to the first 150 elements
rates = values_to_print(1:150);
%rates = [ones(1, 1000)*2, ones(1, 1000)*3, ones(1, 10000)*4];
% Initialize empty arrays to store y values
rate2errornum = [];
rate3errornum = [];
rate4errornum = [];

% Run the code multiple times (change it to 3000 if you want to run over
% the second rates
for run = 1:150
    % Initialize the array with random zeros and ones
    input = randi([0, 1], 1, 98); % Generate a random array of 0s and 1s
    input(99:100) = 0; % Generate K-1 zeros  
    % Print the rate
    fprintf('the rate: %d\n', rates(run));
    
    % Print the input
    fprintf('Input: ');
    fprintf('%d ', input);
    fprintf('\n');

    % Call the appropriate encoder function based on the rate
    if rates(run) == 2
    % Generate random indices to insert 1s
    errorbits=20;
    indices = randperm(200,errorbits);    
    trellis = poly2trellis(3,[5 7]);
    encoded = convenc(input,trellis);
    % Insert 1s at the randomly generated indices
    encoded(indices) = ~encoded(indices);
    % Print the encoded error
    fprintf('encoded data with errors: ');
    fprintf('%d ',encoded );
    fprintf('\n');

    tb = 100;
    decoded = vitdec(encoded,trellis,tb,'trunc','hard');
     % Print the decoded
    fprintf('decoded_data: ');
    fprintf('%d ',decoded );
    fprintf('\n'); 
    numbitsoferror=biterr(input,decoded);
    % Print the bitserrornum
    fprintf('number of bits error: ');
    fprintf('%d ', numbitsoferror );
    fprintf('\n\n');
    rate2errornum = [rate2errornum, numbitsoferror]; 
    end
    if rates(run) == 3
    % Generate random indices to insert 1s
    errorbits=30;
    indices = randperm(300,errorbits); 
    trellis = poly2trellis(3,[5 7 7]);
    encoded = convenc(input,trellis);
    % Insert 1s at the randomly generated indices
    encoded(indices) = ~encoded(indices);
    % Print the encoded error
    fprintf('encoded data with errors: ');
    fprintf('%d ',encoded );
    fprintf('\n');

    tb = 100;
    decoded = vitdec(encoded,trellis,tb,'trunc','hard');
     % Print the decoded
    fprintf('decoded_data: ');
    fprintf('%d ',decoded );
    fprintf('\n'); 
    numbitsoferror=biterr(input,decoded);
    % Print the bitserrornum
    fprintf('number of bits error: ');
    fprintf('%d ', numbitsoferror );
    fprintf('\n\n');
    rate3errornum = [rate3errornum, numbitsoferror];

    end
    if rates(run) == 4
    % Generate random indices to insert 1s
    errorbits=40;
    indices = randperm(400,errorbits);
    trellis = poly2trellis(3,[5 7 7 7]);
    encoded = convenc(input,trellis);
    % Insert 1s at the randomly generated indices
    encoded(indices) =~encoded(indices);
    % Print the encoded error
    fprintf('encoded data with errors: ');
    fprintf('%d ',encoded );
    fprintf('\n');

    tb = 100;
    decoded = vitdec(encoded,trellis,tb,'trunc','hard');
     % Print the decoded
    fprintf('decoded_data: ');
    fprintf('%d ',decoded );
    fprintf('\n'); 
    numbitsoferror=biterr(input,decoded);
    % Print the bitserrornum
    fprintf('number of error bits: ');
    fprintf('%d ', numbitsoferror );
    fprintf('\n\n'); 
    rate4errornum = [rate4errornum, numbitsoferror];
    end
end
% Generate default x values
x1 = 1:numel(rate2errornum);
x2 = 1:numel(rate3errornum);
x3 = 1:numel(rate4errornum);

% Plot each y value separately
figure;
plot(x1, rate2errornum, 'r'); % Red color for y1
hold on;
plot(x2, rate3errornum, 'g'); % Green color for y2
plot(x3, rate4errornum, 'b'); % Blue color for y3

% Compute means
mean_y1 = mean(rate2errornum);
mean_y2 = mean(rate3errornum);
mean_y3 = mean(rate4errornum);

% Plot means as horizontal lines
plot([x1(1), x1(end)], [mean_y1, mean_y1], 'r--'); % Red dashed line for mean of y1
plot([x2(1), x2(end)], [mean_y2, mean_y2], 'g--'); % Green dashed line for mean of y2
plot([x3(1), x3(end)], [mean_y3, mean_y3], 'b--'); % Blue dashed line for mean of y3

hold off;

xlabel('Index');
ylabel('number of bit errors in the decoded bits');
legend('rate of 1/2', 'rate of 1/3', 'rate of 1/4', ...
    ['Mean of rate 1/2 (', num2str(mean_y1), ')'], ...
    ['Mean of rate 1/3 (', num2str(mean_y2), ')'], ...
    ['Mean of rate 1/4 (', num2str(mean_y3), ')']);




%{

% Loop over valid indices for threshold 1
for i = 1:numel(validIndices1)
    if validIndices1(i)
        % Convert the datetime value to string
        timeString = datestr(datenum(timeColumn(i)), 'dd/mm/yyyy HH:MM:SS');
        fprintf(fid1, 'x=%d: %s\n', i-1, timeString);
    end
end

% Loop over valid indices for threshold 2
for i = 1:numel(validIndices2)
    if validIndices2(i)
        % Convert the datetime value to string
        timeString = datestr(datenum(timeColumn(i)), 'dd/mm/yyyy HH:MM:SS');
        fprintf(fid2, 'x=%d: %s\n', i-1, timeString);
    end
end

% Close the files
fclose(fid1);
fclose(fid2);

%}

% Plot the graph of values for Y1
figure;
plot(x, y1, 'b-');
xlabel('Time');
ylabel('x angle rate[rad/sec]');
title('x angle rate');
grid on;

% Calculate the maximum and minimum values for Y1
[y1Max, y1MaxIndex] = max(y1);
[y1Min, y1MinIndex] = min(y1);

% Display the maximum and minimum values for Y1 on the graph
hold on;
text(x(y1MaxIndex), y1Max, ['Max: ', num2str(y1Max), ' (at x = ', num2str(x(y1MaxIndex)), ')'], 'Color', 'red', 'VerticalAlignment', 'bottom');
text(x(y1MinIndex), y1Min, ['Min: ', num2str(y1Min), ' (at x = ', num2str(x(y1MinIndex)), ')'], 'Color', 'red', 'VerticalAlignment', 'top');


% Plot the graph of values for Y2
figure;
plot(x, y2, 'g-');
xlabel('Time');
ylabel('Y2');
title('Y angle rate');
grid on;

% Calculate the maximum and minimum values for Y2
[y2Max, y2MaxIndex] = max(y2);
[y2Min, y2MinIndex] = min(y2);

% Display the maximum and minimum values for Y2 on the graph
hold on;
text(x(y2MaxIndex), y2Max, ['Max: ', num2str(y2Max), ' (at x = ', num2str(x(y2MaxIndex)), ')'], 'Color', 'red', 'VerticalAlignment', 'bottom');
text(x(y2MinIndex), y2Min, ['Min: ', num2str(y2Min), ' (at x = ', num2str(x(y2MinIndex)), ')'], 'Color', 'red', 'VerticalAlignment', 'top');


% Plot the graph of values for Y3
figure;
plot(x, y3, 'g-');
xlabel('Time');
ylabel('Y3');
title('Z angle rate');
grid on;

% Calculate the maximum and minimum values for Y3
[y3Max, y3MaxIndex] = max(y3);
[y3Min, y3MinIndex] = min(y3);

% Display the maximum and minimum values for Y3 on the graph
hold on;
text(x(y3MaxIndex), y3Max, ['Max: ', num2str(y3Max), ' (at x = ', num2str(x(y3MaxIndex)), ')'], 'Color', 'red', 'VerticalAlignment', 'bottom');
text(x(y3MinIndex), y3Min, ['Min: ', num2str(y3Min), ' (at x = ', num2str(x(y3MinIndex)), ')'], 'Color', 'red', 'VerticalAlignment', 'top');
%}