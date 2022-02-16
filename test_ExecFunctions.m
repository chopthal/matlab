close force all; clear

app = GenerateResultApp;

parentPath = 'D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\iMSPR_ProA_IgG\2022-02-03 13-28-34';
% parentPath = 'D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\iMSPR_ProA_SmallMolecule\2022-02-04 11-13-59';
AnalyzeKinetics(app, parentPath);
% GenerateReport(app, parentPath);
