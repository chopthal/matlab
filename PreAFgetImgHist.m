% 2020. 11. 30

% iMeasy_Multi_v1.0.0 -> iMeasy_Multi_v1.0.6

% use Get_Snapshot for reconnect process.

% function GData = PreAFgetImgHist
function GData = PreAFgetImgHist(MainApp)

global Z_abs_um cur_Channel

Z_im = Get_Snapshot(MainApp, cur_Channel);

% Z_im = getsnapshot(vid);
% Z_im = Z_im * 2^4;

[Gmag, ~] = imgradient(im2double(Z_im));    
S = sort(Gmag(:), 'descend');
GmagInten = mean(S(1:round(numel(Gmag))));

coorZ = Z_abs_um;
GData = [GmagInten coorZ];