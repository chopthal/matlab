function [k, kName, chi2, fittedT, fittedR] = ReadyForCurveFitting(concentration, eventTime, xdata, ydata, fittingVariable)    

fitTimer = tic;
% fittingVariable.FittingModel = 'OneToOneMassTransfer';
[k, kName, chi2, T, R] = OneToOneStandardFitting(...
    concentration, eventTime, xdata, ydata, fittingVariable.(fittingVariable.FittingModel), fittingVariable.FittingModel);

fitTime = toc(fitTimer); disp(fitTime)
fittedT = reshape(T, size(R, 1)/length(concentration), length(concentration));
fittedR = reshape(R(:, 3), size(R, 1)/length(concentration), length(concentration));

end