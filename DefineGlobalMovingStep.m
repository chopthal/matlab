function DefineGlobalMovingStep(ROI)

global step_Coarse_X_um step_Medium_X_um step_Fine_X_um...
    step_Coarse_Y_um step_Medium_Y_um step_Fine_Y_um...
    step_Coarse_Z_um step_Medium_Z_um step_Fine_Z_um...
    Pixel2umDefault LensMagDefault lensMag

pixel2um = Pixel2umDefault * LensMagDefault/lensMag;

im_W_um = ROI(3) * pixel2um;
im_H_um = ROI(4) * pixel2um;

step_Coarse_X_um = im_W_um*3;
step_Medium_X_um = im_W_um;
step_Fine_X_um = im_W_um*0.1;
step_Coarse_Y_um = im_H_um*3;
step_Medium_Y_um = im_H_um;
step_Fine_Y_um = im_H_um*0.1;

if lensMag == 4
    
    step_Coarse_Z_um = 500;
    step_Medium_Z_um = 100;
    step_Fine_Z_um = 10;

else
    
    step_Coarse_Z_um = 100;
    step_Medium_Z_um = 10;
    step_Fine_Z_um = 10/3;
    
end