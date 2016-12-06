% CompareMaps.m - Program for testing propagation models and computing RPS
%
% Example Usage:
%
% >> [mu,sigma] = CompareMaps(MeasurementFile,PredictionFile);
%
% This function will browse through all of the data in the MeasurementFile
% and compare it with records of the same name in the Prediction File.  Every non-empty
% site in MeasurementFile must have a counterpart in PredictionFile or the function will
% return an error.  If the format is OK, the procedure will tabulate the mean error,
% the standard deviation error, and the RPS (Raw Performance Score) of the modeled maps.
%
% For example, let's say that the file 'Fake_Data_EFGH.mat' contains the secret measurements
% made around Georgia Tech for the cellular sites.  A student submits his or her file
% for testing in the file 'Crummy_Models_EFGH.mat'.  To evaluate the performance of these
% models, the instructor will run
%
% >> [mu,sigma] = CompareMaps('Fake_Data_EFGH','Crummy_Models_EFGH');
%
% These sample files are included for you to try the procedure and verify that your
% submitted file is in the proper format.  Note: Your submitted file should be named after
% yourself (surname first), i.e. 'Smith_John.mat'.
%
% You may also use this file to test your modeling skills on the sites that have available
% data.  The syntax would look something like:
%
% >> [mu,sigma] = CompareMaps('Cell_Info','My_Latest_Guess_ABCD');
%

function [mu,sigma] = CompareMaps(  MeasurementFile, PredictionFile );

% Initialize Variables
mu = [];
sigma = [];
X = load(MeasurementFile);
Y = load(PredictionFile);
Names = fieldnames(X);
close all;

fprintf( 1, 'Comparing Measurements in %s to Predictions in %s\n\n', upper(MeasurementFile), upper(PredictionFile));

% Loop through each measurement
for i = 1:length(Names),
    Measurement = getfield(X,Names{i});   
    I = Measurement.ReceivedPowerMap ~= 0;
    if any(any(I))
       Prediction = getfield(Y,Names{i});
        error = Prediction.ReceivedPowerMap(I) - Measurement.ReceivedPowerMap(I);
        mu = [ mu; sum(error)/length(error) ];
        sigma = [ sigma; (sum((error-mu(i)).^2)/length(error))^.5 ];
    
        Title = Names{i}; Title( find(Title=='_') ) = ' ';
        figure(i); imagesc(Prediction.ReceivedPowerMap); axis equal; axis xy; colorbar; title(['Prediction for ' Title]);
        fprintf(1,'\n   Site %s, mean of %+4.2f dB, std dev of %4.2f dB',Names{i},mu(i),sigma(i));
    end;
end;


ave_mu = sum(abs(mu))/length(mu);
ave_std = sum(sigma)/length(sigma);
RPS = ave_std + 1/50*ave_mu^1.5;

fprintf(1,'\n\nAverage Error of (mean = %2.1f dB, sigma = %2.1f dB) for %i site(s)',ave_mu,ave_std,length(Names));
fprintf(1,'\n\nRaw Performance Score (RPS): %2.1f\n',RPS);



